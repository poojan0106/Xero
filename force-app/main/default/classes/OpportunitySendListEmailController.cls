public class OpportunitySendListEmailController {
    public List<Id> opportunityIds {get; set;}
    
    // Updated constructor
    public OpportunitySendListEmailController(ApexPages.StandardSetController controller) {
        List<Opportunity> selectedOpportunities = (List<Opportunity>)controller.getSelected();
        opportunityIds = new List<Id>();
        for (Opportunity opp : selectedOpportunities) {
            opportunityIds.add(opp.Id);
        }
    }

    public PageReference sendListEmail() {
        List<Opportunity> opportunities = [
            SELECT Id, ContactId
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ];
        
        List<Id> contactIds = new List<Id>();
        for (Opportunity opp : opportunities) {
            contactIds.add(opp.ContactId);
        }
        
        PageReference pr = new PageReference('/lightning/o/Contact/list?filterName=Recent&action=listEmail');
        pr.getParameters().put('ids', String.join(contactIds, ','));
        return pr;
    }
}