/**
 * Created by mgladman on 20/10/2017.
 */
@IsTest
private class Bundilla_Tests {
    
	@isTest(seeAllData=true)// See All Data is required to get skills, they cannot be creted!!! Wtf
	static void testCopySkillsFromLineItem(){
		//Test.setMock(WebServiceMock.class, new Bundilla_WebserviceMock());
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());
		Account account = new Account(
			Name = 'Test1'
		);
		insert account;

		Contact contact = new Contact(
			AccountId = account.Id,
			LastName = 'Test'
		);
		insert contact;
		
        WorkOrder workOrder = new WorkOrder(
			Subject = 'Test',
			Pricebook2Id = Test.getStandardPricebookId(),
			AccountId = account.Id,
			ContactId = contact.Id
		);
		insert workOrder;

		list<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();

        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours'
		));
        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours'
		));
        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Minutes'
		));
		insert workOrderLineItems;

		//insert skill;
		List<Skill> skills = [SELECT Id FROM Skill LIMIT 1];

		SkillRequirement skillRequirement = new SkillRequirement(
			RelatedRecordId = workOrderLineItems[0].Id,
			SkillId = skills[0].Id
		);

		insert skillRequirement;


		Test.startTest();
			Bundilla_A_CopySkillsFromLineItem.copySkillsFromLineItem(new List<Id>{workOrder.Id});
		Test.stopTest();

	}
    
    @isTest(seeAllData=true)// See All Data is required to get skills, they cannot be creted!!! Wtf
	static void testCopySkillsFromLineItem1(){
		//Test.setMock(WebServiceMock.class, new Bundilla_WebserviceMock());
		Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());
		Account account = new Account(
			Name = 'Test2'
		);
		insert account;

		Contact contact = new Contact(
			AccountId = account.Id,
			LastName = 'Test'
		);
		insert contact;
        
        Opportunity opp = new Opportunity(
        	Name = 'Test',
            AccountId = account.id,
            WO_Time__c = 1,
            StageName = 'Processing',
            CloseDate = date.today().addDays(2)
        );
        insert opp;
		
        WorkOrder workOrder = new WorkOrder(
			Subject = 'Test',
			Pricebook2Id = Test.getStandardPricebookId(),
			AccountId = account.Id,
			ContactId = contact.Id,
            Opportunity__c = opp.id
		);
		insert workOrder;

		list<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();

        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours'
		));
        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Hours'
		));
        workOrderLineItems.add(new WorkOrderLineItem(
			WorkOrderId = workOrder.Id,
            Duration = 1,
            DurationType = 'Minutes'
		));
		insert workOrderLineItems;

		//insert skill;
		List<Skill> skills = [SELECT Id FROM Skill LIMIT 1];

		SkillRequirement skillRequirement = new SkillRequirement(
			RelatedRecordId = workOrderLineItems[0].Id,
			SkillId = skills[0].Id
		);

		insert skillRequirement;


		Test.startTest();
			Bundilla_A_CopySkillsFromLineItem.copySkillsFromLineItem(new List<Id>{workOrder.Id});
		Test.stopTest();

	}
}