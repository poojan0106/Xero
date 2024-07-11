public with sharing class QKXERO_Contact implements QKXERO_Object {
	private static String baseEndpoint = 'Contact';

	public String ContactID {get;set;} 
	public String Name {get;set;} 
	public String EmailAddress {get;set;}
	public String FirstName {get;set;}
	public String LastName {get;set;}
	public List<Address> Addresses {get;set;} 
	public List<Phone> Phones {get;set;} 
	//public List<ContactGroup> ContactGroups {get;set;} // Commented out because not used *yet*.
	//public List<ContactPerson> ContactPersons {get;set;} // Commented out because not used *yet*.
	public Boolean HasValidationErrors {get;set;} 


	public class Address {
		public String AddressType {get;set;} 
		public String City {get;set;} 
		public String Region {get;set;} 
		public String PostalCode {get;set;} 
		public String Country {get;set;} 
		public String AttentionTo {get;set;} 
		public String AddressLine1 {get;set;} 
	/*
      <Addresses>
        <Address>
          <AddressType>STREET</AddressType>
        </Address>
        <Address>
          <AddressType>POBOX</AddressType>
          <AddressLine1>L4, CA House</AddressLine1>
          <AddressLine2>14 Boulevard Quay</AddressLine2>
          <City>Wellington</City>
          <PostalCode>6012</PostalCode>
        </Address>
      </Addresses>
	*/
	}

	public class Phone {
		public String PhoneType {get;set;} 
		public String PhoneNumber {get;set;} 
		public String PhoneAreaCode {get;set;} 
		public String PhoneCountryCode {get;set;} 
		
		//<Phones>
		//    <Phone>
		//      <PhoneType>DEFAULT</PhoneType>
		//    </Phone>
		//    <Phone>
		//      <PhoneType>DDI</PhoneType>
		//    </Phone>
		//    <Phone>
		//      <PhoneType>MOBILE</PhoneType>
		//    </Phone>
		//    <Phone>
		//      <PhoneType>FAX</PhoneType>
		//    </Phone>
		//  </Phones>
		
	}

/*	public class ContactGroup {
		
		//<ContactGroups>
		//    <ContactGroup>
		//      <ContactGroupID>97bbd0e6-ab4d-4117-9304-d90dd4779199</ContactGroupID>
		//      <Name>VIP Customers</Name>
		//      <Status>ACTIVE</Status>
		//    </ContactGroup>
		//    <ContactGroup>
		//      <ContactGroupID>d0c68f1a-e5dd-4a45-aa02-27d8fdbfd562</ContactGroupID>
		//      <Name>Preferred Suppliers</Name>
		//      <Status>ACTIVE</Status>
		//    </ContactGroup>
		//</ContactGroups>
		
	}*/


/*	// Not sure what Xero type this is - probably SF Contact equiv
	public class ContactPerson {

	}*/

	public static QKXERO_Contact getById(String xeroId){
		String result = QKXERO_Request.httpGet(QKXERO_Auth.getInstance(), baseEndpoint+'/'+xeroId);
		List<QKXERO_Contact> contacts = deserialise(result);
		if(contacts.size() > 0){
			return contacts[0];
		}else{
			throw new QKXERO_Exception('Could not find an Contact with Id '+xeroId);
		}
	}

	// Get all contacts that match a given where condition and/or modified since. This also has pagination
	public static List<QKXERO_Contact> query(String whereCondition, Datetime modifiedSince, Integer page){
		Map<String, String> params = new Map<String, String>();
		Map<String, String> headers = new Map<String, String>();
		//{'where'=>whereCondition, 'page'=>String.valueOf(page)}
		if(whereCondition != null){
			params.put('where', whereCondition);
		}

		if(page != null){
			if(page < 1 || page > 100){
				throw new QKXERO_Exception('Pages can only be between 1 and 100');
			}
			params.put('page', String.valueOf(page));
		}

		if(modifiedSince != null){
			// The ModifiedAfter filter is actually an HTTP header: 'If-Modified-Since'. 
			// A UTC timestamp (yyyy-mm-ddThh:mm:ss) . Only contacts created or modified since this timestamp will be returned e.g. 2009-11-12T00:00:00
			headers.put('If-Modified-Since', modifiedSince.formatGMT('yyyy-MM-dd\THH:mm:ss'));
		}



		String result = QKXERO_Request.httpGet(QKXERO_Auth.getInstance(), baseEndpoint, params, headers);
		List<QKXERO_Contact> contacts = deserialise(result);
		
		// Recursively run until all pages of contacts have been retrieved, this allows n + 1 runs
		if(page != null && page < 100 && contacts.size() >= 100){
			contacts.addAll(query(whereCondition, modifiedSince, page + 1));
		}

		// TODO: Add in a callout count to make sure not to break limits

		System.debug(result);
		System.debug(contacts);
		//return null;
		return contacts;
	}

	// Get all contacts that match a given where condition and/or modified since. This does not have pagination
	public static List<QKXERO_Contact> query(String whereCondition, Datetime modifiedSince){
		return query(whereCondition, modifiedSince, null);
	}

	// Get all contacts that match a given where condition 
	public static List<QKXERO_Contact> query(String whereCondition){
		return query(whereCondition, null, null);
	}

	// Get all contacts
	public static List<QKXERO_Contact> query(){
		return query(null, null, null);
	}

	public static List<QKXERO_Contact> deserialise(String jsonResult){
		// We need to "extract" the results from the Xero response. This is a bit hacky, but better than string juggling
		jsonResult = QKXERO_Utils.fixJsonDate(jsonResult);
		Map<String, Object> jsonUntyped = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
		JSON.serialize(jsonUntyped);
		return (List<QKXERO_Contact>)JSON.deserialize(JSON.serialize(jsonUntyped.get('Contacts')), List<QKXERO_Contact>.class);
	}

	public static String serialise(QKXERO_Object contact){
		String jsonString = JSON.serialize(contact);

		Set<String> skipNodes = new Set<String>{'HasErrors', 'ValidationErrors', 'HasAttachments', 'HasValidationErrors'};
		return QKXERO_Utils.serialise(jsonString, 'Contact', skipNodes);
	}

	public static QKXERO_Contact saveXero(QKXERO_Object contact){
		List<QKXERO_Contact> result = saveXero(new List<QKXERO_Object>{contact});
		if(result == null || result.size() == 0){
			return null;
		}else{
			return result[0];
		}
	}

	public static List<QKXERO_Contact> saveXero(List<QKXERO_Object> contacts){

		String body;
		for(QKXERO_Object contact: contacts){
			body += serialise(contact);
		} 

		body = '<Contacts>' + body + '</Contacts>';
		String response = QKXERO_Request.httpPost(QKXERO_Auth.getInstance(), baseEndpoint+'?SummarizeErrors=false', body);
		List<QKXERO_Contact> returnedContacts = deserialise(response);
		return returnedContacts;
	}

/*	
	// Temporarily commented out to increase code
	public static Account convertContactToSobject(QKXERO_Contact xContact){
		// Currently we don't want to do much more than just the Xero ID, it's okay if the names are different, they don't need to sync
		Account account = new Account(
			Xero_ID__c = xContact.ContactId
		);

		return account;
	} */
}