trigger AccountTrigger on Account (before insert, before update, after insert, after update)  {
if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            // Activity 2
			AccountTriggerHandler.createContact(Trigger.new);
        }
    	if(Trigger.isupdate) {
            // Activity 3
			AccountTriggerHandler.updateContactEmail(Trigger.new, Trigger.oldMap);
        }
    } 
}