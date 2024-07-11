/*
 * Created By : Yogesh 
 * Date : 25/03/
 */
public class XeroInvoiceSyncSchedulerNew implements Schedulable {
	public void execute(SchedulableContext sc)
    {
        //calling actual batch class
        Database.executeBatch(new BatchToGetXeroInvoicePaymentStatus_ByRes(),2000);
    }
}