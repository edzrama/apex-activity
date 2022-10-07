trigger PurchaseOrderRequestTrigger on Purchase_Order_Request__c (before insert, before update, after insert, after update)  {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            // Activity 5
            PurchaseOrderRequestHandler.errorAccountValidation(Trigger.new);
        }
        if(Trigger.isUpdate) {
            // Activity 1
            PurchaseOrderRequestHandler.setCompleteDatetoToday(Trigger.new, Trigger.OldMap);   
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            // Activity 10
            PurchaseOrderRequestHandler.closePOMods(Trigger.new,Trigger.OldMap);
        }
    }    
}