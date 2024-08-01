/*
*	Created : 	By Yogesh
*	Date 	: 	26-03-2021
*/
@isTest 
public class XeroAPITest {
    
    @testSetup
    static void setup() {
        Xero_Setup__c setupRecord = new Xero_Setup__c(
            Access_Token__c = 'dummyAccessToken',
            Refresh_Token__c = 'dummyRefreshToken',
            Token_Expiration_time__c = DateTime.now().addMinutes(1)
        );
        insert setupRecord;
        
        Xero_Admin__c adminRecord = new Xero_Admin__c(
            Client_Id__c = 'dummyClientId',
            Client_Secret__c = 'dummyClientSecret'
        );
        insert adminRecord;
    }

    @isTest 
    static void testGetContact() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock'));
        
        Test.startTest();
        
        XeroContact xeroContact = XeroAPI.getContact('10b46b4c-35c1-49c4-a7eb-983ab08ebe1a');
        try{
            String process401ErrorN = XeroUtils.process401Error('process401Error = process401Error');
        }
        catch(Exception e){}
        
        Test.stopTest();
        
        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            xeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }
    
  
    @isTest 
    static void testGetContactN() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        try{
            XeroContact xeroContact = XeroAPI.getContact('10b46b4c-35c1-49c4-a7eb-983ab08ebe1a');
        }
        catch(Exception e)
        {
            
        }
        Test.stopTest();
        
        
    }
    
    @isTest 
    static void testGetContacts() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock'));
        
        Test.startTest();
        XeroContact xeroContact;
        try{
            xeroContact = XeroAPI.getContacts()[0];
        }
        catch(Exception e)
        {
            
        }
        
        
        Test.stopTest();
        
        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            xeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }
    
    @isTest 
    static void testGetContactsN() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        try{
            XeroContact xeroContact = XeroAPI.getContacts()[0];
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest 
    static void testSendContactForChild() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock'));
        
        Contact con = new Contact();
        con.Firstname = 'Yogesh';
        con.lastname = 'Baldaniya';
        con.Email = 'Yogesh@resonantcloud.info';
        insert con;
        
        Account accChild = new Account();
        accChild.Name = 'accChild';  
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial'; 
        accChild.Commercial_Classification__c = 'Normal';
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
        insert accChild;
        
        XeroContact myXeroContact = new XeroContact(accChild);
        
        Test.startTest();
        
        myXeroContact = XeroAPI.sendContact(myXeroContact, 'accessToken');
        XeroConnection xc = new XeroConnection();
        Test.stopTest();
        
        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            myXeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }
    
    @isTest 
    static void testSendContactForChildN() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Contact con = new Contact();
        con.Firstname = 'Yogesh';
        con.lastname = 'Baldaniya';
        con.Email = 'Yogesh@resonantcloud.info';
        insert con;
        
        Account accChild = new Account();
        accChild.Name = 'accChild';  
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial'; 
        accChild.Commercial_Classification__c = 'Normal';
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
        insert accChild;
        try{
            XeroContact myXeroContact = new XeroContact(accChild);
            
            Test.startTest();
            
            myXeroContact = XeroAPI.sendContact(myXeroContact,'accessToken');
            Test.stopTest();
        }
        catch(Exception e)
        {
            
        }
    }
    
    @isTest 
    static void testSendContactForParent() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock'));
        
        Contact con = new Contact();
        con.Firstname = 'Yogesh';
        con.lastname = 'Baldaniya';
        con.Email = 'Yogesh@resonantcloud.info';
        insert con;
        
        Account accParent = new Account();
        accParent.Name = 'accParent';
        accParent.Active__c= true;
        accParent.Payment_Term__c = 2;
        accParent.Type = 'Commercial';
        accParent.Commercial_Classification__c = 'Normal';
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
        accChild.Commercial_Classification__c = 'Normal';
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
        
        XeroContact myXeroContact = new XeroContact(accChild);
        
        Test.startTest();
        
        myXeroContact = XeroAPI.sendContact(myXeroContact,'accessToken');
        
        Test.stopTest();
        
        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            myXeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }
    
    @isTest 
    static void getGetInvoice() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock'));
        List<XeroInvoice> xi_List = new List<XeroInvoice>();
        Account accChild = new Account();
        accChild.Name = 'accChild';  
        accChild.Active__c= true;
        accChild.Payment_Term__c = 2;
        accChild.Type = 'Commercial';
        accChild.Commercial_Classification__c = 'Normal';
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
        insert accChild;
        Invoice__c i = new Invoice__c();
        i.Account__c = accChild.id;
        i.Xero_ID__c = '30aa67f9-d5e5-4351-9e28-c085a6b2d37f';
        i.Status__c = 'Status__c';
        insert i; 
        
        Test.startTest();
        
        XeroInvoice xeroInvoice = XeroAPI.getInvoice('30aa67f9-d5e5-4351-9e28-c085a6b2d37f');
        xi_List.add(xeroInvoice);
        XeroInvoicePaymentStatusHandler.xeroInvoices(xi_List);
        Test.stopTest();
        
    }
    
    @isTest 
    static void testGetInvoices() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock'));
        
        Test.startTest();
        
        XeroInvoice xeroInvoice = XeroAPI.getInvoices()[0];
        Test.stopTest();
        
    }
    
    @isTest 
    static void testGetInvoicesWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        try
        {
            XeroInvoice xeroInvoice = XeroAPI.getInvoices()[0];
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    
    @isTest 
    static void testGetInvoicesWithDaysFilter() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock'));
        
        Test.startTest();
        try
        {
            XeroInvoice xeroInvoice = XeroAPI.getInvoices(1)[0];
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    
    @isTest 
    static void testgetInvoiceWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        
        try
        {
            XeroInvoice xeroInvoice = XeroAPI.getInvoice('Helebv');
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest 
    static void testgetModifiedInvoicesWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        
        try
        {
            List<XeroInvoice> xeroInvoice = XeroAPI.getModifiedInvoices(System.today());
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest 
    static void testGetInvoicesWithDaysFilterWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        
        try
        {
            List<XeroInvoice> xeroInvoice = XeroAPI.getInvoices(1);
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest 
    static void testSendInvoice() {
        
        // Set the Mock Class    
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
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
        accChild.Commercial_Classification__c = 'Normal';
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
        insert accChild;
        
        Asset ass = new Asset();
        ass.Name = 'TEMP';
        ass.Street__c='28/16 Okinja Road';
        ass.City__c='Alexandra Headland';
        ass.Zip_Postal_Code__c='4572';
        ass.Country__c='Australia';
        ass.State_Province__c='Queensland';
        ass.AccountId=accChild.Id;
        //a.ContactId=con.Id;
        insert ass;
        
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
        wrkOrder.AssetId = ass.id;
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 1;
        wOLineItem.UnitPrice = 2310.01;
        wOLineItem.Discount = 2;
        wOLineItem.Description = 'USA Space Camp - Final Invoice';
        insert wOLineItem;
        
        WorkOrderLineItem wOLineItem2 = new WorkOrderLineItem();
        wOLineItem2.WorkOrderId = wrkOrder.Id;
        wOLineItem2.PricebookEntryId = pbookEntry.id;
        wOLineItem2.Quantity = 10;
        wOLineItem2.UnitPrice = 10;
        wOLineItem2.Discount = 2;
        insert wOLineItem2;
        
        List<WorkOrderLineItem> lst_WorkOderLineItems = new List<WorkOrderLineItem>();
        lst_WorkOderLineItems.add(wOLineItem);
        lst_WorkOderLineItems.add(wOLineItem2);
        
        wOLineItem.status = 'Completed';
        wOLineItem.Invoiced__c = False;
        update wOLineItem;
        lst_WorkOderLineItems.add(wOLineItem);      
        
        accChild.Xero_ID__c = '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a';
        update accChild;
        
        //Update workOder for creation invoice testing 
        checkRecursive_byRes.run = true;
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.completed_internally__c = true;
        wrkOrder.From_the_Finish_Flow__c = true;
        update wrkOrder;
        
        Attachment a = new Attachment();
        a.Name = 'name';
        a.body = blob.valueOf('base64');
        a.ParentId = accChild.id;
        insert a;
        
        XeroInvoice myXeroInvoiceN = new XeroInvoice(accChild.Xero_ID__c);  
        XeroPayment xp = new XeroPayment(accChild.Xero_ID__c, 200, 100.100, 'referenceFormate'); 
        String myAdd = 'Hello 123';
        XeroInvoice myXeroInvoice = new XeroInvoice('INV-0009', wrkOrder,accChild,accChild.Xero_ID__c,lst_WorkOderLineItems, myAdd,true);        
        
        Test.startTest();
        
        myXeroInvoice = XeroAPI.sendInvoice(myXeroInvoice,'accessToken');
        XeroAPI.getModifiedInvoices(System.today());
        XeroAPI.sendPayment(xp,'accessToken');
        
        XeroOnlineInvoice xoi = new XeroOnlineInvoice();
        xoi.serialize();
        
        XeroAccount xa = new XeroAccount(200, accChild.id);
        xa.serialize();
        
        XeroUtilityMail.confirmationEmail(accChild.id, 'InvNumber', accChild.id, 'nrupa@resonantcloud.info', 'InvUrl', 'Bundilla_Template', con.Id);
        
        List<XeroValidationError> xve = new List<XeroValidationError>();
        XeroValidationError.processValidationErrors(xve);
        
        XeroInvoice.TrackingCategory xt = new XeroInvoice.TrackingCategory('name', 'option');
        String myAdd1 = 'Hello 123';
        XeroInvoice myXeroInvoice1 = new XeroInvoice('INV-0009', wrkOrder,accChild,accChild.Xero_ID__c,lst_WorkOderLineItems, myAdd1,true);        
        
        Test.stopTest();
        
    }
    
    
    static testMethod void testSendInvoice2() {
        
        // Set the Mock Class
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        // multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        
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
        accParent.Commercial_Classification__c = 'Normal';
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
        
        
        /* Account accChild = new Account();
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
accChild.ParentId = accParent.id;
insert accChild;*/
        
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
        wrkOrder.AccountId = accParent.Id;
        wrkOrder.ContactId = con.id;
        wrkOrder.Pricebook2Id = Test.getStandardPricebookId();
        wrkOrder.Status = 'New';
        wrkOrder.Duration = 1;
        wrkOrder.Send_Invoice__c = 'No';
        insert wrkOrder;    
        
        WorkOrderLineItem wOLineItem = new WorkOrderLineItem();
        wOLineItem.WorkOrderId = wrkOrder.Id;
        wOLineItem.PricebookEntryId = pbookEntry.id;
        wOLineItem.Quantity = 1;
        wOLineItem.UnitPrice = 2310.01;
        wOLineItem.Discount = 2;
        wOLineItem.Description = 'USA Space Camp - Final Invoice';
        insert wOLineItem;
        
        WorkOrderLineItem wOLineItem2 = new WorkOrderLineItem();
        wOLineItem2.WorkOrderId = wrkOrder.Id;
        wOLineItem2.PricebookEntryId = pbookEntry.id;
        wOLineItem2.Quantity = 10;
        wOLineItem2.UnitPrice = 10;
        wOLineItem2.Discount = 2;
        insert wOLineItem2;
        
        List<WorkOrderLineItem> lst_WorkOderLineItems = new List<WorkOrderLineItem>();
        lst_WorkOderLineItems.add(wOLineItem);
        lst_WorkOderLineItems.add(wOLineItem2);
        
        wOLineItem.status = 'Completed';
        wOLineItem.Invoiced__c = False;
        update wOLineItem;
        lst_WorkOderLineItems.add(wOLineItem);      
        
        Accparent.Xero_ID__c = '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a';
        update Accparent;
        
        //Update workOder for creation invoice testing 
        checkRecursive_byRes.run = true;
        wrkOrder.Payment_Collected__c  = 10;
        wrkOrder.Send_Invoice__c = 'Yes';
        wrkOrder.completed_internally__c = true;
        wrkOrder.From_the_Finish_Flow__c = true;
        wrkOrder.Final_Service_Note__c = 'Yogesh';
        update wrkOrder;
        
        // Blob pdf = XeroAPI.getInvoiceAsPdf('30aa67f9-d5e5-4351-9e28-c085a6b2d37f');
        
    }

    @istest
    static void testGetInvoiceAsPDF() {

        //Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroOnlineInvoiceMock'));
        
        Test.startTest();
        
        XeroAPI.getInvoiceAsPdf('30aa67f9-d5e5-4351-9e28-c085a6b2d37f','accessToken');
        Test.stopTest();
    } 
    @istest
    static void testGetXeroTenantId() {
        
        //Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroConnectionsMock'));
        
        Test.startTest();
        
        
        system.assertEquals(
            '82d2a576-821a-44ac-869d-7f902857741d', 
            XeroAPI.getXeroTenantId(),
            'Xero Tenant should be retrieved.'
        );
        
        Test.stopTest();
    }
    
    @istest
    static void testGetXeroTenantIdWithEXp() {
        
        //
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        // Set the Mock Class
        //Test.setMock(HttpCalloutMock.class, setStaticMock('XeroConnectionsMock'));
        
        Test.startTest();
        
        try
        {
            String idsss = XeroApi.getXeroTenantId();
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
    }
    
    @isTest 
    static void getOnlineInvoiceTest() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroOnlineInvoiceMock'));
        
        Test.startTest();
        
        try
        {
            String xeroinvoiceResponse = XeroAPI.getOnlineInvoice('30aa67f9-d5e5-4351-9e28-c085a6b2d37f','accessToken');
        }
        catch(Exception e)
        {
            
        }
        
        
        Test.stopTest();
        
    }
    
    @isTest 
    static void getOnlineInvoiceTestN() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        try
        {
            String xeroinvoiceResponse = XeroAPI.getOnlineInvoice('30aa67f9-d5e5-4351-9e28-c085a6b2d37f','accessToken');
        }
        catch(Exception e)
        {
            
        }
        Test.stopTest();
        
    }

    static testMethod void TestInvoiceCreationForParentAcc2ForPrepay()
    {
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Connections','XeroConnectionMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Contacts','XeroContactMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices','XeroInvoiceMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Payments','XeroPaymentMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Invoices/30aa67f9-d5e5-4351-9e28-c085a6b2d37f/OnlineInvoice','XeroOnlineInvoiceMock');
        
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Prepayments/?IDs=17020147-39af-46b0-9447-53b1ca7fdbd9,2e9f8bd3-6130-41d5-a7f7-ad746aa5c474','XeroPrepaymentsMock');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9','XeroPrepaymentsMock'); 
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Prepayments','XeroAllPrepayments');
        
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Prepayments/17020147-39af-46b0-9447-53b1ca7fdbd9/Allocations','XeroPrepaymentAllocations_350');
        multimock.setStaticResource('https://api.xero.com/api.xro/2.0/Prepayments/2e9f8bd3-6130-41d5-a7f7-ad746aa5c474/Allocations','XeroPrepaymentAllocations_150');
        
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        
        /*XeroPrepayment xp = new XeroPrepayment();
        XeroPrepayment xp1 = new XeroPrepayment('1aba06f5-e339-4790-86b9-e82c1da0d069');
        xp.serialize();*/
        
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
        accParent.Commercial_Classification__c = 'Normal';
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
        accChild.Commercial_Classification__c = 'Normal';
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
        
        Test.stopTest();

    }
    
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
    
    /*
     @isTest 
    static void testGetPrepaymentWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        
        try
        {
            
            List<XeroPrepayment> perpays = XeroAPI.getPrepayment('kk','ll');
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }*/
    
    
    @isTest 
    static void testGetSinglePrepaymentWithExp() {
        
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Fake());
        
        Test.startTest();
        
        try
        {
            
            List<XeroPrepayment> perpays = XeroAPI.getSinglePrepayment('kk','accessToken');
        }
        catch(Exception e)
        {
            
        }
        
        Test.stopTest();
        
    }
    
    
    public static StaticResourceCalloutMock setStaticMock (String mockName) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        return mock;
    }
    

    
    
    public static StaticResourceCalloutMock setStaticMock2 (String mockName) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json');
        return mock;
        
    }
    
    
}