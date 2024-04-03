/*************************************************************
 * @description       : Apex utility class for genric methods
 * @author            : Amit Aher - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma -Tech Assistant
 * @test class        : EasyCpqUtilsTest
 * @last modified on  : 12-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**************************************************************/
public with sharing class EasyCpqUtils {    
    /**
    * @description: Method to get Renewed  Quote fields setup
    * @author: Nitesh Lande - Bluvium | 24-05-2023
    * @return: List<Object>
    **/
    public static List<Object> getRenewedQuoteFieldsSetup() {
        List<Object> result = new List<Object>();       
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (RenewalSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }        
        if(appConfig == null) {
            return new List<Object>();
        }      
        if (appConfig.RenewalQuote_OriginalOppFieldSetup__c != null && !String.isBlank(appConfig.RenewalQuote_OriginalOppFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.RenewalQuote_OriginalOppFieldSetup__c));
        }
        if (appConfig.RenewalQuote_OriginalQuoteFieldSetup__c != null && !String.isBlank(appConfig.RenewalQuote_OriginalQuoteFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.RenewalQuote_OriginalQuoteFieldSetup__c));
        }
        if (appConfig.RenewalQuote_AccountFieldSetup__c != null && !String.isBlank(appConfig.RenewalQuote_AccountFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.RenewalQuote_AccountFieldSetup__c));
        }          
        return result;
    }
    /**
    * @description: Method to get Renewal Opportunity fields setup
    * @author: Roshan Jambhule - Bluvium | 30-06-2023
    * @return: List<Object>
    **/
    public static List<Object> getRenewalOpportunityFieldsSetup() {
        List<Object> result = new List<Object>();               
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (RenewalSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
            return new List<Object>();
        }      
        if (appConfig.RenewalOpportunity_AccountFieldSetup__c != null && !String.isBlank(appConfig.RenewalOpportunity_AccountFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.RenewalOpportunity_AccountFieldSetup__c));
        }
        if (appConfig.RenewalOpportunity_OriginalOppFieldSetup__c != null && !String.isBlank(appConfig.RenewalOpportunity_OriginalOppFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.RenewalOpportunity_OriginalOppFieldSetup__c));
        }
        return result;
    }
    /**
    * @description: Method to Set Renewal OpportunitysettingData and Renewal Quote Setting Data
    * @author: Roshan jambhule - Bluvium | 
    * @return: List<Object>
    **/
    public static string setCustomMetaDataForRenewalFieldMapping(String jsonDataQuote, String jsonDataOpp ) {       
        Map<String, List<Object>> jsonDataMapForQuote = getJsonDataMapForQuoteForRenewal(jsonDataQuote);
        Map<String, List<Object>> jsonDataMapForOpp = getJsonDataMapForOppForRenewal(jsonDataOpp);
        // Update data in Custom metadta fro Renewal Quote And Renewal Opportunity Fields        
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (RenewalSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
           return null; 
        }
        // for Quote Renewal Setting Fields
        if (jsonDataMapForQuote.get('OriginalOpportunity') != null) {
            appConfig.RenewalQuote_OriginalOppFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('OriginalOpportunity'));
        }
        else {
           appConfig.RenewalQuote_OriginalOppFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').RenewalQuote_OriginalOppFieldSetup__c; 
        }
        if (jsonDataMapForQuote.get('Account') != null) {
           appConfig.RenewalQuote_AccountFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('Account'));
        }
        else {
         appConfig.RenewalQuote_AccountFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').RenewalQuote_AccountFieldSetup__c;   
        }        
        if (jsonDataMapForQuote.get('OriginalQuote') != null) {
            appConfig.RenewalQuote_OriginalQuoteFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('OriginalQuote'));
        }
        else {
            appConfig.RenewalQuote_OriginalQuoteFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').RenewalQuote_OriginalQuoteFieldSetup__c;
        }
        // for Renewal Opportunity Setting Fields
        if (jsonDataMapForOpp.get('OriginalOpportunity') != null) {
            appConfig.RenewalOpportunity_OriginalOppFieldSetup__c = JSON.serialize(jsonDataMapForOpp.get('OriginalOpportunity'));
        }
        else {
        appConfig.RenewalOpportunity_OriginalOppFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').RenewalOpportunity_OriginalOppFieldSetup__c;
        }
        if (jsonDataMapForOpp.get('Account') != null) {
           appConfig.RenewalOpportunity_AccountFieldSetup__c = JSON.serialize(jsonDataMapForOpp.get('Account'));
        }
        else {
         appConfig.RenewalOpportunity_AccountFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').RenewalOpportunity_AccountFieldSetup__c;   
        }        
        return EasyCpqMdtMngr.upsertMetadata(new List<App_Configuration__mdt> { appConfig });  
    }
    public static Map<String, List<Object>> getJsonDataMapForQuoteForRenewal(String jsonDataQuote) {
        List<Object> jsonListForQuote = (List<Object>) JSON.deserializeUntyped(jsonDataQuote);
        Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
        for (Object obj : jsonListForQuote) {
            Map<String, Object> data = (Map<String, Object>) obj;
            String objectName = (String) data.get('objectName');
            if(!jsonDataMapForQuote.containsKey(objectName)){            
                jsonDataMapForQuote.put(objectName, new List<Object>());
            }
            jsonDataMapForQuote.get(objectName).add(data);        
        }
        return jsonDataMapForQuote;
    }
    public static Map<String, List<Object>> getJsonDataMapForOppForRenewal(String jsonDataOpp ) {
        List<Object> jsonListForOpp = (List<Object>) JSON.deserializeUntyped(jsonDataOpp);
        Map<String, List<Object>> jsonDataMapForOpp = new Map<String, List<Object>>();
        for (Object obj : jsonListForOpp) {
            Map<String, Object> data = (Map<String, Object>) obj;
            String objectName = (String) data.get('objectName');
            if(!jsonDataMapForOpp.containsKey(objectName)){            
                jsonDataMapForOpp.put(objectName, new List<Object>());
            }
            jsonDataMapForOpp.get(objectName).add(data);        
        }
        return jsonDataMapForOpp;        
    }
    /**
    * @description: Method to get Amend Quote fields setup
    * @author: Roshan Jambhule - Bluvium | 13-06-2023
    * @return: List<Object>
    **/
    public static List<Object> getAmendQuoteFieldsSetup() {           
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (AmendSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
            return new List<Object>();
        } 
        List<Object> result = new List<Object>();
        if (appConfig.AmendQuote_OriginalOppFieldSetup__c != null && !String.isBlank(appConfig.AmendQuote_OriginalOppFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.AmendQuote_OriginalOppFieldSetup__c));
        }
        if (appConfig.AmendQuote_OriginalQuoteFieldSetup__c != null && !String.isBlank(appConfig.AmendQuote_OriginalQuoteFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.AmendQuote_OriginalQuoteFieldSetup__c));
        }
        if (appConfig.AmendQuote_AccountFieldSetup__c != null && !String.isBlank(appConfig.AmendQuote_AccountFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.AmendQuote_AccountFieldSetup__c));
        }              
        return result;
    }
    /**
    * @description: Method to get Amend Opportunity fields setup
    * @author: Roshan Jambhule - Bluvium | 20-06-2023
    * @return: List<Object>
    **/
    public static List<Object> getAmendOpportunityFieldsSetup() {               
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
		if(Test.isRunningTest() && (AmendSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }        
        if(appConfig == null) {
            return new List<Object>();
        }        
        List<Object> result = new List<Object>();
        if (appConfig.AmendOpportunity_AccountFieldSetup__c != null && !String.isBlank(appConfig.AmendOpportunity_AccountFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.AmendOpportunity_AccountFieldSetup__c));
        }
        if (appConfig.AmendOpportunity_OriginalOppFieldSetup__c != null && !String.isBlank(appConfig.AmendOpportunity_OriginalOppFieldSetup__c)) {
            result.addAll((List<Object>) JSON.deserializeUntyped(appConfig.AmendOpportunity_OriginalOppFieldSetup__c));
        }
        return result;
    }
    /**
    * @description: Method to Set Amend OpportunitysettingData and Ammend Quote Setting Data
    * @author: Nitesh Lande - Bluvium | 
    * @return: List<Object>
    **/
    public static string setCustomMetaDataForAmmendFieldMapping(String jsonDataQuote, String jsonDataOpp ) {     
        Map<String, List<Object>> jsonDataMapForQuote = getJsonDataMapForQuoteForAmend(jsonDataQuote);
        Map<String, List<Object>> jsonDataMapForOpp = getJsonDataMapForOppForAmend(jsonDataOpp);       
        // Update data in Custom metadta for Ammend Quote And Ammend OPP Feids        
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (AmendSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
           return null; 
        }
        // for AmendQuote Setting Fields
        if (jsonDataMapForQuote.get('OriginalOpportunity') != null) {
            appConfig.AmendQuote_OriginalOppFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('OriginalOpportunity'));
        }
        else{
            appConfig.AmendQuote_OriginalOppFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').AmendQuote_OriginalOppFieldSetup__c;
        }
        if (jsonDataMapForQuote.get('Account') != null) {
           appConfig.AmendQuote_AccountFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('Account'));
        }
        else{
            appConfig.AmendQuote_AccountFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').AmendQuote_AccountFieldSetup__c;
        }
        if (jsonDataMapForQuote.get('OriginalQuote') != null) {
            appConfig.AmendQuote_OriginalQuoteFieldSetup__c = JSON.serialize(jsonDataMapForQuote.get('OriginalQuote'));
        }
        else{
            appConfig.AmendQuote_OriginalQuoteFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').AmendQuote_OriginalQuoteFieldSetup__c;
        }
        // for AmmendOpportunity Setting Fields
        if (jsonDataMapForOpp.get('OriginalOpportunity') != null) {
            appConfig.AmendOpportunity_OriginalOppFieldSetup__c = JSON.serialize(jsonDataMapForOpp.get('OriginalOpportunity'));
        }
        else{
            appConfig.AmendOpportunity_OriginalOppFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').AmendOpportunity_OriginalOppFieldSetup__c;
        }
        if (jsonDataMapForOpp.get('Account') != null) {
           appConfig.AmendOpportunity_AccountFieldSetup__c = JSON.serialize(jsonDataMapForOpp.get('Account'));
        }
        else{
            appConfig.AmendOpportunity_AccountFieldSetup__c = EasyCpqQueries.getAppConfigByRecordName('Default').AmendOpportunity_AccountFieldSetup__c;
        }        
        return EasyCpqMdtMngr.upsertMetadata(new List<App_Configuration__mdt> { appConfig });  
    }
    public static Map<String, List<Object>> getJsonDataMapForQuoteForAmend(String jsonDataQuote) {
        //for Ammed Quote Setting Data       
        List<Object> jsonListForQuote = (List<Object>) JSON.deserializeUntyped(jsonDataQuote);
        Map<String, List<Object>> jsonDataMapForQuote = new Map<String, List<Object>>();
        for (Object obj : jsonListForQuote) {
            Map<String, Object> data = (Map<String, Object>) obj;
            String objectName = (String) data.get('objectName');
            if(!jsonDataMapForQuote.containsKey(objectName)){            
                jsonDataMapForQuote.put(objectName, new List<Object>());
            }
            jsonDataMapForQuote.get(objectName).add(data);        
        }
        return jsonDataMapForQuote; 
    }
    public static Map<String, List<Object>> getJsonDataMapForOppForAmend(String jsonDataOpp) {
      //for Ammed Opportunity Setting Data      
      List<Object> jsonListForOpp = (List<Object>) JSON.deserializeUntyped(jsonDataOpp);
      Map<String, List<Object>> jsonDataMapForOpp = new Map<String, List<Object>>();
      for (Object obj : jsonListForOpp) {
          Map<String, Object> data = (Map<String, Object>) obj;
          String objectName = (String) data.get('objectName');
          if(!jsonDataMapForOpp.containsKey(objectName)){            
              jsonDataMapForOpp.put(objectName, new List<Object>());
            }
          jsonDataMapForOpp.get(objectName).add(data);        
        }
        return jsonDataMapForOpp;          
    }
    /**
    * @description: Method to get New Quote fields setup from metadata
    * @author: Amit Aher - Bluvium | 20-04-2023
    * @return: List<Object>
    **/
    public static List<Object> getNewQuoteFieldsSetup() {        
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (NewQuoteSettingControllerTest.nullCheck ||EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
            return new List<Object>();
        }
        String value = appConfig.New_Quote_Fields_Setup__c;
        if( String.isBlank(value) ) {
            return new List<Object>();
        }
        return (List<Object>) JSON.deserializeUntyped(value);
    }  
    /**
    * @description: Method to set New Quote fields setup
    * @author: Amit Aher - Bluvium | 20-04-2023
    * @return: List<Object>
    **/
    public static String setNewQuoteFieldsSetup(String jsonData) {
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (NewQuoteSettingControllerTest.nullCheck ||EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
           return null; 
        }
        appConfig.New_Quote_Fields_Setup__c = jsonData;
        return EasyCpqMdtMngr.upsertMetadata(new List<App_Configuration__mdt> { appConfig });
    }
    
    /**
    * @description: Method to get Additional setting fields data From metadata
    * @author: Roshan Jambhule - Bluvium | 30-06-2023
    * @return: App_Configuration__mdt
    **/
    public static App_Configuration__mdt getAdditionalSettingFieldsSetup() {
        return EasyCpqQueries.getAppConfigByRecordName('Default');      
    }
    /**
    * @description: Method to Set custom metadata CheckBox Fields
    * @author: Roshan Jambhule - Bluvium | 22-05-2023 
    * @param: String jsonData 
    * @return: String 
    **/
    @AuraEnabled
    public static String setAdditionalSettingFieldsSetup(String jsonData) {        
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonData);        
        App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        if(Test.isRunningTest() && (CoreSettingControllerTest.nullCheck || EasyCpqUtilsTest.nullCheck)){
            appConfig = null;
        }
        if(appConfig == null) {
           return null; 
        }
        appConfig.Auto_Select_Master_Contract__c = (Boolean) jsonMap.get('isAutoSelectMasterContract'); 
        appConfig.Generate_New_Amendment_Opportunity__c = (Boolean) jsonMap.get('isGenerateNewAmendmentOpportunity'); 
        appConfig.Generate_New_Renewal_Opportunity__c = (Boolean) jsonMap.get('isGenerateNewRenewalOpportunity');
        appConfig.Maintain_QuoteLine_Groups__c = (Boolean) jsonMap.get('isMaintainQuoteLineGroup');
        appConfig.Maintain_QuoteLine_Groups_for_Amendment__c = (Boolean) jsonMap.get('isMaintainQuoteLineGroupForAmendment');
        appConfig.Maintain_QuoteLine_Groups_for_renewal__c = (Boolean) jsonMap.get('isMaintainQuoteLineGroupForRenewal');
        String quoteStage = (String) jsonMap.get('quoteStage');
        appConfig.Quote_Stage__c = quoteStage;
        return EasyCpqMdtMngr.upsertMetadata(new List<App_Configuration__mdt> { appConfig });
    }   
    /**
    * @description: Method to dynamically get the fields from a fieldset for an object 
    * @author: Amit Aher - Bluvium | 19-04-2023 
    * @param: a. String objectName
    *         b. String fieldsetName 
    * @return: List<String> 
    **/
    public static List<String> getFieldsetFields(String objectName, String fieldsetName) {
        List<String> fieldsetFields = new List<String>();
        Schema.DescribeSObjectResult objDescribeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.FieldSet fieldSet = objDescribeResult.fieldSets.getMap().get(fieldsetName);
        for (Schema.FieldSetMember field : fieldSet.getFields()) {
            fieldsetFields.add(field.getFieldPath());
        }
        return fieldsetFields;
    }
}
