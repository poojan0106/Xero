@isTest
private class TestInvoiceSplitTrigger {
    
    // Utility method to create a test Account record
    private static Account createTestAccount() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        return testAccount;
    }
    
    // Adjusted utility method to create a test Invoice__c record with an associated Account
    private static Invoice__c createTestInvoice() {
        // First, create a test Account record
        Account testAccount = createTestAccount();
        
        // Then, create the Invoice__c record linked to the created Account
        Invoice__c invoice = new Invoice__c(
            Account__c = testAccount.Id
            // Populate other required fields for Invoice__c here
        );
        insert invoice;
        return invoice;
    }
    
    // Utility method to create a test Invoice_Split__c record
    private static Invoice_Split__c createTestInvoiceSplit(Invoice__c relatedInvoice, Decimal percentage, User teamMember) {
        Invoice_Split__c invoiceSplit = new Invoice_Split__c(
            Invoice__c = relatedInvoice.Id,
            SplitPercentage__c = percentage,
            SplitMember__c = teamMember.Id
        );
        return invoiceSplit;
    }
    
    @isTest static void testAfterInsert() {
        Invoice__c testInvoice = createTestInvoice();
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1]; // Example way to get a test user
        
        // Setup - Create a test Invoice_Split__c record with a specific percent and related account
        Invoice_Split__c testInvoiceSplit = createTestInvoiceSplit(testInvoice, 0.00, testUser);
        
        Test.startTest();
        // Insert the Invoice_Split__c record to fire the after insert trigger
        insert testInvoiceSplit;
        Test.stopTest();
    }
    
    @isTest static void testAfterUpdate() {
    Invoice__c testInvoice = createTestInvoice();
    User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
    Invoice_Split__c testInvoiceSplit = createTestInvoiceSplit(testInvoice, 0.00, testUser);
    insert testInvoiceSplit;

    // Prepare the update - modify fields as needed
    testInvoiceSplit.SplitPercentage__c = -5.00; // Example update

    Test.startTest();
    // Update the Invoice_Split__c record to fire the after update trigger
    update testInvoiceSplit;
    Test.stopTest();

}

    
    
    
     
    @isTest static void testAfterDelete() {
    	Invoice__c testInvoice = createTestInvoice();
    	User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
    	Invoice_Split__c testInvoiceSplit = createTestInvoiceSplit(testInvoice, 0.00, testUser);
    	insert testInvoiceSplit;

    	Test.startTest();
    	// Delete the Invoice_Split__c record to fire the after delete trigger
    	delete testInvoiceSplit;
    	Test.stopTest();
        


   
        // Assertions
        // Here, you will need to assert the expected outcomes based on your trigger's logic.
        // For example, verify that the SplitAmount__c field has been calculated correctly, or that related records have been updated/created.
    }
}