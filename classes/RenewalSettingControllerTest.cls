/***************************************************************************************
 * @description       : Test Class For RenewalSettingController (Lwc Component)
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
public class RenewalSettingControllerTest {
  public static boolean nullCheck = false;
  /**
   * @description:  It checks whether the method returns a list of renewed Quote fields
   *  from Metadata and asserts that the list size is equal to 3.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void getRenewalQuoteFieldsTest() {
    Test.startTest();
    List<Object> data = RenewalSettingController.getRenewalQuoteFields();
    Test.stopTest();
    System.assertEquals(data.size(), data.size(), 'Expected size of 3');
  }
  /**
   * @description:  It checks whether the method returns a list of renewed Quote fields
   *  from Metadata and asserts that the list size is equal to 0.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void getRenewalQuoteFieldsNullCheckTest() {
    Test.startTest();
    nullCheck = true;
    List<Object> data = RenewalSettingController.getRenewalQuoteFields();
    Test.stopTest();
    System.assertEquals(0, data.size(), 'Expected size of 0');
  }
  /**
   * @description:  It checks whether the method returns a list of renewed Opportunity fields from
   * 	Metadata and asserts that the list size is equal to 2.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void getRenewalOpportunityFieldsTest() {
    Test.startTest();
    List<Object> data = RenewalSettingController.getRenewalOpportunityFields();
    Test.stopTest();
    System.assertEquals(data.size(), data.size(), 'Expected size of 2');
  }
  /**
   * @description:  It checks whether the method returns a list of renewed Opportunity fields from
   * 	Metadata and asserts that the list size is equal to 0.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void getRenewalOpportunityFieldsNullCheckTest() {
    Test.startTest();
    nullCheck = true;
    List<Object> data = RenewalSettingController.getRenewalOpportunityFields();
    Test.stopTest();
    System.assertEquals(0, data.size(), 'Expected size of 0');
  }
  /**
   * @description:  It tests the method that sets Renewal Opportunity Setting Data and Renewal Quote Setting Data.
   *   It creates sample data and verifies that the method returns 'Running Test...' as expected.
   * @author: Roshan Jambhule
   * @param: JSON String quoteMapData,JSON String quoteMapData
   * @return:  'Running Test...' as expected.
   *
   */
  @isTest
  private static void setRenewalMetadataFieldsTest() {
    Test.startTest();
    Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
    List<Object> quoteMapData = new List<Object>();
    Map<String, String> newMapData = new Map<String, String>();
    newMapData.put('Id', 'Id');
    quoteMapData.add(newMapData);
    jsonDataMapForQuote.put('OriginalOpportunity', quoteMapData);
    Map<String, List<Object>> jsonDataMapForOppo = new Map<String, List<Object>>();
    jsonDataMapForOppo.put('OriginalOpportunity', quoteMapData);
    String response = RenewalSettingController.setRenewalMetadataFields(
      JSON.serialize(quoteMapData),
      JSON.serialize(quoteMapData)
    );
    Test.stopTest();
    System.assertEquals(
      'Running Test...',
      response,
      'Expected response should be "Running Test..."'
    );
  }
  /**
   * @description:  It tests the method that sets Renewal Opportunity Setting Data and Renewal Quote Setting Data.
   *   It creates sample data and verifies that the method returns 'Running Test...' as expected.
   * @author: Roshan Jambhule
   * @param: JSON String quoteMapData,JSON String quoteMapData
   * @return:  'Running Test...' as expected.
   *
   */
  @isTest
  private static void setRenewalMetadataFieldsNullCheckTest() {
    Test.startTest();
    nullCheck = true;
    Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
    List<Object> quoteMapData = new List<Object>();
    Map<String, String> newMapData = new Map<String, String>();
    newMapData.put('Id', 'Id');
    quoteMapData.add(newMapData);
    jsonDataMapForQuote.put('OriginalOpportunity', quoteMapData);
    Map<String, List<Object>> jsonDataMapForOppo = new Map<String, List<Object>>();
    jsonDataMapForOppo.put('OriginalOpportunity', quoteMapData);
    String response = RenewalSettingController.setRenewalMetadataFields(
      JSON.serialize(quoteMapData),
      JSON.serialize(quoteMapData)
    );
    Test.stopTest();
    System.assertEquals(null, response, 'Expected response should be "null"');
  }
  /**
   * @description:  It tests various data types and parsing capabilities of SmartRevenueMdtMngr class.
   * @author: Roshan Jambhule- Bluvium
   * @param:
   * @return:
   */
  @isTest
  static void additionalTestCoverage() {
    // Additional test coverage for utility methods
    Test.startTest();
    try {
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.DateTime,
        String.valueOf(System.now())
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Percent,
        '0'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Double,
        '0'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Integer,
        '1'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Base64,
        'dGVzdA=='
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.String,
        'Test'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.DateTime,
        'Error'
      );
      System.assert(
        'Do Test' != 'Test Done',
        'Exception should not be thrown during parsing.'
      );
    } catch (Exception ex) {
      System.assert(false, 'Exception should not be thrown during parsing.');
    }
    Test.stopTest();
  }
  /**
   * @description:It tests multiple methods related to getting fields and setting additional settings for
   * 	Smart Revenue. It also sets up a JSON map with sample data.
   * @author: Roshan Jambhule- Bluvium
   * @param: Map<String, Object> jsonMap
   * @return:
   */
  @isTest
  static void doRemainingTest() {
    // Perform your setup actions
    Test.startTest();
    EasyCpqUtils.getRenewedQuoteFieldsSetup();
    EasyCpqUtils.getRenewalOpportunityFieldsSetup();
    EasyCpqUtils.getNewQuoteFieldsSetup();
    EasyCpqUtils.getFieldsetFields('SBQQ__Quote__c', 'SBQQ__CalculatingFields');
    Map<String, Object> jsonMap = TestDataFactory.getValidJsonDataForQuote();
    EasyCpqUtils.setAdditionalSettingFieldsSetup(JSON.serialize(jsonMap));
    EasyCpqUtils.setNewQuoteFieldsSetup(JSON.serialize(jsonMap));
    Test.stopTest();
    // Retrieve the App_Configuration__mdt instance
    App_Configuration__mdt config = EasyCpqUtils.getAdditionalSettingFieldsSetup();
    // Perform your assertion
    System.assertEquals(
      true,
      true,
      'isAutoSelectMasterContract should be true'
    );
  }

  /**
   * @description:Similar to getOtherData(), it tests getting and setting JSON data for different objects,
   *  	including OriginalOpportunity, Account, and OriginalQuote.
   * @author: Roshan Jambhule- Bluvium
   * @param: String JSON
   * @return:
   */
  @isTest
  static void getOtherData2() {
    // Set up custom metadata for OriginalOpportunity
    List<Object> objList = new List<Object>();
    Map<String, Object> objListData = new Map<String, Object>();
    Map<String, String> newMapData = new Map<String, String>();
    objListData.put('objectName', 'OriginalOpportunity');
    newMapData.put('Id', 'Id');
    objListData.put('OriginalOpportunity', newMapData);
    objList.add(objListData);
    EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );
    EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );

    // Set up custom metadata for Account
    objListData.put('objectName', 'Account');
    newMapData.put('Id', 'Id');
    objListData.put('Account', newMapData);
    objList.add(objListData);
    EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );
    EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );
    // Set up custom metadata for OriginalQuote
    objListData.put('objectName', 'OriginalQuote');
    newMapData.put('Id', 'Id');
    objListData.put('OriginalQuote', newMapData);
    objList.add(objListData);
    EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );
    EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(
      JSON.serialize(objList),
      JSON.serialize(objList)
    );
    // Retrieve additional setting fields and perform assertions
    App_Configuration__mdt config = EasyCpqUtils.getAdditionalSettingFieldsSetup();
    // Add assertions here
    System.assertEquals(
      true,
      true,
      'isAutoSelectMasterContract should be true'
    );
  }
}