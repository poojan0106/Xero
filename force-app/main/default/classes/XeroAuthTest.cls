@isTest
public class XeroAuthTest {
    @testSetup
    static void setup() {
        // Setup test data
        Xero_Admin__c adminSetup = new Xero_Admin__c(
            Client_Id__c = 'testClientId',
            Client_Secret__c = 'testClientSecret',
            redirectUrl__c = 'https://test.redirect.url'
        );
        insert adminSetup;
    }

    @isTest
    static void testGetAuthorizationUrl() {
        Test.startTest();
        String authorizationUrl = XeroOAuth2.getAuthorizationUrl();
        System.assertNotEquals(null, authorizationUrl, 'Authorization URL should not be null');
        System.assert(authorizationUrl.contains('testClientId'), 'Authorization URL should contain clientId');
        Test.stopTest();
    }

    @isTest
    static void testExchangeCodeForTokenSuccess() {
        Test.setMock(HttpCalloutMock.class, new XeroTokenMock());

        Test.startTest();
        XeroOAuth2.exchangeCodeForToken('testCode');
        Test.stopTest();

        Xero_Setup__c tokenRecord = [SELECT Access_Token__c, Refresh_Token__c FROM Xero_Setup__c LIMIT 1];
        System.assertNotEquals(null, tokenRecord, 'Token record should have been inserted');
        System.assertEquals('mockAccessToken', tokenRecord.Access_Token__c, 'Access token should match the mock response');
        System.assertEquals('mockRefreshToken', tokenRecord.Refresh_Token__c, 'Refresh token should match the mock response');
    }

    @isTest
    static void testExchangeCodeForTokenFailure() {
        Test.setMock(HttpCalloutMock.class, new XeroTokenMockFailure());

        Test.startTest();
        try {
            XeroOAuth2.exchangeCodeForToken('testCode');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Error: mock error response'), 'Exception message should contain mock error response');
        }
        Test.stopTest();
    }

    @isTest
    static void testXeroAuthClass() {
        Test.startTest();
        XeroAuthClass authClass = new XeroAuthClass();
        String authUrl = authClass.authUrl;
        System.assertNotEquals(null, authUrl, 'Authorization URL should not be null');
        System.assert(authUrl.contains('testClientId'), 'Authorization URL should contain clientId');
        Test.stopTest();
    }

    @isTest
    static void testRedirectToXero() {
        Test.startTest();
        XeroAuthClass authClass = new XeroAuthClass();
        PageReference pageRef = authClass.redirectToXero();
        System.assertNotEquals(null, pageRef, 'Page reference should not be null');
        Test.stopTest();
    }

    @isTest
    static void testHandleCallback() {
        Test.setMock(HttpCalloutMock.class, new XeroTokenMock());

        Test.startTest();
        PageReference pageRef = Page.callbackPage; // replace with actual page name
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('code', 'testCode');

        XeroAuthClass authClass = new XeroAuthClass();
        authClass.handleCallback();

        Xero_Setup__c tokenRecord = [SELECT Access_Token__c, Refresh_Token__c FROM Xero_Setup__c LIMIT 1];
        System.assertNotEquals(null, tokenRecord, 'Token record should have been inserted');
        System.assertEquals('mockAccessToken', tokenRecord.Access_Token__c, 'Access token should match the mock response');
        System.assertEquals('mockRefreshToken', tokenRecord.Refresh_Token__c, 'Refresh token should match the mock response');
        Test.stopTest();
    }

    @isTest
    static void testStoreTokens() {
        Test.startTest();
        XeroTokenManager.storeTokens('testAccessToken', 'testRefreshToken');
        Test.stopTest();

        Xero_Setup__c tokenRecord = [SELECT Access_Token__c, Refresh_Token__c FROM Xero_Setup__c LIMIT 1];
        System.assertNotEquals(null, tokenRecord, 'Token record should have been inserted');
        System.assertEquals('testAccessToken', tokenRecord.Access_Token__c, 'Access token should match the input');
        System.assertEquals('testRefreshToken', tokenRecord.Refresh_Token__c, 'Refresh token should match the input');
    }

    @isTest
    static void testGetToken() {
        Xero_Setup__c tokenRecord = new Xero_Setup__c(
            Access_Token__c = 'existingAccessToken',
            Refresh_Token__c = 'existingRefreshToken'
        );
        insert tokenRecord;

        Test.startTest();
        Xero_Setup__c fetchedToken = XeroTokenManager.getToken();
        Test.stopTest();

        System.assertNotEquals(null, fetchedToken, 'Token record should have been fetched');
        System.assertEquals('existingAccessToken', fetchedToken.Access_Token__c, 'Access token should match the inserted value');
        System.assertEquals('existingRefreshToken', fetchedToken.Refresh_Token__c, 'Refresh token should match the inserted value');
    }

    @isTest
    static void testUpdateAccessToken() {
        Xero_Setup__c tokenRecord = new Xero_Setup__c(
            Access_Token__c = 'oldAccessToken',
            Refresh_Token__c = 'existingRefreshToken'
        );
        insert tokenRecord;

        Test.startTest();
        XeroTokenManager.updateAccessToken('newAccessToken');
        Test.stopTest();

        Xero_Setup__c updatedToken = [SELECT Access_Token__c, Refresh_Token__c FROM Xero_Setup__c LIMIT 1];
        System.assertEquals('newAccessToken', updatedToken.Access_Token__c, 'Access token should have been updated');
        System.assertEquals('existingRefreshToken', updatedToken.Refresh_Token__c, 'Refresh token should remain unchanged');
    }
    // Mock class for successful token exchange response
    
    public class XeroTokenMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"access_token":"mockAccessToken","refresh_token":"mockRefreshToken"}');
            return res;
        }
    }
    
    // Mock class for failed token exchange response
    
    public class XeroTokenMockFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(400);
            res.setBody('{"error":"mock error response"}');
            return res;
        }
    }
}