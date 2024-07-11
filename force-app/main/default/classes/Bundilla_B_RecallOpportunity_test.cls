@istest
public class Bundilla_B_RecallOpportunity_test {
    @testSetup
    static void testData(){ 
        
        
        
    }
    
    static testmethod void test() {  
        
        
        Account account = new Account(
            Name = 'Test',
            Xero_ID__c = 'edfced',
            Type = 'Domestic Customer'
        );
        insert account;
        
        Contact contact = new Contact(
            AccountId = account.Id,
            LastName = 'Beau Rheinberger',
            Email = 'test@gmail.com'
        );
        insert contact;
        
        //Test WorkType
        WorkType wtype = new WorkType();
        wtype.Name = 'testWorkType';
        wtype.EstimatedDuration = 22.22;
        insert wtype;
        
        //Added Product 
        Product2 product = new Product2();
        product.Name = 'test';
        product.Work_Type__c = wtype.id;
        product.isActive = true;
        insert product;
        
        Product2 pr = new Product2();
        pr.name = 'Test Product';
        pr.Family = 'Pest - Domestic';
        pr.Description = 'test';
        pr.Work_Type__c = wtype.id;
        pr.isActive = true;
        insert pr;
        
        PriceBook2 customPriceBook = new PriceBook2();
        customPriceBook.Name='Custom Pricebook';
        customPriceBook.IsActive=true;
        insert customPriceBook;
        
        Pricebookentry pbookEntry = new Pricebookentry();
        pbookEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbookEntry.product2id = pr.Id;
        pbookEntry.UnitPrice = 1;
        pbookEntry.isActive = true;
        pbookEntry.UseStandardPrice = false;
        insert pbookEntry;
        
        Pricebookentry pbookEntry1 = new Pricebookentry();
        pbookEntry1.Pricebook2Id =  customPriceBook.id ;
        pbookEntry1.product2id = pr.Id;
        pbookEntry1.UnitPrice = 1;
        pbookEntry1.isActive = true;
        pbookEntry1.UseStandardPrice = false;
        insert pbookEntry1;
        
        
        Asset a = new Asset();
        a.Name = 'TEMP';
        a.Street__c='28/16 Okinja Road';
        a.City__c='Alexandra Headland';
        a.Zip_Postal_Code__c='4572';
        a.Country__c='Australia';
        a.State_Province__c='Queensland';
        a.AccountId=account.Id;
        a.ContactId=contact.Id;
        insert a;
        WorkOrder workOrder = new WorkOrder(
            Subject = 'Test',
            Pricebook2Id = customPriceBook.id,
            AccountId = account.Id,
            ContactId = contact.Id,
            AssetId=a.Id
        );
        insert workOrder;
        
        list<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();
        
        workOrderLineItems.add(new WorkOrderLineItem(
            WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours',
            Warranty_End_Date__c=System.today().addDays(21),
            Status = 'Completed',
            PricebookEntryId = pbookEntry1.Id
            
        ));
        workOrderLineItems.add(new WorkOrderLineItem(
            WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours',
            Warranty_End_Date__c=System.today().addDays(21),
            Status = 'Completed',
            PricebookEntryId = pbookEntry1.Id
        ));
        workOrderLineItems.add(new WorkOrderLineItem(
            WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Minutes',
            Warranty_End_Date__c=System.today().addDays(21),
            Status = 'Completed',
            PricebookEntryId = pbookEntry1.Id
        ));
        insert workOrderLineItems;
        
        
        /*String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);*/
        
            Test.startTest();
            Bundilla_B_RecallOpportunity uca = new Bundilla_B_RecallOpportunity();
            Id batchId = Database.executeBatch(uca);
            Test.stopTest();
        
        
        
    }
    
}