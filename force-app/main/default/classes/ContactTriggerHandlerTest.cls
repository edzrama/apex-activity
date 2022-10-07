@isTest
public class ContactTriggerHandlerTest {
    // Activity 4 Test
	@testSetup static void setup() {
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe');
        insert acc;
        Contact con = new Contact(AccountId=acc.ID, FirstName='Jane', LastName='Doe', Email='janedoe@gmail.com');
        insert con;
    }
    
    @isTest static void updateAccountEmail_PositiveTest(){
        Test.startTest();
        Contact con2 = [SELECT Email FROM Contact LIMIT 1];
        con2.Email = 'johndoe@gmail.com';
        update con2;
        
        Account acc2 = [SELECT Email__c FROM Account LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(acc2.Email__c, con2.Email, 'Account Email should match the Contact Email');
    }
    
    @isTest static void updateAccountEmail_NegativeTest(){
        Test.startTest();
        //Insert account with no email
        Contact con2 = [SELECT FirstName, Email FROM Contact LIMIT 1];
        con2.FirstName = 'Jane';
        update con2;
        
        Account acc2 = [SELECT Email__c FROM Account LIMIT 1];
        Test.stopTest();
        System.assertNotEquals(acc2.Email__c, con2.Email, 'Account Email should not update.');
    }
}