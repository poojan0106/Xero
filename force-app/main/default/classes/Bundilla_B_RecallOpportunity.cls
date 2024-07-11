global class Bundilla_B_RecallOpportunity implements Database.Batchable<sobject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date d = system.today().addDays(21);
        List<String> ss=new List<String>();
        ss.add('Completed');
        ss.add('Closed');
        System.debug('----ss----'+ss);
        System.debug('----d----'+d);
        List<WorkOrderLineItem> WOLI = New list<WorkOrderLineItem>();
        
        if(!test.isRunningTest())
        {
            WOLI = [Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,Product2.Time__c, Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive,PricebookEntry.Product2Id,Quantity,PricebookEntry.UnitPrice,WorkOrder.Account_Type__c,Discount,Product_Name__c From WorkOrderLineItem Where Warranty_End_Date__c = :d  AND Status IN :ss];
            ////Warranty_Period_Day__c != 0
            System.debug('-----WOLI---'+WOLI);
            //return Database.getQueryLocator([Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,  Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive From WorkOrderLineItem Where Warranty_End_Date__c = :d  AND Status IN :ss]);
            
            return Database.getQueryLocator([Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,Product2.Time__c, Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive,PricebookEntry.Product2Id,Quantity,PricebookEntry.UnitPrice,WorkOrder.Account_Type__c,Discount,Product_Name__c From WorkOrderLineItem Where Warranty_End_Date__c = :d  AND Status IN :ss AND Warranty_Period_Day__c != 0]);
            
            
        }else
        {
            WOLI = [Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,Product2.Time__c,Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive,PricebookEntry.Product2Id,Quantity,PricebookEntry.UnitPrice,WorkOrder.Account_Type__c,Discount,Product_Name__c From WorkOrderLineItem order by createddate desc limit 3  ];
            System.debug('-----WOLI2---'+WOLI);
            return Database.getQueryLocator([Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,Product2.Time__c,WorkOrderId,  Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive,PricebookEntry.Product2Id,Quantity,PricebookEntry.UnitPrice,WorkOrder.Account_Type__c,Discount,Product_Name__c From WorkOrderLineItem order by createddate desc limit 3  ]);
            
        }
        
        // return WOLI;
        //return Database.getQueryLocator([Select Id,Contact_Email__c,Send_Email_Trigger__c,Account_Type__c,WorkOrder.Account.ParentId,WorkOrder.Contact.AccountId,WorkOrder.Asset.AccountId,WorkOrder.AccountId,Product2.Name,workorder.account.type,WorkOrder.Opportunity__r.Primary_Contact__r.Id,WorkOrder.AssetId,workOrder.account.OwnerId,TotalPrice,  WorkOrderId,  Warranty_End_Date__c,WorkOrder.ContactId, WorkOrder.Account.Owner.isactive From WorkOrderLineItem Where Warranty_End_Date__c = :d  AND Status IN :ss]);
    }
    
    global void execute(Database.BatchableContext BC, List<WorkOrderLineItem> scope) {
      try{
        System.debug('------scope----'+scope);
        System.debug('------scope.size()----'+scope.size());
        List<Opportunity> OppList = New List<Opportunity>();
        List<OpportunityLineItem> OppProductList = new List<OpportunityLineItem>();
        List<WorkOrderLineItem> WoliList = New List<WorkOrderLineItem>();
        List<id> toMail = new List<id>();
        Set<String> setofUniqueWOLI = new Set<String>();
        User u = [Select id,name,Email from User where Name = 'Beau Rheinberger'];
        //PricebookEntry unitPriceOfLoyalBonus = [select id,Name,UnitPrice from PricebookEntry where id =: Label.ID_of_Loyality_Bonus_Product];
        
        //String customLabel = label.Mail_Ids; 
        //toMail= System.Label.Mail_Ids.split(',');
        system.debug('toMail'+toMail);
        
        Map<String,WorkOrderLineItem> mapOfPriceBookEntry = new Map<String,WorkOrderLineItem>();
        List<String> lstProductName = new List<String>(); 
        
        for(WorkOrderLineItem WOI : scope){
            Date d2 = WOI.Warranty_End_Date__c.addDays(14);
            mapOfPriceBookEntry.put(WOI.Id,WOI);
            lstProductName.add(WOI.Product_Name__c);
            
            Opportunity o = new Opportunity();
            o.Name = WOI.Product2.Name + ' - Renewal';
            o.AccountId = WOI.WorkOrder.AccountId;
            o.Type= 'Existing Business';
            o.Original_Work_Order_Line_Item__c=WOI.Id;
            
            if( WOI.WorkOrder.Account.Owner.isactive){
                o.OwnerId=WOI.workOrder.account.OwnerId;
            }
            else{
                o.OwnerId=u.Id;
            }
            
            o.LeadSource='Annual Recall';
            o.StageName = 'Qualification';
            o.CloseDate= d2 ;
            o.Amount=WOI.TotalPrice;
            o.Original_Work_Order__c = WOI.WorkOrderId;
            system.debug('o.Original_Work_Order__c'+o.Original_Work_Order__c);
            o.WO_Time__c= WOI.Product2.Time__c;
            system.debug('o.WO_Time__c'+o.WO_Time__c);
            if(WOI.WorkOrder.AssetId!=null && WOI.WorkOrder.Asset.AccountId == WOI.WorkOrder.AccountId)
            {
                o.Asset__c=WOI.WorkOrder.AssetId;
            }
            if(WOI.WorkOrder.ContactId!=null)
            {
                if(WOI.WorkOrder.Contact.AccountId== WOI.WorkOrder.AccountId || WOI.WorkOrder.Contact.AccountId== WOI.WorkOrder.Account.ParentId)
                {
                    o.Primary_Contact__c=WOI.WorkOrder.ContactId;   
                }
            }
            OppList.add(o);
            System.debug('----WOI.Contact_Email__c---'+WOI.Contact_Email__c);
            System.debug('----WOI.Account_Type__c---'+WOI.Account_Type__c);
            System.debug('---- before WOI.Send_Email_Trigger__c---'+WOI.Send_Email_Trigger__c);
            
            
            
            if(WOI.Contact_Email__c <> null && WOI.Account_Type__c == 'Domestic Customer'){
                System.debug('-----WOI.Contact_Email__c-----'+WOI.Contact_Email__c);
                if(!setofUniqueWOLI.contains(WOI.Contact_Email__c))
                {
                    WoliList.add(WOI);
                    setofUniqueWOLI.add(WOI.Contact_Email__c);
                    WOI.Send_Email_Trigger__c = true;
                }
                
                
                System.debug('----setofUniqueWOLI---'+setofUniqueWOLI);
                System.debug('----setofUniqueWOLI.size()---'+setofUniqueWOLI.size());
                //WoliList.add(WOI);
                
            }
        }
        
        if(OppList.size() > 0 && !OppList.isEmpty())
        {
            
            	insert OppList;
              
        }
        
        System.debug('lstProductName :: ' +lstProductName);
        List<PricebookEntry> latestPBEntry = [select id,Name,UnitPrice,Pricebook2.name,Pricebook2.IsActive,IsActive,
                                              Pricebook2.CreatedDate,Product2.name from PricebookEntry where
                                              Pricebook2.IsActive = true AND Product2.name in:lstProductName  
                                              order by Pricebook2.CreatedDate DESC];
        
        System.debug('latestPBEntry size :: ' +latestPBEntry);
        Map<String,PricebookEntry>  mapOfLatestPBEntry= new Map<String,PricebookEntry>();
        String latestPBYear = '';
        if(latestPBEntry.size() > 0 && !latestPBEntry.isEmpty())
        {
           latestPBYear = latestPBEntry[0].Pricebook2.name;
        system.debug('latestPBYear :: ' +latestPBYear);
        }
        
        List<PricebookEntry> pbEntryForLoyalityBonus = [select id,Name,UnitPrice,Pricebook2.name,Product2.name,IsActive 
                                                  from PricebookEntry where Pricebook2.name =: latestPBYear 
                                                  AND Product2.name =: Label.Loyalty_Bonus];
        
        For(PricebookEntry pb : latestPBEntry)
        {
            if(pb.Pricebook2.name == latestPBYear)
            {
                mapOfLatestPBEntry.put(pb.name,pb);	
            }
        }
        
        List<id> idOfOppList = new List<id>();
        for(Opportunity opp : OppList)
        {
            idOfOppList.add(opp.id);
        }
        
        List<Opportunity> lstOppList = [Select id,Original_Work_Order_Line_Item__c,Original_Work_Order_Line_Item__r.Status,name,
                                        Original_Work_Order_Line_Item__r.Product_Name__c
                                        from Opportunity where id in: idOfOppList];
        
        system.debug('lstOppList :: ' +lstOppList.size());
        system.debug('product name :: ' +lstOppList[0].Original_Work_Order_Line_Item__r.Product_Name__c);
        
        For(Opportunity opp : lstOppList)
        {
            //System.debug('mapOfPriceBookEntry.get(opp.Original_Work_Order_Line_Item__c).PricebookEntry.UnitPrice :: ' +mapOfPriceBookEntry.get(opp.Original_Work_Order_Line_Item__c).PricebookEntry.UnitPrice);
            //System.debug('mapOfPriceBookEntry.containsKey(opp.Original_Work_Order_Line_Item__c)'+mapOfPriceBookEntry.containsKey(opp.Original_Work_Order_Line_Item__c));
            //System.debug('mapOfLatestPBEntry.containsKey(opp.Original_Work_Order_Line_Item__r.Product_Name__c)'+mapOfLatestPBEntry.containsKey(opp.Original_Work_Order_Line_Item__r.Product_Name__c));
            //System.debug('mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).IsActive '+mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).IsActive );
            if(mapOfPriceBookEntry.containsKey(opp.Original_Work_Order_Line_Item__c) && 
               mapOfLatestPBEntry.containsKey(opp.Original_Work_Order_Line_Item__r.Product_Name__c) && 
               mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).IsActive == true)
            {
                OpportunityLineItem oppProduct = new OpportunityLineItem();
                oppProduct.OpportunityId = opp.id;
                oppProduct.Quantity = 1 ;
                oppProduct.Discount = mapOfPriceBookEntry.get(opp.Original_Work_Order_Line_Item__c).Discount ;
                System.debug('opp.Original_Work_Order_Line_Item__r.Status :: ' +opp.Original_Work_Order_Line_Item__r.Status);
                //System.debug('opp.Original_Work_Order_Line_Item__r.Product2.name :: ' +opp.Original_Work_Order_Line_Item__r.Product2.name);
                System.debug('opp.Original_Work_Order_Line_Item__r.Product_Name__c :: ' +opp.Original_Work_Order_Line_Item__r.Product_Name__c);
                if(mapOfLatestPBEntry.containsKey(opp.Original_Work_Order_Line_Item__r.Product_Name__c))
                {
                    system.debug('in the map');
                    System.debug('id :: ' +mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).id);
                    System.debug('unit price :: ' +mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).UnitPrice);
                    oppProduct.Product2Id = mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).id;
                    oppProduct.UnitPrice = mapOfLatestPBEntry.get(opp.Original_Work_Order_Line_Item__r.Product_Name__c).UnitPrice;
                }
                //oppProduct.TotalPrice = opp.Amount;
                OppProductList.add(oppProduct); 
                
                If(mapOfPriceBookEntry.get(opp.Original_Work_Order_Line_Item__c).WorkOrder.Account_Type__c == Label.Domestic_Customer && pbEntryForLoyalityBonus.size() > 0 && !pbEntryForLoyalityBonus.isEmpty() && pbEntryForLoyalityBonus[0].IsActive == true &&(opp.Name.contains(Label.Loyalty_Bonus_For_Deluxe_Pest_Control) || opp.Name.contains(Label.Loyalty_Bonus_For_Termite_Inspection) || opp.Name.contains(Label.Loyalty_Bonus_For_Supreme_Pest_Package)))
                {
                    OpportunityLineItem oppProduct2 = new OpportunityLineItem();
                    oppProduct2.OpportunityId = opp.id;
                    oppProduct2.Quantity = 1 ;
                    //oppProduct2.Discount = mapOfPriceBookEntry.get(opp.Original_Work_Order_Line_Item__c).Discount ;
                    //oppProduct2.Product2Id = Label.ID_of_Loyality_Bonus_Product;
                    oppProduct2.Product2Id = pbEntryForLoyalityBonus[0].id;
                    oppProduct2.UnitPrice = pbEntryForLoyalityBonus[0].UnitPrice;
                    //oppProduct2.TotalPrice = opp.Amount;
                    OppProductList.add(oppProduct2);
                }
            }
        }
        
        System.debug('Size of OppProductList :: ' +OppProductList);
        if(OppProductList.size() > 0 && !OppProductList.isEmpty())
        {
            insert OppProductList;
        }
        
        System.debug('OppProductList :: ' +OppProductList);
        
        System.debug('----WoliList----'+WoliList);
        System.debug('----WoliList.size()----'+WoliList.size());
        Database.update(WoliList,false);
        
        
        System.debug('------OppList------'+OppList);
        System.debug('------OppList.size()------'+OppList.size());
        if(OppList.size()>0){
            String htmlBody = 'The automated Recall process was a success.<br>'
                +'The total number of opportunities created = '+OppList.size()+'<br>'+'<br>'+
                'Below are the links to the Opportunities:<br>';
            String oppLink='';
            for(Opportunity o :OppList)
            {
                oppLink = oppLink + System.URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Opportunity/'+o.Id+'/view'+'<br>';
            }
            
            htmlBody+='\n'+oppLink;
            System.debug('----htmlBody----'+htmlBody);
            
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE Address =: label.org_wide_account_email limit 1];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            toMail.add(u.Id);
            mail.setSubject('Automated Recall Process');
            mail.setHtmlBody(htmlBody);
            mail.setToAddresses(toMail);
            mail.setOrgWideEmailAddressId(owa.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
    }
      catch (Exception e) 
            {       	
                    String htmlBody = 'The automated Recall Apex process has failed.<br>'
                    +'Please see below for the details and contact Resonant Cloud for assistance.<br>';
                    String errorMsg='Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
                    + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString() ;
                    
                    
                    htmlBody+='\n'+errorMsg;
                    System.debug('----htmlBody----'+htmlBody);
                    
                    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE Address =: label.org_wide_account_email limit 1];
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   // toMail.add(u.Id);
                   List<String> toMail = new List<String>();
                    toMail= System.Label.Mail_Ids.split(',');
                	system.debug('toMail'+toMail);
                    mail.setSubject('Automated Recall Process Failed');
                    mail.setHtmlBody(htmlBody);
                    mail.setToAddresses(toMail);
                    mail.setOrgWideEmailAddressId(owa.id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
                }

    }
    
    global void finish(Database.BatchableContext BC) {
        
        Id yourclassid='01p6F000009qiGdQAI' ;
        List<AsyncApexJob> myrunningjob = [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClassId =: yourclassid order by CreatedDate DESC limit 1];
		System.debug('###### running job status is: '+myrunningjob[0].status);

        
    }
    
}