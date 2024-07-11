global class DateTimeConversion {
     public static DateTime convertToUserTimezone(Datetime datetimeValue) {
        // Replace 'America/Los_Angeles' with the target timezone of the user
        TimeZone tz = TimeZone.getTimeZone('(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)');
        Integer offset = tz.getOffset(datetimeValue) / 1000;
        return datetimeValue.addSeconds(offset);
    }
}