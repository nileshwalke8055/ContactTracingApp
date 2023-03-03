public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges() {
        return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
                FROM Location__c
                ORDER BY Status_Update_Date__c
                 DESC LIMIT 100];       
    }
    public static List<Location__c> searchLocations(String searchTerm){
        searchTerm =searchTerm + '%';
          return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
                  FROM Location__c
                  WHERE Name LIKE :searchTerm
                  OR  Pincode__c LIKE :searchTerm
                  OR  Address__c LIKE :searchTerm
                  ORDER BY Status_Update_Date__c
                  DESC];
    }
    public static Location__c getLocationById (string LocationId){
     List<Location__c> Location =[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
                                  FROM Location__c
                                  WHERE  id=:LocationId];
        if(Location !=null && Location.size() > 0){
            return Location[0];
      }
      return null;

        } 
        public static Map<String, integer> getStatusCount(){
            Map<String,integer> healthcountMap =new Map<String,integer>();
            for(aggregateResult ar :[SELECT Status__c,COUNT(id) total
                                    FROM Location__c
                                    GROUP BY Status__c])
                                    {
            healthcountMap.put(String.valueOF(ar.get('Status__c')),integer.valueOF(ar.get('total')));
        }     
        return healthcountMap;                   
    }
    public static void updateRedScore(Set<id> locationIds){
        List<location__c> locationToUpdate =new List<Location__c>();
        AggregateResult[] redPeoplePerLocation =[SELECT Location__c ,Count(Id) TOTAL
                                                FROM Location_Tracing__c
                                                WHERE Person__r.Health_Status__c='Red'
                                                AND Visit_Date__c =LAST_N_DAYS:10
                                                AND Location__c IN:locationIds
                                                GROUP BY Location__c];

         for(AggregateResult ar :redPeoplePerLocation){
            string locationId =string.valueOf(ar.get('location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            string status =getstatus(redScore);
            locationToUpdate.add(new location__c(id=locationId, Red_Score__c=redScore, status__c=status));
         } 
         if(locationToUpdate !=null && locationToUpdate.size()>0){
            update locationToUpdate;
         }                                      
        }
        public static String getstatus(Integer redScore){
            if(redScore == 0){
                return 'Green';
            }
            else if(redScore <= 5){
                return 'Yellow';
            }
            else if(redScore <= 10){
                return 'orange';    
            }
            else{
                return 'red';
            }

        }// for Aura
    public static Map<String, Integer> getStatusCount1() {
       AggregateResult[] healthCoutnMap =[SELECT  Status__c, Count(Id) total
                        FROM Location__c  
                        GROUP BY Status__c ];
            if(healthCoutnMap !=null && healthCoutnMap.size() >0){
                Map<String, Integer> result = new Map<String, Integer>();
                for(AggregateResult ar :healthCoutnMap){
                result.put(String.valueOf(ar.get('Status__c')),Integer.valueOf(ar.get('total')));
                }
                return result;
            }  
            return null;       
}    
}