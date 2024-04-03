/***************************************************************************************
 * @description       : This Test class for the CreateAmendLWC Class which is refer to 
 * the Quick Action button LWC Component
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
public class CreateAmendLWCTest {
  /**
   * @description: Sets up test data for unit tests by creating and inserting records for Account,
   *               Opportunity, Product2, PricebookEntry, OpportunityLineItem, SBQQ__Quote__c,
   *               SBQQ__QuoteLine__c, Order, OrderItem, and Contract objects.
   * @author: Roshan Jambhule- Bluvium
   * @return:
   */
  @TestSetup
  static void prepareData() {
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
    insert quoteList;
    List<SBQQ__QuoteLine__c> quoteLines = TestDataFactory.createquoteLines(
      quoteList,
      prodList,
      pbEntry
    );
    insert quoteLines;
    List<Order> orderList = TestDataFactory.createOrder(quoteList);
    insert orderList;
    List<OrderItem> orderItems = TestDataFactory.createOrderProductLines(
      orderList,
      quoteLines
    );
    insert orderItems;
    List<Contract> contrList = new List<Contract>();
    Contract objContr = new Contract();
    objContr.AccountId = accList[0].Id;
    objContr.SBQQ__Opportunity__c = oppoList[0].Id;
    objContr.SBQQ__Quote__c = quoteList[0].id;
    objContr.Status = 'Draft';
    objContr.StartDate = Date.newInstance(2025, 1, 1);
    objContr.ContractTerm = 12;
    objContr.SBQQ__RenewalForecast__c = false;
    objContr.SBQQ__RenewalQuoted__c = false;
    objContr.SBQQ__RenewalOpportunity__c = null;
    contrList.add(objContr);
    insert contrList;
  }
  /**
   * @description: Tests the functionality of the getFieldLableAndFieldAPI method in the CreateAmendLWC
   *               class by verifying that it returns a non-null and non-empty JSON string representing
   *               the mapping of field labels to field API names for the Contract object's Amend field set.
   * @author: Roshan Jambhule- Bluvium
   * @return:
   */
  @isTest
  static void testgetFieldLableAndFieldAPI() {
    Test.startTest();
    String fieldMapJson = CreateAmendLWC.getFieldLableAndFieldAPI();
    System.assertNotEquals(
      null,
      fieldMapJson,
      'Field map JSON should not be null'
    );
    System.assertNotEquals(
      '',
      fieldMapJson,
      'Field map JSON should not be empty'
    );
    Test.stopTest();
  }

  /**
   * @description: Tests the functionality of the getContracts method in the CreateAmendLWC class
   *               by verifying that it returns a list of contracts associated with a specified account.
   * @author: Roshan Jambhule- Bluvium
   * @param: accId - The Id of the test account for which contracts are retrieved.
   * @return:
   */
  @isTest
  static void testGetContracts() {
    string accId = [SELECT Id FROM Account WHERE Name = 'Test Account1' LIMIT 1]
    .id;
    Test.startTest();
    List<Contract> returnedContracts = CreateAmendLWC.getContracts(accId);
    Test.stopTest();
    System.assertEquals(
      1,
      returnedContracts.size(),
      'Expected exactly one contract to be returned'
    );
  }

/**
 * @description: Tests the amendContract method in the CreateAmendLWC class when the condition for true execution is met.
 * @author: Roshan Jambhule- Bluvium
 */
  @isTest
  static void testAmendContractWhenTrueExecution() {
    List<Contract> contractList = [
      SELECT id, SBQQ__Opportunity__c, SBQQ__Quote__c, AccountId
      FROM Contract
      WHERE Account.Name = 'Test Account1'
      LIMIT 1
    ];
    test.startTest();
    String quoteId = CreateAmendLWC.amendContract(
      contractList[0].id,
      contractList[0].SBQQ__Opportunity__c,
      contractList[0].SBQQ__Opportunity__c,
      contractList[0].AccountId,
      contractList[0].SBQQ__Quote__c
    );
    test.stopTest();
    System.assertNotEquals(null, quoteId, 'Quote ID should not be null');
    System.assertNotEquals('', quoteId, 'Quote ID should not be empty');
  }
  /**
 * @description: Tests the amendContract method in the CreateAmendLWC class when the condition for false execution is met.
 * @author: Roshan Jambhule- Bluvium
 */
  @isTest
  static void testamendContractFalseExecution() {
    string accId = [SELECT Id FROM Account WHERE Name = 'Test Account1' LIMIT 1]
    .id;
    Opportunity objOpportunity = new Opportunity();
    objOpportunity.Name = 'TestOpp2';
    objOpportunity.AccountId = accId;
    objOpportunity.StageName = 'Prospecting';
    objOpportunity.Description = 'Description for testing';
    objOpportunity.CloseDate = Date.newInstance(2023, 1, 1);
    insert objOpportunity;
    List<Contract> contractList = [
      SELECT id, SBQQ__Opportunity__c, SBQQ__Quote__c, AccountId
      FROM Contract
      WHERE Account.Name = 'Test Account1'
      LIMIT 1
    ];
    test.startTest();
    String quoteId = CreateAmendLWC.amendContract(
      contractList[0].id,
      objOpportunity.id,
      contractList[0].SBQQ__Opportunity__c,
      contractList[0].AccountId,
      contractList[0].SBQQ__Quote__c
    );
    test.stopTest();
    System.assertNotEquals(null, quoteId, 'Quote ID should not be null');
    System.assertNotEquals('', quoteId, 'Quote ID should not be empty');
  }
}