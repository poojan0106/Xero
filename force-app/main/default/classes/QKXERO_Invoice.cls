public with sharing class QKXERO_Invoice implements QKXERO_Object {
	private static String baseEndpoint = 'Invoice';

	// Public dataset
	public String Type {get;set;} 
	public String InvoiceID {get;set;} 
	public String InvoiceNumber {get;set;} 
	public String Reference {get;set;} 
	public List<Payment> Payments {get;set;} 
	public List<CreditNote> CreditNotes {get;set;} 
	public List<Prepayment> Prepayments {get;set;} 
	public List<Overpayment> Overpayments {get;set;} 
	public Double AmountDue {get;set;} 
	public Double AmountPaid {get;set;} 
	public Double AmountCredited {get;set;} 
	public Double CurrencyRate {get;set;} 
	public Boolean HasErrors {get;set;} 
	public Boolean IsDiscounted {get;set;} 
	public Boolean HasAttachments {get;set;} 
	public QKXERO_Contact Contact {get;set;} 
	public Datetime Date_d {get;set;} 
	public Datetime DueDate_d {get;set;} 
	public String Status {get;set;} 
	public String LineAmountTypes {get;set;} 
	public List<LineItem> LineItems {get;set;} 
	public Double SubTotal {get;set;} 
	public Double TotalTax {get;set;} 
	public Double Total {get;set;} 
	public Datetime UpdatedDateUTC {get;set;} 
	public String CurrencyCode {get;set;} 
	public Datetime FullyPaidOnDate_d {get;set;} 

	// Include warnings from update/create?

	public class Payment {
		public String PaymentID {get;set;} 
		//public String XDate {get;set;} 
		public Double Amount {get;set;} 
		public Double CurrencyRate {get;set;} 
		public Boolean HasAccount {get;set;} 
		public Boolean HasValidationErrors {get;set;} 
	}

	public class CreditNote {
					/*
		<CreditNotes>
		  <CreditNote>
		    <Contact>
		      <ContactID>c6c7b870-bb4d-489a-921e-2f0ee4192ff9</ContactID>
		      <Name>Test Apply Credit Note</Name>
		    </Contact>
		    <Date>2012-08-30T00:00:00</Date>
		    <Status>PAID</Status>
		    <LineAmountTypes>Inclusive</LineAmountTypes>
		    <SubTotal>86.96</SubTotal>
		    <TotalTax>13.04</TotalTax>
		    <Total>100.00</Total>
		    <UpdatedDateUTC>2012-08-29T23:43:01.097</UpdatedDateUTC>
		    <CurrencyCode>NZD</CurrencyCode>
		    <FullyPaidOnDate>2012-08-30T00:00:00</FullyPaidOnDate>
		    <Type>ACCRECCREDIT</Type>
		    <CreditNoteID>aea95d78-ea48-456b-9b08-6bc012600072</CreditNoteID>
		    <CreditNoteNumber>CN-0002</CreditNoteNumber>
		    <CurrencyRate>1.000000</CurrencyRate>
		    <RemainingCredit>0.00</RemainingCredit>
		    <Allocations>
		      <Allocation>
		        <AppliedAmount>100.00</AppliedAmount>
		        <Date>2012-08-30T00:00:00</Date>
		        <Invoice>
		          <InvoiceID>87cfa39f-136c-4df9-a70d-bb80d8ddb975</InvoiceID>
		          <InvoiceNumber>INV-0001</InvoiceNumber>
		        </Invoice>
		      </Allocation>
		    </Allocations>
		  </CreditNote>
		</CreditNotes>
					*/
	}

	public class Prepayment {
		/*
		<Prepayments>
		  <Prepayment>
		    <Contact>
		      <ContactID>c6c7b870-bb4d-489a-921e-2f0ee4192ff9</ContactID>
		      <Name>Mr Contact</Name>
		    </Contact>
		    <Date>2012-08-30T00:00:00</Date>
		    <Status>PAID</Status>
		    <LineAmountTypes>Inclusive</LineAmountTypes>
		    <SubTotal>86.96</SubTotal>
		    <TotalTax>13.04</TotalTax>
		    <Total>100.00</Total>
		    <UpdatedDateUTC>2012-08-29T23:43:01.097</UpdatedDateUTC>
		    <CurrencyCode>NZD</CurrencyCode>
		    <FullyPaidOnDate>2012-08-30T00:00:00</FullyPaidOnDate>
		    <Type>RECEIVE-PREPAYMENT</Type>
		    <PrepaymentID>aea95d78-ea48-456b-9b08-6bc012600072</PrepaymentID>
		    <CurrencyRate>1.000000</CurrencyRate>
		    <RemainingCredit>0.00</RemainingCredit>
		    <Allocations>
		      <Allocation>
		        <AppliedAmount>100.00</AppliedAmount>
		        <Date>2012-08-30T00:00:00</Date>
		        <Invoice>
		          <InvoiceID>87cfa39f-136c-4df9-a70d-bb80d8ddb975</InvoiceID>
		          <InvoiceNumber>INV-0001</InvoiceNumber>
		        </Invoice>
		      </Allocation>
		    </Allocations>
		    <HasAttachments>false</HasAttachments>
		  </Prepayment>
		</Prepayments>
		*/
	}

	public class Overpayment{
		/*
		<Overpayments>
		  <Overpayment>
		    <Contact>
		      <ContactID>c6c7b870-bb4d-489a-921e-2f0ee4192ff9</ContactID>
		      <Name>Mr Contact</Name>
		    </Contact>
		    <Date>2015-03-30T00:00:00</Date>
		    <Status>PAID</Status>
		    <LineAmountTypes>Inclusive</LineAmountTypes>
		    <SubTotal>86.96</SubTotal>
		    <TotalTax>13.04</TotalTax>
		    <Total>100.00</Total>
		    <UpdatedDateUTC>2015-03-29T23:43:01.097</UpdatedDateUTC>
		    <CurrencyCode>NZD</CurrencyCode>
		    <Type>RECEIVE-OVERPAYMENT</Type>
		    <OverpaymentID>aea95d78-ea48-456b-9b08-6bc012600072</OverpaymentID>
		    <CurrencyRate>1.000000</CurrencyRate>
		    <RemainingCredit>0.00</RemainingCredit>
		    <Allocations>
		      <Allocation>
		        <AppliedAmount>100.00</AppliedAmount>
		        <Date>2015-03-30T00:00:00</Date>
		        <Invoice>
		          <InvoiceID>87cfa39f-136c-4df9-a70d-bb80d8ddb975</InvoiceID>
		          <InvoiceNumber>INV-0001</InvoiceNumber>
		        </Invoice>
		      </Allocation>
		    </Allocations>
		    <HasAttachments>false</HasAttachments>
		  </Overpayment>
		</Overpayments>
		*/
	}

	public class LineItem {
		public String ItemCode {get;set;} 
		public String Description {get;set;} 
		public Double UnitAmount {get;set;} 
		public String TaxType {get;set;} 
		public Double TaxAmount {get;set;} 
		public Double LineAmount {get;set;} 
		public Double DiscountRate {get;set;}
		public String AccountCode {get;set;} 
		public List<Tracking> Tracking {get;set;} 
		public Double Quantity {get;set;} 
		public String LineItemID {get;set;} 
		public List<Prepayment> ValidationErrors {get;set;} 
	}

	public class Tracking {
		public String Name {get;set;} 
		public String Option {get;set;} 
		public String TrackingCategoryID {get;set;} 
		public String TrackingOptionID {get;set;} 
	}
	
	
// This works fundamentally differently to `query` - this gives you way more info
	public static QKXERO_Invoice getById(String xeroId){
		String result = QKXERO_Request.httpGet(QKXERO_Auth.getInstance(), baseEndpoint+'/'+xeroId);
		List<QKXERO_Invoice> invoices = deserialise(result);
		if(invoices.size() > 0){
			return invoices[0];
		}else{
			throw new QKXERO_Exception('Could not find an Invoice with Id '+xeroId);
		}

	}

	// Get all invoices that match a given where condition and/or modified since. This also has pagination
	public static List<QKXERO_Invoice> query(String whereCondition, Datetime modifiedSince, Integer page){
		Map<String, String> params = new Map<String, String>();
		Map<String, String> headers = new Map<String, String>();
		//{'where'=>whereCondition, 'page'=>String.valueOf(page)}
		if(whereCondition != null){
			params.put('where', whereCondition);
		}

		if(page != null){
			if(page < 1 || page > 100){
				throw new QKXERO_Exception('Pages can only be between 1 and 100');
			}
			params.put('page', String.valueOf(page));
		}

		if(modifiedSince != null){
			// The ModifiedAfter filter is actually an HTTP header: 'If-Modified-Since'. 
			// A UTC timestamp (yyyy-mm-ddThh:mm:ss) . Only invoices created or modified since this timestamp will be returned e.g. 2009-11-12T00:00:00
			headers.put('If-Modified-Since', modifiedSince.formatGMT('yyyy-MM-dd\THH:mm:ss'));
		}



		String result = QKXERO_Request.httpGet(QKXERO_Auth.getInstance(), baseEndpoint, params, headers);
		List<QKXERO_Invoice> invoices = deserialise(result);
		
		// Recursively run until all pages of invoices have been retrieved, this allows n + 1 runs
		if(page != null && page < 100 && invoices.size() >= 100){
			invoices.addAll(query(whereCondition, modifiedSince, page + 1));
		}

		// TODO: Add in a callout count to make sure not to break limits

		//System.debug(result);
		//return null;
		return invoices;
	}

	// Get all invoices that match a given where condition and/or modified since. This does not have pagination
	public static List<QKXERO_Invoice> query(String whereCondition, Datetime modifiedSince){
		return query(whereCondition, modifiedSince, null);
	}

	// Get all invoices that match a given where condition 
	public static List<QKXERO_Invoice> query(String whereCondition){
		return query(whereCondition, null, null);
	}

	// Get all invoices
	public static List<QKXERO_Invoice> query(){
		return query(null, null, null);
	}

	public static QKXERO_Invoice saveXero(QKXERO_Object invoice){
		List<QKXERO_Invoice> result = saveXero(new List<QKXERO_Object>{invoice});
		if(result == null || result.size() == 0){
			return null;
		}else{
			return result[0];
		}
	}

	public static List<QKXERO_Invoice> saveXero(List<QKXERO_Object> invoices){

		String body = '';
		for(QKXERO_Object invoice: invoices){
			body += serialise(invoice);
		} 

		body = '<Invoices>' + body + '</Invoices>';
		String response = QKXERO_Request.httpPost(QKXERO_Auth.getInstance(), baseEndpoint+'?SummarizeErrors=false', body);
		System.debug(response);
		List<QKXERO_Invoice> returnedInvoices = deserialise(response);
		return returnedInvoices;
	}

	public static Blob getPdf(String xeroId){
		// TODO: Add in try/catch
		Map<String, String> headers = new Map<String, String>();
		headers.put('Accept', 'application/pdf');
		return QKXERO_Request.httpGetBlob(QKXERO_Auth.getInstance(), baseEndpoint + '/' + xeroId, headers);
	}

	public static void commitPdf(Id invoiceId){
		Invoice__c invoice = [SELECT Id, Name, Xero_Id__c, Invoice_Number__c FROM Invoice__c WHERE Id = :invoiceId];
		if(invoice.Xero_ID__c != null){
			Blob pdf = getPdf(invoice.Xero_Id__c);
			Attachment attachmentPDF = new Attachment();
			attachmentPdf.parentId = invoice.Id;
			attachmentPdf.name = invoice.Name + '.pdf';
			attachmentPdf.body = pdf;
			insert attachmentPDF;
		}

	}

	public static List<Invoice_Line_Item__c> mergeLineItems(QKXERO_Invoice xInvoice, List<Invoice_Line_Item__c> lineItems){
		List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();
		Invoice_Line_Item__c tempInvoiceLineItem;

		System.debug(xInvoice.LineItems);

		for(QKXERO_Invoice.LineItem xInvoiceLineItem: xInvoice.LineItems){
			tempInvoiceLineItem = null;
			// If all required sections are null / empty, skip adding it in
			if(xInvoiceLineItem.UnitAmount == null && xInvoiceLineItem.Quantity == null && xInvoiceLineItem.Description == null){
				continue;
			}
			for(Invoice_Line_Item__c lineItem : lineItems) {
				System.debug(lineItem);
				System.debug(xInvoiceLineItem);
				if(xInvoiceLineItem.LineItemID == lineItem.Xero_Id__c){
					tempInvoiceLineItem = lineItem;
					break;
				}

				if(xInvoiceLineItem.UnitAmount == lineItem.Unit_Price__c && 
				 xInvoiceLineItem.Quantity == lineItem.Quantity__c &&
				 xInvoiceLineItem.AccountCode == lineItem.Account_Code__c &&
				 //xInvoiceLineItem.Description == lineItem.Description__c &&
				 lineItem.Xero_Id__c == null){
					// This is an approximate match for non linked line items
					tempInvoiceLineItem = lineItem;
					lineItem.Xero_Id__c = xInvoiceLineItem.LineItemID;
					break;
				}
			}
			if(tempInvoiceLineItem == null){
				tempInvoiceLineItem = new Invoice_Line_Item__c();
			}
			invoiceLineItems.add(QKXERO_Invoice.convertInvoiceLineItemToSobject(xInvoiceLineItem, tempInvoiceLineItem));
			/*Invoice_Line_Item__c tempInvoiceLineItem = QKXERO_Invoice.convertInvoiceLineItemToSobject(xInvoiceLineItem);
			tempInvoiceLineItem.Invoice__c = invoiceId;
			invoiceLineItems.add(tempInvoiceLineItem);*/
		}

		return invoiceLineItems;
	}

	public static Invoice__c convertInvoiceToSobject(QKXERO_Invoice xInvoice){
		Invoice__c invoice = new Invoice__c(
			Amount_Paid__c = xInvoice.AmountPaid,
			Due_Date__c = Date.valueOf(xInvoice.DueDate_d),
			Invoice_Date__c = Date.valueOf(xInvoice.Date_d),
			Line_Amount_Type__c = xInvoice.LineAmountTypes,
			Type__c = xInvoice.Type,
			Xero_ID__c = xInvoice.InvoiceID,
			Subtotal__c = xInvoice.SubTotal, 
			Tax__c = xInvoice.TotalTax,
			Total__c = xInvoice.Total,
			Invoice_Number__c = xInvoice.InvoiceNumber,
			//Account__c = xInvoice. // Requires lookup
			Amount_Due__c = xInvoice.AmountDue,
			Status__c = xInvoice.Status
		);
		return invoice; 
	} 

	public static Invoice_Line_Item__c convertInvoiceLineItemToSobject(QKXERO_Invoice.LineItem xLineItem, Invoice_Line_Item__c invoiceLineItem){
		
		invoiceLineItem.Account_Code__c = xLineItem.AccountCode;
		invoiceLineItem.Amount__c = xLineItem.LineAmount;
		//invoiceLineItem.Description__c = xLineItem.Description;
		invoiceLineItem.Discount__c = xLineItem.DiscountRate;
		invoiceLineItem.Quantity__c = xLineItem.Quantity;
		invoiceLineItem.Unit_Price__c = xLineItem.UnitAmount;
		invoiceLineItem.Xero_Id__c = xLineItem.LineItemId;
		return invoiceLineItem; 
		// Must get Product_Reference__c and Invoice__c from this
		//return invoice;
	} 

	public static QKXERO_Invoice writeInvoice(Id invoiceId){
		Invoice__c invoice = [
			SELECT Id, Name, Amount_Paid__c, Due_Date__c, Status__c, 
			  Invoice_Date__c, Line_Amount_Type__c, Type__c, Xero_ID__c, 
			  Subtotal__c, Tax__c, Total__c, Invoice_Number__c, Amount_Due__c, 
			  Account__r.Xero_ID__c, Account__r.Name, Reference__c
			FROM Invoice__c 
			WHERE Id = :invoiceId
			LIMIT 1
		];

		List<Invoice_Line_Item__c> invoiceLineItems = [
			SELECT Id, Name, Account_Code__c, Amount__c, 
			  Discount__c, Quantity__c, Unit_Price__c, Xero_Id__c
			FROM Invoice_Line_Item__c 
			WHERE Invoice__c = :invoiceId
		];

		return commitInvoiceToXero(invoice, invoiceLineItems);
	}

	private static QKXERO_Invoice commitInvoiceToXero(Invoice__c invoice, List<Invoice_Line_Item__c> invoiceLineItems){
		QKXERO_Contact xContact = new QKXERO_Contact();
		xContact.ContactID = invoice.Account__r.Xero_ID__c;
		if(xContact.ContactID == null){
			xContact.Name = invoice.Account__r.Name;
		}
		

		QKXERO_Invoice xInvoice = new QKXERO_Invoice();
		xInvoice.AmountPaid = invoice.Amount_Paid__c;
		xInvoice.DueDate_d = invoice.Due_Date__c;
	    xInvoice.Date_d = invoice.Invoice_Date__c;
		xInvoice.LineAmountTypes = invoice.Line_Amount_Type__c;
		xInvoice.Type = invoice.Type__c == null ? 'ACCREC' : invoice.Type__c;
		xInvoice.Status = invoice.Status__c == null ? 'DRAFT' : invoice.Status__c;
		xInvoice.InvoiceID = invoice.Xero_ID__c;
		xInvoice.Reference = invoice.Reference__c;
		//xInvoice.SubTotal  = invoice.Subtotal__c;
		//xInvoice.TotalTax = invoice.Tax__c;
		//xInvoice.Total = invoice.Total__c;
		xInvoice.InvoiceNumber = invoice.Invoice_Number__c == null ? invoice.Name : invoice.Invoice_Number__c;
		//xInvoice.AmountDue  = invoice.Amount_Due__c;
		xInvoice.Contact = xContact;

		xInvoice.LineItems = new List<LineItem>();
		for(Invoice_Line_Item__c invoiceLineItem : invoiceLineItems){
			LineItem xLineItem = new LineItem();
			xLineItem.AccountCode = invoiceLineItem.Account_Code__c;
			xLineItem.LineAmount = invoiceLineItem.Amount__c;
			//xLineItem.Description = invoiceLineItem.Product_Reference__r.Name; //changed by Ammon Ho at 17/07/2017 6:21PM from xLineItem.Description = invoiceLineItem.Description__c; to xLineItem.Description = invoiceLineItem.Product_Reference__r.Name; 
			//xLineItem.Description = invoiceLineItem.Description__c; 
			xLineItem.DiscountRate = invoiceLineItem.Discount__c;
			xLineItem.Quantity = invoiceLineItem.Quantity__c;
			xLineItem.UnitAmount = invoiceLineItem.Unit_Price__c;
			xLineItem.LineItemID = invoiceLineItem.Xero_Id__c;
			xInvoice.LineItems.add(xLineItem);
		}

		System.debug(xInvoice);

		return saveXero(xInvoice);
	}

	/*public static void readAllXeroContactInvoices(Id accountId){
		Account account = [SELECT Id, Xero_Id__c FROM Account WHERE Id = :accountId LIMIT 1];
		List<QKXERO_Invoice> xeroInvoices = QKXERO_Invoice.query('Contact.ContactID.ToString().Equals("' + account.Xero_Id__c + '")',null, 1);
		commitInvoicesToSalesforce(accountId, xeroInvoices);
	}

	private static void commitInvoicesToSalesforce(Id accountId, List<QKXERO_Invoice> xeroInvoices){
		List<Invoice__c> invoices = new List<Invoice__c>();
		Map<String, List<Invoice_Line_Item__c>> invoiceLineItems = new Map<String, List<Invoice_Line_Item__c>>();
		
		// Create invoices + invoice line items
		for(QKXERO_Invoice xeroInvoice : xeroInvoices){
			Invoice__c invoice = convertInvoiceToSobject(xeroInvoice);
			invoice.Account__c = accountId;
			invoices.add(invoice);

			if(!invoiceLineItems.containsKey(invoice.Xero_Id__c)){
				invoiceLineItems.put(invoice.Xero_Id__c, new List<Invoice_Line_Item__c>());
			}
			List<Invoice_Line_Item__c> localLineItems = invoiceLineItems.get(invoice.Xero_Id__c);

			// Add all the line items into the map via localLineItems
			for(LineItem xeroLineItem : xeroInvoice.LineItems){
				Invoice_Line_Item__c invoiceLineItem = new Invoice_Line_Item__c();
				invoiceLineItem = convertInvoiceLineItemToSobject(xeroLineItem, invoiceLineItem);
				localLineItems.add(invoiceLineItem);
			}
		} 

		System.debug(invoices);
		upsert invoices Xero_Id__c;

		List<Invoice_Line_Item__c> lineItemsToInsert = new List<Invoice_Line_Item__c>();
		for(Invoice__c invoice : invoices){
			for(Invoice_Line_Item__c lineItem : invoiceLineItems.get(invoice.Xero_Id__c)){
				lineItem.Invoice__c = invoice.Id;
				lineItemsToInsert.add(lineItem);
			}
		}

		upsert lineItemsToInsert Xero_Id__c;
	}*/

	public static List<QKXERO_Invoice> deserialise(String jsonResult){
		// Date is a keyword in Apex, we replace it with DateXero to avoid collision 
		//jsonResult = jsonResult.replace('"Date":','"XDate":');

		// We need to "extract" the results from the Xero response. This is a bit hacky, but better than string juggling
		jsonResult = QKXERO_Utils.fixJsonDate(jsonResult);
		//System.debug('JSON Result (after fixing date): '+jsonResult);
		Map<String, Object> jsonUntyped = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
		JSON.serialize(jsonUntyped);
		return (List<QKXERO_Invoice>)JSON.deserialize(JSON.serialize(jsonUntyped.get('Invoices')), List<QKXERO_Invoice>.class);
	}

	public static String serialise(QKXERO_Object xInvoice){
		QKXERO_Invoice invoice = (QKXERO_Invoice) xInvoice;
		if(invoice.LineItems == null || invoice.LineItems.size() == 0){
			invoice.LineItems = null;
		}
		System.debug(invoice);
		String jsonString = JSON.serialize(invoice);
		//System.debug(jsonString);
		// Date is a keyword in Apex, we replaced it with DateXero to avoid collision, this is fixing it back up
		//jsonString = jsonString.replace('"XDate":','"Date":');

		Set<String> skipNodes = new Set<String>{'HasErrors', 'ValidationErrors', 'IsDiscounted', 'HasAttachments', 'HasValidationErrors'};
		return QKXERO_Utils.serialise(jsonString, 'Invoice', skipNodes);
	}

}