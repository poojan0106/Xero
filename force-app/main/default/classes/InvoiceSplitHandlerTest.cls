@IsTest
private class InvoiceSplitHandlerTest {

    @TestSetup
    static void setup() {
        // Create test Invoice
        Invoice__c testInvoice = new Invoice__c(/* set necessary fields */);
        insert testInvoice;

        // Optionally create initial Invoice_Split__c and Invoice_History__c records if needed for update/delete tests
        Invoice_Split__c initialSplit = new Invoice_Split__c(
            Invoice__c = testInvoice.Id,
            SplitMember__c = '2F0050w0000042AxXAAU',
            SplitPercentage__c = 50
        );
        insert initialSplit;

        Invoice_History__c initialHistory = new Invoice_History__c(
            Invoice__c = testInvoice.Id,
            InstalmentRecipient__c = '0050w0000042AxXAAU',
            SplitPercentage__c = 50,
            Type__c = 'Earnings' // Assuming 'Earnings' is a valid Type__c value
        );
        insert initialHistory;
    }
    
    @IsTest
    static void testHandleAfterInsert() {
        List<Invoice_Split__c> newSplits = new List<Invoice_Split__c>{
            new Invoice_Split__c(Invoice__c = [SELECT Id FROM Invoice__c LIMIT 1].Id, SplitMember__c = '0050w0000042AxXAAU', SplitPercentage__c = 30)
        };
        Test.startTest();
        InvoiceSplitHandler.handleAfterInsert(newSplits);
        Test.stopTest();

        List<Invoice_History__c> histories = [SELECT Id FROM Invoice_History__c WHERE InstalmentRecipient__c = '0050w0000042AxXAAU'];
        System.assertEquals(1, histories.size(), 'A new Invoice History record should have been created for the new split.');
    }
    
    @IsTest
    static void testHandleAfterUpdate() {
        Invoice_Split__c existingSplit = [SELECT Id, SplitPercentage__c FROM Invoice_Split__c LIMIT 1];
        Map<Id, Invoice_Split__c> oldSplitMap = new Map<Id, Invoice_Split__c>{existingSplit.Id => existingSplit};
        existingSplit.SplitPercentage__c = 60; // Change the split percentage

        Test.startTest();
        InvoiceSplitHandler.handleAfterUpdate(oldSplitMap, new Map<Id, Invoice_Split__c>{existingSplit.Id => existingSplit});
        Test.stopTest();

        List<Invoice_History__c> updatedHistories = [SELECT SplitPercentage__c FROM Invoice_History__c WHERE InstalmentRecipient__c = '0050w0000042AxXAAU'];
        System.assertEquals(60, updatedHistories[0].SplitPercentage__c, 'The Invoice History SplitPercentage should be updated to 60.');
    }
    
    @IsTest
    static void testHandleAfterDelete() {
        Invoice_Split__c splitToDelete = [SELECT Id FROM Invoice_Split__c WHERE SplitMember__c = '0050w0000042AxXAAU' LIMIT 1];
        List<Invoice_Split__c> splitsToDelete = new List<Invoice_Split__c>{splitToDelete};

        Test.startTest();
        InvoiceSplitHandler.handleAfterDelete(splitsToDelete);
        Test.stopTest();

        List<Invoice_History__c> remainingHistories = [SELECT Id FROM Invoice_History__c WHERE InstalmentRecipient__c = '0050w0000042AxXAAU'];
        System.assertEquals(0, remainingHistories.size(), 'Related Invoice History records should be deleted.');
    }
}