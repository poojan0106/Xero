public with sharing class QKXERO_A_GetXeroPdfInvoice {

	@InvocableMethod(label='Get PDF Invoice from Xero' description='')
	public static void getXeroPdfInvoice (List<Id> invoiceIds) {
		// TODO: Make this bulk friendly
		for(Id invoiceId : invoiceIds){
			futureGetXeroPdfInvoice(invoiceId);
		}
	}


	@Future(callout=true)
	static void futureGetXeroPdfInvoice (Id invoiceId) {
		Invoice__c origInvoice = [SELECT Id, Invoice_Number__c, Name FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];
		QKXERO_Buttons.getPdf(origInvoice.Id, origInvoice.Invoice_Number__c, origInvoice.Name);
	}
}