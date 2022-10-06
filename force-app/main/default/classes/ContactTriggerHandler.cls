public class ContactTriggerHandler {
    // Activity 4
	public static void UpdateAccountEmail(List<Contact> lContact, Map<ID, Contact> mContactOld) {
        list<Account> lAccountToUpdate = new list<Account>();
        Map<ID, Contact> lAcctIDstoConEmail = new Map<Id,Contact>();
        for(Contact con : lContact) {
            if(con.Email != mContactOld.get(con.id).Email) {
               lAcctIDstoConEmail.put(con.AccountId, con);
            }
        }
        if(!lAcctIDstoConEmail.isEmpty()) {
        for(Account acct: [SELECT ID, Email__c from Account WHERE ID IN :lAcctIDstoConEmail.keySet()]) {
            if(acct.Email__c != lAcctIDstoConEmail.get(acct.ID).Email) {
                lAccountToUpdate.add(new Account(ID=acct.ID, Email__c = lAcctIDstoConEmail.get(acct.ID).Email));
            }
        }
        
        if(!lAccountToUpdate.isEmpty()) {
            update lAccountToUpdate;
        }
        }
}   
}