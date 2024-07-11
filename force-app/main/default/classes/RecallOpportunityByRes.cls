public class RecallOpportunityByRes {
    
    public static void makeCall(List<WorkOrderLineItem> scope)
    {
        System.debug('------scope----'+scope);
        System.debug('------scope.size()----'+scope.size());
        List<Opportunity> OppList = New List<Opportunity>();
        List<WorkOrderLineItem> WoliList = New List<WorkOrderLineItem>();
        List<Id> toMail = new List<Id>();
        Set<String> setofUniqueWOLI = new Set<String>();
        User u = [Select id,name,Email from User where Name = 'Beau Rheinberger'];
        
        for(WorkOrderLineItem WOI : scope){
            Date d2 = WOI.Warranty_End_Date__c.addDays(14);
            
            Opportunity o = new Opportunity();
            o.Name = WOI.Product2.Name + ' - Renewal';
            o.AccountId = WOI.WorkOrder.AccountId;
            o.Type= 'Existing Business';
            o.Original_Work_Order_Line_Item__c=WOI.Id;
            o.OwnerId=WOI.workOrder.account.OwnerId;
            o.LeadSource='Annual Recall';
            o.StageName = 'Qualification';
            o.CloseDate= d2 ;
            o.Amount=WOI.TotalPrice;
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
        insert OppList;
        
        
        System.debug('----WoliList----'+WoliList);
        System.debug('----WoliList.size()----'+WoliList.size());
        Database.update(WoliList,false);
        
        
        System.debug('------OppList------'+OppList);
        System.debug('------OppList.size()------'+OppList.size());
        if(OppList.size()>0){
            String htmlBody = 'The automated recall process was a success.<br>'
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
}