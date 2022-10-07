@isTest
public class POModificationTriggerHandlerTest {
    @testSetup static void setup() {
        Account acc = new Account(Name='Test Account', First_Name__c='John', Last_Name__c='Doe', Email__c= 'test@testemail.com');
        insert acc;
        
        Purchase_Order_Request__c por = new Purchase_Order_Request__c(Account__c=acc.ID, Amount__c=10, Description__c='Test PO Request', Status__c='New');
        insert por;
        
        Purchase_Order_Modification__c pom = new Purchase_Order_Modification__c(New_Amount__c=20,Status__c='New',Purchase_Order_Request__c= por.ID);
        insert pom;
        
    }
    // Activity 6 Test
    @isTest static void updatePORequestAmount_PositiveTest(){
        Purchase_Order_Modification__c pom2 = [SELECT Status__c,New_Amount__c FROM Purchase_Order_Modification__c LIMIT 1];
        pom2.status__c = 'Completed';
        
        Test.startTest();
        update pom2;
        Purchase_Order_Request__c por2 = [SELECT Amount__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(pom2.New_Amount__c, por2.Amount__c, 'PO Request Amount should match PO Mod New Amount');
    }
    
    @isTest static void updatePORequestAmount_NegativeTest(){
        
        Purchase_Order_Modification__c pom2 = [SELECT Status__c,New_Amount__c FROM Purchase_Order_Modification__c LIMIT 1];
        pom2.status__c = 'Pending';
        
        Test.startTest();
        update pom2;
        Purchase_Order_Request__c por2 = [SELECT Amount__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertNotEquals(pom2.New_Amount__c, por2.Amount__c, 'PO Request Amount should not match PO Mod New Amount');
    }
    
    // Activity 7 Test - No negative test as it is deemed unnecessary to do so.
    @isTest static void saveDeletePOM_Test(){
        Purchase_Order_Modification__c pom2 = [SELECT Name FROM Purchase_Order_Modification__c LIMIT 1];
        
        Test.startTest();
        delete pom2;
        Purchase_Order_Request__c por2 = [SELECT Deleted_POM__c FROM Purchase_Order_Request__c LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(pom2.Name, por2.Deleted_POM__c, 'Deleted POM value should match the name of POM');
    }
    
    // Activity 8 Test
    @isTest static void validatePOMCreate_PositiveTest(){
        Purchase_Order_Request__c por2 = [SELECT ID FROM Purchase_Order_Request__c LIMIT 1];
        Boolean exceptionOccurred = false;
        // there's already one record created above for POM, we're adding 2 more 
        List<Purchase_Order_Modification__c> lPOMsToInsert = new List<Purchase_Order_Modification__c>();
        for(Integer i=0;i<2;i++) {
            Purchase_Order_Modification__c pom2 = new Purchase_Order_Modification__c(New_Amount__c=20,Status__c='New',Purchase_Order_Request__c= por2.ID);
            lPOMsToInsert.add(pom2);
        }
        
        Test.startTest();
        insert lPOMsToInsert;
        List<Purchase_Order_Modification__c> lPOMs = [SELECT ID FROM Purchase_Order_Modification__c];
        Test.stopTest();
        
        System.assertEquals(3,lPOMS.size(), 'Records should have been inserted');
    }
    
    @isTest static void validatePOMCreate_NegativeTest(){
        Purchase_Order_Request__c por2 = [SELECT ID FROM Purchase_Order_Request__c LIMIT 1];
        Boolean exceptionOccurred = false;
        // there's already one record created above for POM, we're adding 3 more 
        List<Purchase_Order_Modification__c> lPOMsToInsert = new List<Purchase_Order_Modification__c>();
        for(Integer i=0;i<3;i++) {
            Purchase_Order_Modification__c pom2 = new Purchase_Order_Modification__c(New_Amount__c=20, Status__c='New', Purchase_Order_Request__c=por2.ID);
            lPOMsToInsert.add(pom2);
        }
        
        Test.startTest();
        try {
            insert lPOMsToInsert;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            exceptionOccurred = true;
        }
        Test.stopTest();
        
        //Assert that an exception was thrown
        System.assert(exceptionOccurred, 'PO Request cannot have more than 3 modification records');
    }
    
    
    // Activity 9 Test
    @isTest static void validatePOMPending_PositiveTest(){
        Purchase_Order_Request__c por2 = [SELECT ID FROM Purchase_Order_Request__c LIMIT 1];
        Purchase_Order_Modification__c pom2 = new Purchase_Order_Modification__c(New_Amount__c=20, Status__c='Completed', Purchase_Order_Request__c=por2.ID);
        insert pom2;
        
        Purchase_Order_Modification__c pom3 = new Purchase_Order_Modification__c(New_Amount__c=10, Status__c='New', Purchase_Order_Request__c=por2.ID);
        Boolean exceptionOccurred = false;
        Test.startTest();
        insert pom3;
        Test.stopTest();
        
        List<Purchase_Order_Modification__c> lPOMs = [SELECT ID FROM Purchase_Order_Modification__c];
        System.assertEquals(3,lPOMS.size(), 'Records should have been inserted');
        
    }
    
    @isTest static void validatePOMPending_NegativeTest(){
        Boolean exceptionOccurred = false;
        Purchase_Order_Request__c por2 = [SELECT ID FROM Purchase_Order_Request__c LIMIT 1];
        Purchase_Order_Modification__c pom2 = new Purchase_Order_Modification__c(New_Amount__c=20,Status__c='Pending',Purchase_Order_Request__c= por2.ID);
        insert pom2;
        Purchase_Order_Modification__c pom3 = new Purchase_Order_Modification__c(New_Amount__c=10,Status__c='New',Purchase_Order_Request__c= por2.ID);
        
        Test.startTest();
        try {
            insert pom3;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            exceptionOccurred = true;
        }
        Test.stopTest();
        
        //Assert that an exception was thrown
        System.assert(exceptionOccurred, 'Cannot insert new PO Request Modification when there\'s an exising in \'Pending\' status');
    }
    
}