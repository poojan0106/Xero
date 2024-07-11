trigger WorkOrderTrigger on WorkOrder (after insert,after Update) {
    
           // WorkOrderTriggerRecursiveHandler.isFirstTime = false;
        
        List<WorkOrder> wo = [Select id,Address,PostalCode,ServiceTerritoryId,
                              Opportunity__c,Opportunity__r.Work_Order_Notes__c,
                              Opportunity__r.WO_Time__c,Duration,Description from WorkOrder where id in :Trigger.New];
        List<ServiceTerritory> serTerritory = [select id,(Select id,name,Description__c,Service_Territory__c from ZipCode__r) from serviceTerritory];
        List<WorkOrder> updateWOList = new List<WorkOrder>();
        
        Map<String,Id> ZipCodes = new Map<String,Id>(); 
        for(ServiceTerritory st : serTerritory)
        {
            for(ZipCode__c zc : st.ZipCode__r)
            {
                ZipCodes.put(zc.Name,zc.Service_Territory__c);
            }
        }
        System.debug('----ZipCodes----'+ZipCodes);
        System.debug('----wo[0].PostalCode----'+wo[0].PostalCode);
        System.debug('----woSize----'+wo.size());
        System.debug('----wo----'+wo);
        System.debug('After Update check'+TRIGGER.ISAFTER);
        System.debug('After Update check'+TRIGGER.ISUPDATE);
        if(Trigger.isUpdate && Trigger.isAfter)
        {
            System.debug('inside update');
            /*  static code 
            if(wo[0].PostalCode!=null && wo[0].PostalCode!=Trigger.oldMap.get(wo[0].id).PostalCode)
            {
                System.debug('Yogi9904');
                System.debug('----Trigger.oldMap.get(wo[0].id).PostalCode----'+Trigger.oldMap.get(wo[0].id).PostalCode);
                WorkOrder updateWO = new WorkOrder();
                updateWO.Id = wo[0].Id;
                updateWO.ServiceTerritoryId = ZipCodes.get(wo[0].PostalCode);
                updateWOList.add(updateWO);
                
            } */
            
            // bulkified code 
            for(WorkOrder worrd  : wo)
            {
                System.debug('00Yogi99:-'+worrd.PostalCode);
                if(worrd.PostalCode!=null && wo[0].PostalCode!=Trigger.oldMap.get(wo[0].id).PostalCode){
                    System.debug('----Trigger.oldMap.get(workOrder.id).PostalCode----'+Trigger.oldMap.get(worrd.id).PostalCode);
                    
                    WorkOrder updateWO = new WorkOrder();
                    updateWO.Id = worrd.Id;
                    updateWO.ServiceTerritoryId = ZipCodes.get(worrd.PostalCode);
                    updateWOList.add(updateWO);
                }
            }
            
            if(updateWOList.size()>0)
            {
                update updateWOList;
            } 
        }  
    
    if(Trigger.isInsert)
    {
        List<WorkOrder> updateWOList = new List<WorkOrder>();
        
        for(WorkOrder worrd  : wo)
        {
            if(worrd.Opportunity__c!=null && worrd.Opportunity__r.Work_Order_Notes__c!=null &&  worrd.Description!=  worrd.Opportunity__r.Work_Order_Notes__c)
                worrd.Description=  worrd.Opportunity__r.Work_Order_Notes__c;
            
            if(worrd.Opportunity__c!=null && worrd.Opportunity__r.WO_Time__c!=null &&  worrd.Duration!=  worrd.Opportunity__r.WO_Time__c)
                worrd.Duration=  worrd.Opportunity__r.WO_Time__c;
            
            updateWOList.add(worrd);
        }
        if(updateWOList.size()>0)
        {
            update updateWOList;
        } 
    }
}