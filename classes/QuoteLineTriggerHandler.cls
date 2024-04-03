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
public with sharing class QuoteLineTriggerHandler {
    public static Boolean fromRenewalLWC= false;   
    public static void afterInsert(List<SBQQ__QuoteLine__c> newList){     
        BECPQ__App_Configuration__mdt mataRec = EasyCpqQueries.getAppConfigByRecordName('Default');       
        if((mataRec != null && (mataRec.BECPQ__Maintain_QuoteLine_Groups_for_renewal__c||
            mataRec.BECPQ__Maintain_QuoteLine_Groups_for_Amendment__c ) || Test.isRunningTest()) && !fromRenewalLWC){          
            List<String> qId = new List<String>();
            List<String> quoteId = new List<String>();                        
            for(SBQQ__QuoteLine__c rec : newList){              
                qId.add(rec.SBQQ__Quote__c);                 
            }            
            List<SBQQ__Quote__c> quoteList = [Select Id,BECPQ__Has_Group__c ,SBQQ__MasterContract__c,SBQQ__Type__c From SBQQ__Quote__c WHERE ID IN:qId WITH SECURITY_ENFORCED];            
            for(SBQQ__Quote__c objQuote :quoteList){
                if((objQuote.SBQQ__Type__c == 'Amendment' && objQuote.SBQQ__MasterContract__c != null ) ||(objQuote.SBQQ__Type__c == 'Renewal')){
                    quoteId.add(objQuote.id);
                }
            }
            if(quoteId.size()>0){                
                QuoteLineAnalyzerTriggerHandler.handleAfterInsert(quoteId);                              
                List<SBQQ__Quote__c> qtopdate = new List<SBQQ__Quote__c>();
                for (String rec : quoteId) {
                    qtopdate.add(new SBQQ__Quote__c (id =rec,SBQQ__LineItemsGrouped__c = true, BECPQ__Has_Group__c=true));
                }
                if(Schema.sObjectType.SBQQ__Quote__c.isUpdateable()){
                 update qtopdate;
                }                 
            }
        }
    }
}