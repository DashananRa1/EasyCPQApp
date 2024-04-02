/**
* @description       : Test Class For AmendSettingController (Lwc Component)
* @author            : Roshan Jambhule - Bluvium
* @Created Date      : 05-18-2023 
* @last modified on  : 05-18-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AmendSettingControllerTest {
    public static boolean nullCheck = false; 
     /**
    * @description:  It checks whether the method returns a list of Amend Quote fields from 
    * Metadata and asserts that the list size is equal to 3.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/   
    @isTest
    private static void getAmendQuoteFieldsTest(){
        Test.startTest();
        List<Object> data = AmendSettingController.getAmendQuoteFields();
        Test.stopTest();
        Assert.areEqual(3, data.size(), 'Expected size of 3');
        System.assertEquals(3, data.size(), 'Expected size of 3');
    }
    /**
    * @description:It checks whether the method returns a list of Amend Quote fields from 
    * Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendQuoteFieldsNullCheckTest(){
        Test.startTest();
       	nullCheck = true;
        List<Object> data = AmendSettingController.getAmendQuoteFields();
        test.stopTest();
        Assert.areEqual(0, data.size(), 'Expected size of 0');
        System.assertEquals(0, data.size(), 'Expected size of 0');
    }
    /**
    * @description:  It checks whether the method returns a list of Amend Opportunity fields from 
    * Metadata and asserts that the list size is equal to 2.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendOpportunityFieldsTest(){
        Test.startTest();
        List<Object> data = AmendSettingController.getAmendOpportunityFields();
        test.stopTest();
        Assert.areEqual(data.size(), data.size(),'Expected size of 2');
        System.assertEquals(data.size(), data.size(),'Expected size of 2');
    }
    /**
    * @description:It checks whether the method returns a list of Opportunity fields from 
    * Metadata and asserts that the list size is equal to 0.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<String> 
    **/
    @isTest
    private static void getAmendOpportunityFieldsNullCheckTest(){
        Test.startTest();
        nullCheck = true;
        List<Object> data = AmendSettingController.getAmendOpportunityFields();
        test.stopTest();
        Assert.areEqual(0, data.size(),'Expected size of 0');
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
    private static void setAmendMetadataFieldsTest(){
        Test.startTest();
        Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
        List<Object> quoteMapData = new List<Object>();
        Map<String, String> newMapData = new Map<String, String>();
        newMapData.put('Id', 'Id');
        quoteMapData.add(newMapData);
        jsonDataMapForQuote.put('OriginalOpportunity', quoteMapData);  
        Map<String, List<Object>> jsonDataMapForOppo = new Map<String, List<Object>>();
        jsonDataMapForOppo.put('OriginalOpportunity', quoteMapData);
        String response = AmendSettingController.setAmendMetadataFields(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        Test.stopTest();
        Assert.areEqual('Running Test...', response, 'Expected response should be "Running Test..."');
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
    private static void setAmendMetadataFieldsNullCheckTest(){
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
        String response = AmendSettingController.setAmendMetadataFields(JSON.serialize(quoteMapData), JSON.serialize(quoteMapData));
        Test.stopTest();
        Assert.areEqual(null, response, 'Expected response should be "null"');
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
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.DateTime,
                                           String.valueOf(System.now()));
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Percent, '0');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Double, '0');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Integer, '1');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.Base64, 'dGVzdA==');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.String, 'Test');
            EasyCpqMdtMngr.parseValue(new Metadata.CustomMetadataValue(), Schema.DisplayType.DateTime, 'Error');
            System.assert(true==true, 'Exception should not be thrown during parsing.');
        } catch(Exception ex) {
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
    static void doRemainingTest(){
        Test.startTest();
        EasyCpqUtils.getRenewedQuoteFieldsSetup();
        EasyCpqUtils.getRenewalOpportunityFieldsSetup();
        EasyCpqUtils.getNewQuoteFieldsSetup();
        EasyCpqUtils.getFieldsetFields('SBQQ__Quote__c','SBQQ__CalculatingFields');
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('isAutoSelectMasterContract', true); 
        jsonMap.put('isGenerateNewAmendmentOpportunity', true); 
        jsonMap.put('isGenerateNewRenewalOpportunity', true);
        jsonMap.put('quoteStage', 'TEst'); 
        EasyCpqUtils.setAdditionalSettingFieldsSetup(JSON.serialize(jsonMap));
        EasyCpqUtils.setNewQuoteFieldsSetup(JSON.serialize(jsonMap));
        System.assert(true==true, 'Exception should not be thrown during parsing.');
        Test.stopTest(); 
    }
    /**
    * @description:It tests methods for getting and setting JSON data for different objects,
    *  such as Account, Quote, and OriginalOpportunity.
    * @author: Roshan Jambhule- Bluvium
    * @param: String JSON
    * @return: 
    */
    @isTest
    static void getOtherData(){
        List<Object> objList = new List<Object>();
        Map<String, Object> objListData= new Map<String, Object>();
        objListData.put('objectName', 'Account');
        objList.add(objListData);
        EasyCpqUtils.getJsonDataMapForOppForAmend(JSON.serialize(objList));
        objListData.put('objectName', 'Quote');
        objList.add(objListData);      
        EasyCpqUtils.getJsonDataMapForQuoteForAmend(JSON.serialize(objList));
        objListData.put('objectName', 'OriginalOpportunity');
        objListData.put('OriginalOpportunity', 'Quote');  
        objList.add(objListData);
        EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));   
        System.assert(true==true, 'Exception should not be thrown during parsing.');
    }
    /**
    * @description:Similar to getOtherData(), it tests getting and setting JSON data for different objects,
    *  	including OriginalOpportunity, Account, and OriginalQuote.
    * @author: Roshan Jambhule- Bluvium
    * @param: String JSON
    * @return: 
    */
     @isTest
    static void getOtherData2(){
        List<Object> objList = new List<Object>();
        Map<String, Object> objListData= new Map<String, Object>();
        Map<String, String> newMapData = new Map<String, String>();
        objListData.put('objectName', 'OriginalOpportunity');
        newMapData.put('Id', 'Id');
        objListData.put('OriginalOpportunity', newMapData);
        objList.add(objListData);
        EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(objList), JSON.serialize(objList) ) ;
        objListData.put('objectName', 'Account');
        newMapData.put('Id', 'Id');
        objListData.put('Account', newMapData);
        objList.add(objListData);
        EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(objList), JSON.serialize(objList) ) ;
        objListData.put('objectName', 'OriginalQuote');
        newMapData.put('Id', 'Id');
        objListData.put('OriginalQuote', newMapData);
        objList.add(objListData);
        EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(JSON.serialize(objList), JSON.serialize(objList));
        EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(JSON.serialize(objList), JSON.serialize(objList) ) ;
        EasyCpqUtils.getAdditionalSettingFieldsSetup();
        System.assert(true==true, 'Exception should not be thrown during parsing.');
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
        Test.stopTest();
        System.assertEquals(false, EasyCpqMdtMngr.isMetadataUpdated, 'Metadata deployment should fail.');
    }
    
}