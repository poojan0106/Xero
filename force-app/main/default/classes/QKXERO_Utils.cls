public with sharing class QKXERO_Utils {
	private static Set<String> skipNodes;


	public static String encode(String value){
		System.debug('Encoding: '+ value);
		return EncodingUtil.urlEncode(EncodingUtil.urlDecode(value, 'UTF-8'), 'UTF-8')
				.replace('+','%20');
	}

	public static String generateSoqlLineItems(Id invoiceId){
		List<String> fields = new List<String>(Invoice_Line_Item__c.SObjectType.getDescribe().fields.getMap().keySet());
		String soql = ''
        + ' SELECT ' + String.join(fields, ',')
        + ' FROM Invoice_Line_Item__c'
        + ' WHERE Invoice__c = \''+invoiceId+'\'';


        return soql;
	}

	// Convert Xeros funky datetime string into a real datetime
	/*public static Datetime convertDatetime(String datetimeString){
		// Xero Date: "\/Date(1496016000000+0000)\/"
		// Regex: \((\d+)\+ - Any digits between a ( and a + charecter

		if(datetimeString == null || datetimeString == ''){
			return null;
		}
		Pattern pat = Pattern.compile('\\((\\d+)\\+');
		Matcher matcher = pat.matcher(datetimeString);
		if(matcher.find()){
			return Datetime.newInstance(Integer.valueOf(matcher.group(1)));
		}

		return null;

	}*/

	// Convert Xeros funky datetime string into a real datetime
	public static String fixJsonDate(String jsonString){
		// Xero Date: "\/Date(1496016000000+0000)\/"
		// Regex: "(.*)": "(.*Date\((\d+)\+(\d+).*)" - Grab the whole line

		String returnJson = jsonString;
		if(jsonString == null || jsonString == ''){
			return null;
		}
		String regex = '"(.*)": "(.*Date\\((\\d+)\\+(\\d+).*)"';
		Pattern pat = Pattern.compile(regex);
		Matcher matcher = pat.matcher(jsonString);
		Datetime dateTemp;

		while(matcher.find()){
			dateTemp = Datetime.newInstance(Long.valueOf(matcher.group(3)));
			//matcher.replaceFirst('"$1_d": "'+dateTemp.formatGmt('yyyy-MM-dd\THH:mm:ssZ')+'"');
			returnJson = returnJson.replace(matcher.group(0),'"'+matcher.group(1)+'_d": "'+dateTemp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+'"');

		}

		System.debug(returnJson);

		return returnJson;

	}

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Takes an generic object and converts to XML string
    *   @return XML String
    **/
	public static String serialise(String jsonString, String parentNode, Set<String> skipNodesInput) {
		if(skipNodesInput != null){
			skipNodes = skipNodesInput;
		}else{
			skipNodes = new Set<String>();
		}		

		// Create a parser so we can iterate over each JSON line
		JSONParser parser = JSON.createParser(jsonString);

        // Instantiate new document
        Dom.Document xmlDoc = new Dom.Document();

        // Create parent element
        Dom.XmlNode parentElement = xmlDoc.createRootElement(parentNode, null, null);

        // Process the JSON parser
        processJson (parser, parentElement);

    	// Convert the XML Doc into a string
    	String xmlString = xmlDoc.toXmlString();
    	xmlString = xmlString.replace('<?xml version="1.0" encoding="UTF-8"?>','');

		return xmlString;
	}

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Dynamic method used to process JSON elements accordingly
    *   @return Nudda
    **/
    private static void processJson (JSONParser parser, Dom.XmlNode parentElement) {

    	// Iterate over each JSON line
		while (parser.nextToken() != null) {

			// If it's the start of a object
			if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

				// Process the object
				processJsonObject (parser, parentElement, parser.getCurrentName());
			}

			// If the element is for an array of child elements
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

				// Process the array
				processJsonArray (parser, parentElement);
			}

			// If it's standard value
			if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

				// Add the key value element to the XML
				addValueElement (parser, parentElement);
			}
    	}

    }

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Serialize a JSON object into XML
    *   @return Nudda
    **/
    private static void processJsonObject (JSONParser parser, Dom.XmlNode parentElement, String objectName) {
    	if(!skipNodes.contains(objectName)){
			// Create child element for the object
			Dom.XmlNode objectElement = parentElement.addChildElement(removeD(objectName), null, null);
			while (parser.nextToken() != null) {

				// If the Array has ended
				if (parser.getCurrentToken() == JSONToken.END_OBJECT) {

					// Break out of the loop
					break;
				}


				// If it's the start of a object, process itself again
				if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

					// Process the object
					processJsonObject (parser, objectElement, parser.getCurrentName());
				}

				// If the element is for an array of child elements
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

					// Process the array
					processJsonArray (parser, objectElement);
				}

				if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

					// Add value element to the XML
					addValueElement (parser, objectElement);
				}
			}
		}else{
			skip(parser);
		}
	}

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Serialize a JSON object into XML
    *   @return Nudda
    **/
    private static void processJsonArray (JSONParser parser, Dom.XmlNode parentElement) {


    	// Control whether the array is the top level, or an array
    	// within the JSON
    	Boolean topLevelArray = false;

    	// The name of the array
    	String parentArrayName = parser.getCurrentName();

    	// If the array has no name, it's probabaly top-level.
    	if (String.isBlank(parentArrayName)) {

   			// Create an Array name
    		if(parentElement.getName().endsWith('ses')){
				parentArrayName = parentElement.getName().substring(0, parentElement.getName().length() - 2);
			}else if(parentElement.getName().endsWith('s')){
				parentArrayName = parentElement.getName().substring(0, parentElement.getName().length() - 1);
			}

    		// This array has no name, so must be top level
    		topLevelArray = true;
    	}

    	if(!skipNodes.contains(parentArrayName)){
	    	// Create child element for the object
			Dom.XmlNode arrayElement = parentElement.addChildElement(removeD(parentArrayName), null, null);

			// Iterate over elements in the array
			while (parser.nextToken() != null) {
				// If the Array has ended, break out
				if (parser.getCurrentToken() == JSONToken.END_ARRAY) {

					break;
				}

				// If it's the start of the end
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {

					// Only run if the current token isn't the top level array
					if (!topLevelArray) {

						// Take the name of the object
						String arrayName = parser.getCurrentName();

						if (String.isBlank(arrayName)) {

							// Take the name of the parent array
							arrayName = arrayElement.getName();

							// Attempts to guess the pluralisation
							if(arrayName.endsWith('ses')){
								arrayName = arrayName.substring(0, arrayName.length() - 2);
							}else if(arrayName.endsWith('s')){
								arrayName = arrayName.substring(0, arrayName.length() - 1);
							}
							
						}

						// Process the JSON object
						processJsonObject (parser, arrayElement, arrayName);
					}
				}

				// If the element is for an array of child elements
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

					// Move to next token
					//parser.nextToken();

					// Process the array
					processJsonArray (parser, parentElement);
				}

				if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

					// Add value element to the XML
					addValueElement (parser, arrayElement);
				}

				// Set back to false. This is only applicable once
				topLevelArray = false;
			}
		}else{
			// This will skip all the children elements
			skip(parser);
		}
    }

    private static void skip(JSONParser parser){
		// Iterate over elements in the array
		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.END_OBJECT || parser.getCurrentToken() == JSONToken.END_ARRAY) {

				// Break out of the loop
				break;
			}

			// Literally everything else
			skip(parser);

/*			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
				skip(parser);
			}

			if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
				skip(parser);
			}*/
    	}
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Adds the key value pair as XML
    *   @return Nudda
    **/
    private static void addValueElement (JSONParser parser, Dom.XmlNode parentElement) {

    	// Create value for the parent object
    	if(!skipNodes.contains(removeD(parser.getCurrentName()))){
			Dom.XmlNode childElement = parentElement.addChildElement(removeD(parser.getCurrentName()), null, null);

			// Add the text
			childElement.addTextNode(xmlEncode(parser.getText()));
		}
    }

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Removes the trailing __x on variable names. This is done as a workaround for reserved names by Apex
    *   @return XML String
    **/
	private static String removeD(String value) {

		// If the value is not null or empty string
		if (String.isNotBlank(value)) {

			// Remove the _x
			return value.replace('_d','');
		}
		else {

			// Otherwise just return the normal value
			return value;
		}
	}

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Set of JSONToken Enums used to determine whether to include JSON value in the XML
    *   @return Set of JSONToken Enum strings
    **/
	private static Set<String> acceptedValues {

		get {
			// Value enums which determine the type of value in the JSON
			acceptedValues = new Set<String>{
				'VALUE_FALSE',
				'VALUE_NUMBER_FLOAT',
				'VALUE_NUMBER_INT',
				'VALUE_STRING',
				'VALUE_TRUE'
			};

			return acceptedValues;
		}
		set;
	}

	public static string xmlEncode(String content){

		content = content.replace('&','&amp;')
				.replace('<','&lt;')
				.replace('>','&gt;')
				.replace('\'',' &#39;')
				.replace('"',' &#34;')
				.replace('%','&#37;')
				.replace('*','&#42;')
				.replace('=','&#61;');
		return content;
	}

}