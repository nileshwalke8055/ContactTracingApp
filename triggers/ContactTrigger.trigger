trigger ContactTrigger on Contact (After insert ,After update, After delete,After undelete) {
    switch on trigger.operationType {
        when AFTER_INSERT{
            ContactTriggerHandler.afterInserthandler(Trigger.new);
        }                                     
        when AFTER_UPDATE{
        ContactTriggerHandler.afterUpdatethandler(trigger.new,trigger.oldMap);
        } 
        when AFTER_DELETE{
            ContactTriggerHandler.afterDelete(trigger.old);
            }  
        when AFTER_UNDELETE{
            ContactTriggerHandler.afterUndelete(trigger.new);
            }                                      
}
}