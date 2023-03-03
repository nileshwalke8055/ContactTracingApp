public with sharing class CTLocationTriggerHandler {
    public static void  before_insert(List<Location__c> newRecords) {
        for(Location__c lcoation :newRecords){
            lcoation.status__c ='Green';
        }

    }
    public static void  before_Update(List<Location__c> newRecords ,map<id,Location__c> oldRecordsMap ) {
        for(Location__c lcoation :newRecords){
            if(lcoation.status__c != oldRecordsMap.get(lcoation.id).status__c){
                lcoation.status_Update_Date__c =date.today();
            }
        }
    }
    public static void  after_Update(List<Location__c> newRecords ,map<id,Location__c> oldRecordsMap ) {
        Set<id> StatusChange = new Set<id>();
        for(Location__c lcoation :newRecords){
            if(lcoation.status__c =='red' && oldRecordsMap.get(lcoation.id).status__c !='red')
            StatusChange.add(lcoation.id);
        }
  
        list<location_Tracing__c> locationTraces =CTLocationTracingController.getLoactionByLocationIds(StatusChange);
        Set<id> personIds = new Set<id>();
        for(location_Tracing__c trace :locationTraces){
            personIds.add(trace.person__c);
        }
        List<person__c> peopleToUpdate = new List<person__c>();
        for(id pid :personIds){
            peopleToUpdate.add(new person__c(id=pid,health_status__c ='Yellow'));
        }
        if(peopleToUpdate.size()> 0){
            update peopleToUpdate;
        }
}
}
