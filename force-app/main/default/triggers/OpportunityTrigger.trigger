trigger OpportunityTrigger on Opportunity (after update,after delete) {
    if(checkRecursive.runOnce())
    {
        if(Trigger.isAfter)
        {
            if(Trigger.isUpdate)
            {
                System.debug('----Inside After-----'+Trigger.new);
                Opportunity oppNew = Trigger.new[0];
                System.debug('----oppNew----'+oppNew);
                Opportunity oppOld = Trigger.old[0];
                System.debug('----oppOld----'+oppOld);
                Date todayDate = System.today();
                Integer dt = todayDate.daysBetween(Date.valueOf(oppNew.CloseDate));
                if(dt < 0)
                {
                    dt=-1*dt;
                }
                System.debug('----dt---'+dt);
                System.debug('----Inside After Update-----');
                Account acc = [Select id,Sum_Revenue_Last_455_Days__c,Sum_Revenue_Last_455_to_912_Days__c,Sum_Revenue_Last_912_to_1500_Days__c from Account where id =:oppNew.AccountId];
                
                if(oppOld.StageName!=oppNew.StageName && oppOld.StageName == 'Closed Won')
                {
                    updateAmount(acc,oppNew,dt,'-');
                }
                if(oppOld.StageName!=oppNew.StageName && oppNew.StageName == 'Closed Won')
                {
                    updateAmount(acc,oppNew,dt,'+');
                }
            }
            
            if(Trigger.isDelete)
            {
                System.debug('----Inside After Delete-----');
                Opportunity oppOld = Trigger.old[0];
                System.debug('----oppOld----'+oppOld);
                Date todayDate = System.today();
                Integer dt = todayDate.daysBetween(Date.valueOf(oppOld.CloseDate));
                if(dt < 0)
                {
                    dt=-1*dt;
                }
                System.debug('----dt---'+dt);
                if(oppOld.StageName == 'Closed Won')
                {
                    Account acc = [Select id,Sum_Revenue_Last_455_Days__c,Sum_Revenue_Last_455_to_912_Days__c,Sum_Revenue_Last_912_to_1500_Days__c from Account where id =:oppOld.AccountId];
                    System.debug('----acc----'+acc);
                    
                    updateAmount(acc,oppOld,dt,'-');
                }
                
            }
        }
    }
    public void updateAmount(Account acc,Opportunity opp,Integer dt,String Operation)
    {
        Account accNew = new Account();
        if(dt <= 455)
        {
            Decimal acc_415;
            if(Operation == '-')
            {
                acc_415 = acc.Sum_Revenue_Last_455_Days__c - opp.Amount;
            }
            if(Operation == '+')
            {
                acc_415 = acc.Sum_Revenue_Last_455_Days__c + opp.Amount;
            }
            accNew.Sum_Revenue_Last_455_Days__c = acc_415;
            accNew.Id = acc.id;
        }
        else if(dt > 455 && dt <= 912)
        {
            Decimal acc_912;
            if(Operation == '-')
            {
                acc_912 = acc.Sum_Revenue_Last_455_to_912_Days__c - opp.Amount;
            }
            if(Operation == '+')
            {
                acc_912 = acc.Sum_Revenue_Last_455_to_912_Days__c + opp.Amount;
                
            }
            accNew.Sum_Revenue_Last_455_to_912_Days__c = acc_912;
            accNew.Id = acc.id;
        }
        else if(dt > 912 && dt <= 1500)
        {
            Decimal acc_1500;
            if(Operation == '-')
            {
                acc_1500 = acc.Sum_Revenue_Last_912_to_1500_Days__c - opp.Amount;
            }
            if(Operation == '+')
            {
                acc_1500 = acc.Sum_Revenue_Last_912_to_1500_Days__c + opp.Amount;
            }
            accNew.Sum_Revenue_Last_912_to_1500_Days__c = acc_1500;
            accNew.Id = acc.id;
        }
        update accNew;
    }
}