@isTest
private class TestTinyUrlService {

    // Mock class to simulate HTTP responses
    private class MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public MockHttpResponse(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.responseBody = body;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.statusCode);
            response.setBody(this.responseBody);
            return response;
        }
    }

    // Test method for successful URL shortening
    @isTest static void testShortenSimpleUrlSuccess() {
        // Set up test data and mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{ "data": { "tiny_url": "http://tinyurl.com/example" } }'));

        TinyUrlService.SimpleTinyUrlRequest request = new TinyUrlService.SimpleTinyUrlRequest();
        request.longUrl = 'http://example.com';
        request.apiToken = 'apiTokenExample';

        Test.startTest();
        List<TinyUrlService.TinyUrlResponse> responses = TinyUrlService.shortenSimpleUrl(new List<TinyUrlService.SimpleTinyUrlRequest>{request});
        Test.stopTest();

        // Assertions
        System.assertEquals(1, responses.size());
        System.assertEquals('http://tinyurl.com/example', responses[0].tinyUrl);
        System.assertEquals(200, responses[0].code);
    }

    // Test method for handling non-200 responses
    @isTest static void testShortenSimpleUrlFailure() {
        // Mock a non-200 response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(400, '{}'));

        TinyUrlService.SimpleTinyUrlRequest request = new TinyUrlService.SimpleTinyUrlRequest();
        request.longUrl = 'http://example.com';
        request.apiToken = 'apiTokenExample';

        Test.startTest();
        List<TinyUrlService.TinyUrlResponse> responses = TinyUrlService.shortenSimpleUrl(new List<TinyUrlService.SimpleTinyUrlRequest>{request});
        Test.stopTest();

        // Assertions for failure scenario
        System.assertEquals(1, responses.size());
        System.assertNotEquals(null, responses[0].errors);
    }

    // Test method for exception handling
    @isTest static void testShortenSimpleUrlException() {
        // Mock an exception scenario
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, null)); // Assuming null body will trigger an exception

        TinyUrlService.SimpleTinyUrlRequest request = new TinyUrlService.SimpleTinyUrlRequest();
        request.longUrl = 'http://example.com';
        request.apiToken = 'apiTokenExample';

        Test.startTest();
        List<TinyUrlService.TinyUrlResponse> responses = TinyUrlService.shortenSimpleUrl(new List<TinyUrlService.SimpleTinyUrlRequest>{request});
        Test.stopTest();

        // Assertions for exception scenario
        System.assertEquals(1, responses.size());
        System.assertNotEquals(null, responses[0].errors);
    }

    
}