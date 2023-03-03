public with sharing class CTPeopleTracingTriggerHnadler {

    public static void  before_insert(List<people_Tracing__c> newRecords) {
        system.System.debug('here rechered');
           List<people_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecords);
           system.System.debug('here rechered 1'+duplicates);


    for(people_Tracing__c trace : duplicates){
        system.System.debug('here rechered 2');

        trace.addError('Duplicate record found. person 1:'+trace.person_1__c+' person 2:'+trace.person_2__c);
    }
   }
}