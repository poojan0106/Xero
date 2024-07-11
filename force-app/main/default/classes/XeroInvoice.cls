public class XeroInvoice {
    
    public String Type;	//ACCREC
    public String InvoiceID;	//94b8a8d6-31fd-4d8c-8791-d1a2a7dfe898
    public String InvoiceNumber;	//INV-001 
    public String Reference;	//ABC123
    public XeroContact Contact;
    public String Date_x;	//2019-08-20T00:00:00
    public String DueDate;	//2019-08-20T00:00:00
    public String DueDateString;
    public String BrandingThemeID;

    public Boolean SentToContact;
    public Decimal AmountDue;	//115
    public Decimal AmountPaid;	//0
    public Decimal AmountCredited;	//0
    public Decimal CurrencyRate;	//1
    public Boolean IsDiscounted;
    public Boolean HasAttachments;
    public Boolean HasErrors;
    
    public String Status;	//AUTHORISED
    public String LineAmountTypes;	//Exclusive
    public Decimal SubTotal;	//100
    public Decimal TotalTax;	//15
    public Decimal Total;	//115
    public String UpdatedDateUTC;	///Date(1566260876040+0000)/
    public String CurrencyCode;	//NZD
    public String Url;
    
    public List<LineItem> LineItems;
    public List<Payment> Payments;
    public List<CreditNote> CreditNotes;
    public List<PrePayment> Prepayments;
    public List<OverPayment> Overpayments;

    public List<XeroValidationError> ValidationErrors;

    public class Payment {}

    public class CreditNote {}

    public class PrePayment {}

    public class OverPayment {}

    public class LineItem {

        public String LineItemID;	//006fc261-ee0b-4f4c-bb55-c96ca97cdb53
        public String Description;	//Some Stufff
        public String AccountCode;	//200
        public Decimal LineAmount;	//100
        public String TaxType;	//OUTPUT2
        public Decimal TaxAmount;	//15
        public Decimal UnitAmount;	//100
        public Decimal Quantity;	//1
        public Decimal DiscountRate;
        public List<TrackingCategory> Tracking;
        public List<XeroValidationError> ValidationErrors;
    }

    public class TrackingCategory {

        public String Name;
        public String Option;
        
        public TrackingCategory(String name, String option) {
            this.Name = name;
            this.Option = option;
        }
    }
    /*
    public XeroInvoice(String xeroContactId) {

        // Pass in default values here
        this.Type = 'ACCREC';

        // Set the parent account
        this.Contact = new XeroContact(xeroContactId);
    }
    */
    
    public XeroInvoice(String xeroInvoicId)
    {
        this.InvoiceID  = xeroInvoicId; 
    }
   
    public XeroInvoice(String invoiceNumber,Workorder workOrder, Account account, String xeroContactId, List<WorkOrderLineItem> lst_wOLineItem, String accForReferenceFieldUpdate,boolean completed_internally)
    {
        
        // get next create invoice number
        /*if(!Test.isRunningTest())
        {
            Invoice__c inv_for_number = [select name from Invoice__c order by CreatedDate DESC limit 1 ALL ROWS];
            if(String.isNotBlank(inv_for_number.name))
            {
                String[] formatNumber = inv_for_number.name.split('-');
                integer autoNumber = integer.valueOf(formatNumber[1]) + 1 ;
                String invoiceFormateCreted = formatNumber[0] + '-' + autoNumber;
                this.InvoiceNumber = String.valueOf(invoiceFormateCreted);
            }
        }*/
        
        if(String.isNotBlank(invoiceNumber))
        {
            this.InvoiceNumber = invoiceNumber;
        }
        
        Date invoiceDate;
        if((workOrder.completed_internally__c == true || completed_internally)&&  workOrder.Invoice_date__c != null)
        {
            
            invoiceDate = workOrder.Invoice_date__c;
            Date_x = String.valueOf(invoiceDate);
        }
        else
        {
            invoiceDate = Date.Today();
        }
        
        this.DueDate = String.valueOf(invoiceDate.addDays(integer.valueOf(account.Payment_Term__c)));
        
        //create reference formate 
        String referenceFormate = '';
        if(workOrder.account.name != null && String.isNotBlank(workOrder.account.name))
        {
            referenceFormate = referenceFormate + '' +workOrder.account.name;
        }
        // this account is workOrder account if parent account is exist on workorder account then it is parent account other normal account
        if(String.isNotBlank(account.Billing_Contact__r.Email))
        {
            this.SentToContact = true;
        }
        
        
        if(accForReferenceFieldUpdate!= '')
        {            
            referenceFormate = referenceFormate + ' - ' + accForReferenceFieldUpdate;
        }
        
        if(String.isNotBlank(referenceFormate))
        {
            this.Reference = referenceFormate;
        }
        
        
        //invoice Type 
        this.Type = 'ACCREC'; 
        
        if(workOrder.Collect_Payment__c != Null && workOrder.Collect_Payment__c == 'Yes')
        {
            //this.Status = 'PAID'; directly can't create paid invoice
            this.Status = 'AUTHORISED';
        }
        else
        {
           this.Status = 'AUTHORISED'; 
        }
        

        this.LineAmountTypes = 'Inclusive';
        
        this.Contact  = new XeroContact(xeroContactId);
        
        //Line Item List
        list<LineItem> lineItemList = new list<LineItem>();  
        
        if(lst_wOLineItem != null && lst_wOLineItem.size() > 0)
        {
            
            for(WorkOrderLineItem wOLineItem : lst_wOLineItem)
            {
                //if(wOLineItem.Status == 'Completed' && wOLineItem.Invoiced__c == False)
                {
                    LineItem lineItemObj = new LineItem();
                    lineItemObj.Description = wOLineItem.Product2.Name;
                    lineItemObj.UnitAmount = wOLineItem.UnitPrice;
                    lineItemObj.Quantity = wOLineItem.Quantity;
                    lineItemObj.DiscountRate = wOLineItem.Discount;
                    lineItemObj.AccountCode = '200';
                    lineItemObj.Taxtype = 'OUTPUT';
                    lineItemList.add(lineItemObj);
                }
                
            }
            //if Final_Service_Note__c is available
            if(String.isNotBlank(workOrder.Final_Service_Note__c))
            {
                LineItem lineItemObj = new LineItem();
                lineItemObj.Description = workOrder.Final_Service_Note__c;
                /*lineItemObj.UnitAmount = null;
                lineItemObj.Quantity = null;
                lineItemObj.AccountCode = '200';
                lineItemObj.Taxtype = 'OUTPUT';*/
                lineItemList.add(lineItemObj);
            }
        }
        
        
        this.LineItems = lineItemList; //assign list
        
    }
   

    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        // Replace the _x with the correct format
        serialized = serialized.replace('"Date_x"', '"Date"');

        return serialized;
    }
}