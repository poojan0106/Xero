public class XeroPrepayment { 

	public XeroContact Contact;
	public String Date_x;
	public String Status;
	public String LineAmountTypes;
	public List<LineItem> LineItems;
	public Decimal SubTotal;
	public Decimal TotalTax;
	public Decimal Total;
	public String CurrencyCode;
	public Decimal CurrencyRate;
	public String Type;
	public String Reference;
	public Decimal RemainingCredit;
	public boolean HasAttachments;
	public String PrepaymentID;

	public XeroPrepayment(String PrepaymentIDFromSf)
	{
		this.PrepaymentID = PrepaymentIDFromSf;
	} 
    
    public XeroPrepayment()
    {
        
    } 

	public class LineItem { 

		public String Description;
		public double UnitAmount;
		public String TaxType;
		public double TaxAmount;
		public double LineAmount;
		public integer AccountCode;
		public double Quantity;
		public boolean DiscountEnteredAsPercent;
	}
    
     public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        // Replace the _x with the correct format
        serialized = serialized.replace('"Date_x"', '"Date"');

        return serialized;
    }
}