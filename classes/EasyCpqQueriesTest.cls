/***************************************************************************************
 * @description       : Apex Class to Store All Queries
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
public class EasyCpqQueriesTest {
  /**
   * @description: This method sets up test data by creating a series of related records such as
   *                accounts, opportunities, products, price book entries, opportunity line items,
   *                 quotes, quote lines, orders, and order items. The created records are inserted
   *                 into the database for testing purposes.
   * @author: Roshan Jambhule
   * @return: void
   */
  @testSetup
  static void setupTestData() {
    Id pricebookId = Test.getStandardPricebookId();
    List<Account> acclist = TestDataFactory.createAccount();
    insert acclist;
    List<Opportunity> opplist = TestDataFactory.createOpportunity(acclist);
    insert opplist;
    List<Product2> productList = TestDataFactory.createProducts();
    insert productList;
    List<PricebookEntry> pbEntryList = TestDataFactory.createPricebookEntry(
      productList
    );
    insert pbEntryList;
    List<OpportunityLineItem> opplineitemList = TestDataFactory.createOpportunityLines(
      opplist,
      productList,
      pbEntryList
    );
    insert opplineitemList;
    List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(opplist);
    insert quoteList;
    List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(
      quoteList,
      productList,
      pbEntryList
    );
    insert quoteLines;
    List<Order> orderlist = TestDataFactory.createOrder(quotelist);
    insert orderlist;
    List<OrderItem> orderProductlist = TestDataFactory.createOrderProductLines(
      orderlist,
      quoteLines
    );
    insert orderProductlist;
  }
  /**
   * @description: This test method verifies the functionality of retrieving an application configuration record by its developer name.
   * It ensures that the correct configuration record is retrieved and its developer name matches the expected value.
   * @author: Roshan Jambhule
   */
  @isTest
  static void testGetAppConfigByRecordName() {
    Test.startTest();
    BECPQ__App_Configuration__mdt mtd = EasyCpqQueries.getAppConfigByRecordName(
      'Default'
    );
    Test.stopTest();
    System.assertEquals('Default', mtd.DeveloperName, 'Developer Name');
  }
  /**
   * @description: This test method verifies the behavior of the getAppConfigByRecordName method in a
   *               negative scenario where the provided record name does not exist. It ensures that
   *                the method throws an exception indicating that no records were found.
   * @author: Roshan Jambhule- Bluvium
   */
  @isTest
  static void testNegativeGetAppConfigByRecordName() {
    Test.startTest();
    try {
      EasyCpqQueries.getAppConfigByRecordName('Def');
    } catch (exception e) {
      System.assertEquals(
        'List index out of bounds: 0',
        e.getMessage(),
        'No records'
      );
    }
    Test.stopTest();
  }
}