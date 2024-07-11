public class GMTDateTimeConverter {
    @InvocableMethod(label='Convert GMT to User Timezone')
    public static void convertGMTToUserTimezone(List<GMTDateTimeInput> inputs) {
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());

        List<User> users = [SELECT TimeZoneSidKey FROM User WHERE Id IN :userIds];
        String userTimeZoneId = users[0].TimeZoneSidKey;
        TimeZone userTimeZone = TimeZone.getTimeZone(userTimeZoneId);
        Integer gmtOffset = userTimeZone.getOffset(DateTime.now()) / (1000 * 60); // Get GMT offset in minutes

        for (GMTDateTimeInput input : inputs) {
            // Convert GMT datetime to user's timezone
            Datetime gmtDatetime = input.gmtDatetime;
            Long gmtTimeInMillis = gmtDatetime.getTime();
            Long userTimeInMillis = gmtTimeInMillis + (gmtOffset * 60 * 1000);
            Datetime userDatetime = Datetime.newInstance(userTimeInMillis);

            // Set the converted datetime back to the input object
            input.userDatetime = userDatetime;
        }
    }

    public class GMTDateTimeInput {
        @InvocableVariable(required=true)
        public Datetime gmtDatetime;

        @InvocableVariable
        public Datetime userDatetime;
    }
}