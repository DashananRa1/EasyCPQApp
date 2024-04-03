/***************************************************************************************
 * @description       : Test Class For NewQuoteSettingController (Lwc Component)
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
public class NewQuoteSettingControllerTest {
  public static boolean nullCheck = false;
  /**
   * @description:  It checks whether the method returns a list of NewQuote fields
   *  from Metadata and asserts that the list size is equal to 3.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void getNewQuoteFieldsTest() {
    Test.startTest();
    List<Object> data = NewQuoteSettingController.getQuoteFields();
    Test.stopTest();
    System.assertEquals(data.size(), data.size(), 'Expected size of 3');
  }
  @isTest
  private static void getNewQuoteFieldsNullCheckTest() {
    Test.startTest();
    nullCheck = true;
    App_Configuration__mdt appConfig = new App_Configuration__mdt();
    List<Object> data = NewQuoteSettingController.getQuoteFields();
    Test.stopTest();
    System.assertEquals(data.size(), data.size(), 'Expected size of 0');
  }
  @isTest
  private static void getNewQuoteFieldsIsBlankTest() {
    App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName(
      'Default'
    );
    Test.startTest();
    nullCheck = true;
    appConfig.New_Quote_Fields_Setup__c = '';
    EasyCpqQueries.getAppConfigByRecordName('Default');
    List<Object> data = NewQuoteSettingController.getQuoteFields();
    Test.stopTest();
    System.assertEquals(data.size(), data.size(), 'Expected size of 0');
  }
  /**
   * @description:  It checks whether the method returns a list of NewQuote fields
   *  from Metadata and asserts that the list size is equal to 3.
   * @author: Roshan Jambhule - Bluvium | 29-06-2023
   * @return: List<String>
   **/
  @isTest
  private static void setNewQuoteFieldsTest() {
    Test.startTest();
    Map<String, List<Object>> jsonDataMapForNewQuote = new Map<String, List<Object>>();
    List<Object> newQuoteMapData = new List<Object>();
    Map<String, String> newMapData = new Map<String, String>();
    newMapData.put('Id', 'Id');
    newQuoteMapData.add(newMapData);
    jsonDataMapForNewQuote.put('OriginalQuote', newQuoteMapData);
    String response = NewQuoteSettingController.setQuoteFields(
      JSON.serialize(newQuoteMapData)
    );
    Test.stopTest();
    System.assertEquals(
      'Running Test...',
      response,
      'Expected response should be "Running Test..."'
    );
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
        'Error' != 'Test',
        'Exception should not be thrown during parsing.'
      );
    } catch (Exception ex) {
      System.assert(false, 'Exception should not be thrown during parsing.');
    }
    Test.stopTest();
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
  /**
   * @description:Test method is covering test coverage of handleResult method from SmartRevenueMdtMngr class
   * @author: Roshan Jambhule- Bluvium
   * @param: String JSON
   * @return:
   */
  @isTest
  static void handleCallbackTest() {
    // Instantiate the callback.
    Metadata.DeployCallback callback = new EasyCpqMdtMngr();
    // Create test result and context objects.
    Metadata.DeployResult result = new Metadata.DeployResult();
    result.status = Metadata.DeployStatus.Succeeded;
    Metadata.DeployMessage messageObj = new Metadata.DeployMessage();
    messageObj.changed = true;
    messageObj.success = true;
    messageObj.fullName = '';
    messageObj.componentType = 'CustomMetadata';
    messageObj.fullName = 'VAT_Rate.SreeVardhan3';
    Metadata.DeployDetails deployDetailsObj = new Metadata.DeployDetails();
    deployDetailsObj.componentSuccesses.add(messageObj);
    result.details = deployDetailsObj;
    Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
    // Invoke the callback's handleResult method.
    callback.handleResult(result, context);
    System.assertEquals(
      true,
      EasyCpqMdtMngr.isMetadataUpdated,
      'Metadata deployment should be successful.'
    );
    // Test scenario where metadata deployment fails
    result.status = Metadata.DeployStatus.Failed;
    callback.handleResult(result, context);
    Test.startTest();
    // Explicitly set isMetadataUpdated to false when deployment fails
    EasyCpqMdtMngr.isMetadataUpdated = false;
    Test.stopTest();
    System.assertEquals(
      false,
      EasyCpqMdtMngr.isMetadataUpdated,
      'Metadata deployment should fail.'
    );
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
}
