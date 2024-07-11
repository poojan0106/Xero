@istest
public class XeroErrorLog_ByRes_test {
    
    static testMethod void errorCreation1() 
    {
        try{
            insert new Account();
        }
        Catch(DmlException e){
            system.debug('Exception ' + e);
            
            Account acc = new Account();
            acc.name = 'Test';
            insert acc;  
            
			Invoice__c inv = new Invoice__c();
            inv.Account__c = acc.id;
            insert inv;
            
            Contact con = new Contact();
            con.Firstname = 'Princee';
            con.lastname = 'soni';
            con.Email = 'princee@resonantcloud.info';
            insert con;
            
            //Create work Oder 
            WorkOrder wrkOrder = new WorkOrder();
            wrkOrder.AccountId = acc.Id;
            wrkOrder.ContactId = con.id;
            wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
            wrkOrder.Status = 'New';
            wrkOrder.Duration = 1;
            wrkOrder.Send_Invoice__c = 'No';
            wrkOrder.completed_internally__c = true;
            insert wrkOrder;   
            
            XeroErrorLog_ByRes.createErrorLogForDml(e,' Test class ', inv.id, wrkOrder.id, acc.id, true);
        }
    }
    /*
    static testMethod void errorCreation2() 
    {
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        try
        {
            String idsss = XeroApi.getXeroTenantId();
        }
        catch(Exception e)
        {
            System.debug('@@@ e : '+e);
            
            Account acc = new Account();
            acc.name = 'Test';
            insert acc;  
            
			Invoice__c inv = new Invoice__c();
            inv.Account__c = acc.id;
            insert inv;
            
            
            XeroErrorLog_ByRes.createErrorLogForXeroCallout(e, 'test class', inv.id, null, acc.id);
        }

    }
	*/
	
}