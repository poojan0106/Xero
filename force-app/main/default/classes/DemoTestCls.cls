@isTest
public class DemoTestCls {
    @isTest 
    static void testGetAllPrepayments() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroAllPrepayments'));
        
        Test.startTest();
        
        List<XeroPrepayment> perpays = XeroAPI.getPrepayments();
        System.debug(' : perpays :'+perpays);
        XeroPrepayment xp = new XeroPrepayment();
        XeroPrepayment xp1 = new XeroPrepayment('1aba06f5-e339-4790-86b9-e82c1da0d069');
        xp.serialize();
        
        
        Test.stopTest();
        
        
    }
    
        public static StaticResourceCalloutMock setStaticMock (String mockName) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        return mock;
    }

}