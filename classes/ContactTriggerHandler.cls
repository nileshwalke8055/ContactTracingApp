public with sharing class ContactTriggerHandler {
    public static void afterInserthandler(List<Contact> newContacts) {
        set<id> AccountIds = new set<id>();
        for(contact  con :newContacts){
            if(String.isNotBlank(con.AccountId)){
                AccountIds.add(con.AccountId);
            }
        }
        AccountContactService.UpdateActiveContacts(AccountIds);
       
        }      
    public static void afterUpdatethandler(list<contact> newContacts, map<id,contact> oldcontactsmap) {
        set<id> AccountIds = new set<id>();
        for(contact  con :newContacts){
            if(String.isNotBlank(con.AccountId) && oldcontactsmap.get(con.id).active__c !=con.active__c){
                AccountIds.add(con.AccountId);
            }if(oldcontactsmap.get(con.id).AccountId !=con.AccountId){
                AccountIds.add(con.AccountId);
                AccountIds.add(oldcontactsmap.get(con.id).AccountId);
            }
            }
            AccountContactService.UpdateActiveContacts(AccountIds);
//a
}
    public static void afterDelete(List<Contact> oldContacts) {
        set<id> AccountIds = new set<id>();
        for(contact  con :oldContacts){
            if(String.isNotBlank(con.AccountId)){
                AccountIds.add(con.AccountId);
            }
        }
        AccountContactService.UpdateActiveContacts(AccountIds);
    
}
public static void afterUndelete(List<Contact> newContacts) {
    set<id> AccountIds = new set<id>();
    for(contact  con :newContacts){
        if(String.isNotBlank(con.AccountId)){
            AccountIds.add(con.AccountId);
        }
    }
    AccountContactService.UpdateActiveContacts(AccountIds);
}
}    