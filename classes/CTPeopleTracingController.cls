public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String recordId) {
      return [SELECT Id, Contact_Date__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__r.Health_Status__c, Person_2__r.Token__c
              FROM People_Tracing__c
              WHERE (Person_1__c =:recordId
              OR Person_2__c =:recordId)
              AND Contact_Date__c =LAST_N_DAYS:30
              ORDER BY Contact_Date__c DESC];
    }
   public static List<People_Tracing__c> checkDuplicates(list<People_Tracing__c> peopleTraces){
    set<id> personIds =new Set<id>();
    for(People_Tracing__c trace : peopleTraces){
      personIds.add(trace.Person_1__c);
      personIds.add(trace.Person_2__c);
    }
    List<People_Tracing__c> Duplicates = new List<People_Tracing__c>();
    
    //map id and set<id>
    map<id,set<id>> MapOfExistingRecords = new Map<id, set<id>> ();
  
    //fetching existing records
    list<People_Tracing__c> ExistingRecords =[SELECT id,Person_1__c,Person_2__c
                                              FROM People_Tracing__c  
                                              WHERE Person_1__c 
                                              IN :personIds 
                                              OR Person_2__c
                                              IN:personIds];
    if(ExistingRecords != null && ExistingRecords.size() > 0){
      for(People_Tracing__c trace :ExistingRecords){
        if(! MapOfExistingRecords.containsKey(trace.Person_1__c)){
           MapOfExistingRecords.put(trace.Person_1__c,new set<id>());
        }
        MapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

        if(! MapOfExistingRecords.containsKey(trace.Person_2__c)){
          MapOfExistingRecords.put(trace.Person_2__c,new set<id>());
       }
       MapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
     }
    }
    //loop over existing records to find duplicates
    for(People_Tracing__c trace :peopleTraces){
      //check duplicate in map
      if(( MapOfExistingRecords.containsKey(trace.Person_1__c) 
       && MapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
       ||
       ( MapOfExistingRecords.containsKey(trace.Person_2__c) 
       && MapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))){

        Duplicates.add(trace);
       }
    }
    return Duplicates;  
    
    
  }
}