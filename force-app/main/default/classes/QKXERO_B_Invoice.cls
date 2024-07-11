global class QKXERO_B_Invoice implements Database.Batchable<QKXERO_Invoice>, Database.AllowsCallouts {
	public List<QKXERO_Invoice> recentlyChangedInvoices;

    public Iterable<QKXERO_Invoice> start(Database.BatchableContext BC) {
    	// Regardless of context, always at least get a list of the last 2 days
    	if(this.recentlyChangedInvoices == null){
    		this.recentlyChangedInvoices = QKXERO_Invoice.query(null, Datetime.now().addDays(-2), 1);
    	}
    	
    	return this.recentlyChangedInvoices;
    }

    public void execute(Database.BatchableContext info, List<QKXERO_Invoice> xInvoices) {
    	// Make this a non-iteratable function for now. 
    	System.debug(xInvoices);
    	if(xInvoices.size() == 1){
    		QKXERO_Invoice xInvoice = xInvoices[0];
    		List<Invoice__c> invoices = [SELECT Id, Name FROM Invoice__c WHERE Xero_Id__c = :xInvoice.InvoiceId LIMIT 1];
    		System.debug(invoices);
    		System.debug(xInvoice);
    		if(invoices.size() == 0){
    			// We only want to update already known Invoices. This should be a configuration option later on. 
    			return;
    		}

    		
    		Blob pdf = QKXERO_Invoice.getPdf(xInvoice.InvoiceID);
    		
    		
    		List<Invoice_Line_Item__c> invoiceLineItems;// = [SELECT Id, Name FROM Invoice__c WHERE Xero_Id__c = :xInvoice.InvoiceId LIMIT 1];
    		Invoice__c invoice = QKXERO_Invoice.convertInvoiceToSobject(xInvoice);

			// TODO: Refactor this. This has dead code paths
    		// All callouts should be complete at this point in time. We can start doing DML operations
    		invoice.Id = invoices[0].Id;
    		invoiceLineItems =  Database.query(QKXERO_Utils.generateSoqlLineItems(invoice.Id));

			
    		/*if(invoices.size() > 0){
    			
    		}else{
    			// TODO: Probably move this to the top of the function before running anything else....
    			List<Account> account = [SELECT Id, Name, Xero_Id__c FROM Account WHERE Xero_Id__c = :xInvoice.Contact.ContactId];
    			if(account.size() > 0){
					invoice.Account__c = account[0].Id;
    			}else{
    				// Early terminate before commiting anything. 
    				return;
    			}
    			
    		}*/

    		upsert invoice Xero_Id__c;

    		// TODO: Remove this lookup step. 
    		Invoice__c tempInvoice = [SELECT Id, Name FROM Invoice__c WHERE Id = :invoice.Id LIMIT 1];

			System.debug(invoiceLineItems);
    		invoiceLineItems = QKXERO_Invoice.mergeLineItems(xInvoice, invoiceLineItems);
    		for(Invoice_Line_Item__c invoiceLineItem : invoiceLineItems){
    			invoiceLineItem.Invoice__c = invoice.Id;
    		}
    		upsert invoiceLineItems;
    		System.debug(invoiceLineItems);


    		/*
    		//Attachments are doing something weird, disabling for now
    		// This is a poor mans approach anyway. We should match and update instead of delete and replace.

    		List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :invoice.Id AND (Name = :xInvoice.InvoiceNumber+'.pdf' OR Name = :invoice.Name+'.pdf' OR Name = 'null.pdf')];
			if(attachments.size() > 0){
				delete attachments;
			}
				
    		Attachment attachmentPDF = new Attachment();
			attachmentPdf.parentId = invoice.Id;
			attachmentPdf.name = tempInvoice.Name + '.pdf';
			attachmentPdf.body = pdf; 
			insert attachmentPDF;*/


    	}
    }

    public void finish(Database.BatchableContext info) {}
	
}