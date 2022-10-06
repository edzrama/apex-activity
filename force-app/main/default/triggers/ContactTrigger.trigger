trigger ContactTrigger on Contact (before insert, before update, after insert, after update)  {
if(Trigger.isAfter) {
    	if(Trigger.isupdate) {
            // Activity 4
			ContactTriggerHandler.UpdateAccountEmail(Trigger.new, Trigger.oldMap);
        }
    }
    
}