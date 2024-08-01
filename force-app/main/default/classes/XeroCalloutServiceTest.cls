@isTest
public class XeroCalloutServiceTest {

  @testSetup
    static void setup() {
        Xero_Setup__c setupRecord = new Xero_Setup__c(
            Access_Token__c = 'dummyAccessToken',
            Refresh_Token__c = 'dummyRefreshToken',
            Token_Expiration_time__c = DateTime.now().addMinutes(1)
        );
        insert setupRecord;
        
        Xero_Admin__c adminRecord = new Xero_Admin__c(
            Client_Id__c = 'dummyClientId',
            Client_Secret__c = 'dummyClientSecret'
        );
        insert adminRecord;
    }
    
    @isTest
    static void testExecuteCalloutWithRequestBody() {
        Test.startTest();
        
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"id":"12345"}');
        mockResponse.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        HttpResponse response = XeroCalloutService.executeCallout('POST', 'contacts', '{"name":"Test"}');
        
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('{"id":"12345"}', response.getBody());
        Xero_Setup__c setup = XeroCalloutService.refreshToken();
        Test.stopTest();
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}