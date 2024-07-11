@isTest
public class WorkOrderTrigger_test {
    @isTest
    public static void testMethod1(){
        Test.setMock(HttpCalloutMock.class, new QKXERO_Mock.GenericXeroContactSuccess());
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'test';
        pb.IsActive = true;
        insert pb;
        
        OperatingHours op = new OperatingHours();
        op.Name = 'OP1';
        insert op;
        
        ServiceTerritory st = new ServiceTerritory();
        st.Name = 'ST1';
        st.OperatingHoursId = op.Id;
        st.IsActive = true;
        insert st;
        
        ZipCode__c zc = new ZipCode__c();
        zc.Name = '4001';
        zc.Service_Territory__c = st.id;
        insert zc;
        
        zc.Name = '4002';
        update zc;
        
        setXeroSettings();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.type = 'Commercial';
        acc.Payment_Term__c = 11;
        insert acc;
        
        Contact con = new Contact();
        con.lastname = 'testLastName';
        insert con;
        
        Asset ast = new Asset();
        ast.AccountId = acc.id;
        ast.Zip_Postal_Code__c='4002';
        ast.City__c = 'test';
        ast.Name = 'testAsset';
        ast.State_Province__c = 'Queensland';
        ast.Street__c = 'test';
        ast.Country__c = 'Australia';
        insert ast;
        
        ast.Zip_Postal_Code__c='0001';
        update ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Subject = 'Test';
        wo.Pricebook2Id = pb.Id;
        wo.AccountId = acc.Id;
        wo.ContactId = con.Id;
        wo.PostalCode = '4003';
        insert wo;
        WorkOrderTriggerRecursiveHandler.isFirstTime = true;
       
        wo.Subject = 'Test1234';
        wo.PostalCode = '22222';
        update wo;
        System.assertEquals(1,[SELECT Id FROM WorkOrder WHERE PostalCode = '22222'].size());
    }

    static void setXeroSettings(){
        QKXERO_Private_App__c settings = new QKXERO_Private_App__c(
            Consumer_Key__c = '1234',
            Private_Key_ID__c = 'Xero'
        );
        insert settings;
        
    }
}