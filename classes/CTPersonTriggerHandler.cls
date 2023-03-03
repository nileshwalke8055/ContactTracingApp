public with sharing class CTPersonTriggerHandler {
    public static void  before_insert( list<person__c> newRecords) {
        for(person__c person :newRecords){
            person.health_status__c ='Green';
            person.token__c =CTPersonController.getToken(person.mobile__c);
        }

    }
    public static void  before_update( list<person__c> newRecords, map<id,person__c> oldRecordsMap ){
         for(person__c person :newRecords){
            if(person.health_status__c != oldRecordsMap.get(person.id).health_status__c){
                person.Status_Update_Date__c =date.today();
            }
         }
}
    public static void after_Update (List<person__c> newRecords, Map<id,person__c> oldRecordsMap) {
       set<id> statusChnage =new set<id>();
       set<id> redStatus =new set<id>();
        for(person__c perosn :newRecords){
            if(perosn.health_status__c != oldRecordsMap.get(perosn.id).health_status__c){       
                statusChnage.add(perosn.id);
            }
            if(perosn.health_status__c =='Red' && oldRecordsMap.get(perosn.id).health_status__c!='red'){
                redStatus.add(perosn.id);
            }
}
      Set<id> Processed =new set<id>();
      Processed.addAll(redStatus);

      set<id> orangeStatus =new Set<id>();
      set<id> YellowStatus =new Set<id>();

      list<person__c> personToUpdate =new list<person__c>();
         
      orangeStatus.addAll(CTPersonController.getCohabitants(redStatus,Processed));
      set<id> primarycontacts =CTPersonController.getPrimaryContact(redStatus,Processed);
      orangeStatus.addAll(primarycontacts);
      YellowStatus.addAll(CTPersonController.getNeighbours(redStatus,Processed));
      YellowStatus.addAll(CTPersonController.getSecoundaryContact(primarycontacts,Processed));
       
      for(id pid:orangeStatus){
        personToUpdate.add(new person__c(id=pid, health_status__c = 'Orange'));

      }
      for(id pid:YellowStatus){
        personToUpdate.add(new person__c(id=pid, health_status__c = 'Yellow'));

      }
      if(personToUpdate.size()>0){
      update personToUpdate;
      }

      List<location_Tracing__c>  locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChnage);
     if(locationTraces !=null && locationTraces.size() >0){
        set<id> locationIds =new set<id>();
        for(location_Tracing__c trace :locationTraces){
            locationIds.add(trace.Location__c);
        }
        CTLocationController.updateRedScore(locationIds);
     }
    }

}
