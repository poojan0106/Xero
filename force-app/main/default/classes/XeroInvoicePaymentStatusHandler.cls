/*
 * Created By : Yogesh 
 * Date : 25/03/
 */
public class XeroInvoicePaymentStatusHandler {
    
	public static void xeroInvoices(List<XeroInvoice> responseXeroInvoiceList)
    {
        System.debug('responseXeroInvoiceList '+responseXeroInvoiceList);
        System.debug('responseXeroInvoiceList Size '+responseXeroInvoiceList.size());
        
        Set<String> set_XeroInvoiceIds = new Set<String>();
        Map<String, Invoice__c> map_Invoices = new Map<String, Invoice__c>();
        List<Invoice__c> lst_InvoicesToUpdate = new List<Invoice__c>();
        
        for(XeroInvoice xeroResponse : responseXeroInvoiceList)
        {
            //xeroResponse.InvoiceID
            //add xero response Id in set
            if(String.isNotBlank(xeroResponse.InvoiceID))
            {
                set_XeroInvoiceIds.add(xeroResponse.InvoiceID);
            }
        }
        
        if(set_XeroInvoiceIds != null && set_XeroInvoiceIds.size()>0)
        {
            List<Invoice__c> lst_SfInvoices = [SELECT id, Status__c, Xero_ID__c ,Amount_Due__c
                                               FROM Invoice__c 
                                               WHERE Xero_ID__c IN:set_XeroInvoiceIds ];
            
            System.debug('lst_SfInvoices Size '+lst_SfInvoices.size());
            
            if(!lst_SfInvoices.isEmpty() && lst_SfInvoices.size() > 0)
            {
                for(Invoice__c invoice : lst_SfInvoices)
                {
                    map_Invoices.put(invoice.Xero_ID__c,invoice); 
                }
            }
        }
        
        for(XeroInvoice xeroResponse : responseXeroInvoiceList)
        {
            if(String.isNotBlank(xeroResponse.InvoiceID) && map_Invoices.containsKey(xeroResponse.InvoiceID))
            {
                Invoice__c inv = map_Invoices.get(xeroResponse.InvoiceID);
                if(inv.Status__c != xeroResponse.Status)
                {
                    inv.Status__c = xeroResponse.Status;
                }
                System.debug(' @@@ Integer.valueOf(xeroResponse.AmountDue) : '+xeroResponse.AmountDue);
                
                
                
         // Assuming xeroResponse.Date_x might be null, perform a null-check before proceeding
		if(!String.isBlank(xeroResponse.Date_x)) {
    		String dateString = xeroResponse.Date_x;

    		// Only proceed if the dateString format is as expected to contain '/Date(' and '+'
    		if(dateString.contains('/Date(') && dateString.contains('+')) {
        		// Extract the timestamp as a string. Assuming the format is consistent.
        		String timestampString = dateString.substringBetween('/Date(', '+');

        		// Convert the timestamp string 
        		Long timestamp = Long.valueOf(timestampString);

        		// DateTime.newInstance method accepts milliseconds from unix epoch
        		DateTime invoiceDateTime = DateTime.newInstance(timestamp);

        		// If you only need the date part for a Date field in Salesforce
        		Date invoiceDate = invoiceDateTime.date();

        		System.debug('Invoice DateTime: ' + invoiceDateTime);
        		System.debug('Invoice Date: ' + invoiceDate);

        		// Now you can safely set the date
        		inv.Invoice_Date__c = invoiceDate;
    		} else {
        		// Handle the scenario where dateString does not contain the expected format
        		System.debug('Invalid or unexpected date format: ' + xeroResponse.Date_x);
    		}
		} else {
    		// Handle or log the null or empty dateString scenario
    		System.debug('Date_x is null or empty for invoice ID: ' + xeroResponse.InvoiceID);
		}

                inv.Amount_Paid__c = xeroResponse.AmountPaid;
                inv.Amount_Due__c = xeroResponse.AmountDue;
                inv.Total__c = xeroResponse.Total;
                
                
                System.debug('!!! The Invoice Number is:' +xeroResponse.InvoiceNumber + ' !!!');
                System.debug('*** The Invoice Date is' +xeroResponse.Date_x +' ***');
                System.debug(' @@@ inv.Amount_Due__c : '+inv.Amount_Due__c);
                lst_InvoicesToUpdate.add(inv);                    
            }
        }
        
        if(!lst_InvoicesToUpdate.isEmpty() && lst_InvoicesToUpdate.size() > 0)
        {
            update lst_InvoicesToUpdate;
        }
        System.debug('lst_InvoicesToUpdate size : '+lst_InvoicesToUpdate.size());
    }
}