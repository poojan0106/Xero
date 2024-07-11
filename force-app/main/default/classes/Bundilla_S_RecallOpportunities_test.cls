@istest
public class Bundilla_S_RecallOpportunities_test {
	@isTest
    public static void testMethod1(){
        String CRON_EXP = '0 0 0 15 3 ? *';

        Test.startTest();
       
        String jobId = System.schedule('Bundilla_S_RecallOpportunities',  CRON_EXP, new Bundilla_S_RecallOpportunities());

       	Test.stopTest();
    }
}