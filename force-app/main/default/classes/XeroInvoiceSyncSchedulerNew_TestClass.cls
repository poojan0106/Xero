@IsTest
public class XeroInvoiceSyncSchedulerNew_TestClass {

    @IsTest
    public static void testmethod1() {
        
        XeroInvoiceSyncSchedulerNew testobj = new XeroInvoiceSyncSchedulerNew ();    
        String cronexpression = '0 0 12 * * ?';    
        System.schedule('Invoice Status test', cronexpression, testobj);
 
    }
   
}