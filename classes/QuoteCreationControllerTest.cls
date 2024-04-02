/***************************************************************************************
 * @description       : This Test Class is controller for LWC Component(New_Quote_LWC)
 * @author            : Roshan Jambhule - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : QuoteCreationControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
@isTest
public with sharing class QuoteCreationControllerTest {
  @isTest
  static void createQuoteTest() {
    // Create test data (Opportunity, Account, and any other necessary records)
    List<Account> acclist = TestDataFactory.createAccount();
    insert acclist;
    List<Opportunity> opplist = TestDataFactory.createOpportunity(acclist);
    insert opplist;
    List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(opplist);
    insert quoteList;

    // Call the QuoteCreationController method
    Test.startTest();
    ID result = QuoteCreationController.createQuote(
      opplist[0].Id,
      acclist[0].Id,
      quoteList[0].Id
    );
    // Perform assertions based on the expected results
    System.assertNotEquals(null, result, 'Result');
    // Test QuoteWrapper within the context of QuoteCreationController
    QuoteCreationController.QuoteWrapper wrapper = new QuoteCreationController.QuoteWrapper();
    wrapper.quoteStartDate = Date.today();
    wrapper.opportunityId = opplist[0].Id;
    wrapper.quoteExpirationDate = Date.today().addDays(30);
    wrapper.quotePaymentTerm = 'Net 30';
    wrapper.quoteType = 'Standard';
    wrapper.quotePriceBookId = Test.getStandardPricebookId();
    wrapper.quoteOpportunityId = opplist[0].Id;
    wrapper.quoteAccountId = acclist[0].Id;
    wrapper.newQuoteId = quoteList[0].Id;

    System.assertEquals(
      Date.today(),
      wrapper.quoteStartDate,
      'Expected date is Todays date'
    );
    System.assertEquals(
      opplist[0].Id,
      wrapper.opportunityId,
      'Expected Opportunity'
    );
    System.assertEquals(
      Date.today().addDays(30),
      wrapper.quoteExpirationDate,
      'Expected date is Todays date + 30 Days'
    );
    System.assertEquals(
      'Net 30',
      wrapper.quotePaymentTerm,
      'Expected Payment term is Net 30'
    );
    System.assertEquals(
      'Standard',
      wrapper.quoteType,
      'Expected Quote Type is Standard'
    );
    System.assertEquals(
      Test.getStandardPricebookId(),
      wrapper.quotePriceBookId,
      'Expected pricebook type is standard'
    );
    System.assertEquals(
      opplist[0].Id,
      wrapper.quoteOpportunityId,
      'Expected Quote OpportunityID'
    );
    System.assertEquals(
      acclist[0].Id,
      wrapper.quoteAccountId,
      'Expected Quote AccountID'
    );
    System.assertEquals(
      quoteList[0].Id,
      wrapper.newQuoteId,
      'Expected Quote QuoteID'
    );

    Opportunity opp = CreateQuoteLWC.getOpportunity(opplist[0].Id);
    // Negative scenario
    // Example: Test what happens when the opportunity is null
    try {
      CreateQuoteLWC.createQuoteMethod(null, opplist[0].Id, quoteList[0].id);
    } catch (Exception e) {
      System.assertEquals(
        'Your expected error message',
        e.getMessage(),
        'Error Message'
      );
    }
    Test.stopTest();
  }
}