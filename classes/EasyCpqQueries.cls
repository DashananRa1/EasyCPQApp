/***************************************************************************************
 * @description       : Apex Class to Store All Queries
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
public with sharing class EasyCpqQueries {
  /**
   * @description: Method to get custom metadata record
   * @author: Roshan Jambhule - Bluvium | 25-04-2023
   * @modified:Roshan Jambhule - Bluvium | 13-06-2023
   * @param: String recordName
   * @return: App_Configuration__mdt
   **/
  @AuraEnabled(cacheable=true)
  public static BECPQ__App_Configuration__mdt getAppConfigByRecordName(
    String recordName
  ) {
    List<BECPQ__App_Configuration__mdt> appCon = [
      SELECT
        Id,
        BECPQ__New_Quote_Fields_Setup__c,
        BECPQ__Auto_Select_Master_Contract__c,
        BECPQ__Generate_New_Amendment_Opportunity__c,
        BECPQ__Generate_New_Renewal_Opportunity__c,
        BECPQ__Maintain_QuoteLine_Groups__c,
        BECPQ__Quote_Stage__c,
        BECPQ__RenewalQuote_AccountFieldSetup__c,
        BECPQ__RenewalQuote_OriginalOppFieldSetup__c,
        BECPQ__RenewalQuote_OriginalQuoteFieldSetup__c,
        BECPQ__RenewalOpportunity_AccountFieldSetup__c,
        BECPQ__RenewalOpportunity_OriginalOppFieldSetup__c,
        BECPQ__AmendQuote_AccountFieldSetup__c,
        BECPQ__AmendQuote_OriginalQuoteFieldSetup__c,
        BECPQ__AmendQuote_OriginalOppFieldSetup__c,
        BECPQ__AmendOpportunity_AccountFieldSetup__c,
        BECPQ__AmendOpportunity_OriginalOppFieldSetup__c,
        DeveloperName,
        MasterLabel,
        BECPQ__Maintain_QuoteLine_Groups_for_renewal__c,
        BECPQ__Maintain_QuoteLine_Groups_for_Amendment__c
      FROM BECPQ__App_Configuration__mdt
      WHERE DeveloperName = :String.escapeSingleQuotes(recordName)
      WITH SECURITY_ENFORCED
    ]; //QualifiedApiName

    if (!appCon.isEmpty()) {
      if (appCon.size() > 1) {
        return appCon[appCon.size() - 1];
      } else {
        return appCon[0];
      }
    }
    // If no configuration records are found, return null or handle appropriately
    return null;
  }
}