    public with sharing class CTPersonStatusBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator Start(Database.BatchableContext BC) {
        List<String> healthStatuses =new List<String>{'Red','Green','Orange'};
        Date today =date.today();
        date FourteenDaysAgo =today -14;
        return Database.getQueryLocator('SELECT Id, Health_Status__c FROM Person__c WHERE Status_Update_Date__c = :FourteenDaysAgo AND Health_Status__c IN :healthStatuses');
    }

    public void execute(Database.BatchableContext Bc, List<Person__c> scope){
        for(Person__c person :scope){
          person.Health_Status__c ='Green';
        }
        update scope;
    }
    public void finish(Database.BatchableContext BC){

    }
}