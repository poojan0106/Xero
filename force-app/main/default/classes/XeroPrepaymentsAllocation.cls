public class XeroPrepaymentsAllocation { 
  
    public String Amount;
    public String Date_x;
    //id populate when put call 
    public Prepayment prepayment;
    public XeroInvoice Invoice;
    public Decimal RemainingCredit;//not get in request call
    public List<XeroValidationError> ValidationErrors;
    
    //For put Api
    public XeroPrepaymentsAllocation(String amount_p,String invoiceId_p)
    {         
        this.Invoice = new XeroInvoice(invoiceId_p); 
        this.Amount = amount_p;
    }
    
    public class Allocation { 
        public String AppliedAmount;
        public String Date_x;
        public XeroInvoice Invoice;
    }
    
    public class Prepayment{
        public String prepaymentID;
    }
    
    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);
        serialized = serialized.replace('"Date_x"', '"Date"');
        return serialized;
    }
    
}