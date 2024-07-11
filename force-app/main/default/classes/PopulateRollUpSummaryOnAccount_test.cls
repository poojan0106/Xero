@isTest
public class PopulateRollUpSummaryOnAccount_test {
    
    @isTest
    static void testData(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc.Sum_Revenue_Last_455_Days__c = 10;
        acc.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'test 1';
        acc1.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc1.Sum_Revenue_Last_455_Days__c = 10;
        acc1.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc1;
        
        Contact con = new Contact();
        con.lastName = 'test';
        con.AccountId= acc.Id;
        insert con;
        
        acc.Billing_Contact__c  =  con.id;
        update acc;
        WorkType wt = new WorkType();
        wt.Name = 'test';
        wt.EstimatedDuration = 22.22;
        insert wt;
        
        Product2 pro = new Product2();
        pro.Name = 'test';
        pro.Work_Type__c = wt.id;
        insert pro;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Standard Price Book';
        pb.IsActive= true;
        insert pb;
        
        Id Pricebookid = Test.getStandardPricebookId();
        
        Pricebookentry pbe = new Pricebookentry();
        pbe.Pricebook2Id = Pricebookid;
        pbe.product2id = pro.Id;
        pbe.UnitPrice = 123;
        pbe.isActive = true;
        insert pbe;
        
        Asset testAsst = new Asset();
        testAsst.AccountId= acc.id;
        testAsst.Name='Test Asset';
        testAsst.Street__c='dffg';
        testAsst.City__c='dfgh';
        testAsst.State_Province__c='Victoria';
        testAsst.Country__c='Australia';
        testAsst.Zip_Postal_Code__c='007';
        insert testAsst;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.Asset__c = testAsst.Id;
        opp.AccountId = acc.id;
        opp.Primary_Contact__c = con.id;
        opp.Amount = 1000;
        opp.StageName = 'Qualification';
        opp.CloseDate = System.today()-10;
        insert opp;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        oli.Product2Id = pro.id;
        oli.PricebookEntryId = pbe.id;
        oli.Quantity = 1;
        oli.TotalPrice = 1000;
        insert oli;
        
        Opportunity opp2 = new Opportunity();
        opp2.id = opp.id; 
        opp2.StageName = 'Closed Won';
        update opp2;
        
        Opportunity opp12 = new Opportunity();
        opp12.Name = 'test1';
        opp12.AccountId = acc.id;
        opp12.Asset__c = testAsst.Id;
        opp12.Primary_Contact__c = con.id;
        opp12.Amount = 1000;
        opp12.StageName = 'Qualification';
        opp12.CloseDate = System.today()-12;
        insert opp12;
        
        OpportunityLineItem oli12 = new OpportunityLineItem();
        oli12.OpportunityId = opp12.id;
        
        oli12.Product2Id = pro.id;
        oli12.PricebookEntryId = pbe.id;
        oli12.Quantity = 1;
        oli12.TotalPrice = 1000;
        insert oli12;
        
        Opportunity opp112 = new Opportunity();
        opp112.id = opp12.id;
        opp112.StageName = 'Closed Won';
        update opp112;
        
        
        
        Test.startTest();
        PopulateRollUpSummaryOnAccount obj = new PopulateRollUpSummaryOnAccount();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    } 

    @isTest
    static void testData3(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc.Sum_Revenue_Last_455_Days__c = 10;
        acc.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'test 1';
        acc1.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc1.Sum_Revenue_Last_455_Days__c = 10;
        acc1.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc1;
        
        Contact con = new Contact();
        con.lastName = 'test';
        con.AccountId= acc.Id;
        insert con;
        
        acc.Billing_Contact__c  =  con.id;
        update acc;
        WorkType wt = new WorkType();
        wt.Name = 'test';
        wt.EstimatedDuration = 22.22;
        insert wt;
        
        Product2 pro = new Product2();
        pro.Name = 'test';
        pro.Work_Type__c = wt.id;
        insert pro;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Standard Price Book';
        pb.IsActive= true;
        insert pb;
        
        Id Pricebookid = Test.getStandardPricebookId();
        
        Pricebookentry pbe = new Pricebookentry();
        pbe.Pricebook2Id = Pricebookid;
        pbe.product2id = pro.Id;
        pbe.UnitPrice = 123;
        pbe.isActive = true;
        insert pbe;
        
        Asset testAsst = new Asset();
        testAsst.AccountId= acc.id;
        testAsst.Name='Test Asset';
        testAsst.Street__c='dffg';
        testAsst.City__c='dfgh';
        testAsst.State_Province__c='Victoria';
        testAsst.Country__c='Australia';
        testAsst.Zip_Postal_Code__c='007';
        insert testAsst;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.Asset__c = testAsst.Id;
        opp.AccountId = acc.id;
        opp.Primary_Contact__c = con.id;
        opp.Amount = 1000;
        opp.StageName = 'Qualification';
        opp.CloseDate = System.today()-500;
        insert opp;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        oli.Product2Id = pro.id;
        oli.PricebookEntryId = pbe.id;
        oli.Quantity = 1;
        oli.TotalPrice = 1000;
        insert oli;
        
        Opportunity opp2 = new Opportunity();
        opp2.id = opp.id; 
        opp2.StageName = 'Closed Won';
        update opp2;
        
        Opportunity opp121 = new Opportunity();
        opp121.Name = 'test1';
        opp121.AccountId = acc.id;
		opp121.Asset__c = testAsst.Id;
        opp121.Primary_Contact__c = con.id;
        opp121.Amount = 1000;
        opp121.StageName = 'Qualification';
        opp121.CloseDate = System.today()-510;
        insert opp121;
        
        OpportunityLineItem oli122 = new OpportunityLineItem();
        oli122.OpportunityId = opp121.id;
        oli122.Product2Id = pro.id;
        oli122.PricebookEntryId = pbe.id;
        oli122.Quantity = 1;
        oli122.TotalPrice = 1000;
        insert oli122;
        
        Opportunity opp1122 = new Opportunity();
        opp1122.id = opp121.id;
        opp1122.StageName = 'Closed Won';
        update opp1122;
        
        Test.startTest();
        PopulateRollUpSummaryOnAccount obj = new PopulateRollUpSummaryOnAccount();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
    @isTest
    static void testData4(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc.Sum_Revenue_Last_455_Days__c = 10;
        acc.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'test 1';
        acc1.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc1.Sum_Revenue_Last_455_Days__c = 10;
        acc1.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc1;
        
        Contact con = new Contact();
        con.lastName = 'test';
        con.AccountId= acc.Id;
        insert con;
        
        acc.Billing_Contact__c  =  con.id;
        update acc;
        WorkType wt = new WorkType();
        wt.Name = 'test';
        wt.EstimatedDuration = 22.22;
        insert wt;
        
        Product2 pro = new Product2();
        pro.Name = 'test';
        pro.Work_Type__c = wt.id;
        insert pro;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Standard Price Book';
        pb.IsActive= true;
        insert pb;
        
        Id Pricebookid = Test.getStandardPricebookId();
        
        Pricebookentry pbe = new Pricebookentry();
        pbe.Pricebook2Id = Pricebookid;
        pbe.product2id = pro.Id;
        pbe.UnitPrice = 123;
        pbe.isActive = true;
        insert pbe;
        
        Asset testAsst = new Asset();
        testAsst.AccountId= acc.id;
        testAsst.Name='Test Asset';
        testAsst.Street__c='dffg';
        testAsst.City__c='dfgh';
        testAsst.State_Province__c='Victoria';
        testAsst.Country__c='Australia';
        testAsst.Zip_Postal_Code__c='007';
        insert testAsst;
        
        Asset testAsst2 = new Asset();
        testAsst2.AccountId= acc1.id;
        testAsst2.Name='Test Asset';
        testAsst2.Street__c='dffg';
        testAsst2.City__c='dfgh';
        testAsst2.State_Province__c='Victoria';
        testAsst2.Country__c='Australia';
        testAsst2.Zip_Postal_Code__c='007';
        insert testAsst2;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.Asset__c = testAsst.Id;
        opp.AccountId = acc.id;
        opp.Primary_Contact__c = con.id;
        opp.Amount = 1000;
        opp.StageName = 'Qualification';
        opp.CloseDate = System.today()-1210;
        insert opp;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        oli.Product2Id = pro.id;
        oli.PricebookEntryId = pbe.id;
        oli.Quantity = 1;
        oli.TotalPrice = 1000;
        insert oli;
        
        Opportunity opp2 = new Opportunity();
        opp2.id = opp.id; 
        opp2.StageName = 'Closed Won';
        update opp2;
        
        Opportunity opp12112 = new Opportunity();
        opp12112.Name = 'test1';
        opp12112.AccountId = acc.id;
		opp12112.Asset__c = testAsst.Id;
        opp12112.Primary_Contact__c = con.id;
        opp12112.Amount = 1000;
        opp12112.StageName = 'Qualification';
        opp12112.CloseDate = System.today()-1500;
        insert opp12112;
        
        OpportunityLineItem oli12212 = new OpportunityLineItem();
        oli12212.OpportunityId = opp12112.id;
        oli12212.Product2Id = pro.id;
        oli12212.PricebookEntryId = pbe.id;
        oli12212.Quantity = 1;
        oli12212.TotalPrice = 1000;
        insert oli12212;
        
        Opportunity opp112221 = new Opportunity();
        opp112221.id = opp12112.id;
        opp112221.StageName = 'Closed Won';
        update opp112221;
        
        Test.startTest();
        PopulateRollUpSummaryOnAccount obj = new PopulateRollUpSummaryOnAccount();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
   
    @isTest
    static void testMethod3(){
        Test.startTest();
        UpdateRollupSummary sh1 = new UpdateRollupSummary();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
    }


}