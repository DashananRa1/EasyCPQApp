/***************************************************************************************
 * @description       : This Trigger is for maintaining the Group and Groupline for Amend 
 *                      and Renewal Process Platform Event
 * @author            : Kavita Kore - Bluvium
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
trigger QuoteTrigger on SBQQ__Quote__c(after update) {
  if (Trigger.isAfter && Trigger.isUpdate) {
      system.debug('inside trigger');
     //QuoteTriggerHandler.afterInsert(Trigger.New);
  }
}