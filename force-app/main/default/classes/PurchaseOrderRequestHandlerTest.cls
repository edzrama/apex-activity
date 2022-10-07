@isTest
public class PurchaseOrderRequestHandlerTest {
	@testSetup static void setup() {
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe', Email__c= 'test@testemail.com');
        insert acc;
        
        Purchase_Order_Request__c por = new Purchase_Order_Request__c(Account__c=acc.ID, Amount__c=10, Description__c='Test PO Request', Status__c='New');
        insert por;
    }
    // Activity 1 Test
    @isTest static void setCompleteDatetoToday_PositiveTest(){
        
        Purchase_Order_Request__c por2 = [SELECT Status__c FROM Purchase_Order_Request__c LIMIT 1];
        por2.Status__c = 'Completed';
        update por2;
        
        Test.startTest();
        Purchase_Order_Request__c por3 = [SELECT Completed_Date__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(system.Today(), por3.Completed_Date__c, 'Complete Date should equal to current date');
    }
    
    @isTest static void setCompleteDatetoToday_NegativeTest(){
        
        Purchase_Order_Request__c por2 = [SELECT Status__c FROM Purchase_Order_Request__c LIMIT 1];
        por2.Status__c = 'Pending';
        update por2;
        
        Test.startTest();
        Purchase_Order_Request__c por3 = [SELECT Completed_Date__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertNotEquals(system.Today(), por3.Completed_Date__c, 'Complete Date should not equal to current date');
    }
    
    
      // Activity 5 Test
    @isTest static void errorAccountValidation_PositiveTest(){
        Test.startTest();
        Purchase_Order_Request__c por2 = [SELECT Status__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertEquals('New', por2.Status__c, 'PO Request should have been created.');
    } 
    
    @isTest static void errorAccountValidation_NegativeTest(){
        Account acc = new Account(Name='Test Account 2', First_Name__c='Jane', Last_Name__c='Doe');
        insert acc;
        
        Purchase_Order_Request__c por = new Purchase_Order_Request__c(Account__c=acc.ID, Amount__c=10, Description__c='Test PO Request', Status__c='New');        
        Test.startTest();
        Database.SaveResult porResult = Database.insert(por, false);
        Test.stopTest();

        //Now we can use asserts to check if result was successful
        System.assert(porResult.isSuccess() == false, 'Insert should not be successful');
    }
    
	    // Activity 10 Test
    @isTest static void closePOMods_PositiveTest(){
        
        Purchase_Order_Request__c por2 = [SELECT ID,Status__c FROM Purchase_Order_Request__c LIMIT 1];
        Purchase_Order_Modification__c pom = new Purchase_Order_Modification__c(New_Amount__c=10,Status__c='New',Purchase_Order_Request__c= por2.ID);
        insert pom;
        
        por2.Status__c = 'Closed';
        update por2;
        
        Test.startTest();
        Purchase_Order_Modification__c pom2 = [SELECT Status__c FROM Purchase_Order_Modification__c LIMIT 1];
        Test.stopTest();
        
        System.assertEquals('Closed' , pom2.Status__c, 'PO Modification status should be closed');
    }
    
    @isTest static void closePOMods_NegativeTest(){
        
        Purchase_Order_Request__c por2 = [SELECT ID,Status__c FROM Purchase_Order_Request__c LIMIT 1];
        Purchase_Order_Modification__c pom = new Purchase_Order_Modification__c(New_Amount__c=10,Status__c='New',Purchase_Order_Request__c= por2.ID);
        insert pom;
        
        por2.Status__c = 'Pending';
        update por2;
        
        Test.startTest();
        Purchase_Order_Modification__c pom2 = [SELECT Status__c FROM Purchase_Order_Modification__c LIMIT 1];
        Test.stopTest();
        
        System.assertNotEquals('Closed' , pom2.Status__c, 'PO Modification status should not closed');
    }
    
    }