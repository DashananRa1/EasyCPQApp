/***************************************************************************************
 * @description       : This Class is controller for LWC Component(AmendSeting)
 * @author            : Roshan Jambhule - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : QuoteCreationControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class AmendSettingController {
    /**
    * @description: Method to get list of Amend Quote fields from Metadata
    * @author: Roshan - Bluvium | 13-06-2023 
    * @return: List<String> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Object> getAmendQuoteFields() {        
        return EasyCpqUtils.getAmendQuoteFieldsSetup();
    }
    /**
    * @description: Method to get list of Amend Opportunity fields from Metadata
    * @author: Roshan Jambhule - Bluvium | 19-06-2023 
    * @return: List<String> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Object> getAmendOpportunityFields() {       
        return EasyCpqUtils.getAmendOpportunityFieldsSetup();
    }
    /**
    * @description: Method to set Amend OpportunitySetting Data and Ammend QuoteSettigData to Metadata
    * @author: Nitesh Lande - Bluvium 17-07-2023
    * @param: String quoteJsonStr , String opportunityJsonStr
    * @return: String
    */
    @AuraEnabled
    public static string setAmendMetadataFields(String quoteJsonStr, String opportunityJsonStr) {        
        return EasyCpqUtils.setCustomMetaDataForAmmendFieldMapping(quoteJsonStr,opportunityJsonStr);
    }
}