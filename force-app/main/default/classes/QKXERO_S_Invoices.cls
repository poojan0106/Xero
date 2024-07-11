global class QKXERO_S_Invoices implements Schedulable {
	global void execute(SchedulableContext sc) {
		QKXERO_B_Invoice invoiceBatch = new QKXERO_B_Invoice();
		//invoiceBatch.recentlyChangedInvoices = QKXERO_Invoice.query(null, Datetime.now().addDays(-2));
		database.executebatch(invoiceBatch, 1);
	}
}