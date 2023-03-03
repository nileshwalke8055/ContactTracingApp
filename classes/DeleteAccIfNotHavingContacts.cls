public class DeleteAccIfNotHavingContacts {
    List<Account> Acc =new List<Account>();
    set<id> Setaccids =new set<id>();
     
    map<id,Account> accids =new Map<id,Account>([select id, (select id from contacts) from Account]);    
}