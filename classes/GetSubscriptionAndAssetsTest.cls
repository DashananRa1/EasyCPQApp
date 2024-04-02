/***************************************************************************************
 * @description       : This Test Class is controller is used in SubscriptionAndAssets Vf Page
 * @author            : Nitesh Lande(Bluvium)
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
public with sharing class GetSubscriptionAndAssetsTest {
    @isTest
  static void testGetSubscriptionAndAssets() {
    List<Account> acclist = TestDataFactory.createAccount();
    insert acclist;
    List<Opportunity> opplist = TestDataFactory.createOpportunity(acclist);
    insert opplist;
    List<SBQQ__Quote__c> quoteList = TestDataFactory.createQuote(opplist);
    insert quoteList;    
    SBQQ__Subscription__c testSubscription = new SBQQ__Subscription__c(
      SBQQ__Account__c = acclist[0].Id,
      SBQQ__Quantity__c = 5
    );
    insert testSubscription;    
    Asset testAsset = new Asset(Name = 'TestAsset', AccountId = acclist[0].Id);
    insert testAsset;
    Test.startTest();    
    PageReference pageRef = Page.SubscriptionAndAsset; 
    Test.setCurrentPageReference(pageRef);
    ApexPages.currentPage().getParameters().put('id', quoteList[0].Id);    
    ApexPages.StandardController stdController = new ApexPages.StandardController(
      quoteList[0]
    );
    GetSubscriptionAndAssets controller = new GetSubscriptionAndAssets(
      stdController
    );    
    System.assertEquals(quoteList[0].Id, controller.quoteId, '');
    System.assertEquals(acclist[0].Id, controller.accId, '');    
    controller.toShowSubscriptionAndAssets();    
    System.assertNotEquals(null, controller.subscriptionList, '');
    System.assertNotEquals(null, controller.assetList, '');
    Test.stopTest();
  }
    
}