public with sharing class LeadTriggerHandler {

  public static void assignLeadToCounselor(List<Lead> leads) {
    // get all counselor profiles with the same Program Offer value as the lead
    List<Counselor_Profile__c> counselorProfiles = [SELECT Id, Name, Program_Offer__c
                                                     FROM Counselor_Profile__c
                                                     WHERE Program_Offer__c = :leads[0].Program_Offer__c
                                                     ORDER BY Last_Lead_Assigned__c ASC];

    // initialize a counter for the number of leads assigned to each counselor
    Map<Id, Integer> counselorLeadCount = new Map<Id, Integer>();
    for (Counselor_Profile__c cp : counselorProfiles) {
      counselorLeadCount.put(cp.Id, 0);
    }

    // iterate through the new leads and assign them to a counselor using round-robin logic
    for (Lead lead : leads) {
      Integer minLeadCount = 1000000000;
      Id assignedCounselorId = null;
      for (Id counselorId : counselorLeadCount.keySet()) {
        if (counselorLeadCount.get(counselorId) < minLeadCount) {
          minLeadCount = counselorLeadCount.get(counselorId);
          assignedCounselorId = counselorId;
        }
      }
      lead.Counselor_Profile__c = assignedCounselorId;
      counselorLeadCount.put(assignedCounselorId, minLeadCount + 1);

      // update the Last_Lead_Assigned__c field on the counselor profile to keep track of the round-robin assignment
      Counselor_Profile__c assignedCounselor = [SELECT Id, Last_Lead_Assigned__c
                                                 FROM Counselor_Profile__c
                                                 WHERE Id = :assignedCounselorId];
      assignedCounselor.Last_Lead_Assigned__c = System.now();
      update assignedCounselor;
    }

    sendEmailsToAssignedCounselors(leads);
  }
    ///sending mail
  public static void sendEmailsToAssignedCounselors(List<Lead> leads) {
    List<Id> counselorProfileIds = new List<Id>();
    for (Lead lead : leads) {
        if (lead.Counselor_Profile__c != null) {
            counselorProfileIds.add(lead.Counselor_Profile__c);
        }
    }
    List<Counselor_Profile__c> counselorProfiles = [SELECT Id, Name, Email__c
                                                    FROM Counselor_Profile__c
                                                    WHERE Id IN :counselorProfileIds];
    Map<Id, Counselor_Profile__c> counselorProfileMap = new Map<Id, Counselor_Profile__c>();
    for (Counselor_Profile__c counselorProfile : counselorProfiles) {
        counselorProfileMap.put(counselorProfile.Id, counselorProfile);
    }
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Lead lead : leads) {
        if (lead.Counselor_Profile__c != null) {
         Counselor_Profile__c counselorProfile = counselorProfileMap.get(lead.Counselor_Profile__c);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { counselorProfile.Email__c });
            email.setSubject('New Lead: ' + lead.FirstName + ' ' + lead.LastName);
            email.setPlainTextBody('A new Lead has been created with the following information:\n\n' +
                                   'First Name: ' + lead.FirstName + '\n' +
                                   'Last Name: ' + lead.LastName + '\n' +
                                   'Email: ' + lead.Email + '\n' +
                                   'Mobile: ' + lead.Mobile__c + '\n' +
                                   'Program Offer: ' + lead.Program_Offer__c + '\n\n' +
                                   'Assigned Counselor: ' + counselorProfile.Name);
            emails.add(email);
        }
    }
    Messaging.sendEmail(emails);
}
}