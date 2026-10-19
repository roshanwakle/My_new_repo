// Run with: sf apex run --file scripts/apex/hello.apex --target-org <alias>
List<Account> accounts = AccountService.getRecentAccounts(5);
System.debug('Accounts found: ' + accounts.size());
