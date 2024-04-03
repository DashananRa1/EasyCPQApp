/***************************************************************************************
 * @description       : This Class is controller for LWC Component(Core_Setting_LWC)
 * @author            : Roshan Jambhule - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : CoreSettingControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class CoreSettingController {
    /**
    * @description:Method to get list of Checkbox fields from App_Configuration__mdt(Custom Metadata)
    * @author: Roshan Jambhule - Bluvium | 23-05-2023 
    * @return: List<String> 
    **/
    @AuraEnabled(cacheable=true)
    public static App_Configuration__mdt getAddittionSettingDataFromMetadata(String recordName) {    
        return EasyCpqUtils.getAdditionalSettingFieldsSetup();
    }
    /**
    * @description:Method to Set list of Checkbox fields from Mappings Page Core Setting Component
    * @author: Roshan Jambhule - Bluvium | 23-05-2023 
    * @param: Boolean value
    * @return: App_Configuration__mdt 
    **/
    @AuraEnabled
    public static string setAddittionSettingDataFromMetadata(String jsonStr) {        
        return EasyCpqUtils.setAdditionalSettingFieldsSetup(jsonStr);
    }    
}
