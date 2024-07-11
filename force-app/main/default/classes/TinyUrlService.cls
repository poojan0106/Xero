public class TinyUrlService {

    // Modified request wrapper class to include new fields
public class SimpleTinyUrlRequest {
    @InvocableVariable(required=true)
    public String longUrl;
    
    @InvocableVariable(required=true)
    public String apiToken;
    
    // New fields for tags and expiration date
    @InvocableVariable
    public String tags; // Comma-separated tags
    
    @InvocableVariable
    public String expiresAt; // Expected format: "YYYY-MM-DD HH:MM:SS"
}

// The response class remains unchanged
public class TinyUrlResponse {
    @InvocableVariable(label='Shortened URL')
    public String tinyUrl;
    
    @InvocableVariable(label='Response Code')
    public Integer code;
    
    @InvocableVariable(label='Errors')
    public List<String> errors;
}

// Updated method to handle new fields
@InvocableMethod(label='Shorten Simple URL' description='Shortens a long URL using TinyURL API with additional parameters')
public static List<TinyUrlResponse> shortenSimpleUrl(List<SimpleTinyUrlRequest> requests) {
    List<TinyUrlResponse> responseList = new List<TinyUrlResponse>();
    
    for (SimpleTinyUrlRequest request : requests) {
        // Initialize the request body with new fields
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('url', request.longUrl);
        requestBody.put('domain', 'tinyurl.com');
        
        // Check and add tags if they are not blank
        if (!String.isBlank(request.tags)) {
            requestBody.put('tags', request.tags.split(','));
        }
        
        // Check and add expires_at if it is not blank
        if (!String.isBlank(request.expiresAt)) {
            requestBody.put('expires_at', request.expiresAt);
        }

        // Serialize to JSON, prepare and send the HTTP request as before
        String requestBodyJson = JSON.serialize(requestBody);

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://api.tinyurl.com/create');
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', 'Bearer ' + request.apiToken);
        httpRequest.setBody(requestBodyJson);

        try {
            HttpResponse httpResponse = new Http().send(httpRequest);
            // Handle the response as before
            if (httpResponse.getStatusCode() == 200) {
                // Response handling remains unchanged
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
                Map<String, Object> dataMap = (Map<String, Object>) responseMap.get('data');
                
                TinyUrlResponse response = new TinyUrlResponse();
                response.tinyUrl = (String) dataMap.get('tiny_url');
                response.code = httpResponse.getStatusCode();
                responseList.add(response);
            } else {
                // Handle non-200 responses as before
                TinyUrlResponse errorResponse = new TinyUrlResponse();
                errorResponse.errors = new List<String>{'HTTP error code: ' + httpResponse.getStatusCode()};
                responseList.add(errorResponse);
            }
        } catch (Exception e) {
            // Exception handling remains unchanged
            TinyUrlResponse errorResponse = new TinyUrlResponse();
            errorResponse.errors = new List<String>{'Exception: ' + e.getMessage()};
            responseList.add(errorResponse);
        }
    }
    
    return responseList;
}

}