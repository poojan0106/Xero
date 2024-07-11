public class XeroAccount {
    
    public String AccountID;
	public String Name;
	public String Type;
	public String TaxType;
	public String Description;
	public boolean EnablePaymentsToAccount;
	public boolean ShowInExpenseClaims;
	public String Code;
    
    public XeroAccount(Integer accountCode, String accountID)
    {
        this.Code = String.valueOf(accountCode);
        this.AccountID = accountID;
    }
    
    /*public XeroAccount(Integer accountCode)
    {
        this.Code = String.valueOf(accountCode);
    }*/
     public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        return serialized;
    }
}