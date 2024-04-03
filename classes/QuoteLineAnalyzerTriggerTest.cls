/***************************************************************************************
 * @description       : This test class is on PlatformEvent for maintaining the Group and Groupline for Amend 
 *                      and Renewal Process Platform Event
 * @author            : Kavita Kore - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : QuoteLineAnalyzerTriggerTest
 * @created Date      : 09-21-2023
 * 
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
@isTest
public class QuoteLineAnalyzerTriggerTest {
    @isTest
    static void doTest() {
        Test.startTest();
        List<Account> accList = TestDataFactory.createAccount();
        insert accList;
        
        List<Opportunity> oppoList = TestDataFactory.createOpportunity(accList);
        insert oppoList;
        List<Product2> prodList = TestDataFactory.createProducts();
        insert prodList;
        List<PricebookEntry> pbEntry = TestDataFactory.createPricebookEntry(
            prodList
        );
        insert pbEntry;
        List<OpportunityLineItem> oLi = TestDataFactory.createOpportunityLines(
            oppoList,
            prodList,
            pbEntry
        );
        insert oLi;
        List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(oppoList);
        quoteList[0].SBQQ__Type__c = 'Renewal';
        quoteList[0].SBQQ__LineItemsGrouped__c = true;
        insert quoteList;
        SBQQ__QuoteLineGroup__c newItem = new SBQQ__QuoteLineGroup__c(
            SBQQ__Number__c = 1,
            SBQQ__NetTotal__c = 200,
            SBQQ__ListTotal__c = 200,
            SBQQ__CustomerTotal__c = 200
        );
        newItem.Name = 'TestGroup';
        newItem.SBQQ__Quote__c = quoteList[0].Id; //quoteId;
        insert newItem;
        List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(
            quoteList,
            prodList,
            pbEntry
        );
        quoteLines[0].SBQQ__Group__c = newItem.Id;
        insert quoteLines;
        List<Order> orderList = TestDataFactory.createOrder(quoteList);
        insert orderList;
        List<OrderItem> orderItems = TestDataFactory.createOrderProductLines(
            orderList,
            quoteLines
        );
        insert orderItems;
        Contract c = new Contract(
            SBQQ__Opportunity__c = oppoList[0].Id,
            SBQQ__Quote__c = quoteList[0].id,
            AccountId = accList[0].Id
        );
        c.Name = 'Test Contract';
        c.AccountId = accList[0].Id;
        c.Status = 'Draft';
        insert c;
        List<SBQQ__Quote__c> child = TestDataFactory.createQuote(oppoList);
        child[0].SBQQ__Type__c = 'Renewal';
        child[0].SBQQ__MasterContract__c = c.Id;
        insert child;
        Test.stopTest();
        System.assertEquals(
            'Renewal',
            child[0].SBQQ__Type__c,
            'Name does not match'
        );
    }
    
    @isTest
    static void doDummyTest(){
        Test.startTest();
        List<Account> accList = TestDataFactory.createAccount();
        insert accList;
        
        List<Opportunity> oppoList = TestDataFactory.createOpportunity(accList);
        insert oppoList;
        List<Product2> prodList = TestDataFactory.createProducts();
        insert prodList;
        List<PricebookEntry> pbEntry = TestDataFactory.createPricebookEntry(
            prodList
        );
        insert pbEntry;
        List<OpportunityLineItem> oLi = TestDataFactory.createOpportunityLines(
            oppoList,
            prodList,
            pbEntry
        );
        insert oLi;
        List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(oppoList);
        quoteList[0].SBQQ__Type__c = 'Renewal';
        quoteList[0].SBQQ__LineItemsGrouped__c = true;
        insert quoteList;
        SBQQ__QuoteLineGroup__c newItem = new SBQQ__QuoteLineGroup__c(
            SBQQ__Number__c = 1,
            SBQQ__NetTotal__c = 200,
            SBQQ__ListTotal__c = 200,
            SBQQ__CustomerTotal__c = 200
        );
        newItem.Name = 'TestGroup';
        newItem.SBQQ__Quote__c = quoteList[0].Id; //quoteId;
        insert newItem;
        List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(
            quoteList,
            prodList,
            pbEntry
        );
        quoteLines[0].SBQQ__Group__c = newItem.Id;
        insert quoteLines;
        List<Order> orderList = TestDataFactory.createOrder(quoteList);
        insert orderList;
        List<OrderItem> orderItems = TestDataFactory.createOrderProductLines(
            orderList,
            quoteLines
        );
        insert orderItems;
        Contract c = new Contract(
            SBQQ__Opportunity__c = oppoList[0].Id,
            SBQQ__Quote__c = quoteList[0].id,
            AccountId = accList[0].Id
        );
        c.Name = 'Test Contract';
        c.AccountId = accList[0].Id;
        c.Status = 'Draft';
        insert c;
        List<SBQQ__Quote__c> child = TestDataFactory.createQuote(oppoList);
        child[0].SBQQ__Type__c = 'Renewal';
        child[0].SBQQ__MasterContract__c = c.Id;
        insert child;
        QuoteLineAnalyzerTriggerHandler.handleAfterInsert(new List<String> {''+child[0].Id});
        Test.stopTest();
    }
}