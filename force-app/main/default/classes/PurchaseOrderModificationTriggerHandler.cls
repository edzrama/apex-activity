public class PurchaseOrderModificationTriggerHandler {
    // Activity 6
    public static void updatePORequestAmount(List<Purchase_Order_Modification__c> lPOMod, Map<ID,Purchase_Order_Modification__c> mPOModOld) {
        list<Purchase_Order_Request__c> lPORequestToUpdate = new list<Purchase_Order_Request__c>();
        for(Purchase_Order_Modification__c pom : lPOMod) {
            if(pom.Status__c != mPOModOld.get(pom.id).Status__c && pom.Status__c == 'Completed' ) {
               lPORequestToUpdate.add(new Purchase_Order_Request__c(ID=pom.Purchase_Order_Request__c, Amount__c = pom.New_Amount__c));
            }
        }
        if(!lPORequestToUpdate.isEmpty()) {
            update lPORequestToUpdate;
        }  
}
    
    // Activity 7
    public static void SaveDeletePOM(List<Purchase_Order_Modification__c> mPOModOld) {
        list<Purchase_Order_Request__c> lPORequestToUpdate = new list<Purchase_Order_Request__c>();
        Map<ID, Purchase_Order_Modification__c > mPOReqToPOMod = new Map<ID, Purchase_Order_Modification__c >();
        for(Purchase_Order_Modification__c pom : mPOModOld) {
               mPOReqToPOMod.put(pom.Purchase_Order_Request__c, pom);
        }
        if(!mPOReqToPOMod.isEmpty()) {
        // Place all collected IDs to a Set to use for where clause
        for(Purchase_Order_Request__c por: [SELECT ID, Deleted_POM__c FROM Purchase_Order_Request__c WHERE ID IN :mPOReqToPOMod.keyset()]) {
            String deletedPOM;
            if(por.Deleted_POM__c != Null) {
               deletedPOM = por.Deleted_POM__c +','+ mPOReqToPOMod.get(por.ID).Name;
            }
            else {
               deletedPOM = mPOReqToPOMod.get(por.ID).Name;
            }
            lPORequestToUpdate.add(new Purchase_Order_Request__c(ID=por.ID, Deleted_POM__c = deletedPOM));
        }
        if(!lPORequestToUpdate.isEmpty()) {
            update lPORequestToUpdate;
        }   
        }
}
    
        // Activity 8
    public static void ValidatePOMCreate(List<Purchase_Order_Modification__c> lPOMod) {
        Map<ID, Purchase_Order_Modification__c > mPOReqToPOMod = new Map<ID, Purchase_Order_Modification__c >();
        for(Purchase_Order_Modification__c pom : lPOMod) {
               mPOReqToPOMod.put(pom.Purchase_Order_Request__c, pom);
        }
        if(!mPOReqToPOMod.isEmpty()) {
        for(Purchase_Order_Request__c por: [SELECT Id, (SELECT Id FROM Purchase_Order_Modifications__r) FROM Purchase_Order_Request__c WHERE ID IN :mPOReqToPOMod.keyset()]){
            // if more than 3, in case there's already more than 3 records for PO Mod
            if (por.Purchase_Order_Modifications__r.size() >= 3) {
                // Prevent Insert when PO Mods are more than or equal to 3
                mPOReqToPOMod.get(por.id).addError('You cannot Insert more than 3 PO Modifications for a single PO Request');
            }
        } 
        }
}
    
     // Activity 9
    public static void ValidatePOMPending(List<Purchase_Order_Modification__c> lPOMod) {
        Map<ID, Purchase_Order_Modification__c > mPOReqToPOMod = new Map<ID, Purchase_Order_Modification__c >();
        for(Purchase_Order_Modification__c pom : lPOMod) {
               mPOReqToPOMod.put(pom.Purchase_Order_Request__c, pom);
        }
        if(!mPOReqToPOMod.isEmpty()) {
        for(Purchase_Order_Request__c por: [SELECT Id, (SELECT Id FROM Purchase_Order_Modifications__r) FROM Purchase_Order_Request__c WHERE ID IN (SELECT Purchase_Order_Request__c FROM Purchase_Order_Modification__c WHERE Status__c = 'Pending' AND Purchase_Order_Request__c IN :mPOReqToPOMod.keyset()) ]){
            // if more than 3, in case there's already more than 3 records for PO Mod
            if (por.Purchase_Order_Modifications__r.size() != 0) {
                // Prevent Insert when PO Mods are more than or equal to 3
                mPOReqToPOMod.get(por.id).addError('Cannot Create PO Modification when pending records exist');
            }
        }  
        }
}
}