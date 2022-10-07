@isTest
public class AccountTriggerHandlerTest {
	// Activity 2 Test
    @isTest static void createContact_PositiveTest(){
        Test.startTest();
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe', Email__c= 'test@testemail.com');
        insert acc;
        Contact con = [SELECT FirstName FROM Contact LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(acc.First_Name__c, con.FirstName, 'Contact Record should match the Account');
    }
    
    @isTest static void createContact_NegativeTest(){
        Test.startTest();
        //Insert account with no email
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe');
        insert acc;
        List<contact> contactsToCreate = [SELECT FirstName FROM Contact LIMIT 1];
        Test.stopTest();
        system.assert((contactsToCreate.size() == 0), 'Did not meet the criteria to create account record');
    }
    
    // Activity 3 Test
    @isTest static void updateContactEmail_PositiveTest(){
        
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe',Email__c= 'test@testemail.com');
        insert acc;
        
        Account acc2 = [SELECT Email__c FROM Account LIMIT 1];
        Test.startTest();
        acc2.Email__c = 'newtest@testemail.com';
        update acc2;
        
        Contact con = [SELECT FirstName FROM Contact LIMIT 1];
        Test.stopTest();
        System.assertEquals(acc2.Email__c, con.Email, 'Contact Email should match the Account Email');
    }
    
    @isTest static void updateContactEmail_NegativeTest(){
        
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe');
        insert acc;
        Contact con = new Contact(AccountId=acc.ID, FirstName='Jane', LastName='Doe', Email='janedoe@gmail.com');
        insert con;
        
        Account acc2 = [SELECT First_Name__c,Email__c FROM Account LIMIT 1];
        Test.startTest();
        acc2.First_Name__c = 'Jane';
        update acc2;
        
        Contact con2 = [SELECT Email FROM Contact LIMIT 1];
        Test.stopTest();
        System.assertNotEquals(acc2.Email__c, con2.Email, 'Contact Email should not be updated');
    }
}