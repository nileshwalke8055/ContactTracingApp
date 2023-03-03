@istest
public with sharing class ContactTriggerHandlerTest {
    @TestSetup
    static void MakeDate(){
        List<Account> testAccounts =new List<Account>();
        testAccounts.add (new Account (Name='test 1'));
        testAccounts.add (new Account (Name='test 2'));

       Insert  testAccounts; 

       List<Contact> testContacts =new List<contact>();
       testContacts.add(new Contact(LastName ='Test Contact', AccountId=testAccounts[0].id));
       testContacts.add(new Contact(LastName ='Test Contact 1', AccountId=testAccounts[0].id));
       testContacts.add(new Contact(LastName ='Test Contact 2', AccountId=testAccounts[0].id));
       testContacts.add(new Contact(LastName ='Test Contact 3', AccountId=testAccounts[0].id));
       testContacts.add(new Contact(LastName ='Test Contact 4', AccountId=testAccounts[1].id));
       
         insert testContacts;
        
    }
@istest
    public static void  afterInserthandlerTest() {
         List<Account> accs =[SELECT ID ,Active_Contacts__c FROM Account];
         System.assertEquals( 2, accs.size());
         System.assertEquals( 0, accs[0].Active_Contacts__c);
         System.assertEquals( 0, accs[1].Active_Contacts__c);

         List<contact> allContacts =[SELECT id FROM contact];
         system.assertEquals(5,allContacts.size());
    }

    //BulkTest
 @istest
    public static void afterInserthandlerTestBulk(){
        List<Account> testaccount1 =[SELECT id FROM account  WHERE NAME='test 1'];
        List<Contact> testcontacts =new List<Contact>();
        for(Integer i=0; i<1000; i++){
            testcontacts.add(new contact(lastname='test contact inactive'+1 ,  AccountId = testaccount1[0].Id, active__c =true));
        }
       
        insert testcontacts;

        List<Account> accs =[SELECT id, name ,active_contacts__c FROM Account];
        system.assertEquals(2, accs.size());
        for(account acc:accs){
            if(acc.name =='test 1'){
                system.assertEquals(1000, acc.active_contacts__c);
            }
            if(acc.name =='test 2'){
                system.assertEquals(0, acc.active_contacts__c);
            }
        }
        List<Contact> allContacts =[SELECT id FROM contact];
        system.assertEquals(1005, allContacts.size()); 
        }

        //afterUpdatethandlertest1
@istest
    public static void afterUpdatethandlertest1(){
         List<Contact> allContacts =[SELECT id,LastName FROM contact];
            for(Contact con:allContacts){
                if(con.LastName == 'Test Contact 1' || con.LastName == 'Test Contact 2'){
                    con.active__c =true;
                }
            }

            test.startTest();
            update allContacts;
            test.stopTest();
            List<Account> accs =[SELECT id, name ,active_contacts__c FROM Account];
                system.assertEquals(2, accs.size());
                for(account acc:accs){
                    if(acc.name =='test 1'){
                        system.assertEquals(2, acc.active_contacts__c);
                    }
                    if(acc.name =='test 2'){
                        system.assertEquals(0, acc.active_contacts__c);
                    }
            }
                
                system.assertEquals(5, allContacts.size()); 
                }

   //afterUpdatethandlertest2            
@istest
    public static void afterUpdatethandlertest2(){
        Account testaccount2 =[SELECT id,name FROM account WHERE name ='test 2'];
        List<Contact> allContacts =[SELECT id,LastName FROM contact];
        for(Contact con:allContacts){
            if(con.LastName == 'Test Contact 3'){
                con.active__c =true;
                con.AccountId =testaccount2.Id;
            }
        }

        test.startTest();
        update allContacts;
        test.stopTest();
        List<Account> accs =[SELECT id, name ,active_contacts__c FROM Account];
            system.assertEquals(2, accs.size());
            for(account acc:accs){
                if(acc.name =='test 1'){
                    system.assertEquals(0, acc.active_contacts__c);
                }
                if(acc.name =='test 2'){
                    system.assertEquals(1, acc.active_contacts__c);
                }
        }
            
            system.assertEquals(5, allContacts.size()); 
    }
    //afterDeleteTest
 @istest
    public static void afterDeleteTest(){
        List<Contact> Conc =[SELECT id, Lastname
                             FROM Contact
                             WHERE Name IN('Test Contact 1', 'Test Contact 2')];

          test.startTest();
          delete Conc;
          test.stopTest();

          List<Account> accs =[SELECT id, name ,active_contacts__c FROM Account];
            system.assertEquals(2, accs.size());
            for(account acc:accs){
                if(acc.name =='test 1'){
                    system.assertEquals(0, acc.active_contacts__c);
                
                if(acc.name =='test 2'){
                    system.assertEquals(1, acc.active_contacts__c);
                }
        }
            Conc =[SELECT id,Lastname FROM Contact];
            system.assertEquals(3, Conc.size()); 
        }
         
     }
     //afterUndeleteTest
@istest
    public static void afterUndeleteTest(){
        List<Contact> Conc =[SELECT id, Lastname
                                FROM Contact
                                WHERE Name IN('Test Contact 1', 'Test Contact 2')];
           
           Delete Conc;

            test.startTest();
            Undelete Conc;
            test.stopTest();

            List<Account> accs =[SELECT id, name ,active_contacts__c FROM Account];
            system.assertEquals(2, accs.size());
            for(account acc:accs){
                if(acc.name =='test 1'){
                    system.assertEquals(0, acc.active_contacts__c);
                
                   if(acc.name =='test 2'){
                    system.assertEquals(1, acc.active_contacts__c);
                   }
                }
             Conc =[SELECT id,Lastname FROM Contact];
             system.assertEquals(5, Conc.size()); 
        }
    }    
      
}