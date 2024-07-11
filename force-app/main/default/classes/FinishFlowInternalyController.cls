/*
*Created By Yogesh
*Date 24-03-2021
*/
public class FinishFlowInternalyController {
    public Id workOrderId;
    List<Id> lst_workorderIds = new List<Id>();
    
    public FinishFlowInternalyController(ApexPages.StandardController controller){
        workOrderId = ApexPages.currentPage().getParameters().get('id');
        System.debug('workOrderId: '+workOrderId);
    }
    
    public void callFinishWorkOrderHelper(){
        
        if(checkRecursive.runOnce())
        {
            list<WorkOrder> lst_Workrders = new list<WorkOrder>();
            Map<Id, Account> map_Accounts;
            
            System.debug('@@YY workOrderId : '+workOrderId);
            if(String.isNotBlank(workOrderId))
            {
                WorkOrder wOrder = [SELECT id, Send_Invoice__c, From_the_Finish_Flow__c,
                                    completed_internally__c, Payment_Collected__c, AccountId
                                    FROM WorkOrder
                                    WHERE ID =: workOrderId];
                
                Decimal lineItemsPaymentAmount = 0;
                for(WorkOrderLineItem woLineItem : [select id, WorkOrderId,TotalPrice
                                                    from WorkOrderLineItem 
                                                    where WorkOrderId =: workOrderId and Invoiced__c = FALSE and 
                                                    Status ='Completed' ])
                {
                    lineItemsPaymentAmount = lineItemsPaymentAmount + woLineItem.TotalPrice;
                }
                
                
                if(wOrder.Payment_Collected__c <= lineItemsPaymentAmount)
                {
                    if(wOrder.Send_Invoice__c == 'Yes')
                    {
                        System.debug('without trigger, handler will call...');
                        lst_workorderIds.add(wOrder.id); //added workOrder Id 
                        lst_Workrders.add(wOrder);
                        
                        //create accounts map 
                        if(wOrder.AccountId != null)
                        {
                            map_Accounts = new Map<Id, Account>([SELECT Id, ParentId FROM Account WHERE ID = :wOrder.AccountId]);
                        }
                        else
                        {
                            map_Accounts = new Map<Id, Account>(); 
                        }
                    }
                    else
                    {
                        wOrder.Send_Invoice__c = 'Yes';
                        wOrder.completed_internally__c = True;
                        //wOrder.From_the_Finish_Flow__c = True;
                        try
                        {
                            update wOrder;
                        }
                        catch(DmlException e)
                        {
                            // fail 
                            System.debug('failed update : '+e.getMessage());
                        }
                        System.debug('Now trigger will be call...');
                    }
                    
                    if(!lst_workorderIds.isEmpty() && lst_workorderIds.size() > 0)
                    {
                        Set<Id> InvoiceIds = FinishWorkOrderHelper.invoicesCreationIds(lst_workorderIds, lst_Workrders, map_Accounts);
                        if(!InvoiceIds.isEmpty() && InvoiceIds.size() > 0)
                        {
                            FinishWorkOrderHelper.getWorkOrder(InvoiceIds,true);
                        }
                    }
                }
                else
                {
                    System.debug(' @@addmessage@@  ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Payment amount exceeds the amount outstanding on this invoice '));
                }
            }
        }
        System.debug('lst_workorderIds size : '+lst_workorderIds.size());
    } 
    
    public PageReference goBack()
    {
        PageReference pg = new PageReference('/'+workOrderId);
        pg.setRedirect(true);
        return pg;  
    }
}