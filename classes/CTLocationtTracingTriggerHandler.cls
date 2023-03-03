public with sharing class CTLocationtTracingTriggerHandler {
    public static void before_insert (List<Location_Tracing__C> NewRecords ) {
         List<Location_Tracing__C> Duplicates = CTLOcationTracingController.checkDuplicates(NewRecords);
         for(Location_Tracing__C trace :duplicates){
            trace.addError('Duplicate record found. Location ID:'+trace.Location__c +'Person ID:'+trace.Person__c);

         }
    }
}