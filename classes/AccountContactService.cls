public with sharing class AccountContactService {
    public static void UpdateActiveContacts(set<id> AccountIds) {
        List<AggregateResult> results =[
                            select AccountId,Count(id) totalContacts
                            From Contact
                            WHERE active__c =true AND AccountId IN :AccountIds
                            GROUP BY AccountId];
    Map<id, account> accountstoupdate = new Map<id, account>();
    for(AggregateResult result : results){
    String accId =String.valueOf(result.get('AccountId'));
    integer totalContacts =integer.valueOf(result.get('totalContacts'));

    Account acc =new Account(id =accId, Active_Contacts__c =totalContacts);
    accountstoupdate.put(accId, acc);
    }

    for(id accID :AccountIds){
        if(!accountstoupdate.containsKey(accID)){
            accountstoupdate.put(accID,new Account(id =accId, Active_Contacts__c =0));
            //
        }
    }
    update accountstoupdate.values();

}
}

{name:"rahul",address:"kedgaon"}

stadent ,employee, department ,cource 

select 
