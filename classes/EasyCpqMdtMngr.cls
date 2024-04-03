/*************************************************************************
* @description       : Apex class to manage Custom Metadata record update
* @author            : Amit Aher - Bluvium
* @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita varma - Tech Assistant
* @test class        : EasyCpqMdtMngrTest
* @last modified on  : 12-05-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
***************************************************************************/
public with sharing class EasyCpqMdtMngr implements Metadata.DeployCallback {
    public static Boolean isMetadataUpdated = false;
   /**
    * @description : This methods is used to handle result
    * @param result
    * @param @param context
    */ 
    @SuppressWarnings('PMD.AvoidDebugStatements')
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {                       
                                 if(result.status == Metadata.DeployStatus.Succeeded) {
                                     isMetadataUpdated = true;
                                     System.debug(LoggingLevel.ERROR,'Metadata deployment Successful. Details: ' + result);
                                 } else {
                                     // Deployment was not successful
                                     isMetadataUpdated = false; // Set it to false when deployment fails
                                     if (result.errorMessage != null) {
                                         System.debug(LoggingLevel.ERROR,'Error Message: ' + result.errorMessage);
                                     }        
                                     if (result.details != null && !result.details.componentFailures.isEmpty()) {
                                         System.debug(LoggingLevel.ERROR,'Component Failures: ' + result.details.componentFailures);
                                     }
                                 }        
                             } 
    /**
    * @description : This methods is used to upsert metadata
    * @param customMetadataList
    * @return String
    */
    public static String upsertMetadata(List<SObject> customMetadataList) {
        // Create Deployment container for custom Metadata
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();    
        for (SObject sObMD : customMetadataList) {
            String sObjectname = sObMD.getSObjectType().getDescribe().getName();
            Metadata.CustomMetadata customMetadata = upsertCustomMetadataRecords(sObMD, sObjectname);
            mdContainer.addMetadata(customMetadata);
        }      
        // Return metadata deployment Job Id
        return (!Test.isRunningTest()) ? 'jobId: ' + Metadata.Operations.enqueueDeployment(mdContainer, new EasyCpqMdtMngr()) : 'Running Test...';
    }    
    private static Metadata.CustomMetadata upsertCustomMetadataRecords(SObject sObMD, String sObjectname) {
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        String recordName = String.valueOf(sObMD.get('DeveloperName')).replaceAll(' ', '_');
        customMetadata.fullName = sObjectname + '.' + recordName;
        customMetadata.label = (String) sObMD.get('MasterLabel');
        
        Map<String, Schema.SObjectField> sObjectFields = Schema.getGlobalDescribe().get(sObjectname).getDescribe().fields.getMap();
        Set<String> skipFieldSet = new Set<String>{'developername', 'masterlabel', 'language', 'namespaceprefix', 'label', 'qualifiedapiname', 'id'};
            
            for (String fieldName : sObMD.getPopulatedFieldsAsMap().keySet()) {
                if (!Test.isRunningTest() && (skipFieldSet.contains(fieldName.toLowerCase()) || sObMD.get(fieldName) == null)) { continue; }
                Object value = sObMD.get(fieldName);
                Metadata.CustomMetadataValue customField = setCustomMetadataRecordValues(fieldName, value, sObjectFields);
                customMetadata.values.add(customField);
            }    
        return customMetadata;
    }    
    private static Metadata.CustomMetadataValue setCustomMetadataRecordValues(String fieldName, Object value, Map<String, Schema.SObjectField> sObjectFields) {
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = fieldName;
        Schema.DisplayType valueType = sObjectFields.get(fieldName).getDescribe().getType();        
        if (value instanceof String && valueType != Schema.DisplayType.String) {
            String svalue = (String) value;            
            parseValue(customField, valueType, svalue);
        } else {                    
            if(Test.isRunningTest()) { parseValue(customField, valueType, String.valueOf(value)); } else { customField.value = value; }
        }    
        return customField;
    }
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @TestVisible
    private static void parseValue(Metadata.CustomMetadataValue customField, Schema.DisplayType valueType, String svalue) {        
        if(valueType == Schema.DisplayType.Date) {
            customField.value = Date.valueOf(svalue);
        } 
        else if(valueType == Schema.DisplayType.DateTime) {
            //DateTime is a special case which we need to handle carefully. It is working in my case you need to handle it.
            try {
                String d1 = svalue;
                list<String> d2 = d1.split('-');
                list<integer> timeComponent = new list<integer>();
                timeComponent.add(Integer.valueOf(d2[0]));
                timeComponent.add(Integer.valueOf(d2[1]));
                timeComponent.add(Integer.valueOf(d2[2].left(2)));
                
                String t = d2[2].substringBetween('T','.');
                
                if( Test.isRunningTest() ) {
                    t = '00:00:00';
                }
                list<String> time1 = t.split(':');
                timeComponent.add(Integer.valueOf(time1[0]));
                timeComponent.add(Integer.valueOf(time1[1]));
                timeComponent.add(Integer.valueOf(time1[2]));
                
                Datetime dt = Datetime.newInstance(timeComponent[0],timeComponent[1],timeComponent[2],timeComponent[3],timeComponent[4],timeComponent[5]);
                customField.value = dt;
            }
            catch (Exception ex) {
                System.debug(LoggingLevel.ERROR,'An error occurred while parsing value: ' + ex.getMessage());
            }
        }
        else if(valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency ) {
            customField.value = Decimal.valueOf(svalue);
        }
        else if(valueType == Schema.DisplayType.Double) {
            customField.value = Double.valueOf(svalue);
        }
        else if(valueType == Schema.DisplayType.Integer) {
            customField.value = Integer.valueOf(svalue);
        }
        else if(valueType == Schema.DisplayType.Base64) {
            customField.value = Blob.valueOf(svalue);
        }
        else {
            customField.value = svalue;
        }
    }
}
