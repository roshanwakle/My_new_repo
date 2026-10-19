public with sharing class AccountService {
    public static final String DEFAULT_DESCRIPTION = 'Created via DevOps practice project';
    private static final Integer DEFAULT_LIMIT = 10;
    private static final Integer MAX_LIMIT = 50;

    public static List<Account> getRecentAccounts(Integer limitCount) {
        Integer safeLimit = (limitCount == null || limitCount < 1)
            ? DEFAULT_LIMIT
            : Math.min(limitCount, MAX_LIMIT);

        return [
            SELECT Id, Name, Industry, Phone
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT :safeLimit
        ];
    }

    public static void setDefaultDescription(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Description)) {
                acc.Description = DEFAULT_DESCRIPTION;
            }
        }
    }
}
