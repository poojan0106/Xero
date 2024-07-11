/******
* Created by: Princee Soni -  Resonant cloud
* Created date: 10-03-2021
* Purpose : The work order finish flow should generate the invoice by the FSL technician
******/
trigger FinishWorkOrderTrigger on WorkOrder (after insert, after update) 
{    
    System.debug('checkRecursive_byRes :'+checkRecursive_byRes.run);
    
    //when recorde is created 
    if(Trigger.isAfter && Trigger.IsInsert && System.IsBatch() == false && System.isFuture() == false)
    {
        List<Id> accountIdsFromWo = new List<Id>();
        for(WorkOrder wo : Trigger.new)
        {
            if(wo.AccountId != null && String.isNotBlank(wo.AccountId))
            {
                accountIdsFromWo.add(wo.AccountId);
            }
        }
        
        if(!accountIdsFromWo.isEmpty() && accountIdsFromWo.size()>0)
        {
            
            if(checkRecursive_byRes.runOnce())
            {
                FinishWorkOrderHelper.createXeroContact(accountIdsFromWo); 
            }
        }
    }
    
    System.debug('@@Test Trigger.isAfter : '+Trigger.isAfter);
    System.debug('@@Test Trigger.IsUpdate : '+Trigger.IsUpdate);
    System.debug('@@Test System.IsBatch() : '+System.IsBatch());
    System.debug('@@Test System.isFuture() : '+System.isFuture());
    
    if(Trigger.isAfter && Trigger.IsUpdate && System.IsBatch() == false && System.isFuture() == false)
    {
        system.debug('Work order value old' + Trigger.old);
        system.debug('Work order value new' + Trigger.new);
        
        List<Id> passWo = new List<Id>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, WorkOrder> map_workOrder =  new Map<Id, WorkOrder>();
        Map<ID, Account> map_Accounts; 
        
        for(WorkOrder wo : Trigger.new)
        {
            List<WorkOrderLineItem> lstunInvoiced = [select id from WorkOrderLineItem where status = 'Completed' and Invoiced__c = False and WorkOrderId =: wo.id];
            System.debug('@@ YY lstunInvoiced : '+lstunInvoiced);
            System.debug('@@ YY lstunInvoiced size : '+lstunInvoiced.size());
            System.debug('@@ YY Send_Invoice__c : '+wo.Send_Invoice__c);
            System.debug('@@ YY From_the_Finish_Flow__c : '+wo.From_the_Finish_Flow__c);
            
            if(wo.Send_Invoice__c == 'Yes' && (wo.From_the_Finish_Flow__c == TRUE || wo.completed_internally__c == TRUE) && lstunInvoiced.size()>0)
            {
                System.debug('### Yogesh ### ::: * status : '+wo.Status);
                passWo.add(wo.Id);
                map_workOrder.put(wo.Id, wo);
                if(wo.AccountId != null)
                {
                    accountIds.add(wo.AccountId);
                }
            }
        }
        
        //create accounts map 
        if(!accountIds.isEmpty() && accountIds.size()>0)
        {
            map_Accounts = new Map<Id, Account>([SELECT Id, ParentId FROM Account WHERE ID IN: accountIds]);
        }
        
        //calling for creating invoice record 
        if(!passWo.isEmpty() && passWo.size()>0)
        {
            if(checkRecursive_byRes.runOnce())
            {
                System.debug('@@ Yogi 2021 : invoicesCreationIds method is ready to call ...');
                Set<Id> InvoiceIds = FinishWorkOrderHelper.invoicesCreationIds(passWo, Trigger.new, map_Accounts);
                System.debug('!!@@ map_workOrder @@!! $ : '+map_workOrder);
                if(!InvoiceIds.isEmpty() && InvoiceIds.size() > 0)
                {
                    FinishWorkOrderHelper.getWorkOrder(InvoiceIds,false);
                    //System.debug('@@ Yogi 2021 : InvoiceIds : '+InvoiceIds);
                    //System.debug('@@ Yogi 2021 : InvoiceIds size : '+InvoiceIds.size());
                }
            }
        }
        
    }
}