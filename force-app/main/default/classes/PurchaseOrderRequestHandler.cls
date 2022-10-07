public class PurchaseOrderRequestHandler {
    // Activity 1
	public static void setCompleteDatetoToday(List<Purchase_Order_Request__c> lPORequest, Map<ID,Purchase_Order_Request__c> mPOROld) {
        for(Purchase_Order_Request__c por : lPORequest) {
            if(por.Status__c != mPOROld.get(por.id).Status__c && por.Status__c == 'Completed') {
                // set completed date to current date
                por.Completed_Date__c = System.today();
            }
    }
}
    // Activity 5
    public static void errorAccountValidation(List<Purchase_Order_Request__c> lPORequest) {
        List<ID> laccountIds = new List<ID>();
        Map<ID, Purchase_Order_Request__c > mAccIdToPORequest = new Map<ID, Purchase_Order_Request__c >();
        for(Purchase_Order_Request__c por : lPORequest) {
            if(por.Account__c != Null) {
                // Store PUrchase Order Requests where Account isnt null
                mAccIdToPORequest.put(por.Account__c, por);
            }     
    	}
        if(!mAccIdToPORequest.isEmpty()) {
        // Place all collected IDs to a Set to use for where clause
        for(Account acc: [SELECT Id, (SELECT id FROM Contacts) FROM Account Where id IN :mAccIdToPORequest.keyset()]) {
            if (acc.Contacts.size() == 0) {
                // When contact is empty, find the Purchase Order Request of that account and send an error.
                mAccIdToPORequest.get(acc.id).addError('You cannot Insert a Purchase Order Request for Account without Contact');
            }
        }
    }
}
      // Activity 10
    public static void closePOMods(List<Purchase_Order_Request__c> lPORequest, Map<ID,Purchase_Order_Request__c> mPOROld) {
        Set<ID> sPORIds = new Set<ID>();
        List<Purchase_Order_Modification__c> lPOModToUpdate = new List<Purchase_Order_Modification__c>();
        for(Purchase_Order_Request__c por : lPORequest) {
            // Store PO Request ID when status changed to 'Closed'
            if(por.Status__c != mPOROld.get(por.id).Status__c && por.Status__c == 'Closed' ) {
                sPORIds.add(por.ID);
            }     
    	}
        if(!sPORIds.isEmpty()) {
        // Get all Po Mod using PO Request ID Set (exclude already closed)
        for(Purchase_Order_Modification__c pom: [SELECT Id FROM Purchase_Order_Modification__c Where Purchase_Order_Request__c IN :sPORIds AND Status__c != 'Closed']) {
            // add records to update
            lPOModToUpdate.add(new Purchase_Order_Modification__c(Id=pom.Id, Status__c='Closed'));
        }
        
        if(!lPOModToUpdate.isEmpty()) {
        update lPOModToUpdate;
        }   
    }
}
}