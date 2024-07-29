public with sharing class XeroCalloutService {
        
    /**
    * 	@author Ben Edwards (ben@edwards.nz)
    *	@description Execute the physical callout and return the response
    * 	@return Returns the HttpResponse from the Xero API
    **/
    public static HttpResponse executeCallout (String method, String resourceName) {
        return executeCallout(method, resourceName, null, null);
    }

    public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {
        return executeCallout(method, resourceName, requestBody, null);
    }

    public static HttpResponse executeCallout (String method, String resourceName, String requestBody, Map<String, String> headers) {
        
        Xero_Setup__c tokenRecord = [SELECT Id, Name, Access_Token__c, Refresh_Token__c, Token_Expiration_time__c FROM Xero_Setup__c LIMIT 1];
        // Instantiate a new request
        HttpRequest request = new HttpRequest();

        // Set request parameters
        request.setMethod(method);

        // Set the endpoint using the named credential
        request.setEndpoint(
            'callout:Xero_Dev/' +  
            (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName)
        );
        
        
        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + tokenRecord.Access_Token__c);
        // Set the Xero Tenant ID
        // request.setHeader('xero-tenant-id', Label.Xero_Tenant_Id);
        request.setHeader('xero-tenant-id', '0e4e3a44-ab85-4b7d-8469-ae171c45976c');

        // Set max timeout
        request.setTimeout(120000);

        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {

            // Set the body to the callout
            request.setBody(requestBody);

            // Set the content to XML
            request.setHeader('Content-Type', 'application/json');
        }

        // If we have headers passed into the method, add them to the request
        if (headers != null && !headers.isEmpty()) {
            for (String headerKey :headers.keySet()) {
                request.setHeader(headerKey, headers.get(headerKey));
            }
        }

        system.debug('### Xero Callout Endpoint: ' + request.getEndpoint());
        system.debug('### Xero Callout Method: ' + request.getMethod());
        system.debug('### Xero Callout Body: ' + request.getBody());

        // Debug headers
        if (headers != null && !headers.isEmpty()) {
            for (String headerKey :headers.keySet()) {
                system.debug('### Xero Callout Header: ' + headerKey + ' => ' + headers.get(headerKey));
            }
        }

        // Execute the callout
        HttpResponse response = new Http().send(request);

        system.debug('### Xero Response Status: ' + response.getStatusCode() + ': ' + response.getStatus());
        system.debug('### Xero Response Body: ' + response.getBody());

        // Execute callout and return
        return response;
    }  
    @future(callout=true)
    public static void refreshToken() {
        Xero_Setup__c tokenRecord = [SELECT Id, Name, Access_Token__c, Refresh_Token__c, Token_Expiration_time__c FROM Xero_Setup__c LIMIT 1];
        Xero_Admin__c adminSetup = Xero_Admin__c.getOrgDefaults();
        String token1 = adminSetup.Client_Id__c + ':' + adminSetup.Client_Secret__c;
        String encodedToken = EncodingUtil.base64Encode(Blob.valueOf(token1));

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://identity.xero.com/connect/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('authorization', 'Basic ' + encodedToken);
        request.setHeader('Accept', 'application/json');
        request.setBody('grant_type=refresh_token&refresh_token=' + tokenRecord.Refresh_Token__c);
        request.setTimeout(120000);

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            System.debug('Body: ' + response.getBody());
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String newAccessToken = (String) responseMap.get('access_token');
            String newRefreshToken = (String) responseMap.get('refresh_token');

            Xero_Setup__c tokenRecord1 = new Xero_Setup__c();
            tokenRecord1.Id = tokenRecord.Id;
            tokenRecord1.Refresh_Token__c = newRefreshToken;
            tokenRecord1.Access_Token__c = newAccessToken;
            tokenRecord1.Token_Expiration_time__c = DateTime.now().AddMinutes(30);
            update tokenRecord1;
        } else {
            System.debug('Failed to refresh token: ' + response.getBody());
        }
    }

}