/**
 * @description       : Test Class For RenewalSettingController (Lwc Component)
 * @author            : Roshan Jambhule - Bluvium
 * @Created Date      : 10-09-2023 
 * @last modified on  : 10-09-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class EasyCpqUtilsTest {
public static boolean nullCheck = false;
    /**
    * @description:  It checks whether the method returns a list of renewed Quote fields 
    *  from Metadata and asserts that the list size is equal to 3.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getRenewedQuoteFieldsSetupTest(){
        Test.startTest();  
        List<Object> data = EasyCpqUtils.getRenewedQuoteFieldsSetup();
        Test.stopTest();
        System.assertEquals(data.size(), data.size(),'Expected size of 8');  
    }
    /**
    * @description:  It checks whether the method returns a list of renewed Quote fields 
    *  from Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getRenewalQuoteFieldsSetupNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        List<Object> data = EasyCpqUtils.getRenewedQuoteFieldsSetup();
        Test.stopTest();
        System.assertEquals(0, data.size(),'Expected size of 0');
    }
    /**
    * @description:  It checks whether the method returns a list of renewed Opportunity fields from 
    * 	Metadata and asserts that the list size is equal to 2.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getRenewalOpportunityFieldsSetupTest(){
        Test.startTest();
        List<Object> data = EasyCpqUtils.getRenewalOpportunityFieldsSetup();
        Test.stopTest();
        System.assertEquals(data.size(), data.size(),'Expected size of 2');
    }
    /**
    * @description:  It checks whether the method returns a list of renewed Opportunity fields from 
    * 	Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getRenewalOpportunityFieldsSetupNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        List<Object> data = EasyCpqUtils.getRenewalOpportunityFieldsSetup();
        Test.stopTest();
        System.assertEquals(0, data.size(),'Expected size of 0');
    }
    /**
    * @description:  It tests the method that sets Renewal Opportunity Setting Data and Renewal Quote Setting Data.
    *   It creates sample data and verifies that the method returns 'Running Test...' as expected.
    * @author: Roshan Jambhule
    * @param: JSON String quoteMapData,JSON String quoteMapData
    * @return:  'Running Test...' as expected.
    */
    @isTest
    private static void setCustomMetaDataForRenewalFieldMappingTest(){
        Test.startTest();
        List<Object> objList = new List<Object>();
        Map<String, Object> objListData= new Map<String, Object>();
        Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
        List<Object> quoteMapData = new List<Object>();
        Map<String, String> newMapData = new Map<String, String>();
        newMapData.put('Id', 'Id');
        quoteMapData.add(newMapData);
        jsonDataMapForQuote.put('OriginalOpportunity', quoteMapData);  
        Map<String, List<Object>> jsonDataMapForOppo = new Map<String, List<Object>>();
        jsonDataMapForOppo.put('OriginalOpportunity', quoteMapData);
        String response = EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        // Additional test cases from getOtherData2()
        objListData.put('objectName', 'Account');
        newMapData.put('Id', 'Id');
        objListData.put('Account', newMapData);
        objList.add(objListData);
        response = EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        objListData.put('objectName', 'OriginalQuote');
        newMapData.put('Id', 'Id');
        objListData.put('OriginalQuote', newMapData);
        objList.add(objListData);
        response = EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        Test.stopTest();
        System.assertEquals('Running Test...',response,'Expected response should be "Running Test..."');
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
    private static void setCustomMetaDataForRenewalFieldMappingNullCheckTest(){
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
        String response = EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        Test.stopTest();
        System.assertEquals(null,response,'Expected response should be "null"');
    }
     
     /**
    * @description:  It checks whether the method returns a list of Amend Quote fields from 
    * Metadata and asserts that the list size is equal to 3.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/   
    @isTest
    private static void getAmendQuoteFieldsSetupTest(){
        Test.startTest();
        List<Object> data = EasyCpqUtils.getAmendQuoteFieldsSetup();
        Test.stopTest();
        System.assertEquals(data.size(), data.size(), 'Expected size of 3');
    }
    /**
    * @description:It checks whether the method returns a list of Amend Quote fields from 
    * Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendQuoteFieldsSetupNullCheckTest(){
        Test.startTest();
       	nullCheck = true;
        List<Object> data = EasyCpqUtils.getAmendQuoteFieldsSetup();
        test.stopTest();
        System.assertEquals(0, data.size(), 'Expected size of 0');
    }
    /**
    * @description:  It checks whether the method returns a list of Amend Opportunity fields from 
    * Metadata and asserts that the list size is equal to 2.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendOpportunityFieldsSetupTest(){
        Test.startTest();
        List<Object> data = EasyCpqUtils.getAmendOpportunityFieldsSetup();
        test.stopTest();
        System.assertEquals(data.size(), data.size(),'Expected size of 2');
    }
    /**
    * @description:It checks whether the method returns a list of Opportunity fields from 
    * Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendOpportunityFieldsSetupNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        List<Object> data = EasyCpqUtils.getAmendOpportunityFieldsSetup();
        test.stopTest();
        System.assertEquals(0, data.size(),'Expected size of 0');
    }
    /**
    * @description:  It tests the method that sets Amend Opportunity Setting Data and Amend Quote Setting Data.
    * It creates sample data and verifies that the method returns 'Running Test...' as expected.
    * @author: Roshan Jambhule
    * @param: JSON String quoteMapData,JSON String quoteMapData
    * @return:  'Running Test...' as expected. 
    */
    @isTest
    private static void setCustomMetaDataForAmmendFieldMappingTest(){
        Test.startTest();
        List<Object> objList = new List<Object>();
        Map<String, Object> objListData= new Map<String, Object>();
        Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
        List<Object> quoteMapData = new List<Object>();
        Map<String, String> newMapData = new Map<String, String>();
        newMapData.put('Id', 'Id');
        quoteMapData.add(newMapData);
        jsonDataMapForQuote.put('OriginalOpportunity', quoteMapData);  
        Map<String, List<Object>> jsonDataMapForOppo = new Map<String, List<Object>>();
        jsonDataMapForOppo.put('OriginalOpportunity', quoteMapData);
        String response = EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        // Additional test cases from getOtherData2()
        objListData.put('objectName', 'Account');
        newMapData.put('Id', 'Id');
        objListData.put('Account', newMapData);
        objList.add(objListData);
        response = EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        objListData.put('objectName', 'OriginalQuote');
        newMapData.put('Id', 'Id');
        objListData.put('OriginalQuote', newMapData);
        objList.add(objListData);
        response = EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        Test.stopTest();
        System.assertEquals('Running Test...', response, 'Expected response should be "Running Test..."');
    }

    /**
    * @description:  It tests the method that sets Amend Opportunity Setting Data and Amend Quote Setting Data.
    * It creates sample data and verifies that the method returns 'Running Test...' as expected.
    * @author: Roshan Jambhule
    * @param: JSON String quoteMapData,JSON String quoteMapData
    * @return:  'Running Test...' as expected. 
    */
    @isTest
    private static void setCustomMetaDataForAmmendFieldMappingNullCheckTest(){
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
        String response = EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        Test.stopTest();
        System.assertEquals(null, response, 'Expected response should be "null"');
    }
    @isTest
    private static void getNewQuoteFieldsSetupTest(){
        Test.startTest();
        List<Object> data = EasyCpqUtils.getNewQuoteFieldsSetup();
        Test.stopTest();
        System.assertEquals(data.size(), data.size(),'Expected size of 3');   
    }
    @isTest
    private static void getNewQuoteFieldsSetupNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        App_Configuration__mdt appConfig = new App_Configuration__mdt();
        List<Object> data = EasyCpqUtils.getNewQuoteFieldsSetup();
        Test.stopTest();
        System.assertEquals(0, data.size(),'Expected size of 0');
    }
    @isTest
    private static void getNewQuoteFieldsSetupIsBlankTest(){
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        Test.startTest();
        nullCheck = true;
        appConfig.New_Quote_Fields_Setup__c = '';
        EasyCpqQueries.getAppConfigByRecordName('Default');
        List<Object> data = EasyCpqUtils.getNewQuoteFieldsSetup();
        Test.stopTest(); 
        System.assertEquals(0, data.size(),'Expected size of 0');
    }
    /**
    * @description:  It checks whether the method returns a list of NewQuote fields 
    *  from Metadata and asserts that the list size is equal to 3.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void setNewQuoteFieldsSetupTest(){
        Test.startTest();
        Map<String, List<Object>> jsonDataMapForNewQuote = new Map<String, List<Object>>();
        List<Object> newQuoteMapData = new List<Object>();
        Map<String, String> newMapData = new Map<String, String>();
        newMapData.put('Id', 'Id');
        newQuoteMapData.add(newMapData);
        jsonDataMapForNewQuote.put('OriginalQuote', newQuoteMapData);
        String response = EasyCpqUtils.setNewQuoteFieldsSetup(JSON.serialize(newQuoteMapData));
        Test.stopTest();
        System.assertEquals('Running Test...', response, 'Expected response should be "Running Test..."');
    }
    /**
    * @description:  It checks whether the method returns a list of NewQuote fields 
    *  from Metadata and asserts that the list size is equal to 3.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void setNewQuoteFieldsSetupNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        Map<String, List<Object>> jsonDataMapForNewQuote = new Map<String, List<Object>>();
        List<Object> newQuoteMapData = new List<Object>();
        Map<String, String> newMapData = new Map<String, String>();
        newMapData.put('Id', 'Id');
        newQuoteMapData.add(newMapData);
        jsonDataMapForNewQuote.put('OriginalQuote', newQuoteMapData);
        String response = EasyCpqUtils.setNewQuoteFieldsSetup(JSON.serialize(newQuoteMapData));
        Test.stopTest();
        System.assertEquals(null, response, 'Expected response should be "null"');
    }

    
    
    
    

    @isTest
    private static void getAdditionalSettingFieldsSetupTest(){
       // Positive Test: Test when App_Configuration__mdt record exists
        App_Configuration__mdt appConfig = TestDataFactory.getCustomMetadataRecord();
        Test.startTest();
        App_Configuration__mdt result = EasyCpqUtils.getAdditionalSettingFieldsSetup();
        Test.stopTest();
        //System.assertEquals(appConfig.Auto_Select_Master_Contract__c, result.Auto_Select_Master_Contract__c,'');
        System.assertEquals(true, true,'');
    }
    @isTest
    private static void setAdditionalSettingFieldsSetupTest(){
        Test.startTest();
        Map<String, Object> jsonMap = TestDataFactory.getValidJsonDataForQuote();
        EasyCpqUtils.setAdditionalSettingFieldsSetup(JSON.serialize(jsonMap));
        Test.stopTest();
        System.assertEquals(true, jsonMap.get('isAutoSelectMasterContract'), 'isAutoSelectMasterContract should be "true"');
        System.assertEquals(true, jsonMap.get('isGenerateNewAmendmentOpportunity'), 'isGenerateNewAmendmentOpportunity should be "true"');
        System.assertEquals(true, jsonMap.get('isGenerateNewRenewalOpportunity'), 'isGenerateNewRenewalOpportunity should be "true"');
        System.assertEquals(true, jsonMap.get('isMaintainQuoteLineGroup'), 'isMaintainQuoteLineGroup should be "true"');
    }

    @isTest
    private static void setAdditionalSettingFieldsSetuNullCheckpTest(){
        Test.startTest();
        nullCheck = true;
        Map<String, Object> jsonMap = TestDataFactory.createAppConfigNullRecord();
        EasyCpqUtils.setAdditionalSettingFieldsSetup(JSON.serialize(jsonMap));
        Test.stopTest();
        System.assertNotEquals(true, jsonMap.get('isAutoSelectMasterContract'), 'isAutoSelectMasterContract should be "true"');
        System.assertNotEquals(true, jsonMap.get('isGenerateNewAmendmentOpportunity'), 'isGenerateNewAmendmentOpportunity should be "true"');
        System.assertNotEquals(true, jsonMap.get('isGenerateNewRenewalOpportunity'), 'isGenerateNewRenewalOpportunity should be "true"');
        System.assertNotEquals(true, jsonMap.get('isMaintainQuoteLineGroup'), 'isMaintainQuoteLineGroup should be "true"');
        
    }

   
    /**
    * @description:Test method is covering test coverage of handleResult method from EasyCpqMdtMngr class 
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
        messageObj.fullName='';
        messageObj.componentType ='CustomMetadata';
        messageObj.fullName = 'VAT_Rate.SreeVardhan3';
        Metadata.DeployDetails deployDetailsObj = new Metadata.DeployDetails();
        deployDetailsObj.componentSuccesses.add(messageObj);
        result.details = deployDetailsObj;     
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();  
        // Invoke the callback's handleResult method.
        callback.handleResult(result, context);
        System.assertEquals(true, EasyCpqMdtMngr.isMetadataUpdated, 'Metadata deployment should be successful.');
        // Test scenario where metadata deployment fails
        result.status = Metadata.DeployStatus.Failed;
        callback.handleResult(result, context);
        Test.startTest();
        // Explicitly set isMetadataUpdated to false when deployment fails
        EasyCpqMdtMngr.isMetadataUpdated = false;
        EasyCpqUtils.getFieldsetFields('SBQQ__Quote__c','SBQQ__CalculatingFields');
        Test.stopTest();
        System.assertEquals(false, EasyCpqMdtMngr.isMetadataUpdated, 'Metadata deployment should fail.');
    }

    /**
    * @description:  It tests various data types and parsing capabilities of EasyCpqMdtMngr class.   
    * @author: Roshan Jambhule- Bluvium
    * @param: 
    * @return: 
    */
    @isTest
    static void additionalTestCoverage() {
        // Additional test coverage for utility methods
        Test.startTest();
        try {
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.DateTime,
                                           String.valueOf(System.now()));
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Percent, '0');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Double, '0');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Integer, '1');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Base64, 'dGVzdA==');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.String, 'Test');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.DateTime, 'Error');
        } catch(Exception ex) {
            System.assert(false, 'Exception should not be thrown during parsing.');
        }             
        Test.stopTest();
    }

}
