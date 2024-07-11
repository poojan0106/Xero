@isTest
public class OpportunityTrigger_test {
    @testSetup
    static void testData(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Sum_Revenue_Last_912_to_1500_Days__c = 10;
        acc.Sum_Revenue_Last_455_Days__c = 10;
        acc.Sum_Revenue_Last_455_to_912_Days__c = 10;
        insert acc;
        
        Contact con = new Contact();
        con.lastName = 'test';
        insert con;
        
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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
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
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'test123';
        opp1.AccountId = acc.id;
        opp1.Primary_Contact__c = con.id;
        opp1.Amount = 1000;
        opp1.StageName = 'Qualification';
        opp1.CloseDate = System.today()-510;
        insert opp1;
        
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.OpportunityId = opp1.id;
        oli1.Product2Id = pro.id;
        oli1.PricebookEntryId = pbe.id;
        oli1.Quantity = 1;
        oli1.TotalPrice = 1000;
        insert oli1;
        
        Opportunity opp3 = new Opportunity();
        opp3.id = opp1.id;
        opp3.StageName = 'Closed Won';
        update opp3;
        
        Opportunity opp11 = new Opportunity();
        opp11.Name = 'test12';
        opp11.AccountId = acc.id;
        opp11.Primary_Contact__c = con.id;
        opp11.Amount = 1000;
        opp11.StageName = 'Qualification';
        opp11.CloseDate = System.today()-1210;
        insert opp11;
        
        OpportunityLineItem oli11 = new OpportunityLineItem();
        oli11.OpportunityId = opp11.id;
        oli11.Product2Id = pro.id;
        oli11.PricebookEntryId = pbe.id;
        oli11.Quantity = 1;
        oli11.TotalPrice = 1000;
        insert oli11;
        
        Opportunity opp4 = new Opportunity();
        opp4.id = opp11.id;
        opp4.StageName = 'Closed Won';
        update opp4;
        
    } 
    
    @isTest
    Static void testmethod1(){
        Opportunity deleteOpp = [Select id,name from Opportunity where name = 'test'];
        delete deleteOpp;
    }
    @isTest
    static void testMethod2(){
        Opportunity opp1 = [select id from Opportunity where name = 'test12'];
        Opportunity opp2 = new Opportunity();
        opp2.id = opp1.id;
        opp2.StageName = 'Qualification';
        update opp2;
    }
    
}