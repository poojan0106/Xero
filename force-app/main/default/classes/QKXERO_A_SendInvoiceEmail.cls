public with sharing class QKXERO_A_SendInvoiceEmail {
		@InvocableMethod(label='Get PDF Invoice from Xero' description='')
	public static void sendInvoiceEmail (List<Params> inputParams) {
		// TODO: Make this bulk friendly(er)
		for(Params inputParam : inputParams){
			futureSendInvoiceEmail(inputParam.invoiceId, inputParam.contactId, inputParam.email);
		}
	}


	@Future(callout=true)
	static void futureSendInvoiceEmail (Id invoiceId, Id contactId, String email) {
			
		// Get all the objects we will need. 
		Invoice__c origInvoice = [SELECT Id, Invoice_Number__c, Name, Xero_Id__c FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];
		List<EmailTemplate> emailTemplates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Xero_Invoice_Template' AND IsActive = TRUE LIMIT 1];
		Contact contact = [SELECT Id, Name, Email FROM Contact WHERE Id = :contactId LIMIT 1];

		// Create a new PDF. This does a callout
		Blob pdf = QKXERO_Invoice.getPdf(origInvoice.Xero_Id__c);
		QKXERO_Buttons.getPdf(invoiceId, origInvoice.Invoice_Number__c, origInvoice.Name);
		List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :invoiceId AND (Name = :origInvoice.Name+'.pdf' OR Name = :origInvoice.Invoice_Number__c+'.pdf') LIMIT 1];


		if(contact.Email ==  null){
			return;
		}

		if(emailTemplates.size() == 0){
			return;
		}


		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		if(email != null){
			mail.setToAddresses(new List<String>{email});
			mail.setTreatTargetObjectAsRecipient(false);
		}
		
		// Template
		mail.setTemplateId(emailTemplates[0].Id);

		// Attachments, convert the list of objects to a list of Ids using Map. This is signigantly faster than using a loop.
		mail.setEntityAttachments(new List<Id>(new Map<Id, Attachment>(attachments).keySet()));

		// Set the Invoice and Contact as being the primary objects
		mail.setWhatId(invoiceId);
		mail.setTargetObjectId(contactId);

		// Send the email
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

		
	}

	public class Params {
		@InvocableVariable(required=true label='Invoice ID')
		public Id invoiceId;

		@InvocableVariable(required=true label='Contact ID')
		public Id contactId;

		@InvocableVariable(required=false label='Email Address')
		public String email;
	}
}