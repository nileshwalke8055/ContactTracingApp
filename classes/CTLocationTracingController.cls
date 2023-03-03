public with sharing class CTLocationTracingController {
    public static List<Location_Tracing__c> getVisitord(String LocationId) {
        return [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Person__c, Location__c, Visit_Date__c 
                FROM Location_Tracing__c
                WHERE  id =: LocationId 
                ORDER BY Visit_Date__c
                DESC ];
    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set <id> personids){
      return [SELECT Id, Person__c, Location__c, Visit_Date__c 
              FROM Location_Tracing__c
              WHERE  Person__c IN : personids 
              AND Visit_Date__c = LAST_N_DAYS:10];
    }
    public static List<Location_Tracing__c> getLoactionByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Person__c, Location__c, Visit_Date__c 
                FROM Location_Tracing__c
                WHERE Location__c IN :locationIds
                AND Person__r.Health_Status__c = 'Green'
                AND Visit_Date__c = LAST_n_DAYS:10] ;
    }
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        set<id> locationIds = new set<id>();
        set<id> personids = new set<id>();
        for(Location_Tracing__c trace :newLocationTraces){
            locationIds.add(trace.Location__c);
            personids.add(trace.Person__c);
        }
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c, Visit_Date__c 
                FROM Location_Tracing__c 
                WHERE Location__c
                IN :locationIds
                AND Person__c IN :personids];

        Map<id, set<id>> mapOfExistingRecords = new Map<id, set<id>>();        
        List<Location_Tracing__c> Duplicates =new List<Location_Tracing__c>();

           if(existingRecords != null && existingRecords.size() > 0){
            for(Location_Tracing__c trace  :existingRecords){
                if(! mapOfExistingRecords.containsKey(trace.Location__c)){
                    mapOfExistingRecords.put(trace.Location__c, new set<id>());
                }
                //add personids to map set
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }
            for(Location_Tracing__c trace :newLocationTraces){
                //for check  for location id
                //if item found in map,then check for person in set
                if(mapOfExistingRecords.containsKey(trace.Location__c)
                 && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                    Duplicates.add(trace);

                }
            }

           } 
           return Duplicates;    
    }
}