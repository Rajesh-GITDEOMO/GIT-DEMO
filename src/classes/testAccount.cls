public class testAccount {
@AuraEnabled
public static List<Account>	getAccount(){
        List<Account> accList = [SELECT Id, Name, Phone FROM Account ORDER BY Createddate DESC LIMIT 10];
        system.debug(accList);
        return accList;
}
    
@AuraEnabled
public static Account saveAccount(Account acc) {
	insert acc;
	return acc;    
}
}