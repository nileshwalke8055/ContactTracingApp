public with sharing class CTHealthHeaderController {
    @AuraEnabled
    
    public static Map<String, Integer> getPersonHealthStatusCount() {
        return CTPersonController.getHealthStatusCount1();

    }
    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatucCount(){
        return CTLocationController.getStatusCount1();
    }
}