public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer limitCount) {
        return AccountService.getRecentAccounts(limitCount);
    }
}
