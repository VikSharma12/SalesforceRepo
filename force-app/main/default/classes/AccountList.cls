public class AccountList {
	@auraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Description FROM Account];
    }
    
    @auraEnabled(cacheable=true)
    public static List<Account> getCurrentAccount(String accountId){
        return [SELECT Id, Name, Description, Website FROM Account WHERE Id=:accountId LIMIT 10000];
    }
    
    @auraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId)
    {
        List<Contact> conList=[SELECT Id, FirstName, LastName, Phone, AccountId FROM Contact WHERE AccountId=:accountId LIMIT 10000];
        return conList;
    }
}