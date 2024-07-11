/**
 * Created by mgladman on 20/10/2017.
 */
/*
 * Edited by aho on 24/10/2017. To add Calculation the sum duration from WorkOrderLineItem to WorkOrder 
 */
public class Bundilla_A_CopySkillsFromLineItem {

	@InvocableMethod(label='Copy Skills From Line Item To Work Order' description='')
	public static void copySkillsFromLineItem (List<Id> workOrderIds) {

		Map<Id, WorkOrderLineItem> workOrderLineItems = new Map<Id, WorkOrderLineItem>(
			[SELECT Id, WorkOrderId, Duration, DurationType,workorder.Duration, 
             workorder.Opportunity__c, WorkOrder.Opportunity__r.WO_Time__c 
             FROM WorkOrderLineItem WHERE WorkOrderId = :workOrderIds]
		);
        
        //Added by aho on 24/10/2017.
        Map<Id, WorkOrder> workOrders = new Map<Id, WorkOrder>();
        For(string i : workOrderLineItems.keyset()){
            
            If(workOrders.containskey(workOrderLineItems.get(i).WorkOrderId)){
                workOrder tmp = new workorder();
                tmp = workOrders.get(workOrderLineItems.get(i).WorkOrderId);
               
                if(workOrderLineItems.get(i).WorkOrder.Opportunity__c== null || workOrderLineItems.get(i).WorkOrder.Opportunity__r.WO_Time__c ==null)//added by princee on 21-03-23
                {
                    system.debug('princee test 1 if');
                    If(workOrderLineItems.get(i).DurationType == 'Minutes' && workOrderLineItems.get(i).Duration != 0){
                        Try{
                            tmp.duration = tmp.duration + workOrderLineItems.get(i).Duration/60;
                        } Catch (Exception e){
                            System.debug('The following exception has occurred: ' + e.getMessage());
                        }
                    }Else{
                        Try{
                            tmp.duration = tmp.duration + workOrderLineItems.get(i).Duration;
                        } Catch (Exception e){
                            System.debug('The following exception has occurred: ' + e.getMessage());
                        }
                    }
                    
                }
               else
                {
                    system.debug('princee test 2 else');

                    tmp.duration = workOrderLineItems.get(i).WorkOrder.Opportunity__r.WO_Time__c ;
                }
                workOrders.put(workOrderLineItems.get(i).WorkOrderId, tmp);
            } Else {
                If(workOrderLineItems.get(i).WorkOrder.Opportunity__r.WO_Time__c ==null){
                    system.debug('princee test 3 if');

                    If(workorderlineitems.get(i).DurationType == 'Minutes' && workOrderLineItems.get(i).Duration != 0){
                        workOrders.put(workOrderLineItems.get(i).WorkOrderId, new workOrder(Id = workOrderLineItems.get(i).WorkOrderId, duration = workOrderLineItems.get(i).Duration/60, durationType = 'Hours'));
                        
                    }Else{
                        If(workOrderLineItems.get(i).Duration == NULL){
                            workOrders.put(workOrderLineItems.get(i).WorkOrderId, new workOrder(Id = workOrderLineItems.get(i).WorkOrderId, duration = 0, durationType = 'Hours'));
                        } Else{
                            workOrders.put(workOrderLineItems.get(i).WorkOrderId, new workOrder(Id = workOrderLineItems.get(i).WorkOrderId, duration = workOrderLineItems.get(i).Duration, durationType = 'Hours'));
                        }
                    }
                }
                else
                {
                    system.debug('princee test 4 else');

                    workOrders.put(workOrderLineItems.get(i).WorkOrderId, new workOrder(Id = workOrderLineItems.get(i).WorkOrderId,
                                                                                        duration =workOrderLineItems.get(i).WorkOrder.Opportunity__r.WO_Time__c, 
                                                                                        durationType = 'Hours'));
                }
                
            }
        }
        update workOrders.values();
        //====================================================
        
		System.debug(workOrderLineItems);
		List<SkillRequirement> skillRequirements = [
			SELECT Id, SkillId, SkillLevel, SkillNumber, RelatedRecordId
			FROM SkillRequirement
			WHERE RelatedRecordId = :workOrderLineItems.values()
		];

		List<SkillRequirement> skillRequirementsToAdd = [SELECT Id, RelatedRecordId, SkillId FROM SkillRequirement WHERE RelatedRecordId = :workOrderIds];
		System.debug(skillRequirementsToAdd);
		for(SkillRequirement skillRequirement : skillRequirements){
			SkillRequirement newSkillRequirement = new SkillRequirement(
				SkillId = skillRequirement.SkillId,
				SkillLevel = skillRequirement.SkillLevel
			);
			System.debug(newSkillRequirement);
			newSkillRequirement.RelatedRecordId = workOrderLineItems.get(skillRequirement.RelatedRecordId).WorkOrderId;
			skillRequirementsToAdd.add(newSkillRequirement);
		}

		// Bulk safe de-dupe without lookups
		for(Integer i = skillRequirementsToAdd.size() - 1; i >= 0; i--){
			for(Integer j = skillRequirementsToAdd.size() - 1; j >= 0; j--){
				// Fix up weird odditys that might happens from removing elements
				try{
					if(i >= skillRequirementsToAdd.size() || j >= skillRequirementsToAdd.size()){
						continue;
					}

					// Don't check against itself
					if(i == j){
						continue;
					}

					// Finally, skip duplicate skills
					if(skillRequirementsToAdd[i].RelatedRecordId == skillRequirementsToAdd[j].RelatedRecordId
						&& skillRequirementsToAdd[i].SkillId ==  skillRequirementsToAdd[j].SkillId && skillRequirementsToAdd[j].Id == null){
						System.debug('Skipped');
						skillRequirementsToAdd.remove(j);
						continue;
					}
				}catch(Exception e){
					System.debug(e);
				}
			}
		}

		System.debug(skillRequirementsToAdd);

		Database.upsert(skillRequirementsToAdd, false);

	}

}