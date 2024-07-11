@isTest
public class LeadTrigger_test {
	@istest
    public static void testmethod1(){
        OperatingHours op = new OperatingHours();
        op.Name = 'OP1';
        insert op;
        
        ServiceTerritory st = new ServiceTerritory();
        st.Name = 'ST1';
        st.OperatingHoursId = op.Id;
        st.IsActive = true;
        insert st;
        
        ZipCode__c zc = new ZipCode__c();
        zc.Name = '4002';
        zc.Service_Territory__c = st.id;
        insert zc;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.lastname = 'testLastName';
        insert con;
        
        Lead l = new Lead();
        l.Status = 'New';
        l.lastName = 'test';
        l.Company = 'test';
        l.LeadSource = 'Google';
       	insert l;
        
        Lead l2 = new Lead();
        l2.Status='Qualified';
        l2.Id=l.Id;
        l2.PostalCode = '4002';
        update l2;
    }
}