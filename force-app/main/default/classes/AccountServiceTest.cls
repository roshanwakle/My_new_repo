@IsTest
private class AccountServiceTest {
    @TestSetup
    static void makeData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    @IsTest
    static void getRecentAccounts_respectsLimit() {
        Test.startTest();
        List<Account> result = AccountService.getRecentAccounts(3);
        Test.stopTest();

        Assert.areEqual(3, result.size(), 'Only 3 accounts should be returned');
    }

    @IsTest
    static void getRecentAccounts_usesDefaultWhenLimitMissing() {
        List<Account> result = AccountService.getRecentAccounts(null);

        Assert.areEqual(5, result.size(), 'All 5 test accounts fit under the default limit');
    }

    @IsTest
    static void trigger_setsDefaultDescription() {
        Account acc = [SELECT Description FROM Account LIMIT 1];

        Assert.areEqual(
            AccountService.DEFAULT_DESCRIPTION,
            acc.Description,
            'Trigger should fill a blank description'
        );
    }

    @IsTest
    static void trigger_keepsExistingDescription() {
        Account acc = new Account(Name = 'Has Description', Description = 'Custom text');
        insert acc;

        acc = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Custom text', acc.Description, 'Existing description must not be overwritten');
    }

    @IsTest
    static void controller_returnsAccounts() {
        List<Account> result = AccountController.getAccounts(2);

        Assert.areEqual(2, result.size(), 'Controller should delegate to the service');
    }
}
