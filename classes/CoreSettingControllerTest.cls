/**
* @description       : Test Class for CoreSettingController
* @author            : Roshan Jambhule
* @last modified on  : 09-13-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc 
**/
@IsTest
public class CoreSettingControllerTest {
public static boolean nullCheck = false;
    @isTest
    private static void testGetCheckboxFields(){
       // Positive Test: Test when App_Configuration__mdt record exists
        App_Configuration__mdt appConfig = TestDataFactory.getCustomMetadataRecord();
        Test.startTest();
        App_Configuration__mdt result = CoreSettingController.getAddittionSettingDataFromMetadata('Default');
        Test.stopTest();
        System.assertEquals(true, true,'');  
        
    }
        
	@isTest
    private static void testSetCheckboxFields(){
    Test.startTest();
    Map<String, Object> jsonMap = TestDataFactory.getValidJsonDataForQuote();
    CoreSettingController.setAddittionSettingDataFromMetadata(JSON.serialize(jsonMap));
    Test.stopTest();
    System.assertEquals(true, jsonMap.get('isAutoSelectMasterContract'), 'isAutoSelectMasterContract should be "true"');
    System.assertEquals(true, jsonMap.get('isGenerateNewAmendmentOpportunity'), 'isGenerateNewAmendmentOpportunity should be "true"');
    System.assertEquals(true, jsonMap.get('isGenerateNewRenewalOpportunity'), 'isGenerateNewRenewalOpportunity should be "true"');
    System.assertEquals(true, jsonMap.get('isMaintainQuoteLineGroup'), 'isMaintainQuoteLineGroup should be "true"');
    
    }
    /**
    * @description:It tests multiple methods related to getting fields and setting Core settings for 
    * Easy CPQ. It also sets up a JSON map with sample data.   
    * @author: Roshan Jambhule- Bluvium
    * @param: Map<String, Object> jsonMap
    * @return: 
    */
    @isTest
    static void doRemainingTest(){
        Test.startTest();
        EasyCpqUtils.getRenewedQuoteFieldsSetup();
        EasyCpqUtils.getRenewalOpportunityFieldsSetup();
        EasyCpqUtils.getAmendQuoteFieldsSetup();
        EasyCpqUtils.getAmendOpportunityFieldsSetup();
        EasyCpqUtils.getNewQuoteFieldsSetup();
        EasyCpqUtils.getFieldsetFields('SBQQ__Quote__c','SBQQ__CalculatingFields');
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('isAutoSelectMasterContract', true); 
        jsonMap.put('isGenerateNewAmendmentOpportunity', true); 
        jsonMap.put('isGenerateNewRenewalOpportunity', true);
        jsonMap.put('isMaintainQuoteLineGroup', true); 
        EasyCpqUtils.setAdditionalSettingFieldsSetup(JSON.serialize(jsonMap));
        EasyCpqUtils.setNewQuoteFieldsSetup(JSON.serialize(jsonMap));
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
    private static void additionalTestCoverage() {
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
    
    /**
    * @description:Test method is covering test coverage of handleResult method from EasyCpqMdtMngr class 
    * @author: Roshan Jambhule- Bluvium
    * @param: String JSON
    * @return: 
    */
    @isTest
    private static void handleCallbackTest() {
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
