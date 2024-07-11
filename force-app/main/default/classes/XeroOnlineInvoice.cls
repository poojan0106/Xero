public class XeroOnlineInvoice {

	
	public String OnlineInvoiceUrl;
	

    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        return serialized;
    }
}