trigger AccountTrigger on Account (before insert) {
    AccountService.setDefaultDescription(Trigger.new);
}
