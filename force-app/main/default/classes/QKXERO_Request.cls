public with sharing class QKXERO_Request {
	private static final string baseUrl = 'https://api.xero.com/api.xro/2.0/';

	// Read data (view and list a resource) with params and headers
	public static String httpGet(QKXERO_Auth auth, String endpoint, Map<String, String> params, Map<String, String> customHeaders){
		String urlParameters = '';

		if(params != null){
			for(String param : params.keySet()){
				urlParameters += '&' + QKXERO_Utils.encode(param) + '=' + QKXERO_Utils.encode(params.get(param));
			}
			if(urlParameters.length() > 0 && !endpoint.contains('?')){
				// urlParameters always starts with a &, replace with a ? if the url does not have a ?
				urlParameters = '?' + urlParameters.substring(1);
			}
		}


		return request(auth, baseUrl+endpoint+urlParameters, 'GET', null, customHeaders).getBody();
	}

	public static Blob httpGetBlob(QKXERO_Auth auth, String endpoint, Map<String, String> customHeaders){
		String urlParameters = '';

		/*if(params != null){
			for(String param : params.keySet()){
				urlParameters += '&' + QKXERO_Utils.encode(param) + '=' + QKXERO_Utils.encode(params.get(param));
			}
			if(urlParameters.length() > 0 && !endpoint.contains('?')){
				// urlParameters always starts with a &, replace with a ? if the url does not have a ?
				urlParameters = '?' + urlParameters.substring(1);
			}
		}*/


		return request(auth, baseUrl+endpoint+urlParameters, 'GET', null, customHeaders).getBodyAsBlob();
	}

	// Read data (view and list a resource) with params
	public static String httpGet(QKXERO_Auth auth, String endpoint, Map<String, String> params){
		return httpGet(auth, endpoint, params, null);
	}

	// Read data (view and list a resource) without params
	public static String httpGet(QKXERO_Auth auth, String endpoint){
		//return request(auth, baseUrl+endpoint, 'GET', null, null);
		return httpGet(auth, endpoint, null, null);
	}

	// Create a resource
	public static String httpPost(QKXERO_Auth auth, String endpoint, String body){
		return request(auth, baseUrl+endpoint, 'POST', 'xml='+body, null).getBody();
	}

	// Update a resource
	public static String httpPost(QKXERO_Auth auth, String endpoint, String body, String xeroId){
		return request(auth, baseUrl+endpoint+'/'+xeroId, 'POST', 'xml='+body, null).getBody();
	}

	// Create resource without duplicates [Example, Contacts match based on Name]
	public static String httpPut(QKXERO_Auth auth, String endpoint, String body){
		return request(auth, baseUrl+endpoint, 'PUT', 'xml='+body, null).getBody();
	}

	// With default supplied ID
	public static String httpDelete(QKXERO_Auth auth, String endpoint, String xeroId){
		// TODO: Translate params into endpoint parameters
		return request(auth, baseUrl+endpoint+'/'+xeroId, 'DELETE', null, null).getBody();
	}

	// No id supplied, this is used for more complex DELETEs
	public static String httpDelete(QKXERO_Auth auth, String endpoint){
		// TODO: Translate params into endpoint parameters
		return request(auth, baseUrl+endpoint, 'DELETE', null, null).getBody();
	}

	private static HTTPResponse request(QKXERO_Auth auth, String endpoint, String httpVerb, String body, Map<String, String> customHeaders){
		// Return the XML result
		HttpRequest req = new HttpRequest();

		//Set HTTPRequest Method
		req.setMethod(httpVerb);
		req.setEndpoint(endpoint);
		req.setHeader('Accept', 'application/json');

		if(body!=null){
			req.setBody(body);
			System.debug(body);
			if(httpVerb == 'POST' || httpVerb == 'PUT'){
				req.setHeader('Content-Type','application/x-www-form-urlencoded');
			}
		}

		if(customHeaders != null){
			for(String headerKey : customHeaders.keySet()){
				req.setHeader(headerKey, customHeaders.get(headerKey));
			}
		}

		// Sign the request - much more complicated and annoying than I would like -_-'
		auth.sign(req);

		System.debug('req: '+ req);
		System.debug('req.body: '+ req.getBody());
		System.debug('req.endpoint: '+ req.getEndpoint());
		System.debug('req.headers[Content-Type]: '+ req.getHeader('Content-Type'));


		Http http = new Http();

		try {
			HTTPResponse res = http.send(req);
			return res;
		} catch(System.CalloutException e) {
			// TODO: Change exception handler to be much more informative
			throw new QKXERO_Exception(e.getMessage());
		}
	}



}