@isTest
public class XeroKeepConnectionSchedulerTest {

    @isTest
    static void testXeroApiCallout() {
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;
        

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"Invoices": [{"InvoiceID": "123", "Contact": {"Name": "Test Contact"}, "Date": "2023-01-01T00:00:00"}]}'));
		
        String uniqueJobName = 'Test Xero Callout Job 1' + System.currentTimeMillis();
        String cronExp = '0 0 2 * * ?';
        String jobId = System.schedule(uniqueJobName, cronExp, new XeroKeepConnectionScheduler());
        
        Test.startTest();
        Database.executeBatch(new XeroKeepConnection());
        Test.stopTest();

        
    }
    @isTest
    static void testXeroApiCalloutError() {
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404, '{"error": "Invoice not found"}'));

        Test.startTest();
        try{
        	Database.executeBatch(new XeroKeepConnection());
        }Catch(XeroKeepConnection.XeroApiException e){
            System.assert(e.getMessage().contains('404 - Not Found'));
        }
        Test.stopTest();
    }
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setStatus(getStatusString(statusCode));
            res.setBody(responseBody);
            return res;
        }

        private String getStatusString(Integer statusCode) {
            if (statusCode == 200) {
                return 'OK';
            } else if (statusCode == 404) {
                return 'Not Found';
            } else {
                return 'Unknown';
            }
        }
    }
}