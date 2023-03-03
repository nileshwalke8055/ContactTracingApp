public with sharing class CTDataCleanupSchedule implements Schedulable {
    public static final String CRON ='0 0 2 * * ?';
    public void Execute( SchedulableContext sc) {
        CTPeopleTracingDateCleanupBatch peopleTracingBatch = new CTPeopleTracingDateCleanupBatch();
        Database.executeBatch(peopleTracingBatch, 2000);

         CTLocationTracingDateCleanupBatch LocationTracingBatch = new CTLocationTracingDateCleanupBatch();
        Database.executeBatch(LocationTracingBatch, 2000);
        

    }
}