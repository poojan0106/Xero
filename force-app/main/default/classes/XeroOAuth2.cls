public class XeroOAuth2 {
    public static String getAuthorizationUrl() {
        Xero_Admin__c adminSetup = Xero_Admin__c.getOrgDefaults();
         String clientId = adminSetup.Client_Id__c;
        String redirectUrl = adminSetup.redirectUrl__c;
        String scope = 'openid profile email offline_access accounting.transactions accounting.contacts';
        String state = '123';
        String authorizationUrl = 'https://login.xero.com/identity/connect/authorize';
        
        authorizationUrl = authorizationUrl + '?response_type=code' +
                     '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                     '&redirect_uri=' + EncodingUtil.urlEncode(redirectUrl, 'UTF-8') +
                     '&scope=' + EncodingUtil.urlEncode(scope, 'UTF-8') +
                     '&state=' + EncodingUtil.urlEncode(state, 'UTF-8');
        System.debug('Method Called: ' + redirectUrl);
        system.debug('authUrl 2: ' + authorizationUrl);
        return authorizationUrl;
    }

    public static void exchangeCodeForToken(String code) {
        Xero_Admin__c adminSetup = Xero_Admin__c.getOrgDefaults();
        String clientId = adminSetup.Client_Id__c;
        String clientSecret = adminSetup.Client_Secret__c;
        String redirectUri = adminSetup.redirectUrl__c;
        String grantType = 'authorization_code';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://identity.xero.com/connect/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String body = 'grant_type=' + grantType + 
                      '&code=' + code + 
                      '&redirect_uri=' + redirectUri +
                      '&client_id=' + clientId + 
                      '&client_secret=' + clientSecret;
        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) resMap.get('access_token');
            String refreshToken = (String) resMap.get('refresh_token');
            XeroTokenManager.storeTokens(accessToken, refreshToken);
        } else {
            System.debug('Error: ' + res.getBody());
        }
    }
}