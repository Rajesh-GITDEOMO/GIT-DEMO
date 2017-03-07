trigger testteam on OpportunityTeamMember (before insert,before update,before delete,after insert,after update,after delete) {
system.debug('*****test');
}