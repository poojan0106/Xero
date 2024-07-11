public with sharing class QKXERO_A_SendXeroInvoice {

	@InvocableMethod(label='Send Invoice To Xero' description='')
	public static void sendInvoiceToXero (List<Params> params) {
		// TODO: Make this bulk friendly
		for(Params param : params){
			if(param.future){
				futureSendInvoiceToXero(param.invoiceId);
			}else{
				QKXERO_Buttons.sendInvoice(param.invoiceId);
			}
			
		}
	}


	@Future(callout=true)
	static void futureSendInvoiceToXero (Id invoiceId) {
		QKXERO_Buttons.sendInvoice(invoiceId);
	}

	public class Params {
		@InvocableVariable(required=true)
		public Id invoiceId;

		@InvocableVariable(required=true)
		public Boolean future = true;
	}
}