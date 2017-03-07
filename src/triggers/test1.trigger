trigger test1 on SS_Forecast_Target__c (after insert,after update) {

if(trigger.isinsert){
system.debug('***Insert call');
}

if(trigger.isupdate){
system.debug('***update call');
system.debug('**' +trigger.new);
}




}