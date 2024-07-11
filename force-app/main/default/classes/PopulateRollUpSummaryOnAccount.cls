public class PopulateRollUpSummaryOnAccount implements Database.Batchable<sObject> { 
    public Database.QueryLocator start(Database.BatchableContext BC){
           return Database.getQueryLocator([select id,Name,StageName,AccountId,Amount,CloseDate from Opportunity where StageName = 'Closed Won' And Days_Since_Close_Won__c < 1501]);
    }
    public void execute(Database.BatchableContext BC, List<Opportunity> oppList){
        List<Id> AccId = new List<Id>();
        Map<Id,AccountWrapper> accountWrapperMap = new Map<Id,AccountWrapper>();
        List<Account> accUpdate = new List<Account>();
        for(Opportunity opp : oppList)
        {
            Date todayDate = System.today();
            Integer dt = todayDate.daysBetween(Date.valueOf(opp.CloseDate));
            if(dt < 0)
            {
                dt=-1*dt;
            }
            System.debug('----dt---'+dt);
            
            if(dt <= 455)
            {
                System.debug('-----inside 1-----'+opp.AccountId);
                System.debug('-----inside 1 accountWrapperMap-----'+accountWrapperMap);
                if(accountWrapperMap.containsKey(opp.AccountId))
                {
                    AccountWrapper acc_wrapper = accountWrapperMap.get(opp.AccountId);
                    if(acc_wrapper.has_455)
                    {
                        Decimal amt_455;
                        if(opp.Amount==null)
                        {
                        	amt_455 = acc_wrapper.amount_455;    
                        }
                        else
                        {
                        	amt_455 = acc_wrapper.amount_455 + opp.Amount;    
                        }
                        acc_wrapper.amount_455 = amt_455; 
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);    
                    }
                    else
                    {
                        if(opp.Amount==null)
                        {
                            acc_wrapper.amount_455 = 0;
                        }
                        else
                        {
                            acc_wrapper.amount_455 = opp.Amount;
                        }
                        acc_wrapper.has_455 = true;
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);
                    }
                    
                }
                else
                {
                    AccountWrapper aw_455 = new AccountWrapper();
                    aw_455.accountId = opp.AccountId;
                    System.debug('--opp.Amount--'+opp.Amount);
                    if(opp.Amount==null)
                    {
                        aw_455.amount_455 = 0;
                    }
                    else
                    {
                        aw_455.amount_455 = opp.Amount;
                    }
                    
                    aw_455.has_455 = true;
                    accountWrapperMap.put(opp.AccountId,aw_455);
                    System.debug('-----inside 1 accountWrapperMap 79-----'+accountWrapperMap);
                }
            }
            else if(dt > 455 && dt <= 912)
            {
                System.debug('-----inside 2-----'+opp.AccountId);
                if(accountWrapperMap.containsKey(opp.AccountId))
                {
                    AccountWrapper acc_wrapper = accountWrapperMap.get(opp.AccountId);
                    if(acc_wrapper.has_912)
                    {
                        Decimal amt_912;
                        if(opp.Amount==null)
                        {
                            amt_912 = acc_wrapper.amount_912;
                        }
                        else
                        {
                            amt_912 = acc_wrapper.amount_912 + opp.Amount;
                        }
                         
                        acc_wrapper.amount_912 = amt_912; 
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);    
                    }
                    else
                    {
                        if(opp.Amount==null)
                        {
                        	acc_wrapper.amount_912 = 0;    
                        }
                        else
                        {
                            acc_wrapper.amount_912 = opp.Amount;
                        }
                        acc_wrapper.has_912 = true;
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);
                    }	                    
                }
                else
                {
                    AccountWrapper aw_912 = new AccountWrapper();
                    aw_912.accountId = opp.AccountId;
                    if(opp.Amount==null)
                    {
                    	aw_912.amount_912 = 0;    
                    }
                    else
                    {
                        aw_912.amount_912 = opp.Amount;
                    }
                    aw_912.has_912 = true;
                    accountWrapperMap.put(opp.AccountId,aw_912);
                }
            }
            else if(dt > 912 && dt <= 1500)
            {
                System.debug('-----inside 3-----'+opp.AccountId);
                if(accountWrapperMap.containsKey(opp.AccountId))
                {
                    AccountWrapper acc_wrapper = accountWrapperMap.get(opp.AccountId);
                    if(acc_wrapper.has_1500)
                    {
                        Decimal amt_1500;
                        if(opp.Amount==null)
                        {
                            amt_1500 = acc_wrapper.amount_1500;
                        }
                        else
                        {
                        	amt_1500 = acc_wrapper.amount_1500 + opp.Amount;    
                        }
                         
                        acc_wrapper.amount_1500 = amt_1500; 
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);    
                    }
                    else
                    {
                        if(opp.Amount==null)
                        {
                        	acc_wrapper.amount_1500 = 0;    
                        }
                        else
                        {
                            acc_wrapper.amount_1500 = opp.Amount;
                        }
                        
                        acc_wrapper.has_1500 = true;
                        accountWrapperMap.put(opp.AccountId,acc_wrapper);
                    }
                }
                else
                {
                    AccountWrapper aw_1500 = new AccountWrapper();
                    aw_1500.accountId = opp.AccountId;
                    if(opp.Amount==null)
                    {
                        aw_1500.amount_1500 = 0;
                    }
                    else
                    {
                        aw_1500.amount_1500 = opp.Amount;
                    }
                    
                    aw_1500.has_1500 = true;
                    accountWrapperMap.put(opp.AccountId,aw_1500);
                }
            }
            
        }
        System.debug('---accountWrapperMap---'+accountWrapperMap);
        
        if(accountWrapperMap.size()>0)
        {
            for(Id awId : accountWrapperMap.keySet())
            {
                Account acc = new Account();
                AccountWrapper aw = accountWrapperMap.get(awId);
                if(aw.has_455)
                {
                    acc.Sum_Revenue_Last_455_Days__c = aw.amount_455;
                    acc.Id = awId;
                }
                if(aw.has_912)
                {
                    acc.Sum_Revenue_Last_455_to_912_Days__c = aw.amount_912;
                    acc.Id = awId;
                }
                if(aw.has_1500)
                {
                    acc.Sum_Revenue_Last_912_to_1500_Days__c = aw.amount_1500;
                    acc.Id = awId;
                }
                accUpdate.add(acc);
            }
            if(accUpdate.size()>0)
            {
                System.debug('---accUpdate---'+accUpdate);
                
                update accUpdate;
            }
        }
        
    }
    public void finish(Database.BatchableContext BC){
    } 
}