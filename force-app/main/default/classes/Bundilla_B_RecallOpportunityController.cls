public class Bundilla_B_RecallOpportunityController {
    public Bundilla_B_RecallOpportunityController(ApexPages.StandardController controller){
    }
    public void callBatch(){
        System.debug('batch call:: ');
        Bundilla_B_RecallOpportunity recallBatch = new Bundilla_B_RecallOpportunity();
        database.executebatch(recallBatch,150);
    } 
    
}