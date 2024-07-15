@isTest
public class XeroKeepConnectionSchedulerTest {

    public class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Invoices": [{"InvoiceID": "123", "Contact": {"Name": "Test Contact"}, "Date": "2023-01-01T00:00:00"}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testExecuteCallout() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        XeroKeepConnection.executeCallout();
        Test.stopTest();
    }

    @isTest
    static void testScheduler() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        String uniqueJobName = 'Test Xero Callout Job ' + System.currentTimeMillis();

        String cronExp = '0 0 2 * * ?';
        String jobId = System.schedule(uniqueJobName, cronExp, new XeroKeepConnectionScheduler());

        Test.startTest();
        System.enqueueJob(new XeroKeepConnection());
        Test.stopTest();

    }
}