/***************************************************************************************
* @description       : Apex Test Class for CreateRenewalLWC class
* @author            : Roshan Jambhule - Bluvium
* @group             : Ashwini Singh - Sr.Solution Architect
: Rahul Deshmukh - Business Analyst
: Kavita Kore - Technical Lead
: Amit Aher - Sr.Salesforce Developer
: Roshan Jambhule - Salesforce Developer
: Nitesh Lande - Salesforce Developer
: Ankita Varma - Tech Assistant
* @test class        : EasyCpqQueriesTest
* @created Date      : 09-21-2023
* @last modified on  : 03-05-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
****************************************************************************************/
@isTest
public class CreateRenewLWCTest {
    
    @TestSetup
    static void prepareData(){
        List<Account> accList = TestDataFactory.createAccount();
        insert accList;
        List<Opportunity> oppoList = TestDataFactory.createOpportunity(accList);
        insert oppoList;
        List<Product2> prodList =  TestDataFactory.createProducts();
        insert prodList;
        List<PricebookEntry> pbEntry = TestDataFactory.createPricebookEntry(prodList);
        insert pbEntry;
        List<OpportunityLineItem> oLi =  TestDataFactory.createOpportunityLines(oppoList,prodList,pbEntry);
        insert oLi;
        List<SBQQ__Quote__c> quoteList =  TestDataFactory.createQuote(oppoList);
        insert quoteList;
        List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(quoteList,prodList,pbEntry);
        insert quoteLines;
        List<Order> orderList =  TestDataFactory.createOrder(quoteList);
        insert orderList;
        List<OrderItem> orderItems =  TestDataFactory.createOrderProductLines(orderList,quoteLines);
        insert orderItems;
        List<Contract> contrList = new List<Contract>();
        Contract objContr = new Contract ();
        objContr.AccountId = accList[0].Id;               
        objContr.SBQQ__Opportunity__c =oppoList[0].Id; 
        objContr.SBQQ__Quote__c =quoteList[0].id;
        objContr.Status = 'Draft';
        objContr.StartDate =Date.newInstance(2025, 1, 1);
        objContr.ContractTerm = 12;
        objContr.SBQQ__RenewalForecast__c = false;
        objContr.SBQQ__RenewalQuoted__c = false;
        objContr.SBQQ__RenewalOpportunity__c = null;
        contrList.add(objContr);
        insert contrList;        
    }    
    @isTest
    static void testGetContracts() {        
        string accId  = [SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1].id;        
        Test.startTest();        
        List<Contract> returnedContracts = CreateRenewLWC.getContracts(accId);
        Test.stopTest();
        System.assertEquals(1, returnedContracts.size(), 'Expected exactly one contract to be returned');
    }
    @isTest
    static void testgetFieldLableAndFieldAPI() {
        Test.startTest();    
        String fieldMapJson = CreateRenewLWC.getFieldLableAndFieldAPI();      
        System.assertNotEquals(null, fieldMapJson, 'Field map JSON should not be null');
        System.assertNotEquals('', fieldMapJson, 'Field map JSON should not be empty');   
        Test.stopTest();     
    }
    @isTest
    static void testRenewContractUpdateNormalExecution() { 
        string accId  = [SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1].id;
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'TestOpp2';
        objOpportunity.AccountId = accId;  
        objOpportunity.StageName = 'Prospecting';        
        objOpportunity.Description = 'Description for testing';
        objOpportunity.CloseDate = Date.newInstance(2023, 1, 1);
        insert objOpportunity;    
        List<Contract> contractList = [select id From Contract where Account.Name='Test Account1' LIMIT 1 ];
        List<Contract> updatedContractList= New List<Contract>();
        for(Contract objcontr :contractList){
            objcontr.SBQQ__RenewalForecast__c = true;
            objcontr.SBQQ__RenewalQuoted__c = true;
            updatedContractList.add(objcontr);         
        }
        update updatedContractList;
        test.startTest();
        List<Contract> returnedContracts = CreateRenewLWC.renewContractUpdate(updatedContractList,objOpportunity.id);
        test.stopTest();       
        System.assertEquals(false, returnedContracts[0].SBQQ__RenewalForecast__c,'renewal Forecast check');
        System.assertEquals(false, returnedContracts[0].SBQQ__RenewalQuoted__c,'renewal Quoted check');        
    }
    @isTest
    static void testRenewContractUpdateExceptionHandling() {
        string oppId  = [SELECT Id FROM Opportunity WHERE Name='TestOpp1' LIMIT 1].id; 
        List<Contract> contractList = [select id,SBQQ__RenewalForecast__c,SBQQ__RenewalQuoted__c,SBQQ__RenewalOpportunity__c From Contract where Account.Name='Test Account1' LIMIT 1 ];         
        test.startTest();
        List<Contract> returnedContracts = CreateRenewLWC.renewContractUpdate(contractList,oppId);
        system.debug('returnedContracts=='+returnedContracts);
        test.stopTest();        
        System.assertEquals(false, returnedContracts[0].SBQQ__RenewalForecast__c,'renewal Forecast check');
        System.assertEquals(false, returnedContracts[0].SBQQ__RenewalQuoted__c,'renewal Quoted check'); 
    } 
    @isTest
    static void testgetCustomMetadata() {        
        test.startTest();
        BECPQ__App_Configuration__mdt metadata = CreateRenewLWC.getCustomMetadata();
        test.stopTest();        
        System.assertNotEquals(null, metadata, 'Custom metadata should not be null');        
    }
    @isTest
    static void testrenewContractExceptionExecution() {     
        List<Contract> contractList = [select id,SBQQ__Opportunity__c,SBQQ__Quote__c,AccountId From Contract where Account.Name='Test Account1' LIMIT 1 ];             
        test.startTest();      
        String quoteId = CreateRenewLWC.renewContract(contractList[0].id,
                                                      contractList[0].SBQQ__Opportunity__c,
                                                      contractList,
                                                      contractList[0].SBQQ__Opportunity__c,
                                                      contractList[0].SBQQ__Quote__c,
                                                      contractList[0].AccountId);
        test.stopTest();        
        System.assertNotEquals(null, quoteId, 'Quote ID should not be null');
        System.assertNotEquals('', quoteId, 'Quote ID should not be empty');        
    }
    @isTest
    static void testrenewContractNormalExecution() {
        string accId  = [SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1].id; 
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'TestOpp2';
        objOpportunity.AccountId = accId;  
        objOpportunity.StageName = 'Prospecting';        
        objOpportunity.Description = 'Description for testing';
        objOpportunity.CloseDate = Date.newInstance(2023, 1, 1);
        insert objOpportunity;        
        List<Contract> contractList = [select id,SBQQ__Opportunity__c,SBQQ__Quote__c,AccountId From Contract where Account.Name='Test Account1' LIMIT 1 ];             
        test.startTest();      
        String quoteId = CreateRenewLWC.renewContract(contractList[0].id,
                                                      objOpportunity.id,
                                                      contractList,
                                                      contractList[0].SBQQ__Opportunity__c,
                                                      contractList[0].SBQQ__Quote__c,
                                                      contractList[0].AccountId);
        test.stopTest();        
        System.assertNotEquals(null, quoteId, 'Quote ID should not be null');
        System.assertNotEquals('', quoteId, 'Quote ID should not be empty');        
    }    
}