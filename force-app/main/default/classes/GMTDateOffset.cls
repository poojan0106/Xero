public class GMTDateOffset {
    @InvocableMethod(label='Add GMT Date Offset')
    public static List<GMTDateOutput> addGMTDateOffset(List<GMTDateInput> dateInputs) {
        Integer offsetHours = 10; // Offset in hours
        List<GMTDateOutput> modifiedDates = new List<GMTDateOutput>();

        if (dateInputs != null && !dateInputs.isEmpty()) {
            for (GMTDateInput input : dateInputs) {
                if (input.gmtDate != null) {
                    Datetime modifiedDate = input.gmtDate.addHours(offsetHours);
                    // You can use other methods like addMinutes, addDays, etc., based on your requirement.

                    modifiedDates.add(new GMTDateOutput(modifiedDate));
                }
            }
        }

        return modifiedDates;
    }

    public class GMTDateInput {
        @InvocableVariable(required=true)
        public Datetime gmtDate;
    }

    public class GMTDateOutput {
        @InvocableVariable
        public Datetime modifiedGMTDate;

        public GMTDateOutput(Datetime modifiedGMTDate) {
            this.modifiedGMTDate = modifiedGMTDate;
        }
    }
}