    public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON ='0 0 2 * * ?';
    public void Execute( SchedulableContext sc) {
        CTPersonStatusBatch peopleStatusBatch = new CTPersonStatusBatch();
        Database.executeBatch(peopleStatusBatch, 2000);
        
           CTLocationStatusBatch LocationStatusBatch = new CTLocationStatusBatch();
        Database.executeBatch(LocationStatusBatch, 2000);
         

    }
} 