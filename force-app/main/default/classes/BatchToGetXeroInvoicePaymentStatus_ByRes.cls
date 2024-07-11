/*
 * Created By : Yogesh 
 * Date : 25/03/
 */
public class BatchToGetXeroInvoicePaymentStatus_ByRes implements Database.Batchable<XeroInvoice>, DataBase.AllowsCallouts {
	
    public List<XeroInvoice> start(Database.BatchableContext bc)
    {
        //get current Date time 
        DateTime currentDateTime = DateTime.now();
        //get Xero invoice from salesforce
        List<XeroInvoice> response = XeroAPI.getModifiedInvoices(currentDateTime);
        System.debug('Resoponse !! 231120 YY'+response);
        // return xero invoice list 
        return response;
    }
    
    public void execute(Database.BatchableContext bc, List<XeroInvoice> xeroList)
    {
        if(xeroList != null && xeroList.size()>0)
        {
            XeroInvoicePaymentStatusHandler.xeroInvoices(xeroList);
        }
    }
    
    public void finish(Database.BatchableContext bc)
    {
         System.debug('records Updated');          
    }
}