trigger CTLocationTrigger on Location__c (before insert,after insert, before update, after update) {

    switch on Trigger.operationType{
        when BEFORE_INSERT{
            CTLocationTriggerHandler.before_insert(Trigger.new);

        }
        when BEFORE_UPDATE{
            CTLocationTriggerHandler.before_Update(Trigger.new, trigger.oldMap);


        }
        when AFTER_UPDATE{
            CTLocationTriggerHandler.after_Update(Trigger.new, trigger.oldMap);
    }
}
}