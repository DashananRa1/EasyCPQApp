/***************************************************************************************
 * @description       : Apex Class for LWC Components as Controller to get and set the Methods
 * @author            : Roshan Jambhule - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : RenewalSettingControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class RenewalSettingController {    
    /** 
    * @description: It retrieves a list of renewed Quote fields from Metadata and returns it as a list of objects
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<Object> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Object> getRenewalQuoteFields() {        
        return EasyCpqUtils.getRenewedQuoteFieldsSetup();
    }
    /**
    * @description: It retrieves a list of renewed Opportunity fields from Metadata 
    * and returns it as a list of objects.
    * @author: Roshan Jambhule - Bluvium | 29-06-2023 
    * @return: List<Object> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Object> getRenewalOpportunityFields() {       
        return EasyCpqUtils.getRenewalOpportunityFieldsSetup();
    }
    /**
    * @description: It sets Renewal Opportunity Setting Data and Renewal Quote Setting 
    * Data based on the input JSON strings and returns a string response.
    * @author: Roshan Jambhule- Bluvium 17-07-2023
    * @param: String quoteJsonStr , String opportunityJsonStr
    * @return: String 
    *
    */
    @AuraEnabled
    public static string setRenewalMetadataFields(String quoteJsonStr, String opportunityJsonStr) {        
        return EasyCpqUtils.setCustomMetaDataForRenewalFieldMapping(quoteJsonStr,opportunityJsonStr);
    } 
}