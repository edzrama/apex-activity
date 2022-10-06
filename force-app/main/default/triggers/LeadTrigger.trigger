trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {

            for(Lead newleads : Trigger.new) {
                newleads.LastName += ' (New)';
            }
        }
    }

}