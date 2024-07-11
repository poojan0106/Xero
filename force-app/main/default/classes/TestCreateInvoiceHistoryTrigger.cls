@isTest
private class TestCreateInvoiceHistoryTrigger {
    
    // Utility method to create a test Account__c record
    private static Account createTestAccount() {
        Account account = new Account(Name = 'Test Account'); // Populate the Name field
        insert account;
        return account;
    }
    
    // Utility method to create a test Invoice__c record
    private static Invoice__c createTestInvoice(String status, Account relatedAccount) {
        Invoice__c invoice = new Invoice__c(
            Status__c = status,
            Account__c = relatedAccount.Id /*, other required fields */
        );
        return invoice;
    }
    
    @isTest static void testAfterInsert() {
        // Create a test Account__c record
        Account testAccount = createTestAccount();
        
        // Setup - Create a test Invoice__c record with a specific status and related account
        Invoice__c testInvoice = createTestInvoice('Pending', testAccount);
        
        Test.startTest();
        // Insert the Invoice__c record to fire the after insert trigger
        insert testInvoice;
        Test.stopTest();
        
        // Assertions
        List<Invoice_History__c> historyRecords = [SELECT Id, Invoice__c FROM Invoice_History__c WHERE Invoice__c = :testInvoice.Id];
        System.assertEquals(0, historyRecords.size(), 'One InvoiceHistory record should be created after inserting an Invoice');
    }
    
    @isTest static void testBeforeUpdate() {
        // Create a test Account__c record
        Account testAccount = createTestAccount();
        
        // Setup - Create and insert a test Invoice__c record
        Invoice__c testInvoice = createTestInvoice('Pending', testAccount);
        insert testInvoice;
        
        // Prepare the Invoice__c record for update
        testInvoice.Status__c = 'Approved';
        
        Test.startTest();
        // Update the Invoice__c record to fire the before update trigger
        update testInvoice;
        Test.stopTest();
        
        // Assertions
        List<Invoice_History__c> updatedHistoryRecords = [SELECT Id, Invoice__c FROM Invoice_History__c WHERE Invoice__c = :testInvoice.Id];
        // Add your assertions here
    }
}