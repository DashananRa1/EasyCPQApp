/***************************************************************************************
 * @description       : Apex Class for LWC Components as Controller For NewQuoteCopy (Lwc Component)
 * @author            : Nitesh Lande - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : NewQuoteSettingControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class NewQuoteSettingController {
    /**
    * @description: Method to get list of Quote fields from Metadata
    * @author: Amit Aher - Bluvium | 19-04-2023 
    * @return: List<String> 
    **/
    @AuraEnabled(cacheable=true)
     public static List<Object> getQuoteFields() {       
         return EasyCpqUtils.getNewQuoteFieldsSetup();
     }
    /**
    * @description: Method to set list of Quote fields to Metadata
    * @author: Amit Aher - Bluvium | 19-04-2023 
    * @param: String jsonData 
    * @return: String 
    **/
   @AuraEnabled
     public static string setQuoteFields(String jsonStr) {        
         return EasyCpqUtils.setNewQuoteFieldsSetup(jsonStr);
     }  
}