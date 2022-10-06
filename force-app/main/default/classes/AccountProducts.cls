public class AccountProducts {
    static Final String OPPORTUNITY_STAGE = 'Closed Won';
    
    public static void getOpportunityLineItembyOppIds(List<ID> oppsIds) {
        List<OpportunityLineItem> lOpportunityLineItem = [SELECT Opportunity.Accountid, OpportunityId, ID, Product2Id, ProductCode FROM OpportunityLineItem where OpportunityId IN :oppsIds AND Opportunity.StageName = :OPPORTUNITY_STAGE];
        updateAccountAndCreateAsset(lOpportunityLineItem);
    }
    
    public static void getOpportunityLineItembyAcctIds(List<Id> accountIds) {
       List<OpportunityLineItem> lOpportunityLineItem = [SELECT Opportunity.Accountid, OpportunityId, ID, Product2Id, ProductCode FROM OpportunityLineItem where Opportunity.Accountid IN :accountIds AND Opportunity.StageName = :OPPORTUNITY_STAGE];
       updateAccountAndCreateAsset(lOpportunityLineItem);
    }
    
    private static void updateAccountAndCreateAsset(List<OpportunityLineItem> lOppLineItem) {
        
        Map<Id, Set<String>> mAccountIdToOppId= new Map<Id, Set<String>>();
        Map<Id, Set<String>> mOppIdToLineId = new Map<Id, Set<String>>();
        List<Asset> lAssetToInsert = new List<Asset>();
        List<Account> lAccountToUpdate = new List<Account>();
        
        for(OpportunityLineItem oli : lOppLineItem ) {
            // Account and Opportunity Id List
    		if(oli.Opportunity.Accountid != Null){
        		if(!mAccountIdToOppId.keySet().contains(oli.Opportunity.Accountid)){
            	mAccountIdToOppId.put(oli.Opportunity.Accountid, new Set<String>{oli.OpportunityId});
        		}else{
            	mAccountIdToOppId.get(oli.Opportunity.Accountid).add(oli.OpportunityId);
        		}
    		}
            // Opportunity and Line Products Id List
            if(oli.OpportunityId != Null){
        		if(!mOppIdToLineId.keySet().contains(oli.OpportunityId)){
            	mOppIdToLineId.put(oli.OpportunityId, new Set<String>{oli.ProductCode});
        		}else{
            	mOppIdToLineId.get(oli.OpportunityId).add(oli.ProductCode);
        		}
    		}
            	
            // Build Assets to insert
            lAssetToInsert.add(new Asset(Name=oli.ID, AccountId=oli.Opportunity.Accountid, Opportunity__c=oli.OpportunityId, Product2Id=oli.Product2Id));  

		}
        // Insert Assets
        if(!lAssetToInsert.isEmpty()){
            Insert lAssetToInsert;
        }
        
		
        for (Id acctId : mAccountIdToOppId.keySet()) {
    	// loop through Account and Opportunity ID list
    	Set<String> sOpporunityIds = mAccountIdToOppId.get(acctId);
        Set<String> sProductCodes = new Set<String>();
        
        String productCode;
            // combine all opportunity products per account
            for (ID oppId : sOpporunityIds) {
                if (String.isBlank(productCode)) {
                    productCode = String.join(new List<String>(mOppIdToLineId.get(oppId)), ','); 
                }
                else {
                    productCode += ','+String.join(new List<String>(mOppIdToLineId.get(oppId)), ','); 
                }
			}
            //split product code to eliminate repetition
            sProductCodes.addall(productCode.split(','));
            
            // set product values to account
            lAccountToUpdate.add(new account(Id=acctId, Account_Products__c = string.join(new List<String>(sProductCodes),',')));
                
		}
        // Update Account
        if(!lAccountToUpdate.isEmpty()){
        update lAccountToUpdate;
        }
    }
}