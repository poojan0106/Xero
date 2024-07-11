@isTest
public class RecallOpportunityByRes_test {
    static testmethod void test() {  
        
        
        Account account = new Account(
            Name = 'Test',
            Xero_ID__c = 'edfced'
        );
        insert account;
        
        Contact contact = new Contact(
            AccountId = account.Id,
            LastName = 'Beau Rheinberger',
            Email = 'test@gmail.com'
        );
        insert contact;
        
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
            Pricebook2Id = Test.getStandardPricebookId(),
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
            Status = 'Completed'
            
        ));
        workOrderLineItems.add(new WorkOrderLineItem(
            WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours',
            Warranty_End_Date__c=System.today().addDays(21),
            Status = 'Completed'
        ));
        workOrderLineItems.add(new WorkOrderLineItem(
            WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Minutes',
            Warranty_End_Date__c=System.today().addDays(21),
            Status = 'Completed'
        ));
        insert workOrderLineItems;
        

        
        Test.startTest();
        
        List<WorkOrderLineItem> wOrderLineItems_lst = [Select Id, Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,  Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive ,  Status from  WorkOrderLineItem];
        
        RecallOpportunityByRes.makeCall(wOrderLineItems_lst);
        Test.stopTest();
        
        
    }
    
}