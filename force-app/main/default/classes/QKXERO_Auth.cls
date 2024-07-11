public without sharing class QKXERO_Auth {
	private QKXERO_Credentials credentials = null;
	private static QKXERO_Auth instance = null;

	private QKXERO_Auth() {
		credentials = getCredentials();
	}

	public static QKXERO_Auth getInstance(){
		if(instance == null){
			instance = new QKXERO_Auth();
		}
		return instance;
	}

	/*
	* Responsible for getting credentials from the correct datastore - no SOQL, woot! Limits averted!
	*/
	private QKXERO_Credentials getCredentials(){
		QKXERO_Private_App__c privateAppCustomSettings = QKXERO_Private_App__c.getInstance();
		if( !Test.isRunningTest() && privateAppCustomSettings == null || privateAppCustomSettings.Consumer_Key__c == null || privateAppCustomSettings.Private_Key_ID__c == null){
			//throw new QKXERO_Exception('The org must have Xero settings set. You can set the application settings by Setup > Custom Settings > QK Xero - Private > Manage');
		}
		return new QKXERO_Credentials(
				privateAppCustomSettings.Consumer_Key__c,
				privateAppCustomSettings.Private_Key_ID__c
		);
	}

	/*
	* Basic store for Xero credentials
	*/
	private class QKXERO_Credentials{
		public String consumerKey;
		//public string consumerSecret; //Used for Partner / Public apps
		public String privateKeyName;
		public String callbackUrl = 'login.salesforce.com';

		//public string oauthToken;  //Used for Partner / Public apps
		//public string oauthTokenSecret;  //Used for Partner / Public apps

		public QKXERO_Credentials(String consumerKey,  String privateKeyName){
			this.consumerKey = consumerKey;
			//this.consumerSecret = consumerSecret;
			this.privateKeyName = privateKeyName;
		}

	}


	public void sign(HttpRequest req) {
/*
		//req.setBody(req.getBody().replace('&amp;','&'));
		Map<String, String> oauthParams = getOauthParams();
		String encodedRequest = getEncodedRequestString(oauthParams, req);//.replace('%26amp%3B','%26');
		//Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(encodedRequest), Blob.valueOf(this.credentials.privateKey));
		Blob sig = Crypto.signWithCertificate('RSA-SHA1', Blob.valueOf(encodedRequest), this.credentials.privateKeyName);
		String signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');

		String urlParamChunk = '';
		for (String key : oauthParams.keySet()) {
			// Maybe URL Encode, we'll see
			urlParamChunk += key + '=' + oauthParams.get(key)+'&';
		}
		urlParamChunk += 'oauth_signature='+signature;
		// Need to check to see if ? or & should be used
		if(req.getEndpoint().contains('?')){
			req.setEndpoint(req.getEndpoint() + '&' + urlParamChunk);
		}else{
			req.setEndpoint(req.getEndpoint() + '?' + urlParamChunk);
		}


		if(req.getBody() != null && String.isNotBlank(req.getBody())){
			req.setBody(req.getBody()
					.replace('&','%26')
				//.replace('=', '%3D')
			);
		}



		System.debug('urldecoded-body:' + EncodingUtil.urlDecode(req.getBody(),'UTF-8'));
		System.debug('urldecoded-encoded-request:' + EncodingUtil.urlDecode(encodedRequest,'UTF-8'));
		System.debug('body:' + req.getBody());
		System.debug('endpoint:' + req.getEndpoint());
	
*/
    }
        // Part of Oauth Signing
	private Map<String, String> getOauthParams(){
		String nonce = String.valueOf(Crypto.getRandomLong());
		String timestamp = String.valueOf(DateTime.now().getTime()/1000);

		Map<String, String> parameters = new Map<String, String>();
		parameters.put('oauth_consumer_key',this.credentials.consumerKey);

		parameters.put('oauth_token',this.credentials.consumerKey);

		/*if(verifier!=null) {
			parameters.put('oauth_verifier',verifier);
		}*/
		parameters.put('oauth_signature_method','RSA-SHA1');
		parameters.put('oauth_timestamp',timestamp);
		parameters.put('oauth_nonce',nonce);
		parameters.put('oauth_callback',this.credentials.callbackUrl);
		return parameters;
	}

	// Part of Oauth Signing
	private String getEncodedRequestString(Map<String,String> oauthParams, HttpRequest req) {
		Map<String,String> parameters = oauthParams.clone();
		if((req.getMethod().equalsIgnoreCase('post') || req.getMethod().equalsIgnoreCase('put')) && req.getBody()!=null) {
			parameters.putAll(getUrlParams(req.getBody()));
		}
		String host = req.getEndpoint();
		Integer n = host.indexOf('?');
		if(n>-1) {
			parameters.putAll(getUrlParams(host.substring(n+1)));
			host = host.substring(0,n);
		}
		System.debug('Paramaters: '+ parameters);

		List<String> keys = new List<String>();
		keys.addAll(parameters.keySet());
		keys.sort();
		String s = keys.get(0)+'='+parameters.get(keys.get(0));
		for(Integer i=1;i<keys.size();i++) {
			s = s + '&' + keys.get(i)+'='+parameters.get(keys.get(i));
		}

		// According to OAuth spec, host string should be lowercased, but Google and LinkedIn
		// both expect that case is preserved.
		return req.getMethod().toUpperCase()+ '&' +
				EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
				EncodingUtil.urlEncode(s, 'UTF-8');
	}

	// Part of Oauth Signing
	private Map<String,String> getUrlParams(String value) {

		Map<String,String> res = new Map<String,String>();
		if(value==null || value=='') {
			return res;
		}

		//for(String s : value.split('&')) {
		//System.debug('getUrlParams: '+s);
		List<String> kv = value.split('=');
		if(kv.size()>1) {
			// RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names
			// and values are decoded then encoded before being sorted and concatenated
			// Section 3.6 specifies that space must be encoded as %20 and not +
			String encName = QKXERO_Utils.encode(kv[0]);//EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[0], 'UTF-8'), 'UTF-8').replace('+','%20');
			String encValue = QKXERO_Utils.encode(kv[1]);//EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[1], 'UTF-8'), 'UTF-8').replace('+','%20');
			System.debug('getUrlParams:  -> '+encName+','+encValue);
			res.put(encName,encValue);
		}
		//}
		return res;
	}
}