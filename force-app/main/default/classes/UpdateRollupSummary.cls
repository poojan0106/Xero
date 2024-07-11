global class UpdateRollupSummary implements Schedulable{
	global void execute(SchedulableContext SC) {
      PopulateRollUpSummaryOnAccount M = new PopulateRollUpSummaryOnAccount(); 
      Database.executeBatch(M);
   }
}