public class SendDirectSMS {
    public class SMSRequest {
        @InvocableVariable
        public String username;

        @InvocableVariable
        public String password;

        @InvocableVariable
        public String messageText;

        @InvocableVariable
        public String phoneNumber; // Single phone number as a String
    }

    @InvocableMethod(label = 'Send SMS via directSMS' description = 'Sends an SMS using the directSMS API')
    public static void sendSMS(List<SMSRequest> requests) {
        System.debug('Starting sendSMS method');

        for (SMSRequest req : requests) {
            System.debug('Processing request for phone number: ' + req.phoneNumber);

            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://api.directsms.com.au/s3/rest/sms/send');
            httpRequest.setMethod('POST');

            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setHeader('Username', req.username);
            httpRequest.setHeader('Password', req.password);

            String body = JSON.serialize(new Map<String, Object>{
                'messageType' => '1-way',
                'senderId' => '61408128244',
                'messageText' => req.messageText,
                'to' => new List<String>{req.phoneNumber}
            });
            httpRequest.setBody(body);
            System.debug('Request body: ' + body);

            try {
                Http http = new Http();
                HttpResponse response = http.send(httpRequest);
                System.debug('Response received. Status code: ' + response.getStatusCode());

                if (response.getStatusCode() == 200) {
                    System.debug('Success response: ' + response.getBody());
                    // Handle success logic
                } else {
                    System.debug('Error response: ' + response.getBody());
                    // Handle error logic
                }
            } catch(System.CalloutException e) {
                System.debug('CalloutException: ' + e.getMessage());
                // Exception handling for callout issues
            } catch(Exception e) {
                System.debug('General Exception: ' + e.getMessage());
                // General exception handling for other issues
            }
        }
        System.debug('sendSMS method complete');
    }
}