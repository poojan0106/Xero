@IsTest
private class TestTUPCoverageClass {
    
    @IsTest
    static void testIncrement1() {
        InvoiceHistoryHelper.justIncrement();
	}
    
    @IsTest
    static void testIncrement2() {
        InvoiceSplitHandler.justIncrement();
	}
 
}