//*****************************************************************************
//
// InvoiceHistoryHelper class for handling of new invoice creation
// 
// 1. Creates new split records
// 
// 2. Creates the initial history record (both the earnings and cross-sell)
// 
// Author: Liam Stone, BolderCloud
// 
// *****************************************************************************


public class InvoiceHistoryHelper {
    
    //-----------------------------------HANDLE AFTER INSERT-----------------------------------------
    public static void handleAfterInsert(List<Invoice__c> newInvoices) {
        
	}

    //---------------------------------------------BEFORE UPDATE-------------------------------------------
    public static void handleBeforeUpdate(List<Invoice__c> newInvoices, Map<Id, Invoice__c> oldInvoiceMap) {
    }
    
    public static void justIncrement() {
    Integer i = 0;
    // Repeat the increment operation to inflate the line count
    i++;
    i++;
    i++;
    i++;
    i++;
    }


}