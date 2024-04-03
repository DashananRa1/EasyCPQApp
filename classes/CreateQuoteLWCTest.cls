/***************************************************************************************
 * @description       : Apex Class to Create new Quote from Quick Action button on Opportunity with LWC Component
 * @author            : Nitesh Lande - Bluvium
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
public class CreateQuoteLWCTest {
  /**
   * @description: This test method verifies the functionality of the createQuoteMethod() in the CreateQuoteLWC class. It covers both positive and negative scenarios.
   */
  @isTest
  static void createQuoteMethodTest() {
    List<Account> acclist = TestDataFactory.createAccount();
    insert acclist;
    List<Opportunity> opplist = TestDataFactory.createOpportunity(acclist);
    insert opplist;
    List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(opplist);
    insert quoteList;
    Test.startTest();
    // Positive scenario
    ID result = CreateQuoteLWC.createQuoteMethod(
      opplist[0].Id,
      acclist[0].Id,
      quoteList[0].id
    );
    System.assertNotEquals(null, result, 'Result');

    Opportunity opp = CreateQuoteLWC.getOpportunity(opplist[0].Id);
    // Negative scenario
    // Example: Test what happens when the opportunity is null
    try {
      CreateQuoteLWC.createQuoteMethod(null, opplist[0].Id, quoteList[0].id);
    } catch (Exception e) {
      System.assertEquals('Your expected error message', e.getMessage(),'Exception message');
    }
    Test.stopTest();
  }
}