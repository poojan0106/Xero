global class QKXERO_Buttons {
	webservice static Boolean sendInvoice(Id invoiceId){
		try{
			Invoice__c origInvoice = [SELECT Id, Invoice_Number__c, Name FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];
			List<Invoice_Line_Item__c> origLineItems = Database.query(QKXERO_Utils.generateSoqlLineItems(invoiceId));
			

			QKXERO_Invoice xInvoice = QKXERO_Invoice.writeInvoice(invoiceId);

			if(xInvoice == null || xInvoice.HasErrors){
				return false;
			}
			Invoice__c invoice = QKXERO_Invoice.convertInvoiceToSobject(xInvoice);
			invoice.Id = invoiceId;

			List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();
			Invoice_Line_Item__c tempInvoiceLineItem;
			invoiceLineItems = QKXERO_Invoice.mergeLineItems(xInvoice, origLineItems);
			for(Invoice_Line_Item__c invoiceLineItem : invoiceLineItems){
				invoiceLineItem.Invoice__c = invoiceId;
			}

			update invoice;
			//delete origLineItems;
			upsert invoiceLineItems;
			//QKXERO_Buttons.getPdf(invoiceId, origInvoice.Invoice_Number__c, origInvoice.Name);
		}catch(Exception e){
			System.debug(e);
			System.debug(e.getStackTraceString());
			return false;
		}
		
		return true;
	}

	webservice static Boolean getPdf(Id invoiceId, String invoiceNumber, String invoiceName){
		List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :invoiceId AND (Name = :invoiceNumber+'.pdf' OR Name = :invoiceName+'.pdf')];
		QKXERO_Invoice.commitPdf(invoiceId);
		if(attachments.size() > 0){
			delete attachments;
		}
		return true;
	}
}