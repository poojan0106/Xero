trigger LeadTrigger on Lead (after Update) {
	List<Lead> le = [Select id,Status,PostalCode from lead where id in : Trigger.New];
    System.debug('----le[0]----'+le[0]);
    if(le[0].status!=Trigger.oldMap.get(le[0].id).status && le[0].status=='Qualified')
    {
        System.debug('---lead qualified----');
        List<ServiceTerritory> serTerritory = [select id,(Select id,name,Description__c,Service_Territory__c from ZipCode__r) from serviceTerritory];
        Map<String,Id> ZipCodes = new Map<String,Id>(); 
        for(ServiceTerritory st : serTerritory)
        {
            for(ZipCode__c zc : st.ZipCode__r)
            {
                ZipCodes.put(zc.Name,zc.Service_Territory__c);
            }
        }
        System.debug('----ZipCodes----'+ZipCodes);
        System.debug('---le[0].PostalCode---'+le[0].PostalCode);
        System.debug('----check true---'+ZipCodes.keySet().contains(le[0].PostalCode));
        if(!ZipCodes.keySet().contains(le[0].PostalCode))
        {
            Trigger.new[0].addError('Post Code '+le[0].PostalCode+' not within our Service Area');
        }
        

    }
}