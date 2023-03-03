    public with sharing class CTLocationStatusBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator Start(Database.BatchableContext BC) {
        List<String> healthStatuses =new List<String>{'Red','Green','Orange'};
        Date today =date.today();
        date FourteenDaysAgo =today -14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c = :FourteenDaysAgo AND Status__c IN :healthStatuses');
    }

    public void execute(Database.BatchableContext Bc, List<Location__c> scope){
        for(Location__c person :scope){
          person.Status__c ='Green';
        }
        update scope;
    }
    public void finish(Database.BatchableContext BC){

    }
}