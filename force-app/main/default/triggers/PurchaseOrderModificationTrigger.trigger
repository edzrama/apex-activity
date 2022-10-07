trigger PurchaseOrderModificationTrigger on Purchase_Order_Modification__c (before insert, before update, before delete, after insert, after update, after delete)  {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            // Activity 8
            PurchaseOrderModificationTriggerHandler.validatePOMCreate(Trigger.new);
            // Activity 9
            PurchaseOrderModificationTriggerHandler.validatePOMPending(Trigger.new);
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isupdate) {
            // Activity 6
            PurchaseOrderModificationTriggerHandler.updatePORequestAmount(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isdelete) {
            // Activity 7
            PurchaseOrderModificationTriggerHandler.saveDeletePOM(Trigger.old);
        }
    } 
}