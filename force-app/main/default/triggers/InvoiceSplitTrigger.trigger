trigger InvoiceSplitTrigger on Invoice_Split__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            InvoiceSplitHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            InvoiceSplitHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
        } else if (Trigger.isDelete) {
            InvoiceSplitHandler.handleAfterDelete(Trigger.old);
        }
    }
}