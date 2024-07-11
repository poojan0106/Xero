@isTest
private class InvoiceHistoryHelperTest {

    // Helper method to create a user with a commission
    private static User createUserWithCommission(Decimal commission) {
        User newUser = new User(
            // Set necessary fields according to your org's requirements
            // Username, LastName, Email, etc.
            Commission__c = commission
        );
        insert newUser;
        return newUser;
    }
    
    // Helper method to create a work order linked to an opportunity
    private static WorkOrder createWorkOrder(Id ownerId, Boolean crossSold) {
        Opportunity opp = new Opportunity(
            // Set necessary fields
            OwnerId = ownerId,
            Cross_Sold_or_New_Proposal__c = crossSold
        );
        insert opp;
        
        WorkOrder workOrder = new WorkOrder(
            // Set necessary fields
            Opportunity__c = opp.Id
        );
        insert workOrder;
        return workOrder;
    }

    // Helper method to create invoices
    private static List<Invoice__c> createInvoices(Id workOrderId, Integer count) {
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i = 0; i < count; i++) {
            invoices.add(new Invoice__c(
                // Set necessary fields
                Work_Order__c = workOrderId,
                Amount_Paid__c = 100.00,
                Amount_Due__c = 200.00
            ));
        }
        insert invoices;
        return invoices;
    }

    @isTest
    static void testHandleAfterInsert() {
        // Create test user with commission
        User commissionUser = createUserWithCommission(10.00); // 10% commission
        
        // Create work order linked to opportunity
        WorkOrder workOrder = createWorkOrder(commissionUser.Id, true);
        
        // Create invoices
        List<Invoice__c> invoices = createInvoices(workOrder.Id, 2);

        // Call the method under test
        Test.startTest();
        InvoiceHistoryHelper.handleAfterInsert(invoices);
        Test.stopTest();

        // Verify that Invoice_History__c records were created as expected
        List<Invoice_History__c> histories = [SELECT Id, Invoice__c FROM Invoice_History__c];
        System.assertEquals(2, histories.size(), 'Expected two history records to be created.');
        
        // Additional assertions to verify the correctness of the Invoice_History__c records can be added here
    }

    @isTest
    static void testHandleBeforeUpdate() {
        // Setup similar to testHandleAfterInsert
        User commissionUser = createUserWithCommission(15.00); // 15% commission
        WorkOrder workOrder = createWorkOrder(commissionUser.Id, true);
        List<Invoice__c> invoices = createInvoices(workOrder.Id, 1);

        // Update invoice to trigger before update logic
        invoices[0].Amount_Paid__c = 150.00; // Adjust the amount paid to trigger history creation
        
        // Prepare oldInvoiceMap for handleBeforeUpdate
        Map<Id, Invoice__c> oldInvoiceMap = new Map<Id, Invoice__c>();
        oldInvoiceMap.put(invoices[0].Id, invoices[0].clone());

        // Call the method under test
        Test.startTest();
        InvoiceHistoryHelper.handleBeforeUpdate(invoices, oldInvoiceMap);
        Test.stopTest();

        // Verify that Invoice_History__c records were updated as expected
        List<Invoice_History__c> histories = [SELECT Id, Invoice__c, Amount_Paid__c FROM Invoice_History__c];
        System.assertEquals(1, histories.size(), 'Expected one history record to be updated.');
        System.assertEquals(150.00, histories[0].Amount_Paid__c, 'Expected the amount paid to be updated to 150.00.');
    }

    // Note: In a real-world scenario, you would add more tests to cover various edge cases and ensure comprehensive coverage.
}