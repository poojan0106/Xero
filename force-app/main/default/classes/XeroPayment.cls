public class XeroPayment {
    
	public XeroInvoice Invoice;
	public XeroAccount Account;
	public String Date_x;
	public Decimal Amount;
    public String Reference;
    public List<XeroValidationError> ValidationErrors;
    
    
    public XeroPayment(String xeroInvoiceId, Integer xeroAccountCode, Decimal amount, String referenceFormate)
    {
        this.Invoice = new XeroInvoice(xeroInvoiceId);
        this.Account = new XeroAccount(xeroAccountCode,'F2BAE356-2EB8-403D-801A-8B9732A61CC6');
        this.Date_x = String.valueOf(Date.Today());
        this.Reference = referenceFormate;
        this.Amount = amount;
    }
    
    
    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);
        
        // Replace the _x with the correct format
        serialized = serialized.replace('"Date_x"', '"Date"');
        
        return serialized;
    }
}