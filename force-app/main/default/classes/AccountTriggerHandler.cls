public class AccountTriggerHandler {
    // Activity 2
    public static void createContact(List<Account> lAccount) {
        list<Contact> lContactToInsert = new list<Contact>();
        for(Account acct : lAccount) {
            if(acct.First_Name__c != Null && acct.Last_Name__c != Null && acct.Email__c != Null) {
                // Add to list only if first name, last name, and email are all filled
                lContactToInsert.add(new Contact(FirstName = acct.First_Name__c, LastName= acct.Last_Name__c, Email = acct.Email__c, AccountId = acct.ID ));
            }
        }
        if(!lContactToInsert.isEmpty()) {
            insert lContactToInsert;
        }    
    }
    
    // Activity 3
    public static void updateContactEmail(List<Account> lAccount, Map<ID, Account> mAcctOld) {
        list<Contact> lContactToUpdate = new list<Contact>();
        Map<ID, Account> mAccounts = new Map<ID, Account>();
        // Store Accounts where email changed
        for(Account acct : lAccount) {
            if(acct.Email__c != mAcctOld.get(acct.id).Email__c ) {
                mAccounts.put(acct.ID, acct);
            }
        }
        
        if(!mAccounts.isEmpty()) {
            // used extracted set as where clause
            for(Contact con : [SELECT ID, Email, AccountId from Contact WHERE AccountId IN :mAccounts.keyset()]) {
                // Assign Account email to contact(s) email
                if (mAccounts.get(con.AccountId).Email__c != con.Email) {
                    lContactToUpdate.add(new Contact(ID= con.ID, Email = mAccounts.get(con.AccountId).Email__c));
                }
            }
            if(!lContactToUpdate.isEmpty()) {
                update lContactToUpdate;
            }
        }
    }
}