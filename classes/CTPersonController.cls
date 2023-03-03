public with sharing class CTPersonController {

    public static String getToken(String mobileNo)  {
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = crypto.generateDigest('MD5',value);

        //get the string value of hash Blob
        return EncodingUtil.base64Encode(hash);

    }
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c,status_Update_Date__c, Token__c 
                                FROM Person__c 
                                ORDER BY Status_Update_Date__c
                                DESC 
                                NULLS LAST
                                LIMIT 100];
    }
    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm =searchTerm + '%';
        return [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c,status_Update_Date__c, Token__c 
                                FROM Person__c    
                                WHERE Name    LIKE  :searchTerm
                                OR Mobile__c  LIKE :searchTerm
                                OR Token__c   LIKE :searchTerm
                                ORDER BY Status_Update_Date__c
                                NULLS LAST];
    }
    public static Person__c getPersonById(String personId){
        List<Person__c> people= [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c,status_Update_Date__c, Token__c 
                                FROM Person__c 
                                WHERE  Id =: personId];
      if(people !=null && people.size() > 0){
        return people[0];
      }
      return null;
    }
    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> healthCountMap =new Map<String, Integer>();
        for(AggregateResult ar:[SELECT Health_Status__c, Count(id) total
                                FROM Person__c
                                GROUP BY Health_Status__c]){
            String healthStatus =string.valueOf(ar.get('Health_Status__c'));
            Integer Count =Integer.valueOf(ar.get('totel'));                    
            healthCountMap.put(healthStatus,Count);                   
    }
    return healthCountMap;
}
    public static set<id>  getCohabitants (set<id> personIds,set<id> AlreadyProcessed){
    List<String> healthStatus =new List<String>{'Green','Yellow'};
       List<people_Tracing__c> peopletraces =[SELECT id, person_1__c, person_2__c
                                               FROM people_Tracing__c
                                               WHERE (person_1__c IN :personIds
                                               OR person_2__c IN :personIds)
                                               AND contact_Type__c ='Cohabitant'
                                               AND(person_1__r.health_status__c IN :healthStatus
                                               OR person_2__r.health_status__c IN :healthStatus)]; 
    
        Set<id> Cohabitants =new Set<id>();
        for(people_Tracing__c pt:peopletraces){
            if(!AlreadyProcessed.contains(pt.person_1__c)){
                Cohabitants.add(pt.person_1__c);
                AlreadyProcessed.add(pt.person_1__c);

            }
            if(!personIds.contains(pt.person_2__c)){
                Cohabitants.add(pt.person_2__c);
                AlreadyProcessed.add(pt.person_2__c);

            }

        }
        return Cohabitants;                                        

    }
    public static set<id>  getNeighbours (set<id> personIds,set<id> AlreadyProcessed){
           List<people_Tracing__c> peopletraces =[SELECT id, person_1__c, person_2__c
                                                   FROM people_Tracing__c
                                                   WHERE (person_1__c IN :personIds
                                                   OR person_2__c IN :personIds)
                                                   AND contact_Type__c ='Neighbour'
                                                   AND(person_1__r.health_status__c ='Green'
                                                   OR person_2__r.health_status__c ='green')]; 
        
            Set<id> Neighbours =new Set<id>();
            for(people_Tracing__c pt:peopletraces){
                if(!AlreadyProcessed.contains(pt.person_1__c)){
                    Neighbours.add(pt.person_1__c);
                    AlreadyProcessed.add(pt.person_1__c);

                }
                if(!personIds.contains(pt.person_2__c)){
                    Neighbours.add(pt.person_2__c);
                    AlreadyProcessed.add(pt.person_2__c);

                }
    
            }
            return Neighbours;         

    }
    public static set<id>  getPrimaryContact (set<id> personIds,set<id> AlreadyProcessed){
        List<String> healthStatus =new List<String>{'Green','Yellow'};
        List<people_Tracing__c> peopletraces =[SELECT id, person_1__c, person_2__c
                                                FROM people_Tracing__c
                                                WHERE (person_1__c IN :personIds
                                                OR person_2__c IN :personIds)
                                                AND contact_Type__c = 'Other'
                                                AND contact_Date__c = LAST_N_DAYS:10
                                                AND(person_1__r.health_status__c IN :healthStatus
                                                OR person_2__r.health_status__c IN :healthStatus)]; 
     
         Set<id> PrimaryContacts =new Set<id>();
         for(people_Tracing__c pt:peopletraces){
             if(!AlreadyProcessed.contains(pt.person_1__c)){
                PrimaryContacts.add(pt.person_1__c);
                AlreadyProcessed.add(pt.person_1__c);

             }
             if(!personIds.contains(pt.person_2__c)){
                PrimaryContacts.add(pt.person_2__c);
                AlreadyProcessed.add(pt.person_2__c);

             }
 
         }
         return PrimaryContacts;         

 }
 public static set<id>  getSecoundaryContact (set<id> PrimaryContactsIds,set<id> AlreadyProcessed){
    List<people_Tracing__c> peopletraces =[SELECT id, person_1__c, person_2__c
                                            FROM people_Tracing__c
                                            WHERE (person_1__c IN :PrimaryContactsIds
                                            OR person_2__c IN :PrimaryContactsIds)
                                            AND contact_Type__c = 'Other'
                                            AND contact_Date__c = LAST_N_DAYS:10
                                            AND(person_1__r.health_status__c ='Green'
                                            OR person_2__r.health_status__c ='green')]; 
 
     Set<id> SecoundaryContacts =new Set<id>();
     for(people_Tracing__c pt:peopletraces){
         if(!AlreadyProcessed.contains(pt.person_1__c)){
            SecoundaryContacts.add(pt.person_1__c);
            AlreadyProcessed.add(pt.person_1__c);
         }
         if(!PrimaryContactsIds.contains(pt.person_2__c)){
            SecoundaryContacts.add(pt.person_2__c);
            AlreadyProcessed.add(pt.person_2__c);
         }

     }
     return SecoundaryContacts;         

}
    public static Map<String, Integer> getHealthStatusCount1() {
       AggregateResult[] healthCoutnMap =[SELECT  Health_Status__c, Count(Id) total
                        FROM Person__c  
                        GROUP BY Health_Status__c ];
            if(healthCoutnMap !=null && healthCoutnMap.size() >0){
                Map<String, Integer> result = new Map<String, Integer>();
                for(AggregateResult ar :healthCoutnMap){
                result.put(String.valueOf(ar.get('Health_Status__c')),Integer.valueOf(ar.get('total')));
                }
                return result;
            }  
            return null;          
}
}