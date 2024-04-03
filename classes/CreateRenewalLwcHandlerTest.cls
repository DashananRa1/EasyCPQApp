/***************************************************************************************
* @description       : Apex Test Class for CreateRenewalLwcHandler
* @author            : Nitesh Lande - Bluvium
* @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita Varma - Tech Assistant
* @test class        : EasyCpqQueriesTest
* @created Date      : 02-04-2024
* @last modified on  : 02-04-2024
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
****************************************************************************************/
@isTest
public with sharing class CreateRenewalLwcHandlerTest {
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
        quoteList[0].SBQQ__LineItemsGrouped__c=true;
        update quoteList;
        List<SBQQ__QuoteLineGroup__c> grouplist = new List<SBQQ__QuoteLineGroup__c>(); 
        SBQQ__QuoteLineGroup__c newItem = new SBQQ__QuoteLineGroup__c();
        newItem.SBQQ__Number__c = 1;
        newItem.SBQQ__NetTotal__c = 1000;
        newItem.SBQQ__ListTotal__c = 1000;
        newItem.SBQQ__CustomerTotal__c = 1000;
        newItem.Name = 'Group 1';
        newItem.SBQQ__Quote__c = quoteList[0].id;
        grouplist.add(newItem);        
        insert grouplist;
        List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(quoteList,prodList,pbEntry);
        insert quoteLines;
        quoteLines[0].SBQQ__Group__c=grouplist[0].id;
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
    static void toMaintQlgrpNormalExecution() { 
        string accId  = [SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1].id;
        string groupName  = [SELECT Id,Name FROM SBQQ__QuoteLineGroup__c WHERE Name='Group 1' LIMIT 1].Name;
        List<Contract> contracts  = [SELECT Id,SBQQ__Quote__c FROM Contract WHERE Status='Draft' LIMIT 1];
        List<Product2> prodlist  = [SELECT Id,Name,SBQQ__SubscriptionTerm__c FROM Product2 WHERE Name ='Test Data Factory Product 1' LIMIT 1];
        List<PricebookEntry> pbEntry  = [SELECT Id FROM PricebookEntry WHERE IsActive = true LIMIT 1];
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'TestOpp2';
        objOpportunity.AccountId = accId;  
        objOpportunity.StageName = 'Prospecting';        
        objOpportunity.Description = 'Description for testing';
        objOpportunity.CloseDate = Date.newInstance(2023, 1, 1);
        objOpportunity.SBQQ__RenewedContract__c = Contracts[0].id;
        objOpportunity.SBQQ__Renewal__c =true;
        insert objOpportunity;        
        List<SBQQ__Quote__c> quotelist = new List<SBQQ__Quote__c>();
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Opportunity2__c =objOpportunity.Id;
        quote.SBQQ__Account__c      = accId;                        
        quote.SBQQ__StartDate__c    = Date.newInstance(2024, 1, 1);
        quote.SBQQ__EndDate__c      = Date.newInstance(2025, 12, 31);
        quote.SBQQ__Status__c       = 'Draft';
        quote.SBQQ__Type__c         = 'Renewal';
        quote.SBQQ__Primary__c      = true;
        quote.SBQQ__PriceBook__c    = Test.getStandardPricebookId();                    
        quotelist.add(quote);        
        insert quotelist;        

        List<SBQQ__QuoteLine__c> qlinelist = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qline1 = new SBQQ__QuoteLine__c();
        qline1.SBQQ__Quote__c = quotelist[0].id;
        qline1.SBQQ__StartDate__c = Date.newInstance(2024, 04, 01);
        qline1.SBQQ__EndDate__c = Date.newInstance(2025, 03, 31);
        qline1.SBQQ__Quantity__c = 1;
        qline1.SBQQ__Product__c = Prodlist[0].Id;
        qline1.SBQQ__DefaultSubscriptionTerm__c = Prodlist[0].SBQQ__SubscriptionTerm__c;
        qline1.SBQQ__ListPrice__c = 1000;
        qline1.SBQQ__PricebookEntryId__c = pbEntry[0].id;
        qline1.SBQQ__Existing__c = false;
        qline1.SBQQ__CarryoverLine__c = false;
        qline1.SBQQ__SubscriptionPricing__c ='Fixed Price';
        qlinelist.add(qline1);
        insert qlinelist;
        test.startTest();
        CreateRenewalLwcHandler.toMaintainQlGrp(Contracts,quotelist[0].id);
        test.stopTest(); 
        List<SBQQ__QuoteLine__c> updatedQlList =[select Id ,
                                            SBQQ__Group__c,
                                            SBQQ__Quote__c from SBQQ__QuoteLine__c WHERE
                                            SBQQ__Quote__c=:quotelist[0].id];      
        System.assertEquals(groupName, 'Group 1','check Group Id in Quoteline');
               
    }
}