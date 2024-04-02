/***************************************************************************************
 * @description       : This Class is controller for LWC Component(New_Quote_LWC)
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
public with sharing class QuoteCreationController { 
    
    /**
    * @description: Method to update New Quote Field mapping on Quote Creation
    * @author: Roshan Jambhule - Bluvium | 23-05-2023 
    * @return: List<String> 
    **/
    @AuraEnabled 
    public static ID createQuote(String opportunityId, String quoteAccountId, String newQuoteId){        
        return CreateQuoteLWC.createQuoteMethod(opportunityId,quoteAccountId,newQuoteId);
    }    
    
    public class QuoteWrapper {        
        @AuraEnabled 
        public Date quoteStartDate { get; set; }        
        @AuraEnabled 
        public Id opportunityId { get; set; }        
        @AuraEnabled 
        public Date quoteExpirationDate { get; set; }        
        @AuraEnabled 
        public String quotePaymentTerm { get; set; }  
        @AuraEnabled 
        public String quoteType { get; set; }
        @AuraEnabled 
        public Id quotePriceBookId { get; set; }
        // new Added
        @AuraEnabled 
        public Id quoteOpportunityId { get; set; }
        @AuraEnabled 
        public Id quoteAccountId { get; set; }
        @AuraEnabled 
        public Id newQuoteId { get; set; }
    }    
}