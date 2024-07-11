/*
	Created By 	:	Yogesh
	Date 		:	08-04-2021
	Description : 	insert xero error log during dml and http callout
	XeroErrorLog_ByRes.createErrorLogForDml(e,invoiceId,workOrderId,accountId)
	XeroErrorLog_ByRes.createErrorLogForXeroCallout(e,invoiceId,workOrderId,accountId)
*/
public class XeroErrorLog_ByRes {
	
    public static void createErrorLogForDml(Exception e, String className, Id invoiceId, Id workOrderId, Id accountId, Boolean isUpdateWorkOrder)
    {
        WorkOrder wKOrder = new WorkOrder();
        Xero_Erro__c error = new Xero_Erro__c();
        error.Name  = e.getTypeName();
        error.class_name__c = className;
        error.Stack_Trace_String__c = e.getStackTraceString();
        error.LineNumber__c  = e.getLineNumber();
        error.Error_Description__c = e.getMessage();
        if(workOrderId != null)
        {
            error.Work_Order__c = workOrderId;
            wKOrder.Id = workOrderId;
            if(isUpdateWorkOrder)
            {
                wKOrder.From_the_Finish_Flow__c = false; 
                wKOrder.completed_internally__c = false;
                update wKOrder;
            }            
        }
        if(invoiceId != null)
        {
            error.Invoice__c = invoiceId;
        }
        if(accountId != null)
        {
            error.Account__c = accountId;
        }
        insert error;
    }
}