/******
* Created by: Princee Soni -  Resonant cloud
* Created date: 10-03-2021
* Purpose : The work order finish flow should generate the invoice by the FSL technician
******/
public class FinishWorkOrderHelper {
    
    public static String className = String.valueOf(FinishWorkOrderHelper.class);
    public static Decimal prePay1 = 0;
    public static Decimal prePay2 = 0;
    
    @future(callout=true)
    public static void createXeroContact(List<Id> accountIds)
    {
            String accessToken;
            Xero_Setup__c Tokens;
        try
        {
            List<account> lstAccountToUpdate = new List<Account>();
            List<Account> lst_accounts = new List<Account>();
            List<Id> lst_ParentAccountIds = new List<Id>();

            DateTime currentDateTime = DateTime.now();
            Tokens = FinishWorkOrderHelper.CheckResponse(currentDateTime);

            if (Tokens != null) {
                accessToken = Tokens.Access_Token__c;
            } else {
                accessToken = null;
            }

            for(Account acc : [select id, ParentId, Xero_Email__c, BillingCity, Xero_ID__c, BillingAddress, Billing_Contact__r.Email,
                               BillingState, BillingCountry,Billingstreet, Payment_Term__c,
                               BillingPostalCode, name, phone 
                               from account where Id IN: accountIds])
            {
                if(acc.ParentId != null)
                {
                    lst_ParentAccountIds.add(acc.ParentId);
                }
                else
                {
                    lst_accounts.add(acc);
                }
            }
            
            if(!lst_ParentAccountIds.isEmpty() && lst_ParentAccountIds.size()>0)
            {
                for(Account acc : [select id, ParentId, Xero_Email__c, BillingCity, Xero_ID__c,
                                   BillingState, BillingCountry,Billingstreet, Billing_Contact__r.Email,
                                   BillingPostalCode, name, phone , Payment_Term__c
                                   from account where Id IN: lst_ParentAccountIds])
                {
                    lst_accounts.add(acc);
                }
            }
            
            
            
            if(!lst_accounts.isEmpty() && lst_accounts.size()>0)
            {
                for(Account acc : lst_accounts)
                {
                    XeroContact requestXeroContact = new XeroContact(acc);
                    XeroContact responseXeroContact;
                    
                    responseXeroContact = XeroAPI.sendContact(requestXeroContact,accessToken);
                    if(responseXeroContact.ContactID != null && responseXeroContact.ContactID != '')
                    {
                        acc.Xero_Id__c = responseXeroContact.ContactID;
                        lstAccountToUpdate.add(acc);
                    }
                    
                }
            }
            
            //now update accounts 
            if(!lstAccountToUpdate.isEmpty() && lstAccountToUpdate.size() > 0)
            {
                update lstAccountToUpdate;
            }
            if (Tokens != null) {
               update Tokens;
            }
        }
        catch(Exception e)
        {
            XeroErrorLog_ByRes.createErrorLogForDml(e,className+' Method : getWorkOrder()', null, null, accountIds[0], false);
            if (Tokens != null) {
                update Tokens;
            }
        }
    }
    
    public static set<Id> invoicesCreationIds(List<Id> workorderIds, List<WorkOrder> lst_WorkOrder, Map<Id, Account> map_Accounts)
    {
		System.debug('@@ Yogi 2021 : calling invoice creation method in handler ');
        List<Invoice__c> lst_InvoiceCreated = new List<Invoice__c>();
        
        Decimal totalLineItemAount = 0;
        
        for(WorkOrderLineItem woLineItem : [select id, WorkOrderId, Product_Name__c, Product2.Name, 
                                            PricebookEntry.Product2Id, UnitPrice, Quantity, Discount, TotalPrice  
                                            from WorkOrderLineItem 
                                            where WorkOrderId IN: workorderIds and Invoiced__c = FALSE and 
                                            Status ='Completed' ])
        {
           
            totalLineItemAount = totalLineItemAount + woLineItem.TotalPrice;
        }
       	
        if(totalLineItemAount > 0)
        {
            for(WorkOrder wo: lst_WorkOrder)
            {
                Invoice__c inv = new Invoice__c();
                //set Account 
                if(map_Accounts.containsKey(wo.AccountId))
                {
                    System.debug('!!@@ map_Accounts.get(wo.AccountId) @@!! $ : '+map_Accounts.get(wo.AccountId));
                    if(map_Accounts.get(wo.AccountId).ParentId != null)
                    {
                        //if parent account is exists 
                        inv.Account__c = map_Accounts.get(wo.AccountId).ParentId;
                    }
                    else
                    {
                        // parent account is not exists 
                        inv.Account__c = map_Accounts.get(wo.AccountId).Id;
                    }
                }
                inv.Work_Order__c = wo.Id;
                lst_InvoiceCreated.add(inv);
            }
            
            Boolean isInvoiceCreated = false;
            
            if(!lst_InvoiceCreated.isEmpty() && lst_InvoiceCreated.size() > 0)
            {
                insert lst_InvoiceCreated;
                isInvoiceCreated = true;
            }
            if(isInvoiceCreated)
            {
                //conver list to set
                Set<Id> invoiceIds = (new Map<Id,Invoice__c>(lst_InvoiceCreated)).keySet().clone();
                System.debug('invoiceIds : '+invoiceIds.size());
                if(!invoiceIds.isEmpty() && invoiceIds.size() > 0)
                {
                    return invoiceIds; 
                }
            }
        }
        return new Set<Id>();
    }
    
    @future(callout=true)
    public static void getWorkOrder(Set<Id> set_InvoiceIds, Boolean completed_internally)
    {
        List<Id> workorderIds = new List<Id>();
        Boolean isUpdateWorkOrder = false;
        String accessToken;
        Xero_Setup__c Tokens;
        try
        {
            DateTime currentDateTime = DateTime.now();
            Tokens = FinishWorkOrderHelper.CheckResponse(currentDateTime);

            if (Tokens != null) {
                accessToken = Tokens.Access_Token__c;
            } else {
                accessToken = null;
            }
            if(!set_InvoiceIds.isEmpty() && set_InvoiceIds.size() > 0)
            {
                
                map<Id,Invoice__c> map_InvoicesToWorkOrderId = new map<Id,Invoice__c>();
                
                for(Invoice__c get_Inv : [SELECT Id, name, Work_Order__c from Invoice__c WHERE id IN: set_InvoiceIds])
                {
                    if(get_Inv.Work_Order__c != null)
                    {
                        workorderIds.add(get_Inv.Work_Order__c);
                        map_InvoicesToWorkOrderId.put(get_Inv.Work_Order__c,get_Inv);
                    }
                }
                
                if(!workorderIds.isEmpty() && workorderIds.size() > 0)
                {
                    
                    system.debug('Princee FinishWorkOrderHelper Ids ' + workorderIds);
                    
                    List<Workorder> lstWorkOrder = [select id,WorkOrderNumber, ContactId, AccountId, Account.ParentId, Account.Xero_ID__c,LastModifiedBy.Alias,
                                                    account.Xero_Email__c,Send_Invoice__c, Collect_Payment__c, From_the_Finish_Flow__c,
                                                    Payment_Method__c, Payment_Collected__c, Deposit_Collected__c, Account.BillingAddress, 
                                                    Account.BillingCity, account.BillingState, account.BillingCountry,
                                                    account.BillingPostalCode, account.name,contact.firstname,
                                                    WorkOrder.Pre_payment_1_xero_id__c, WorkOrder.Pre_payment_1_xero_remaining_amount__c,
                                                    WorkOrder.Pre_payment_2_xero_id__c, WorkOrder.Pre_payment_2_xero_remaining_amount__c,
                                                    Contact.Email,Asset.AccountId,Invoice_date__c, completed_internally__c,
                                                    Asset.Street__c,asset.State_Province__c,asset.Zip_Postal_Code__c,asset.city__c,asset.country__c,
                                                    contact.lastname,Amount_Due__c, TotalPrice, GrandTotal, Discount,Account.Billing_Contact__r.Email,
                                                    Final_Service_Note__c, Invoice__r.Id , Invoice__r.Invoice_Url__c, Invoice__r.Xero_ID__c, Invoice__r.Invoice_Number__c,
                                                    Invoice__r.Work_Order__r.Account.Billing_Contact__r.Email,
                                                    (select id,LineItemNumber,Product_Name__c,ListPrice,TotalPrice,
                                                     UnitPrice,Quantity,Discount,Invoiced__c 
                                                     from WorkOrderLineItems )                                                
                                                    from workorder
                                                    where id in :workorderIds];
                    
                    List<Id> lst_AccountIds = new List<Id>();
                    
                    if(!lstWorkOrder.isEmpty() && lstWorkOrder.size() > 0)
                    {
                        for(Workorder wR : lstWorkOrder)
                        {
                            if(wR.From_the_Finish_Flow__c || wR.completed_internally__c)
                            {
                                isUpdateWorkOrder = true;
                            }
                            //if(wR.Account.ParentId != null && wR.Account.ParentId != '')
                            if(wR.Account.ParentId != null)
                            {
                                lst_AccountIds.add(wR.Account.ParentId);
                            }
                            if(wr.Asset.AccountId != null)
                            {
                                lst_AccountIds.add(wr.Asset.AccountId);
                            }
                            //else
                            {
                                lst_AccountIds.add(wR.AccountId);                    
                            }
                        }
                    }
                    
                    System.debug(' $$ Yogesh $$ : lstWorkOrder 1  : '+lstWorkOrder);
                    System.debug(' $$ Yogesh $$ : lst_AccountIds : '+lst_AccountIds);
                    
                    Map<Id,Account> mapIdToAcc = new Map<Id,Account>();
                    if(!lst_AccountIds.isEmpty() && lst_AccountIds.size() > 0)
                    {
                        for(Account acc : [select id,Xero_Email__c,BillingCity, Xero_ID__c, BillingAddress, Billing_Contact__r.Email,
                                           BillingState, BillingCountry,Billingstreet,Payment_Term__c,
                                           BillingPostalCode, name, phone 
                                           FROM account WHERE id IN: lst_AccountIds])
                        {
                            mapIdToAcc.put(acc.id,acc);
                        }
                    }
                    
                    //[select id, Product_Name__c, UnitPrice, Quantity  from WorkOrderLineItem where WorkOrderId IN: workorderIds]
                    
                    Map<String, List<WorkOrderLineItem>> map_WorkOrderLineItem = new Map<String, List<WorkOrderLineItem>>();
                    for(WorkOrderLineItem woLineItem : [select id, WorkOrderId, Product_Name__c, Product2.Name, 
                                                        PricebookEntry.Product2Id, UnitPrice, Quantity, Discount, TotalPrice  
                                                        from WorkOrderLineItem 
                                                        where WorkOrderId IN: workorderIds and Invoiced__c = FALSE and 
                                                        Status ='Completed' ])
                    {
                        
                        if(map_WorkOrderLineItem.containsKey(woLineItem.WorkOrderId))
                        {
                            // put object in map list
                            map_WorkOrderLineItem.get(woLineItem.WorkOrderId).add(woLineItem);
                        }
                        else
                        {
                            //create list and put in map
                            List<WorkOrderLineItem> lst_WorkOrderLineItem = new List<WorkOrderLineItem>();
                            lst_WorkOrderLineItem.add(woLineItem);
                            map_WorkOrderLineItem.put(woLineItem.WorkOrderId,lst_WorkOrderLineItem);
                        }
                    }
                    
                    list<Workorder> createcontactWO = new List<Workorder>();
                    list<Workorder> createInvoiceWO = new List<Workorder>();
                    List<account> lstAccountToUpdate = new List<Account>();
                    List<workorder> lstWorkOrderToUpdate = new List<workorder>();
                    Map<String,String> map_MapinvoiceLineItemsIdToWorkOrderLineItems = new Map<String,String>();
                    List<InsertInvoiceWrapper> lst_InsertInvoiceWrapper = new List<InsertInvoiceWrapper>();
                    Map<String, String> map_sfInvoiceId = new Map<String, String>();
                    Map<String,String> mapXeroContactIdToAcc = new Map<String,String>();
                    list<Invoice__c> lst_InsertToInvoices = new list<Invoice__c>();
                    List<WorkOrderLineItem> lst_WorkOderLineItemToUpdateAfterInvoiceInsert = new List<WorkOrderLineItem>();
                    List<Invoice_Line_Item__c> lst_ToUpdateInvoiceLineItemAfterUpdateWrkOdrLinTm = new List<Invoice_Line_Item__c>();
                    List<Attachment> lst_attechments = new List<Attachment>(); // store invoice pdf
                    
                    
                    System.debug(' $$ Yogesh $$ : lstWorkOrder 2  : '+lstWorkOrder);
                    for(Workorder wo: lstWorkOrder)
                    {
                        if(wo.account.ParentId != null)
                        {
                            if(mapIdToAcc.ContainsKey(wo.account.ParentId))
                            {
                                Account acc = mapIdToAcc.get(wo.account.ParentId);
                                if(acc.Xero_ID__c != null && acc.Xero_ID__c != '')
                                {
                                    createInvoiceWO.add(wo);
                                    // add xero contact Id 
                                    mapXeroContactIdToAcc.put(acc.id,acc.Xero_ID__c);
                                }
                                else                
                                {
                                    createcontactWO.add(wo);
                                }
                            }
                        }
                        else
                        {
                            if(wo.account.Xero_ID__c != null && wo.account.Xero_ID__c != '')
                            {
                                createInvoiceWO.add(wo);
                                // add xero contact Id 
                                mapXeroContactIdToAcc.put(wo.AccountId,wo.account.Xero_ID__c);
                            }
                            else                
                            {
                                createcontactWO.add(wo);
                            }
                        }
                        
                    }
                    
                    system.debug('Princee createInvoiceWO size : ' + createInvoiceWO.size());
                    system.debug('Princee createInvoiceWO : ' + createInvoiceWO);
                    system.debug('Princee createcontactWO size : ' + createcontactWO.size());
                    system.debug('Princee createcontactWO  : ' + createcontactWO);
                    
                    if(!createcontactWO.isempty() && createcontactWO.size()>0)
                    {
                        for(Workorder wo : createcontactWO)
                        {
                            if(completed_internally == True)
                            {
                                wo.completed_internally__c = True;
                            }
                            
                            String accountIdForIdentity;
                            if(wo.Account.ParentId != null)
                            {
                                accountIdForIdentity = wo.Account.ParentId;
                            }
                            else
                            {
                                accountIdForIdentity = wo.AccountId;
                            }
                            
                            if(String.isNotBlank(accountIdForIdentity) && mapIdToAcc.containsKey(accountIdForIdentity))
                            {
                                Account account = mapIdToAcc.get(accountIdForIdentity);
                                XeroContact requestXeroContact = new XeroContact(account);
                                system.debug('Princee requestXeroContact : ' + requestXeroContact);
                                
                                XeroContact responseXeroContact;
                                //Account account = new Account();

                                responseXeroContact = XeroAPI.sendContact(requestXeroContact,accessToken);
                                if(responseXeroContact.ContactID != null && responseXeroContact.ContactID != '')
                                {
                                    account.Xero_Id__c = responseXeroContact.ContactID;
                                    lstAccountToUpdate.add(account);
                                    String xeroContactId = responseXeroContact.ContactID;
                                    
                                    {
                                        //add for update invoice id
                                        //lstWorkOrderToUpdate.add(woResponseInObject);
                                        // add xero contact Id 
                                        mapXeroContactIdToAcc.put(account.id,xeroContactId);
                                        //Add for create invoice
                                        createInvoiceWO.add(wo);
                                    }
                                    //GET https://api.xero.com/api.xro/2.0/Invoices/9b9ba9e5-e907-4b4e-8210-54d82b0aa479/OnlineInvoice
                                }
                            }
                        }
                    }
                    
                    // update  invoice //change insert to update 
                    if(!createInvoiceWO.isempty() && createInvoiceWO.size()>0)
                    {
                        for(Workorder wo : createInvoiceWO)
                        {
                            String accountIdForIdentity; //for filter account id 
                            if(wo.Account.ParentId != null)
                            {
                                accountIdForIdentity = wo.Account.ParentId;
                            }
                            else
                            {
                                accountIdForIdentity = wo.AccountId;
                            }
                            
                            //Create invoice 
                            if(String.isNotBlank(accountIdForIdentity) && mapXeroContactIdToAcc.containsKey(accountIdForIdentity))
                            {
                                String xeroContactId = mapXeroContactIdToAcc.get(accountIdForIdentity); 
                                List<WorkOrderLineItem> lst_wOLineItem = new List<WorkOrderLineItem>();
                                if(map_WorkOrderLineItem.containsKey(wo.id))
                                {
                                    lst_wOLineItem = map_WorkOrderLineItem.get(wo.id);
                                }
                                //map_WorkOrderLineItem
                                System.debug('@@@### wo :: @@  ::'+wo);
                                System.debug('@@@### xeroContactId :: @@  ::'+xeroContactId);
                                System.debug('@@@### lst_wOLineItem :: @@  ::'+lst_wOLineItem);
                                
                                if(mapIdToAcc.ContainsKey(accountIdForIdentity))
                                {
                                    Account acc = mapIdToAcc.get(accountIdForIdentity);
                                    
                                    //For Reference field
                                    Account accForReferenceFieldUpdate;
                                    
                                    /*if(wo.Asset.AccountId != null && mapIdToAcc.containsKey(wo.Asset.AccountId))
                                    {
                                    accForReferenceFieldUpdate = mapIdToAcc.get(wo.Asset.AccountId);
                                    }*/
                                                                            
                                    String myadd = '';
                                    system.debug('wo.AssetId : ' + wo.AssetId);
                                    if(wo.AssetId!= null)
                                    {
                                        if(wo.asset.Street__c !=null) myadd = myadd + wo.asset.Street__c+', ';
                                        if(wo.asset.City__c !=null) myadd = myadd + wo.asset.City__c +', ';
                                        if(wo.asset.State_Province__c !=null) myadd = myadd + wo.asset.State_Province__c +', ';
                                        if(wo.asset.Country__c !=null) myadd = myadd + wo.asset.Country__c +', ';
                                        if(wo.asset.Zip_Postal_Code__c !=null) myadd = myadd + wo.asset.Zip_Postal_Code__c ;
                                        system.debug('ten : ' + myadd);
                                        
                                    }
                                    else
                                    {
                                        Address add = acc.BillingAddress;
                                        if(add.Street !=null) myadd = myadd + add.Street+', ';
                                        if(add.Country !=null) myadd = myadd + add.Country +', ';
                                        if(add.City !=null) myadd = myadd + add.City +', ';
                                        if(add.State !=null) myadd = myadd + add.State +', ';
                                        if(add.postalCode !=null) myadd = myadd + add.postalCode +', ';
                                        if(add.countryCode !=null) myadd = myadd + add.countryCode;
                                        system.debug('ten : ' + myadd);
                                        
                                    }
                                    
                                    if(map_InvoicesToWorkOrderId.containsKey(wo.Id))
                                    {
                                        //get Invice obj
                                        Invoice__c obj_Invoice = map_InvoicesToWorkOrderId.get(wo.Id);
                                        InsertInvoiceWrapper responseInInvoiceWrapper = createInvoice(wo,obj_Invoice, acc, xeroContactId, lst_wOLineItem, myadd,completed_internally,accessToken);
                                        //lstWorkOrderToUpdate.add(responseInInvoiceWrapper.workOrder);
                                        if(responseInInvoiceWrapper != null)
                                        {
                                            lst_InsertInvoiceWrapper.add(responseInInvoiceWrapper);
                                            System.debug('@@@ Invoice Creation Status : Invoice is ready to create ');
                                        }
                                        else 
                                        {
                                            System.debug('@@@ Invoice Creation Status : Invoice is Not ready to create ');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //update accounts
                    if(!lstAccountToUpdate.isEmpty() && lstAccountToUpdate.size() > 0)
                    {
                        update lstAccountToUpdate;
                    }
                    
                    Map<Id,Invoice__c> map_InvoiceBasedOnWorkOrderId = new  Map<Id,Invoice__c>();
                    if(lst_InsertInvoiceWrapper != null && lst_InsertInvoiceWrapper.size() > 0)
                    {
                        System.debug('@@ Yogesh2021 @@ : lst_InsertInvoiceWrapper : '+lst_InsertInvoiceWrapper);
                        for(InsertInvoiceWrapper iWrapper :lst_InsertInvoiceWrapper)
                        {
                            iWrapper.invoice.Work_Order__c = iWrapper.workOrder.Id;
                            lst_InsertToInvoices.add(iWrapper.invoice);
                            if(iWrapper.invoiceAttechment != null)
                            {
                                //Attachment iNV_Attechment = iWrapper.invoiceAttechment;
                                //iNV_Attechment.ParentId = iWrapper.workOrder.Id; 
                                iWrapper.invoiceAttechment.ParentId = iWrapper.workOrder.Id;
                                lst_attechments.add(iWrapper.invoiceAttechment);
                            }
                            
                        }
                        
                        if(lst_InsertToInvoices != null && lst_InsertToInvoices.size() > 0)
                        {
                            update lst_InsertToInvoices; //chage insert to update 
                        }
                        
                        if(lst_attechments != null && lst_attechments.size() > 0)
                        {
                            insert lst_attechments;
                        }
                        
                        if(lst_InsertToInvoices != null && lst_InsertToInvoices.size() > 0)
                        {
                            //INVOICE:::
                            for(Invoice__c invoice :lst_InsertToInvoices)
                            {
                                if(String.isNotBlank(invoice.Xero_ID__c) && String.isNotBlank(invoice.Id))
                                {
                                    map_sfInvoiceId.put(invoice.Xero_ID__c,invoice.Id);
                                }
                            }
                        }
                        
                        List<Invoice_Line_Item__c> lst_InsertInvoiceLineItems = new List<Invoice_Line_Item__c>();
                        for(InsertInvoiceWrapper iWrapper :lst_InsertInvoiceWrapper)
                        {
                            for(Invoice_Line_Item__c lineItem : iWrapper.lst_LineItems)
                            {
                                if(map_sfInvoiceId.containsKey(iWrapper.xeroInvoiceId))
                                {
                                    lineItem.Invoice__c = map_sfInvoiceId.get(iWrapper.xeroInvoiceId);
                                    lst_InsertInvoiceLineItems.add(lineItem);
                                }
                            }
                        }
                        
                        if(lst_InsertInvoiceLineItems != null && lst_InsertInvoiceLineItems.size() > 0)
                        {
                            insert lst_InsertInvoiceLineItems;
                        }
                        
                        if(lst_InsertInvoiceLineItems != null && lst_InsertInvoiceLineItems.size() > 0)
                        {
                            for(Invoice_Line_Item__c iLT :lst_InsertInvoiceLineItems)
                            {
                                String genrateInvoiceLineItemIdentityKey, quantity, description, unitPrice;
                                if(iLT.Quantity__c != null)
                                {
                                    quantity = '';
                                    quantity = String.valueOf(Integer.valueOf(iLT.Quantity__c));
                                }
                                
                                if(iLT.Description__c != null)
                                {
                                    description = '';
                                    description = iLT.Description__c;
                                }
                                
                                if(iLT.Unit_Price__c != null)
                                {
                                    unitPrice = '';
                                    unitPrice = String.valueOf(iLT.Unit_Price__c);
                                }
                                genrateInvoiceLineItemIdentityKey = '';
                                if(String.isNotBlank(quantity)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + quantity;
                                if(String.isNotBlank(description)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + description;
                                if(String.isNotBlank(unitPrice)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + unitPrice;
                                
                                System.debug('$$ Yogi && : genrateInvoiceLineItemIdentityKey :'+genrateInvoiceLineItemIdentityKey);
                                if(String.isNotBlank(genrateInvoiceLineItemIdentityKey))
                                {
                                    // put invoice_line_item id in map based on invoice_line_item -> quanity+description+unitPrice 
                                    map_MapinvoiceLineItemsIdToWorkOrderLineItems.put(genrateInvoiceLineItemIdentityKey,iLT.Id);
                                }
                                System.debug('$$ Yogi && : map_MapinvoiceLineItemsIdToWorkOrderLineItems :'+map_MapinvoiceLineItemsIdToWorkOrderLineItems);
                            }
                        }
                        
                        for(InsertInvoiceWrapper iWrapper :lst_InsertInvoiceWrapper)
                        {
                            if(map_sfInvoiceId.containsKey(iWrapper.xeroInvoiceId))
                            {
                                
                                //iWrapper.workOrder.Invoice__c = map_sfInvoiceId.get(iWrapper.xeroInvoiceId);
                                /* if(iWrapper.workOrder.From_the_Finish_Flow__c == False)
                                {
                                iWrapper.workOrder.From_the_Finish_Flow__c = True;
                                }*/
                                iWrapper.workOrder.From_the_Finish_Flow__c = False;
                                iWrapper.workOrder.completed_internally__c = False;
                                
                                lstWorkOrderToUpdate.add(iWrapper.workOrder);
                                
                                if(map_WorkOrderLineItem.containsKey(iWrapper.workOrder.Id))
                                {
                                    for(WorkOrderLineItem wOLineItem : map_WorkOrderLineItem.get(iWrapper.workOrder.Id))
                                    {
                                        String genrateInvoiceLineItemIdentityKey, quantity, description, unitPrice;
                                        if(wOLineItem.Quantity != null)
                                        {
                                            quantity = '';
                                            quantity = String.valueOf(Integer.valueOf(wOLineItem.Quantity));
                                        }
                                        if(wOLineItem.Product2.Name != null)
                                        {
                                            description = '';
                                            description = wOLineItem.Product2.Name;
                                        }
                                        if(wOLineItem.UnitPrice != null)
                                        {
                                            unitPrice = '';
                                            unitPrice = String.valueOf(wOLineItem.UnitPrice);
                                        }
                                        genrateInvoiceLineItemIdentityKey = '';
                                        if(String.isNotBlank(quantity)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + quantity;
                                        if(String.isNotBlank(description)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + description;
                                        if(String.isNotBlank(unitPrice)) genrateInvoiceLineItemIdentityKey = genrateInvoiceLineItemIdentityKey + unitPrice;
                                        
                                        System.debug('$$ Yogi && : genrateInvoiceLineItemIdentityKey :'+genrateInvoiceLineItemIdentityKey);
                                        if(String.isNotBlank(genrateInvoiceLineItemIdentityKey))
                                        {
                                            // get invoice_line_item id in map based on workOderLineItem -> quanity+description+unitPrice 
                                            if(map_MapinvoiceLineItemsIdToWorkOrderLineItems.containsKey(genrateInvoiceLineItemIdentityKey))
                                            {
                                                String invoiceLineItemId = map_MapinvoiceLineItemsIdToWorkOrderLineItems.get(genrateInvoiceLineItemIdentityKey);
                                                System.debug('$$ Yogi $$ : invoiceLineItemId : '+invoiceLineItemId);
                                                if(String.isNotBlank(invoiceLineItemId))
                                                {
                                                    wOLineItem.Invoice_Line_Item__c = invoiceLineItemId;
                                                    wOLineItem.Invoiced__c = TRUE;
                                                    lst_WorkOderLineItemToUpdateAfterInvoiceInsert.add(wOLineItem);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        //update work order 
                        if(!lstWorkOrderToUpdate.isEmpty() && lstWorkOrderToUpdate.size() > 0)
                        {
                            update lstWorkOrderToUpdate;
                        }
                        
                        //Update work Oder Line Item
                        if(!lst_WorkOderLineItemToUpdateAfterInvoiceInsert.isEmpty() && lst_WorkOderLineItemToUpdateAfterInvoiceInsert.size() > 0)
                        {
                            update lst_WorkOderLineItemToUpdateAfterInvoiceInsert;
                        }
                        
                        if(!lst_InsertInvoiceLineItems.isEmpty() && lst_InsertInvoiceLineItems.size() > 0)
                        {
                            //lst_InsertInvoiceLineItems convert into map with invoice line item id
                            Map<Id, Invoice_Line_Item__c> map_InvoiceLineItemFromList = new Map<Id, Invoice_Line_Item__c>(lst_InsertInvoiceLineItems);
                            if(!lst_WorkOderLineItemToUpdateAfterInvoiceInsert.isEmpty() && lst_WorkOderLineItemToUpdateAfterInvoiceInsert.size() > 0)
                            {
                                for(WorkOrderLineItem wOLI : lst_WorkOderLineItemToUpdateAfterInvoiceInsert)
                                {
                                    
                                    if(wOLI.PricebookEntry.Product2Id != null && String.isNotBlank(wOLI.PricebookEntry.Product2Id) && map_InvoiceLineItemFromList.ContainsKey(wOLI.Invoice_Line_Item__c))
                                    {
                                        Invoice_Line_Item__c invoiceLineItem = map_InvoiceLineItemFromList.get(wOLI.Invoice_Line_Item__c);
                                        invoiceLineItem.Product_Reference__c = wOLI.PricebookEntry.Product2Id;
                                        lst_ToUpdateInvoiceLineItemAfterUpdateWrkOdrLinTm.add(invoiceLineItem);
                                    }
                                }
                            }
                        }
                        // update invoice lst
                        if(!lst_ToUpdateInvoiceLineItemAfterUpdateWrkOdrLinTm.isEmpty() && lst_ToUpdateInvoiceLineItemAfterUpdateWrkOdrLinTm.size() > 0)
                        {
                            update lst_ToUpdateInvoiceLineItemAfterUpdateWrkOdrLinTm;
                        }
                    }
                    
                    system.debug(lstWorkOrderToUpdate);
                    //lstWorkOrderToUpdate[0].Invoice__r.Id != ''
                    if(!lstWorkOrderToUpdate.isEmpty() && lstWorkOrderToUpdate.size() > 0)
                    {
                        set<Id> woIds = new set<Id>();
                        for(WorkOrder wo : lstWorkOrderToUpdate)
                        {
                            woIds.add(wo.Id);
                        }
                        if(woIds != null && woIds.size() > 0)
                        {
                            System.debug('!!@@ Current User Id - '+UserInfo.getUserId());//Returns the context user's is.
                            System.Debug('!!@@ Current UserType-' + UserInfo.getUserType());//Returns the context user's type.

                            List<Invoice__c> lst_Inv= [select id,Invoice_Url__c, Xero_ID__c,
                                                       Invoice_Number__c, Work_Order__r.Account.Name,
                                                       Account__r.Billing_Contact__r.Email,
                                                       Work_Order__r.Account.Billing_Contact__r.Email,Work_Order__r.Id
                                                       from Invoice__c
                                                       where Work_Order__c IN: woIds order by CreatedDate desc limit 1];
                            for(Invoice__c inv : lst_Inv)
                            {
                                if(!Test.isRunningTest() && inv != null && String.isNotBlank(inv.Account__r.Billing_Contact__r.Email))
                                {
                                    ////inv.Work_Order__r.Account.Billing_Contact__r.Email,
                                    
                                    XeroUtilityMail.confirmationEmail(inv.Work_Order__r.Id,
                                                                      inv.Invoice_Number__c,
                                                                      Inv.id,
                                                                      inv.Account__r.Billing_Contact__r.Email,
                                                                      inv.Invoice_Url__c, 
                                                                      Label.Xero_Email_Notification_Template,
                                                                     inv.Account__r.Billing_Contact__c);
                                }
                                
                            }
                        }
                    	}
                    
                }
            }
            if (Tokens != null) {
                update Tokens;
            }
        }
        catch(Exception e)
        {
            XeroErrorLog_ByRes.createErrorLogForDml(e,className+' Method : getWorkOrder()', null, workorderIds[0], null, isUpdateWorkOrder);
            if (Tokens != null) {
                update Tokens;
            }
        }
    }
    
    Public static InsertInvoiceWrapper createInvoice(Workorder wo, Invoice__c invoice, Account account, String xeroContactId, List<WorkOrderLineItem> lst_wOLineItem, String accForReferenceFieldUpdate,Boolean completed_internally,String accessToken)
    {
        InsertInvoiceWrapper insertWrapperObj = new InsertInvoiceWrapper();
        
        Decimal totalLineItemAount = 0;
        
        if(!lst_wOLineItem.isEmpty() && lst_wOLineItem.size() > 0)
        {
            for(WorkOrderLineItem woLineItem : lst_wOLineItem)
            {
                totalLineItemAount = totalLineItemAount + woLineItem.TotalPrice;
            }
        }
        else
        {
            System.debug('@@@ Create invoice : Line Item not exits  ');
        }
        
        if(xeroContactId != null && xeroContactId != '' && totalLineItemAount > 0)
        {
            System.debug('wo '+wo);
            System.debug('xeroContactId '+xeroContactId);
            
            XeroInvoice xeroInvoiceRequest = new XeroInvoice(invoice.name, wo, account, xeroContactId, lst_wOLineItem,accForReferenceFieldUpdate,completed_internally);
            
            System.debug('@@@### xeroInvoiceRequest :: @@  ::'+xeroInvoiceRequest);
            System.debug('@@@### xeroInvoiceRequest Reference:: @@  ::'+xeroInvoiceRequest.Reference);
            
            xeroInvoice responseXeroInvoice = XeroAPI.sendInvoice(xeroInvoiceRequest,accessToken);
            if(responseXeroInvoice.InvoiceID != null && String.isNotBlank(responseXeroInvoice.InvoiceID))
            {
                
                // assign xero invoice id in wrapper class 
                insertWrapperObj.xeroInvoiceId = responseXeroInvoice.InvoiceID;
                // assign workorder object in wrapper class 
                insertWrapperObj.workOrder = wo;
                // assign account id in wrapper class 
                insertWrapperObj.AccountId = account.Id;
                System.debug('invoice is created :  '+responseXeroInvoice.InvoiceID);
                //Invoice__c invoice = new Invoice__c();
                //invoice.Account__c = account.Id;
                if(String.isNotBlank(account.Billing_Contact__r.Email)) { invoice.sent__c = true; }
                invoice.Xero_ID__c = responseXeroInvoice.InvoiceID;
                invoice.Type__c = responseXeroInvoice.Type;
                invoice.Invoice_Number__c = responseXeroInvoice.InvoiceNumber;
                invoice.Reference__c = responseXeroInvoice.Reference;
                //invoice.Reference__c = accForReferenceFieldUpdate.Name;
                //System.debug('accForReferenceFieldUpdate.Name :'+accForReferenceFieldUpdate.Name);
                invoice.Amount_Paid__c = responseXeroInvoice.AmountPaid;
                invoice.Amount_Due__c = responseXeroInvoice.AmountDue;
                System.debug(' @@@### responseXeroInvoice.AmountPaid : '+responseXeroInvoice.AmountPaid);
                System.debug(' @@@### responseXeroInvoice.AmountDue : '+responseXeroInvoice.AmountDue);
                invoice.Due_Date__c = Date.valueOf(responseXeroInvoice.DueDateString);
                
                if(responseXeroInvoice.Date_x != null)
                {
                    //date_x convert into Date format 
                    string due = responseXeroInvoice.Date_x;
                    string secs = due.split('\\(')[1].split('\\+')[0];
                    System.debug('!!Test Date!! : '+due );
                    System.debug('!!Test secs!! : '+secs );
                    Datetime dt = Datetime.newInstance(Long.valueOf(secs));
                    Date result = dt.date();
                    invoice.Invoice_Date__c = result;
                }
                
                invoice.Line_Amount_Type__c = responseXeroInvoice.LineAmountTypes;
                invoice.Status__c = responseXeroInvoice.Status;
                invoice.Subtotal__c = responseXeroInvoice.SubTotal;
                invoice.Tax__c = responseXeroInvoice.TotalTax;
                invoice.Total__c = responseXeroInvoice.Total;
                invoice.Amount_Due__c = responseXeroInvoice.AmountDue;
                //lineItem list form xero response 
                List<XeroInvoice.LineItem> lst_ResponseInvoiceLineItems = responseXeroInvoice.LineItems;
                System.debug('@@ Yogesh2021 @@ : invoice : '+invoice);
                // assign sf invoice in wrapper class
                insertWrapperObj.invoice = invoice;
                
                System.debug('@@ Yogesh2021 @@ : lst_ResponseInvoiceLineItems 1: '+lst_ResponseInvoiceLineItems);
                
                //After insert invoice call this  
                //invoice line item to update line item object 
                System.debug('@@ Yogesh2021 @@ : lst_ResponseInvoiceLineItems 2: '+lst_ResponseInvoiceLineItems);
                
                if(lst_ResponseInvoiceLineItems != null && lst_ResponseInvoiceLineItems.size() > 0)
                {
                    System.debug('@@ Yogesh2021 @@ : lst_ResponseInvoiceLineItems 3: '+lst_ResponseInvoiceLineItems);
                    for(XeroInvoice.LineItem responseLineItem : lst_ResponseInvoiceLineItems)
                    {
                        System.debug('## Yogesh ## : responseLineItem.AccountCode : '+ responseLineItem.AccountCode);
                        Invoice_Line_Item__c invoiceLineItem = new Invoice_Line_Item__c();
                        invoiceLineItem.Account_Code__c =  responseLineItem.AccountCode;
                        invoiceLineItem.Amount__c =  responseLineItem.LineAmount;
                        invoiceLineItem.Description__c =  responseLineItem.Description;
                        invoiceLineItem.Discount__c =  responseLineItem.DiscountRate;
                        invoiceLineItem.Quantity__c =  responseLineItem.Quantity;
                        invoiceLineItem.Unit_Price__c =  responseLineItem.UnitAmount;
                        invoiceLineItem.Xero_Id__c =  responseLineItem.LineItemID;
                        insertWrapperObj.addLineItem(invoiceLineItem);
                        System.debug('@@ Yogesh2021 @@ : invoiceLineItem : '+invoiceLineItem);
                    }
                    System.debug('@@ Yogesh2021 @@ : insertWrapperObj.lst_LineItems : '+insertWrapperObj.lst_LineItems);
                }
                
            }
            
            
            
            
            //|//////////////////////////////////////////////////////////////////////////////////|
            //|///////////////// *** Code Added Start Prepayment BY Yogesh *** //////////////////|
            //|//////////////////////////////////////////////////////////////////////////////////|
            
            Boolean goWithPaymentCollectedByTech  = perPaymentManager(insertWrapperObj, accessToken);
            System.debug('!!! $$ prePay1 $$ !!! : '+prePay1);
            System.debug('!!! $$ prePay2 $$ !!! : '+prePay2);
            
            //if true means remains payment 
            if(goWithPaymentCollectedByTech)
            {
                Integer xeroAccountCode = 0; //use custom label
                if(String.isNotBlank(system.Label.xero_payment_account_code))
                {
                    xeroAccountCode = Integer.valueOf(system.Label.xero_payment_account_code);
                }
                System.debug('@@@ -> xeroAccountpayentCode : '+xeroAccountCode);
                 
				//First paid pre Office Deposite 
				if(String.isNotBlank(String.Valueof(insertWrapperObj.workOrder.Deposit_Collected__c)) && insertWrapperObj.workOrder.Deposit_Collected__c > 0)
                {
					String paymentReference = '';
					Decimal DepositCollectedAmount = insertWrapperObj.workOrder.Deposit_Collected__c;
					Decimal payAmount = 0;

                    paymentReference = 'Office ';
                    if(String.isNotBlank(insertWrapperObj.workOrder.LastModifiedBy.Alias)) paymentReference = paymentReference + responseXeroInvoice.InvoiceNumber + ' ';
                    paymentReference = paymentReference + ' Pre-pay';

					// due amount = 1000 > 500 = DepositCollectedAmount
					if(insertWrapperObj.invoice.Amount_Due__c >= DepositCollectedAmount)
                    {
                    	payAmount = DepositCollectedAmount;
                    }
					else
                    {
                    	payAmount = insertWrapperObj.invoice.Amount_Due__c;
                    }
                    
                    if(payAmount > 0)
                    {
                        Decimal paidAmount = applyPaymentInXero(responseXeroInvoice.InvoiceID, xeroAccountCode, payAmount, paymentReference, insertWrapperObj, accessToken);
                        if(paidAmount > 0)
                        {
                            System.debug('@@## deposite paid in xero successfully with amount $ '+paidAmount);
                            insertWrapperObj.workOrder.Deposit_Collected__c = insertWrapperObj.workOrder.Deposit_Collected__c - payAmount;
                        }
                    }
                    
                }
                
                //second paid payment collected by tech
                if(String.isNotBlank(String.Valueof(insertWrapperObj.workOrder.Payment_Collected__c)) && insertWrapperObj.workOrder.Payment_Collected__c > 0)
                {
                    String paymentReference = '';
                    Decimal paymentCollectedByTech = insertWrapperObj.workOrder.Payment_Collected__c;
                    Decimal payAmount = 0;
                    
                    if(String.isNotBlank(insertWrapperObj.workOrder.LastModifiedBy.Alias)) paymentReference = paymentReference + insertWrapperObj.workOrder.LastModifiedBy.Alias + ' ';
                    if(String.isNotBlank(insertWrapperObj.workOrder.LastModifiedBy.Alias)) paymentReference = paymentReference + responseXeroInvoice.InvoiceNumber + ' ';
                    if(String.isNotBlank(insertWrapperObj.workOrder.Payment_Method__c)) paymentReference = paymentReference + insertWrapperObj.workOrder.Payment_Method__c;
                    
                    // due amount = 1000 > 500 = paymentCollectedByTech
                    if(insertWrapperObj.invoice.Amount_Due__c >= paymentCollectedByTech)
                    {
                        payAmount = paymentCollectedByTech;
                    }
                    else
                    {
                        payAmount = insertWrapperObj.invoice.Amount_Due__c;
                    }
                    
                    if(payAmount > 0)
                    {
                        Decimal paidAmount = applyPaymentInXero(responseXeroInvoice.InvoiceID, xeroAccountCode, payAmount, paymentReference, insertWrapperObj, accessToken);
                        if(paidAmount > 0)
                        {
                            System.debug('@@## payment collected by tech paid in xero successfully with amount $ '+paidAmount);
                            //insertWrapperObj.workOrder.Payment_Collected__c = insertWrapperObj.workOrder.Payment_Collected__c - payAmount;
                        }
                    }
                    
                }

            }
            
            
            //START Add prePay amount on only sf invoice paid amount
            if(prePay1 > 0)
            {
                insertWrapperObj.invoice.Amount_Paid__c = insertWrapperObj.invoice.Amount_Paid__c + prePay1;
                System.debug('!! @@ ## prePay1 : '+prePay1);
                System.debug('!! @@ ## added prePay1 : '+insertWrapperObj.invoice.Amount_Paid__c);
            }
            
            if(prePay2 > 0)
            {
                insertWrapperObj.invoice.Amount_Paid__c = insertWrapperObj.invoice.Amount_Paid__c + prePay2;
                System.debug('!! @@ ## prePay2 : '+prePay2);
                System.debug('!! @@ ## added prePay1 : '+insertWrapperObj.invoice.Amount_Paid__c);
            }
            //END Add prePay amount on only sf invoice paid amount
    
            //|//////////////////////////////////////////////////////////////////////////////////|
            //|//////////////// ***  Code Added End Prepayment BY Yogesh  *** ///////////////////|
            //|//////////////////////////////////////////////////////////////////////////////////|
            
            
            // update online invoice url on invoice object 
            if(responseXeroInvoice.InvoiceID != null && String.isNotBlank(responseXeroInvoice.InvoiceID))
            {
                String onlineInvoiceUrl = XeroAPI.getOnlineInvoice(responseXeroInvoice.InvoiceID, accessToken);
                if(onlineInvoiceUrl != null  && String.isNotBlank(onlineInvoiceUrl))
                {
                    insertWrapperObj.invoice.Invoice_Url__c = onlineInvoiceUrl;
                }
                
                if(String.isNotBlank(onlineInvoiceUrl))
                {
                    System.debug('onlineInvoiceUrl before call attechment fun : '+onlineInvoiceUrl);
                    if(!Test.isRunningTest())
                    {
                        Attachment invoiceAttech = attachInvoice(onlineInvoiceUrl,responseXeroInvoice.InvoiceID, responseXeroInvoice.InvoiceNumber,account.Name, accessToken);
                        if(invoiceAttech != null)
                        {
                            insertWrapperObj.invoiceAttechment = invoiceAttech;
                        }
                    }
                }
                System.debug('insertWrapperObj.invoiceAttechment : '+insertWrapperObj.invoiceAttechment);
            }
            return insertWrapperObj;
        }
        else
        {
            System.debug('@@@ Create invoice : xeroContactId is not exists Or totalLineItemAount is less then 0 ');
        }
        return null;
    }
    
    public static decimal applyPaymentInXero(String invoiceID, Integer xeroAccountCode, decimal payAmount, String reference, InsertInvoiceWrapper insertWrapperObj, String accessToken)
    {
        Decimal paidAmount = 0;
        XeroPayment requestXeroPayment = new  XeroPayment(invoiceID,xeroAccountCode,payAmount,reference);
        System.debug('## Yogesh@@@@ ## requestXeroPayment : '+requestXeroPayment);
        
        XeroPayment responseXeroPayment = XeroAPI.sendPayment(requestXeroPayment,accessToken);
        if(responseXeroPayment.Invoice.InvoiceID != null)
        {
            paidAmount = payAmount;
            System.debug('## Yogesh@@@@ ## responseXeroPayment : '+responseXeroPayment);
            insertWrapperObj.invoice.Status__c = responseXeroPayment.Invoice.Status;
            insertWrapperObj.invoice.Amount_Paid__c = responseXeroPayment.Invoice.AmountPaid;
            insertWrapperObj.invoice.Amount_Due__c = responseXeroPayment.Invoice.AmountDue;
        }
        
        return payAmount;
    }
    
    public static Boolean perPaymentManager(InsertInvoiceWrapper insertWrapperObj, String accessToken)
    {
        if(insertWrapperObj.workOrder != null && insertWrapperObj.invoice != null)
        {
            // Assign insertWrapperObj.workOrder and insertWrapperObj.invoice  in obj For Temporary use
            WorkOrder workOrder = insertWrapperObj.workOrder;
            Invoice__c invoice = insertWrapperObj.invoice;
            
            Decimal totalInvoiceDueAmount = invoice.Amount_Due__c;
            
            
            //START Get prePayments From xero 
            //
            
            String sf_PrePay1_Id = '';
            String sf_PrePay2_Id = '';
            
            decimal Xero_PrePay1_amount;
            decimal xero_PrePay2_amount;
            
            if(String.isNotBlank(String.valueOf(workOrder.Pre_payment_1_xero_id__c)))
            {
                sf_PrePay1_Id = workOrder.Pre_payment_1_xero_id__c;
            }
            if(String.isNotBlank(String.valueOf(workOrder.Pre_payment_2_xero_id__c)))
            {
                sf_PrePay2_Id = workOrder.Pre_payment_2_xero_id__c;
            }
            
            //Make xero Prepayments callout 
            //List<XeroPrepayment> prePaymentsFromXero_lst = XeroAPI.getPrepayment(sf_PrePay1_Id, sf_PrePay2_Id);
            
            List<XeroPrepayment> prePaymentsFromXero_lst = getXeroPrepaymentsOneByOne(sf_PrePay1_Id, sf_PrePay2_Id, accessToken);
            if(!prePaymentsFromXero_lst.isEmpty() && prePaymentsFromXero_lst.size() > 0)
            {
                for(XeroPrepayment prePayObj : prePaymentsFromXero_lst)
                {
                    if(prePayObj.PrepaymentID != null)
                    {
                        if(prePayObj.PrepaymentID == workOrder.Pre_payment_1_xero_id__c)
                        {
                            //workOrder.Pre_payment_1_xero_remaining_amount__c = prePayObj.RemainingCredit;
                            Xero_PrePay1_amount = prePayObj.RemainingCredit;
                        }
                        if(prePayObj.PrepaymentID == workOrder.Pre_payment_2_xero_id__c)
                        {
                            //workOrder.Pre_payment_2_xero_remaining_amount__c = prePayObj.RemainingCredit;
                            Xero_PrePay2_amount = prePayObj.RemainingCredit;
                        }
                    }
                }
            }
            
            //
            //END Get prePayments From xero
            
            
            //Xero PrePayment 1 
            if(totalInvoiceDueAmount > 0 && String.isNotBlank(workOrder.Pre_payment_1_xero_id__c))
            {
                if(String.isNotBlank(String.valueOf(workOrder.Pre_payment_1_xero_remaining_amount__c)))
                {
                    //workOrder.Pre_payment_1_xero_remaining_amount__c is not null logic	
                    if(workOrder.Pre_payment_1_xero_remaining_amount__c > 0 && Xero_PrePay1_amount > 0)
                    {
                        if(String.isNotBlank(invoice.Xero_ID__c))
                        {
                            
                            String prePay1AmountRemaining_InString = '';
                            
                            
                            if(Xero_PrePay1_amount >= workOrder.Pre_payment_1_xero_remaining_amount__c)
                            {
                                //nothing 
                            }
                            else
                            {
                                workOrder.Pre_payment_1_xero_remaining_amount__c = Xero_PrePay1_amount;
                            }
                            
                            
                            
                            if(workOrder.Pre_payment_1_xero_remaining_amount__c > totalInvoiceDueAmount)
                            {
                                prePay1AmountRemaining_InString  = String.valueOf(totalInvoiceDueAmount);
                            }
                            else
                            {
                                prePay1AmountRemaining_InString  = String.valueOf(workOrder.Pre_payment_1_xero_remaining_amount__c);
                            }
                            
                            XeroPrepaymentsAllocation xeroPrePaymentAllocateRequest = new XeroPrepaymentsAllocation(prePay1AmountRemaining_InString, invoice.Xero_ID__c);
                            XeroPrepaymentsAllocation xeroPrePaymentAllocateResponse = XeroAPI.SendPrepaymentsAllocations(workOrder.Pre_payment_1_xero_id__c, xeroPrePaymentAllocateRequest, accessToken);
	
                            if(String.isNotBlank(xeroPrePaymentAllocateResponse.Amount))
                            {
                                System.debug('xeroPrePaymentAllocateResponse.Amount : '+ xeroPrePaymentAllocateResponse.Amount);
                                prePay1 = Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                workOrder.Pre_payment_1_xero_remaining_amount__c = workOrder.Pre_payment_1_xero_remaining_amount__c - Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                totalInvoiceDueAmount = totalInvoiceDueAmount - Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                if(totalInvoiceDueAmount <= 0)
                                {
                                    invoice.Amount_Due__c = totalInvoiceDueAmount;
                                    insertWrapperObj.workOrder = workOrder;
                                    insertWrapperObj.invoice = invoice;
                                    return false;
                                }
                            }
                        }
                        System.debug('@@@ perPaymentManager @@@ workOrder.Pre_payment_1_xero_remaining_amount__c : '+workOrder.Pre_payment_1_xero_remaining_amount__c);
                        
                    }
                }
                else
                {
                    //workOrder.Pre_payment_1_xero_remaining_amount__c is null logic
                }
            }
            
            //Xero PrePayment 2
            if(totalInvoiceDueAmount > 0 && String.isNotBlank(workOrder.Pre_payment_2_xero_id__c))
            {
                if(String.isNotBlank(String.valueOf(workOrder.Pre_payment_2_xero_remaining_amount__c)))
                {
                    //workOrder.Pre_payment_2_xero_remaining_amount__c is not null logic	
                    if(workOrder.Pre_payment_2_xero_remaining_amount__c > 0  && Xero_PrePay2_amount > 0)
                    {
                        if(String.isNotBlank(invoice.Xero_ID__c))
                        {
                            String prePay2AmountRemaining_InString = '';
                            
                            
                            if(Xero_PrePay2_amount >= workOrder.Pre_payment_2_xero_remaining_amount__c)
                            {
                                //nothing 
                            }
                            else
                            {
                                workOrder.Pre_payment_2_xero_remaining_amount__c = Xero_PrePay2_amount;
                            }
                            
                            
                            if(workOrder.Pre_payment_2_xero_remaining_amount__c > totalInvoiceDueAmount)
                            {
                                prePay2AmountRemaining_InString  = String.valueOf(totalInvoiceDueAmount);
                            }
                            else
                            {
                                prePay2AmountRemaining_InString  = String.valueOf(workOrder.Pre_payment_2_xero_remaining_amount__c);
                            }
                            
                            XeroPrepaymentsAllocation xeroPrePaymentAllocateRequest = new XeroPrepaymentsAllocation(prePay2AmountRemaining_InString, invoice.Xero_ID__c);
                            XeroPrepaymentsAllocation xeroPrePaymentAllocateResponse = XeroAPI.SendPrepaymentsAllocations(workOrder.Pre_payment_2_xero_id__c, xeroPrePaymentAllocateRequest, accessToken);
                           
                            if(String.isNotBlank(xeroPrePaymentAllocateResponse.Amount))
                            {
                                prePay2 = Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                System.debug('xeroPrePaymentAllocateResponse.Amount : '+ xeroPrePaymentAllocateResponse.Amount);
                                workOrder.Pre_payment_2_xero_remaining_amount__c = workOrder.Pre_payment_2_xero_remaining_amount__c - Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                totalInvoiceDueAmount = totalInvoiceDueAmount - Decimal.valueOf(xeroPrePaymentAllocateResponse.Amount);
                                if(totalInvoiceDueAmount <= 0)
                                {
                                    invoice.Amount_Due__c = totalInvoiceDueAmount;
                                    insertWrapperObj.workOrder = workOrder;
                                    insertWrapperObj.invoice = invoice;
                                    return false;
                                }
                            }
                            
                        }
                        System.debug('@@@ perPaymentManager @@@ workOrder.Pre_payment_2_xero_remaining_amount__c : '+workOrder.Pre_payment_2_xero_remaining_amount__c);
                    }
                }
                else
                {
                    //workOrder.Pre_payment_1_xero_remaining_amount__c is null logic
                }
            }
            
            invoice.Amount_Due__c = totalInvoiceDueAmount;
            System.debug('@@@ perPaymentManager @@@ invoice due ammount : '+invoice.Amount_Due__c);
            //ReAssign Object 
            insertWrapperObj.workOrder = workOrder;
            insertWrapperObj.invoice = invoice;
            
        }
        
        return true;
    }
    
    public static List<XeroPrepayment> getXeroPrepaymentsOneByOne(String id_prepay1, String id_prepay2,String accessToken)
    {
     
        List<XeroPrepayment> xeroPrepayment_lst = new List<XeroPrepayment>();
        
		if(String.isNotBlank(id_prepay1))
        {
            List<XeroPrepayment> prepay1_FromXero = XeroAPI.getSinglePrepayment(id_prepay1, accessToken);
            
            if(!prepay1_FromXero.isEmpty() && prepay1_FromXero.size() > 0)
            {
                xeroPrepayment_lst.add(prepay1_FromXero[0]);
            }
        }
        
        if(String.isNotBlank(id_prepay2))
        {
            List<XeroPrepayment> prepay2_FromXero = XeroAPI.getSinglePrepayment(id_prepay2, accessToken);
            
            if(!prepay2_FromXero.isEmpty() && prepay2_FromXero.size() > 0)
            {
                xeroPrepayment_lst.add(prepay2_FromXero[0]);
            }
        }
        
        return xeroPrepayment_lst;
    }
    
    public static Attachment attachInvoice(String OnineInvoiceLink, String XeroId, String InvoiceNmber, String accName, String accessToken){
        
        String url = OnineInvoiceLink + '/Invoice/DownloadPdf/'+XeroId;
        System.debug('@@@ In attachInvoice -> url : '+url);
        System.debug('@@@ In attachInvoice -> XeroId : '+XeroId);
        System.debug('@@@ In attachInvoice -> InvoiceNmber : '+InvoiceNmber);
        System.debug('@@@ In attachInvoice -> accName : '+accName);

        if(String.isNotBlank(XeroId))
        {
            blob file = XeroAPI.getInvoiceAsPdf(XeroId, accessToken);
            if(file != null)
            {
                Attachment n = new Attachment();
                //n.ParentId = InvId; //set where you want to Save/Attach file
                n.Name = accName != null ? InvoiceNmber + '-' + accName +'.pdf' : InvoiceNmber+'.pdf';
                n.Body = file;
                n.contentType = 'application/pdf';
                return n;
            }
        }
        return null;
        
    }

    public class InsertInvoiceWrapper
    {
        String xeroInvoiceId;
        String sfInvoiceId;
        String AccountId;
        workorder workOrder;
        Invoice__c invoice;
        Attachment invoiceAttechment;
        List<Invoice_Line_Item__c> lst_LineItems;
        
        public InsertInvoiceWrapper()
        {
            this.lst_LineItems = new List<Invoice_Line_Item__c>();
        }
        
        public void addLineItem(Invoice_Line_Item__c lineItem)
        {
            this.lst_LineItems.add(lineItem);
        }
    }

    public static Xero_Setup__c CheckResponse(DateTime dt){
        String accessToken;
        Xero_Setup__c xroSetup;

        String resourceName = 'Invoices';
        Map<String, String> modifiedHeader = null;
        dt = dt.addDays(-7); //Get invoices to update in the last week
        if (dt != null) 
        {            
            // Build the modified header
            String strDate = String.valueOf(dt.date());
            String strTime = String.valueOf(dt.time());
            String strDateTime = strDate+'T'+strTime;
            
            System.debug('@@@ strDateTime = '+strDateTime);
            
            modifiedHeader = new Map<String, String> {'If-Modified-Since' => strDateTime};
        }
        
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName, null, modifiedHeader); 
         
        if(response.getStatusCode() == 401){
            xroSetup = XeroCalloutService.refreshToken();
            //accessToken = xroSetup.Access_Token__c;
            return xroSetup;
        }else {
            return null;
        }
    }
}