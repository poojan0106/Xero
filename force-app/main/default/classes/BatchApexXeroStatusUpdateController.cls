/*
Created by: Yogesh
Created on" 23/11/2020
*/
public class BatchApexXeroStatusUpdateController {

    Id RecordId;
  
    public BatchApexXeroStatusUpdateController(ApexPages.StandardController controller){
        RecordId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference callBatch(){
        // Your code here to execute the batch class/es
        System.debug('!!241120 call batch ');
        BatchToGetXeroInvoicePaymentStatus_ByRes batch = new BatchToGetXeroInvoicePaymentStatus_ByRes();
        Database.executeBatch(batch);      
        PageReference pg = new PageReference('/'+RecordId);
        pg.setRedirect(true);
        return pg;  
    } 

    
}