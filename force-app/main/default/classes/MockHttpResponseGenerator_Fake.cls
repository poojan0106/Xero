@isTest
global class MockHttpResponseGenerator_Fake implements HttpCalloutMock {
    // Implement this interface method
    // //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(400);
        return res;
    }
}