@IsTest
public class FinishFlowInternalyController_Test {
    
    
    static testMethod void TestButtonFinishFlowInternalyController()
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
        wrkOrder.Send_Invoice__c = 'Yes';
        insert wrkOrder;   
        
        Invoice__c inv = new Invoice__c();
        inv.Work_Order__c = wrkOrder.id;
        inv.Account__c = accParent.id;
        insert inv;
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 10;
        wOLineItem.UnitPrice = 10;
        wOLineItem.Discount = 2;
        wOLineItem.Status ='Completed';
        insert wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.From_the_Finish_Flow__c = true;
        //update wrkOrder;
        
        Apexpages.StandardController sc=new Apexpages.StandardController(wrkOrder);
        Apexpages.currentPage().getParameters().put('Id',wrkOrder.id);
        FinishFlowInternalyController workOrderController = new FinishFlowInternalyController(sc);
        workOrderController.callFinishWorkOrderHelper();
        
        workOrderController.goBack();
        
    }
    
    static testMethod void TestButtonFinishFlowInternalyControllerMethod2()
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
        wOLineItem.Status ='Completed';
        insert wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.From_the_Finish_Flow__c = true;
        update wrkOrder;
        
        Apexpages.StandardController sc=new Apexpages.StandardController(wrkOrder);
        Apexpages.currentPage().getParameters().put('Id',wrkOrder.id);
        FinishFlowInternalyController workOrderController = new FinishFlowInternalyController(sc);
        workOrderController.callFinishWorkOrderHelper();
        
    }

	static testMethod void TestButtonFinishFlowInternalyControllerMethod3()
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
        wOLineItem.Status ='Completed';
        insert wOLineItem;
        
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing 
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.From_the_Finish_Flow__c = true;
        update wrkOrder;
        
        Apexpages.StandardController sc=new Apexpages.StandardController(wrkOrder);
        Apexpages.currentPage().getParameters().put('Id',wrkOrder.id);
        FinishFlowInternalyController workOrderController = new FinishFlowInternalyController(sc);
        workOrderController.callFinishWorkOrderHelper();
        
        wOLineItem.Invoiced__c = false;
        update wOLineItem;
            
        checkRecursive_byRes.run = true;
        //Update workOder for creation invoice testing  
        wrkOrder.Payment_Collected__c  = 100000;
        wrkOrder.From_the_Finish_Flow__c = true;
        update wrkOrder;
        
      
        workOrderController.callFinishWorkOrderHelper();
        
    }    
    public static StaticResourceCalloutMock setStaticMock(String mockName) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        return mock;
    }
}