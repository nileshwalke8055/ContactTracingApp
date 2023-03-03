public with sharing class CTPeopleTracingDateCleanupBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator Start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS : 30');
    }

    public void execute(Database.BatchableContext Bc, List<people_Tracing__c> scope){
        delete scope;
    }
    public void finish(Database.BatchableContext BC){

    }
}