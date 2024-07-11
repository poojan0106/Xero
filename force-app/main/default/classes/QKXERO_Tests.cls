@isTest
private class QKXERO_Tests {
	
	@isTest 
	static void automation_send_xero_invoice_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroInvoiceSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		Invoice__c invoice = invoiceFactory(account.Id);
		insert invoice;

		insert invoiceLineItemFactory(invoice.Id, 5, 50);
		insert invoiceLineItemFactory(invoice.Id, 1, 163.00);// This matches one of the line items on the returned Invoice
		insert invoiceLineItemFactory(invoice.Id, 9, 2000.45);


		QKXERO_A_SendXeroInvoice.Params param = new QKXERO_A_SendXeroInvoice.Params();
		param.invoiceId = invoice.Id;

		Test.startTest();
			QKXERO_A_SendXeroInvoice.sendInvoiceToXero(new List<QKXERO_A_SendXeroInvoice.Params>{param});
		Test.stopTest();

		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroPdfSuccess());

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void query_xero_invoice_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroInvoiceSuccess());

		setXeroSettings();


		Test.startTest();
			List<QKXERO_Invoice> invoices = QKXERO_Invoice.query('', Datetime.now(),1);
			invoices = QKXERO_Invoice.query('', Datetime.now());
			invoices = QKXERO_Invoice.query('');
			QKXERO_Invoice.getById('1234');
		Test.stopTest();

		QKXERO_Invoice invoice = invoices[0];
		invoice.Contact.Addresses[0].AddressType = '';
		invoice.Contact.Addresses[0].City = '';
		invoice.Contact.Addresses[0].Region = '';
		invoice.Contact.Addresses[0].PostalCode = '';
		invoice.Contact.Addresses[0].Country = '';
		invoice.Contact.Addresses[0].AttentionTo = '';

		invoice.Contact.Phones[0].PhoneType = '';
		invoice.Contact.Phones[0].PhoneNumber = '';
		invoice.Contact.Phones[0].PhoneAreaCode = '';
		invoice.Contact.Phones[0].PhoneCountryCode = '';


		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroPdfSuccess());

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void get_xero_invoice_pdf_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroPdfSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		Invoice__c invoice = invoiceFactory(account.Id);
		invoice.Xero_Id__c = '4567';
		insert invoice;

		insert invoiceLineItemFactory(invoice.Id, 5, 50);
		insert invoiceLineItemFactory(invoice.Id, 1, 20);
		insert invoiceLineItemFactory(invoice.Id, 9, 2000.45);

		Test.startTest();
			QKXERO_Buttons.getPdf(invoice.Id, 'Test', 'INV-0000');
		Test.stopTest();

		

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void automation_get_xero_contact_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		QKXERO_A_FindCreateContact.Params param = new QKXERO_A_FindCreateContact.Params();
		param.accountId = account.Id;
		param.lookupName = 'Test';

		Test.startTest();
			QKXERO_A_FindCreateContact.findOrCreateXeroContact(new List<QKXERO_A_FindCreateContact.Params>{param});
			//QKXERO_A_SendXeroInvoice.sendInvoiceToXero(new List<Id>{invoice.Id});
		Test.stopTest();

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void automation_get_xero_pdf_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroPdfSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		Invoice__c invoice = invoiceFactory(account.Id);
		invoice.Xero_Id__c = '4567';
		insert invoice;

		insert invoiceLineItemFactory(invoice.Id, 5, 50);
		insert invoiceLineItemFactory(invoice.Id, 1, 20);
		insert invoiceLineItemFactory(invoice.Id, 9, 2000.45);


		Test.startTest();
			QKXERO_A_GetXeroPdfInvoice.getXeroPdfInvoice(new List<Id>{invoice.Id});
			//QKXERO_A_SendXeroInvoice.sendInvoiceToXero(new List<Id>{invoice.Id});
		Test.stopTest();

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void query_xero_contact_normal() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());

		setXeroSettings();


		Test.startTest();
			List<QKXERO_Contact> contacts = QKXERO_Contact.query('', Datetime.now(),1);
			contacts = QKXERO_Contact.query('', Datetime.now());
			contacts = QKXERO_Contact.query('');
			QKXERO_Contact.getById('1234');

			// TODO: Remove
			contacts[0].HasValidationErrors = true;
			QKXERO_Contact.saveXero(contacts[0]);
		Test.stopTest();

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void http_verbs() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());

		setXeroSettings();


		Test.startTest();
			QKXERO_Auth auth = QKXERO_Auth.getInstance();
			String endpoint = '/';
			String xeroId = '1234';
			Map<String, String> headersAndParameters = new Map<String, String>();
			String body = '';

			QKXERO_Request.httpDelete(auth, endpoint);
			QKXERO_Request.httpDelete(auth, endpoint, xeroId);
			QKXERO_Request.httpGet(auth, endpoint);
			QKXERO_Request.httpGet(auth, endpoint, headersAndParameters);
			QKXERO_Request.httpGet(auth, endpoint, headersAndParameters, headersAndParameters);
			QKXERO_Request.httpGetBlob(auth, endpoint, headersAndParameters);
			QKXERO_Request.httpPost(auth, endpoint, body);
			QKXERO_Request.httpPut(auth, endpoint, body);
			


		Test.stopTest();

		// TODO: Add asserts. 
		// TODO: Add additional mocks

	}

	@isTest 
	static void invoice_schedule() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroInvoiceSuccess());

		setXeroSettings();


		Test.startTest();
			QKXERO_S_Invoices scheduleInvoice = new QKXERO_S_Invoices();
			System.schedule('Xero invoice', '0 0 23 * * ?', scheduleInvoice);			
		Test.stopTest();

		// TODO: Add asserts.

	}

	@isTest 
	static void invoice_batch_no_merge() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroInvoiceSuccess());

		setXeroSettings();


		Test.startTest();
			QKXERO_B_Invoice invoiceBatch = new QKXERO_B_Invoice();
			invoiceBatch.recentlyChangedInvoices = QKXERO_Invoice.query(null, Datetime.now().addDays(-2));
			database.executebatch(invoiceBatch, 1);	
		Test.stopTest();

		// TODO: Add asserts.

	}

	@isTest 
	static void invoice_batch_merge() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroInvoiceSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		Invoice__c invoice = invoiceFactory(account.Id);
		invoice.Xero_Id__c = 'cc2f7c1c-2c8a-431a-9617-3524abe9cedd';
		insert invoice;

		invoice = [SELECT Id, Name, Xero_Id__c FROM Invoice__c LIMIT 1];
		Attachment attachmentPDF = new Attachment();
		attachmentPdf.parentId = invoice.Id;
		attachmentPdf.name = invoice.Name + '.pdf';
		attachmentPdf.body = Blob.valueOf('Bloby');
		insert attachmentPDF;

		insert invoiceLineItemFactory(invoice.Id, 5, 50);
		insert invoiceLineItemFactory(invoice.Id, 1, 20);
		insert invoiceLineItemFactory(invoice.Id, 9, 2000.45);



		Test.startTest();
			QKXERO_B_Invoice invoiceBatch = new QKXERO_B_Invoice();
			invoiceBatch.recentlyChangedInvoices = QKXERO_Invoice.query(null, Datetime.now().addDays(-2));
			database.executebatch(invoiceBatch, 1);	
		Test.stopTest();

		// TODO: Add asserts.

	}

	@isTest 
	static void automation_send_invoice_email() {
		// Implement Mock
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroPdfSuccess());

		setXeroSettings();
		Account account = accountFactory();
		account.Xero_Id__c = '1234';
		insert account;

		Invoice__c invoice = invoiceFactory(account.Id);
		invoice.Xero_Id__c = 'cc2f7c1c-2c8a-431a-9617-3524abe9cedd';
		insert invoice;

		invoice = [SELECT Id, Name, Xero_Id__c FROM Invoice__c LIMIT 1];
		Attachment attachmentPDF = new Attachment();
		attachmentPdf.parentId = invoice.Id;
		attachmentPdf.name = invoice.Name + '.pdf';
		attachmentPdf.body = Blob.valueOf('Bloby');
		insert attachmentPDF;

		Contact contact = new Contact(
			FirstName = 'Test',
			LastName = 'Super Test',
			Email = 'example@example.com'
		);
		insert contact;



		insert invoiceLineItemFactory(invoice.Id, 5, 50);
		insert invoiceLineItemFactory(invoice.Id, 1, 20);
		insert invoiceLineItemFactory(invoice.Id, 9, 2000.45);

		QKXERO_A_SendInvoiceEmail.Params params = new QKXERO_A_SendInvoiceEmail.Params();
		params.invoiceId = invoice.Id;
		params.contactId = contact.Id;
        params.email = null;
		

		Test.startTest();
			QKXERO_A_SendInvoiceEmail.sendInvoiceEmail(new List<QKXERO_A_SendInvoiceEmail.Params>{params});
			//params.email = 'example2@example.com';
			//QKXERO_A_SendInvoiceEmail.sendInvoiceEmail(new List<QKXERO_A_SendInvoiceEmail.Params>{params});
		Test.stopTest();

		// TODO: Add asserts.

	}


	static Account accountFactory(){
		return new Account(
			Name = 'Test'
		);
	}

	static Invoice__c invoiceFactory(Id accountId){
		return new Invoice__c(
			Account__c = accountId
		);
	}

	static Invoice_Line_Item__c invoiceLineItemFactory(Id invoiceId, Integer qty, Decimal amount){
		return new Invoice_Line_Item__c(
			Invoice__c = invoiceId,
			Quantity__c = qty,
			Unit_Price__c = amount
		);
	}

	static void setXeroSettings(){
		QKXERO_Private_App__c settings = new QKXERO_Private_App__c(
			Consumer_Key__c = '1234',
			Private_Key_ID__c = 'Xero'
		);
		insert settings;
	}
	
}