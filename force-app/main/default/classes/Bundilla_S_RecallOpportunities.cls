global class Bundilla_S_RecallOpportunities implements Schedulable {
	global void execute(SchedulableContext sc) {
        Bundilla_B_RecallOpportunity recallBatch = new Bundilla_B_RecallOpportunity();
		database.executebatch(recallBatch,150);
    }
}