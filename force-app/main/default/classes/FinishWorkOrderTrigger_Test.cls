@isTest
public class FinishWorkOrderTrigger_Test {
    
    
    static testMethod void TestInvoiceCreation() 
    {
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);
        
        Contact con = new Contact();
        con.Firstname = 'Princee';
        con.lastname = 'soni';
        con.Email = 'princee@resonantcloud.info';
        insert con;
        
        Account accChild = new Account();
        accChild.Name = 'accChild';  
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial'; 
        accChild.BillingStreet = '21 Girvan Grove';
        accChild.BillingCity = 'Ironbark';
        accChild.BillingState = 'Victoria';
        accChild.BillingPostalCode = '3550';
        accChild.BillingCountry = 'Australia';
        accChild.ShippingCity = accChild.BillingCity;
        accChild.ShippingCountry = accChild.BillingCountry;
        accChild.ShippingPostalCode =accChild.BillingPostalCode;
        accChild.ShippingState=accChild.BillingState;
        accChild.ShippingStreet = accChild.BillingStreet; 
        accChild.Billing_Contact__c = con.id;
        accChild.Payment_Term__c = 5;
        insert accChild;
        
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
        
        Pricebookentry pbookEntry = new Pricebookentry();
        pbookEntry.Pricebook2Id =  Test.getStandardPricebookId();
        pbookEntry.product2id = product.Id;
        pbookEntry.UnitPrice = 1;
        pbookEntry.isActive = true;
        pbookEntry.UseStandardPrice = false;
        insert pbookEntry;
        
        //Create work Oder 
        WorkOrder wrkOrder = new WorkOrder();
        wrkOrder.AccountId = accChild.Id;
        wrkOrder.ContactId = con.id;
        wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
        wrkOrder.Status = 'New';
        wrkOrder.Duration = 1;
        wrkOrder.Send_Invoice__c = 'No';
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 10;
        wOLineItem.UnitPrice = 10;
        wOLineItem.Discount = 2;
        insert wOLineItem;
        
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        update wrkOrder;
        
    }
    
    static testMethod void TestInvoiceCreationForParentAcc()
    {
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);
        
        Contact con = new Contact();
        con.Firstname = 'Princee';
        con.lastname = 'soni';
        con.Email = 'princee@resonantcloud.info';
        insert con;
        
        Account accParent = new Account();
        accParent.Name = 'accParent';
        accParent.Active__c= true;
        accParent.Payment_Term__c = 2;
        accParent.Type = 'Commercial';
        accParent.BillingStreet = 'Address Demo';
        accParent.BillingCity = 'Ironbark';
        accParent.BillingState = 'Victoria';
        accParent.BillingPostalCode = '3550';
        accParent.BillingCountry = 'Australia';
        accParent.ShippingCity = accParent.BillingCity;
        accParent.ShippingCountry = accParent.BillingCountry;
        accParent.ShippingPostalCode =accParent.BillingPostalCode;
        accParent.ShippingState=accParent.BillingState;
        accParent.ShippingStreet = accParent.BillingStreet;
        accParent.Billing_Contact__c = con.id;
        accParent.Payment_Term__c = 5;
        accParent.Xero_ID__c = '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a';
        insert accParent;
        
        Account accChild = new Account();
        accChild.Name = 'accChild';
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial';
        accChild.ParentId = accParent.id;
        accChild.BillingStreet = 'Address Demo';
        accChild.BillingCity = 'Ironbark';
        accChild.BillingState = 'Victoria';
        accChild.BillingPostalCode = '3550';
        accChild.BillingCountry = 'Australia';
        accChild.ShippingCity = accChild.BillingCity;
        accChild.ShippingCountry = accChild.BillingCountry;
        accChild.ShippingPostalCode =accChild.BillingPostalCode;
        accChild.ShippingState=accChild.BillingState;
        accChild.ShippingStreet = accChild.BillingStreet;
        accChild.Billing_Contact__c = con.id;
        accChild.Payment_Term__c = 5;
        insert accChild;
        
        Asset a = new Asset();
        a.Name = 'TEMP';
        a.Street__c='28/16 Okinja Road';
        a.City__c='Alexandra Headland';
        a.Zip_Postal_Code__c='4572';
        a.Country__c='Australia';
        a.State_Province__c='Queensland';
        a.AccountId=accChild.Id;
        //a.ContactId=con.Id;
        insert a;
        
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
        
        Pricebookentry pbookEntry = new Pricebookentry();
        pbookEntry.Pricebook2Id =  Test.getStandardPricebookId();
        pbookEntry.product2id = product.Id;
        pbookEntry.UnitPrice = 1;
        pbookEntry.isActive = true;
        pbookEntry.UseStandardPrice = false;
        insert pbookEntry;
        
        //Create work Oder 
        WorkOrder wrkOrder = new WorkOrder();
        wrkOrder.AccountId = accChild.Id;
        wrkOrder.ContactId = con.id;
        wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
        wrkOrder.Status = 'New';
        wrkOrder.Duration = 1;
        wrkOrder.Send_Invoice__c = 'No';
        wrkOrder.AssetId = a.id;
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 10;
        wOLineItem.UnitPrice = 10;
        wOLineItem.Discount = 2;
        insert wOLineItem;
        
        WorkOrderLineItem wOLineItem1 = new WorkOrderLineItem();
        wOLineItem1.WorkOrderId = wrkOrder.Id;
        wOLineItem1.PricebookEntryId = pbookEntry.id;
        wOLineItem1.Quantity = 11;
        wOLineItem1.UnitPrice = 11;
        wOLineItem1.Discount = 22;
        insert wOLineItem1;
        
        WorkOrderLineItem wOLineItem2 = new WorkOrderLineItem();
        wOLineItem2.WorkOrderId = wrkOrder.Id;
        wOLineItem2.PricebookEntryId = pbookEntry.id;
        wOLineItem2.Quantity = 132;
        wOLineItem2.UnitPrice = 132;
        wOLineItem2.Discount = 2;
        insert wOLineItem2;
        
        wOLineItem.Status = 'Completed';
        wOLineItem.Invoiced__c = false;
        update wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.From_the_Finish_Flow__c = True;
        update wrkOrder;
        
    }
    
    static testMethod void TestInvoiceCreationForParentAcc2()
    {
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/?IDs=17020147-39af-46b0-9447-53b1ca7fdbd9,2e9f8bd3-6130-41d5-a7f7-ad746aa5c474','XeroPrepaymentsMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9','XeroPrepaymentsMock'); 
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments','XeroAllPrepayments');
        
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9/Allocations','XeroPrepaymentAllocations_350');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/2e9f8bd3-6130-41d5-a7f7-ad746aa5c474/Allocations','XeroPrepaymentAllocations_150');
        
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);
        
        Contact con = new Contact();
        con.Firstname = 'Princee';
        con.lastname = 'soni';
        con.Email = 'princee@resonantcloud.info';
        insert con;
        
        Account accParent = new Account();
        accParent.Name = 'accParent';
        accParent.Active__c= true;
        accParent.Payment_Term__c = 2;
        accParent.Type = 'Commercial';
        accParent.BillingStreet = 'Address Demo';
        accParent.BillingCity = 'Ironbark';
        accParent.BillingState = 'Victoria';
        accParent.BillingPostalCode = '3550';
        accParent.BillingCountry = 'Australia';
        accParent.ShippingCity = accParent.BillingCity;
        accParent.ShippingCountry = accParent.BillingCountry;
        accParent.ShippingPostalCode =accParent.BillingPostalCode;
        accParent.ShippingState=accParent.BillingState;
        accParent.ShippingStreet = accParent.BillingStreet;
        accParent.Billing_Contact__c = con.id;
        accParent.Payment_Term__c = 5;
        accParent.Xero_ID__c = '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a';
        insert accParent;
        
        Account accChild = new Account();
        accChild.Name = 'accChild';
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial';
        accChild.ParentId = accParent.id;
        accChild.BillingStreet = 'Address Demo';
        accChild.BillingCity = 'Ironbark';
        accChild.BillingState = 'Victoria';
        accChild.BillingPostalCode = '3550';
        accChild.BillingCountry = 'Australia';
        accChild.ShippingCity = accChild.BillingCity;
        accChild.ShippingCountry = accChild.BillingCountry;
        accChild.ShippingPostalCode =accChild.BillingPostalCode;
        accChild.ShippingState=accChild.BillingState;
        accChild.ShippingStreet = accChild.BillingStreet;
        accChild.Billing_Contact__c = con.id;
        accChild.Payment_Term__c = 5;
        insert accChild;
        
        Asset a = new Asset();
        a.Name = 'TEMP';
        a.Street__c='28/16 Okinja Road';
        a.City__c='Alexandra Headland';
        a.Zip_Postal_Code__c='4572';
        a.Country__c='Australia';
        a.State_Province__c='Queensland';
        a.AccountId=accChild.Id;
        //a.ContactId=con.Id;
        insert a;
        
        //Test WorkType
        WorkType wtype = new WorkType();
        wtype.Name = 'testWorkType';
        wtype.EstimatedDuration = 22.22;
        insert wtype;
        
        //Added Product 
        Product2 product = new Product2();
        product.Name = 'USA Space Camp - Final Invoice';
        product.Work_Type__c = wtype.id;
        product.isActive = true;
        insert product;
        
        Pricebookentry pbookEntry = new Pricebookentry();
        pbookEntry.Pricebook2Id =  Test.getStandardPricebookId();
        pbookEntry.product2id = product.Id;
        pbookEntry.UnitPrice = 1;
        pbookEntry.isActive = true;
        pbookEntry.UseStandardPrice = false;
        insert pbookEntry;
        
        //Create work Oder 
        WorkOrder wrkOrder = new WorkOrder();
        wrkOrder.AccountId = accChild.Id;
        wrkOrder.ContactId = con.id;
        wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
        wrkOrder.Status = 'New';
        wrkOrder.Duration = 1;
        wrkOrder.Send_Invoice__c = 'No';
        //wrkOrder.AssetId = a.id;
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 1.0000;
        wOLineItem.UnitPrice = 2310.01;
        wOLineItem.Discount = 2;
        insert wOLineItem;
        
        WorkOrderLineItem wOLineItem1 = new WorkOrderLineItem();
        wOLineItem1.WorkOrderId = wrkOrder.Id;
        wOLineItem1.PricebookEntryId = pbookEntry.id;
        wOLineItem1.Quantity = 11;
        wOLineItem1.UnitPrice = 11;
        wOLineItem1.Discount = 22;
        insert wOLineItem1;
        
        WorkOrderLineItem wOLineItem2 = new WorkOrderLineItem();
        wOLineItem2.WorkOrderId = wrkOrder.Id;
        wOLineItem2.PricebookEntryId = pbookEntry.id;
        wOLineItem2.Quantity = 132;
        wOLineItem2.UnitPrice = 132;
        wOLineItem2.Discount = 2;
        insert wOLineItem2;
        
        wOLineItem.Status = 'Completed';
        wOLineItem.Invoiced__c = false;
        update wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.From_the_Finish_Flow__c = True;
        wrkOrder.Pre_payment_1_xero_id__c = '17020147-39af-46b0-9447-53b1ca7fdbd9';
        wrkOrder.Pre_payment_1_xero_remaining_amount__c = 350;
        update wrkOrder;
        
    }
    
    static testMethod void TestInvoiceCreationForParentAcc2ForPrepay()
    {
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/?IDs=17020147-39af-46b0-9447-53b1ca7fdbd9,2e9f8bd3-6130-41d5-a7f7-ad746aa5c474','XeroPrepaymentsMock');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9','XeroPrepaymentsMock'); 
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments','XeroAllPrepayments');
        
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9/Allocations','XeroPrepaymentAllocations_350');
        multimock.setStaticResource('callout:Xero/api.xro/2.0/Prepayments/2e9f8bd3-6130-41d5-a7f7-ad746aa5c474/Allocations','XeroPrepaymentAllocations_150');
        
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);
        
        Contact con = new Contact();
        con.Firstname = 'yogi';
        con.lastname = 'ahir Contact';
        con.Email = 'yogesh@resonantcloud.info';
        insert con;
        
        Account accParent = new Account();
        accParent.Name = 'yogi ahir parentAcc';
        accParent.Active__c= true;
        accParent.Payment_Term__c = 2;
        accParent.Type = 'Commercial';
        accParent.BillingStreet = 'Address Demo';
        accParent.BillingCity = 'Ironbark';
        accParent.BillingState = 'Victoria';
        accParent.BillingPostalCode = '3550';
        accParent.BillingCountry = 'Australia';
        accParent.ShippingCity = accParent.BillingCity;
        accParent.ShippingCountry = accParent.BillingCountry;
        accParent.ShippingPostalCode =accParent.BillingPostalCode;
        accParent.ShippingState=accParent.BillingState;
        accParent.ShippingStreet = accParent.BillingStreet;
        accParent.Billing_Contact__c = con.id;
        accParent.Payment_Term__c = 28;
        accParent.Xero_ID__c = '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a';
        insert accParent;
        
        Account accChild = new Account();
        accChild.Name = 'Yogesh childAcc';
        accChild.Active__c= true;
        accChild.Type = 'Commercial';
        accChild.ParentId = accParent.id;
        accChild.BillingStreet = '67 Mount Mellum Road';
        accChild.BillingCity = 'Landsborough';
        accChild.BillingState = 'Queensland';
        accChild.BillingPostalCode = '4550';
        accChild.BillingCountry = 'Australia';
        accChild.ShippingCity = accChild.BillingCity;
        accChild.ShippingCountry = accChild.BillingCountry;
        accChild.ShippingPostalCode =accChild.BillingPostalCode;
        accChild.ShippingState=accChild.BillingState;
        accChild.ShippingStreet = accChild.BillingStreet;
        accChild.Billing_Contact__c = con.id;
        accChild.Payment_Term__c = 12;
        insert accChild;
        
        Asset asset = new Asset();
        asset.Name = 'TEMP';
        asset.Street__c='28/16 Okinja Road';
        asset.City__c='Alexandra Headland';
        asset.Zip_Postal_Code__c='4572';
        asset.Country__c='Australia';
        asset.State_Province__c='Queensland';
        asset.AccountId=accChild.Id;
        //a.ContactId=con.Id;
        insert asset;
        
        //Test WorkType
        WorkType wtype = new WorkType();
        wtype.Name = 'testWorkType';
        wtype.EstimatedDuration = 22.22;
        insert wtype;
        
        //Added Product 
        Product2 product = new Product2();
        product.Name = 'USA Space Camp - Final Invoice';
        product.Work_Type__c = wtype.id;
        product.isActive = true;
        insert product;
        
        Pricebookentry pbookEntry = new Pricebookentry();
        pbookEntry.Pricebook2Id =  Test.getStandardPricebookId();
        pbookEntry.product2id = product.Id;
        pbookEntry.UnitPrice = 1;
        pbookEntry.isActive = true;
        pbookEntry.UseStandardPrice = false;
        insert pbookEntry;
        
        //Create work Oder 
        WorkOrder wrkOrder = new WorkOrder();
        wrkOrder.AccountId = accChild.Id;
        wrkOrder.ContactId = con.id;
        WrkOrder.AssetId = asset.id;
        wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
        wrkOrder.Status = 'New';
        wrkOrder.Duration = 1;
        wrkOrder.Send_Invoice__c = 'No';
        //wrkOrder.AssetId = a.id;
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 1.0000;
        wOLineItem.UnitPrice = 1000;
        insert wOLineItem;
        
        /*WorkOrderLineItem wOLineItem1 = new WorkOrderLineItem();
wOLineItem1.WorkOrderId = wrkOrder.Id;
wOLineItem1.PricebookEntryId = pbookEntry.id;
wOLineItem1.Quantity = 11;
wOLineItem1.UnitPrice = 11;
wOLineItem1.Discount = 22;
insert wOLineItem1;*/
        
        /*
WorkOrderLineItem wOLineItem2 = new WorkOrderLineItem();
wOLineItem2.WorkOrderId = wrkOrder.Id;
wOLineItem2.PricebookEntryId = pbookEntry.id;
wOLineItem2.Quantity = 132;
wOLineItem2.UnitPrice = 132;
wOLineItem2.Discount = 2;
insert wOLineItem2; */
        
        wOLineItem.Status = 'Completed';
        wOLineItem.Invoiced__c = false;
        update wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 100;
        wrkOrder.Deposit_Collected__c = 400;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.From_the_Finish_Flow__c = True;
        wrkOrder.Pre_payment_1_xero_id__c = '17020147-39af-46b0-9447-53b1ca7fdbd9';
        wrkOrder.Pre_payment_1_xero_remaining_amount__c = 350;
        wrkOrder.Pre_payment_2_xero_id__c = '2e9f8bd3-6130-41d5-a7f7-ad746aa5c474';
        wrkOrder.Pre_payment_2_xero_remaining_amount__c = 150;
        update wrkOrder;
        
    }
    
    
    public static StaticResourceCalloutMock setStaticMock(String mockName) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        return mock;
    }
    
}