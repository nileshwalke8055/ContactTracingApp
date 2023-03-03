    public with sharing class CTLocationTracingDateCleanupBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator Start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Location_Tracing__c WHERE Visit_Date__c < LAST_N_DAYS : 30');
    }

    public void execute(Database.BatchableContext Bc, List<Location_Tracing__c> scope){
        delete scope;
    }
    public void finish(Database.BatchableContext BC){

    }
}