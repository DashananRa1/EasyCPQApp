/***********************************************************************************************************
 * @description       : Apex Class to Create Renewal Quote and Renewal Opportunity from Quick Action button
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
 ********************************************************************************************************/
public with sharing class CreateRenewLWC {
    @AuraEnabled
    // Create Map of Label and fieldName to use this map in columns of datatable
    public static string getFieldLableAndFieldAPI(){
        List<Map<String ,String>> listOfFieldSet  = new  List<Map<String ,String>>();
            for(Schema.FieldSetMember fieldset : SObjectType.Contract.FieldSets.Renewal.getFields()) {
                Map<String ,String> lableAPIMap = new Map<String ,String>();
                lableAPIMap.put(fieldset.getLabel(),fieldset.getFieldPath());
                listOfFieldSet.add(lableAPIMap);
            }
        return JSON.serialize(listOfFieldSet);
    }
    @AuraEnabled(cacheable=true)
    public static List<Contract> getContracts(String accId) {
        try{
            List<Contract> conList;            
            Set<String> fieldPaths = new Set<String>();            
            for (Schema.FieldSetMember f : SObjectType.Contract.FieldSets.Renewal.getFields()) {
                fieldPaths.add(f.getFieldPath());
            }
            Schema.SObjectType schema = schema.getGlobalDescribe().get('Contract');
            Map<String, Schema.SObjectField> fields = Schema.getDescribe().fields.getMap();
            List<String> fieldList = new List<String>{'SBQQ__RenewalForecast__c','SBQQ__RenewalQuoted__c','SBQQ__RenewalOpportunity__c','SBQQ__Opportunity__c','SBQQ__Quote__c', 'AccountId'};
            fieldList.addAll(fieldPaths);
            if(!CRUD_FLS_CheckUtility.checkReadAccess(fieldList, fields)){
                throw  new AuraHandledException('Permission missing for quote fields.');
            }
            String query = 'SELECT Id,SBQQ__RenewalForecast__c,SBQQ__RenewalQuoted__c,SBQQ__RenewalOpportunity__c,SBQQ__Opportunity__c,SBQQ__Quote__c, AccountId,' +
            String.join(new List<String>(fieldPaths), ', ') + ' FROM Contract WHERE AccountId =:accId WITH SECURITY_ENFORCED';
            conList = Database.query(String.escapeSingleQuotes(query));
            return conList;   
        } catch(Exception e) {
            System.debug('Error'+e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Contract> renewContractUpdate(List<Contract> lstContractUpdate,string oppId) {        
        List<Contract> originalConUpdate = new List<Contract>();
        List<Contract> contractList = new List<Contract>();
        Schema.SObjectType schemaContract = Schema.getGlobalDescribe().get('Contract');
        Map<String, Schema.SObjectField> fields = SchemaContract.getDescribe().fields.getMap();
        List<String> fieldList = new List<String>{'SBQQ__RenewalForecast__c','SBQQ__RenewalQuoted__c','SBQQ__RenewalOpportunity__c','SBQQ__Opportunity__c','SBQQ__Quote__c', 'AccountId'};
        if(!CRUD_FLS_CheckUtility.checkReadAccess(fieldList, fields)){
            throw  new AuraHandledException('Permission missing for quote fields.');
        }
        if(!CRUD_FLS_CheckUtility.checkUpdateAccess(new set<String>{'SBQQ__RenewalForecast__c','SBQQ__RenewalQuoted__c','SBQQ__RenewalOpportunity__c','SBQQ__Opportunity__c','SBQQ__Quote__c', 'AccountId'}, Fields)){
            throw  new AuraHandledException('Permission update missing for contract fields.');
        }
        BECPQ__App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
        Boolean newRenewalOpp = appConfig.BECPQ__Generate_New_Renewal_Opportunity__c;
        Integer contractCount = [SELECT COUNT() FROM Contract WHERE SBQQ__Opportunity__c= :oppId  WITH SECURITY_ENFORCED];
        if(contractCount>0 && !newRenewalOpp){                           
            return lstContractUpdate;
        }
        else{            
            for(Contract objConUpdate : lstContractUpdate) {
                if( (objConUpdate.SBQQ__RenewalForecast__c == true || objConUpdate.SBQQ__RenewalQuoted__c == true || objConUpdate.SBQQ__RenewalOpportunity__c != null)){
                    objConUpdate.SBQQ__RenewalForecast__c = false;
                    objConUpdate.SBQQ__RenewalQuoted__c = false;
                    objConUpdate.SBQQ__RenewalOpportunity__c = null;
                    originalConUpdate.add(objConUpdate);
                }
                contractList.add(objConUpdate);
            }
        }        
        if(Schema.sObjectType.Contract.isUpdateable() && !originalConUpdate.isEmpty()) {
            update originalConUpdate;
            return contractList;
        }
        return lstContractUpdate;
    }	
    @AuraEnabled
    public static string renewContract(String masterContractId, String opportunityId, List<Contract> lstContract ,String masterContOppId, String masterContQuoteId, String masterContAccId ) {
        SBQQ__Quote__c renewalQuote = new SBQQ__Quote__c();
        Opportunity renewalOpportunity = new Opportunity();
        string quoteId;
        Opportunity oppData = new Opportunity();       
        Account accData = new Account();
        SBQQ__Quote__c originalQuoteData = new SBQQ__Quote__c();
        Opportunity originaloppDataForRenewalOpp = new Opportunity();
        Account accDataForRenewalOpp = new Account();
        List<SBQQ__Quote__c> updaterenewalQuote = new List<SBQQ__Quote__c>();
        List<Opportunity> originalOpp = new List<Opportunity>();
        List<Opportunity> updateOriginalOpp = new List<Opportunity>();    
        String renewalOptyId;		
        CreateRenewalContext context = new CreateRenewalContext();
        context.masterContractId = masterContractId;
        context.renewedContracts = lstContract;
        context.returnOnlyQuoteId =true;
        String quoteJSON;
        try {
            BECPQ__App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
            Boolean newRenewalOpp = appConfig.BECPQ__Generate_New_Renewal_Opportunity__c;
            Boolean mainQlGroup = appConfig.BECPQ__Maintain_QuoteLine_Groups_for_renewal__c;      
            Integer contractCount = [SELECT COUNT() FROM Contract WHERE SBQQ__Opportunity__c= :opportunityId  WITH SECURITY_ENFORCED];               
            if(contractCount>0 && !newRenewalOpp){                              
                throw  new AuraHandledException('The primary quote cannot be changed for the opportunity because an order has been created from the quote.');
            }
            else{
                QuoteTriggerHandler.fromRenewalLWC = true;
                quoteJSON = SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractRenewer', masterContractId, JSON.serialize(context));
            }                         
            List<Object> quoteJSONList =   (List<Object>) JSON.deserializeUntyped(quoteJSON);
            Map<String, Object> quoteJSONMap = (Map<String, Object>)quoteJSONList[0];
            quoteId =  (String)quoteJSONMap.get('Id');    
            renewalQuote = [SELECT ID, NAME, SBQQ__Opportunity2__c,SBQQ__PriceBook__c, SBQQ__SubscriptionTerm__c FROM SBQQ__Quote__c WHERE ID =: quoteId WITH SECURITY_ENFORCED LIMIT 1];
            renewalOpportunity = [SELECT ID, NAME FROM Opportunity WHERE ID =: renewalQuote.SBQQ__Opportunity2__c WITH SECURITY_ENFORCED LIMIT 1];            
            string opportunityFields = appConfig.BECPQ__RenewalQuote_OriginalOppFieldSetup__c;
            string accountFields = appConfig.BECPQ__RenewalQuote_AccountFieldSetup__c;
            string originalQuoetFields = appConfig.BECPQ__RenewalQuote_OriginalQuoteFieldSetup__c;            
            string originalOppToRenewalOppFieldsMapping = appConfig.BECPQ__RenewalOpportunity_OriginalOppFieldSetup__c;
            string accountToRenewalOpportunityFieldsMapping = appConfig.BECPQ__RenewalOpportunity_AccountFieldSetup__c;           
            set<string> originalOpportunityFieldSet = new set<string>();
            set<string> accountFieldSet = new set<string>();
            set<string> originlQuoteFieldSet= new set<string>();           
            set<string> originalOpportunityFieldSetForRenewalOpp = new set<string>();
            set<string> accountFieldSetForRenewalOpp = new set<string>();            
            Map<String,string> quoteFieldToOpportunityFieldMap = new Map<String,string>();
            Map<String,string> quoteFieldToAccountFieldMap = new Map<String,string>();
            Map<String,string> quoteFieldToOrigQuoteFieldsMap = new Map<String,string>();            
            Map<String,string> originalOppToRenewalOppFieldMap = new Map<String,string>();
            Map<String,string> accToRenewalOppFieldMap = new Map<String,string>();
            if(string.isNotBlank(opportunityFields)){        
                for(Object obj : (List<Object>)JSON.deserializeUntyped(opportunityFields)){
                    Map<String, Object> data = (Map<String, Object>)obj;
                    String sourceField = (String) data.get('sourcefield');
                    string targetField = (String) data.get('targetfield');                
                    if(!quoteFieldToOpportunityFieldMap.containsKey(sourceField) && string.isNotBlank(targetField)){            
                        quoteFieldToOpportunityFieldMap.put(sourceField, targetField);
                    }                   
                }            
            }
            if(string.isNotBlank(accountFields)){        
                for(Object obj : (List<Object>)JSON.deserializeUntyped(accountFields)){
                    Map<String, Object> data = (Map<String, Object>)obj;
                    String sourceField = (String) data.get('sourcefield');
                    string targetField = (String) data.get('targetfield');                                    
                    if(!quoteFieldToAccountFieldMap.containsKey(sourceField) && string.isNotBlank(targetField)){            
                        quoteFieldToAccountFieldMap.put(sourceField, targetField);
                    }                    
                }            
            }
            if(string.isNotBlank(originalQuoetFields)){        
                for(Object obj : (List<Object>)JSON.deserializeUntyped(originalQuoetFields)){
                    Map<String, Object> data = (Map<String, Object>)obj;
                    String sourceField = (String) data.get('sourcefield');
                    string targetField = (String) data.get('targetfield');                
                    if(!quoteFieldToOrigQuoteFieldsMap.containsKey(sourceField) && string.isNotBlank(targetField)){            
                        quoteFieldToOrigQuoteFieldsMap.put(sourceField, targetField);
                    }                  
                }            
            }
            if(!quoteFieldToOpportunityFieldMap.isEmpty()){         
                originalOpportunityFieldSet.addAll(quoteFieldToOpportunityFieldMap.values());            
            }
            if(!quoteFieldToAccountFieldMap.isEmpty()){         
                accountFieldSet.addAll(quoteFieldToAccountFieldMap.values());
            }
            if(!quoteFieldToOrigQuoteFieldsMap.isEmpty()){              
                originlQuoteFieldSet.addAll(quoteFieldToOrigQuoteFieldsMap.values());
            }              
            if(!originalOpportunityFieldSet.isEmpty()){
                string query = 'SELECT  AccountId,' + String.join(new List<String>(originalOpportunityFieldSet), ',') + ' FROM Opportunity WHERE Id =:masterContOppId WITH SECURITY_ENFORCED';
                oppData = Database.query(String.escapeSingleQuotes(query));        
            }
            if(!accountFieldSet.isEmpty()){
                string query = 'SELECT Id,' + String.join(new List<String>(accountFieldSet), ',') + ' FROM Account WHERE Id=:masterContAccId WITH SECURITY_ENFORCED';
                accData = Database.query(String.escapeSingleQuotes(query));         
            }  
            if(!originlQuoteFieldSet.isEmpty()){
                string query = 'SELECT Id,' + String.join(new List<String>(originlQuoteFieldSet), ',') + ' FROM SBQQ__Quote__c WHERE Id=:masterContQuoteId WITH SECURITY_ENFORCED';
                originalQuoteData = Database.query(String.escapeSingleQuotes(query));
            }         
            if(!quoteFieldToOpportunityFieldMap.isEmpty()){
                for(string quoteField:quoteFieldToOpportunityFieldMap.keyset()){           
                    renewalQuote.put(quoteField,oppData.get(quoteFieldToOpportunityFieldMap.get(quoteField))); 
                }
            }    
            if(!quoteFieldToAccountFieldMap.isEmpty()){
                for(string quoteField:quoteFieldToAccountFieldMap.keyset()){            
                    renewalQuote.put(quoteField,accData.get(quoteFieldToAccountFieldMap.get(quoteField)));
                }
            }    
            if(!quoteFieldToOrigQuoteFieldsMap.isEmpty()){
                for(string quoteField:quoteFieldToOrigQuoteFieldsMap.keyset()){            
                    renewalQuote.put(quoteField,originalQuoteData.get(quoteFieldToOrigQuoteFieldsMap.get(quoteField))); 
                }
            }  
            if(string.isNotBlank(originalOppToRenewalOppFieldsMapping)){        
                for(Object obj : (List<Object>)JSON.deserializeUntyped(originalOppToRenewalOppFieldsMapping)){
                    Map<String, Object> data = (Map<String, Object>)obj;
                    String sourceField = (String) data.get('sourcefield');
                    string targetField = (String) data.get('targetfield');                                    
                    if(!originalOppToRenewalOppFieldMap.containsKey(sourceField) && string.isNotBlank(targetField)){            
                        originalOppToRenewalOppFieldMap.put(sourceField, targetField);
                    }                  
                }            
            }
            if(string.isNotBlank(accountToRenewalOpportunityFieldsMapping)){        
                for(Object obj : (List<Object>)JSON.deserializeUntyped(accountToRenewalOpportunityFieldsMapping)){
                    Map<String, Object> data = (Map<String, Object>)obj;
                    String sourceField = (String) data.get('sourcefield');
                    string targetField = (String) data.get('targetfield');                                    
                    if(!accToRenewalOppFieldMap.containsKey(sourceField) && string.isNotBlank(targetField)){            
                        accToRenewalOppFieldMap.put(sourceField, targetField);
                    }                 
                }            
            }
            if(!originalOppToRenewalOppFieldMap.isEmpty()){            
                originalOpportunityFieldSetForRenewalOpp.addAll(originalOppToRenewalOppFieldMap.values());  
            }
            if(!accToRenewalOppFieldMap.isEmpty()){         
                accountFieldSetForRenewalOpp.addAll(accToRenewalOppFieldMap.values());
            }
            if(!originalOpportunityFieldSetForRenewalOpp.isEmpty()){
                string query = 'SELECT  AccountId,' + String.join(new List<String>(originalOpportunityFieldSetForRenewalOpp), ',') + ' FROM Opportunity WHERE Id =:masterContOppId WITH SECURITY_ENFORCED';
                originaloppDataForRenewalOpp = Database.query(String.escapeSingleQuotes(query));        
            }    
            if(!accountFieldSetForRenewalOpp.isEmpty()){
                string query = 'SELECT Id,' + String.join(new List<String>(accountFieldSetForRenewalOpp), ',') + ' FROM Account WHERE Id =:masterContAccId WITH SECURITY_ENFORCED';
                accDataForRenewalOpp = Database.query(String.escapeSingleQuotes(query)); 
            }  
            if(!originalOppToRenewalOppFieldMap.isEmpty()){
                for(string renewalOppField:originalOppToRenewalOppFieldMap.keyset()){           
                    renewalOpportunity.put(renewalOppField,originaloppDataForRenewalOpp.get(originalOppToRenewalOppFieldMap.get(renewalOppField)));     
                }
            }        
            if(!accToRenewalOppFieldMap.isEmpty()){
                for(string renewalOppField:accToRenewalOppFieldMap.keyset()){            
                    renewalOpportunity.put(renewalOppField,accDataForRenewalOpp.get(accToRenewalOppFieldMap.get(renewalOppField))); 
                }
            } 
            
            if(mainQlGroup){                
                CreateRenewalLwcHandler.toMaintainQlGrp(lstContract,renewalQuote.id) ;
                    renewalQuote.SBQQ__LineItemsGrouped__c = true;
                }
                QuoteTriggerHandler.fromRenewalLWC = false;           
                if(newRenewalOpp){                
                    if(Schema.sObjectType.SBQQ__Quote__c.isUpdateable()){
                        update renewalQuote;
                    }    
                    if(Schema.sObjectType.Opportunity.isUpdateable()){
                        update renewalOpportunity;
                    }                
                }
            if(Test.isRunningTest()){
                IF(newRenewalOpp){
                    appConfig.BECPQ__Generate_New_Renewal_Opportunity__c = false;
                } 
            }
            if(!newRenewalOpp){ 
                List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();                           
                List<Opportunity> orgnlOpp = new List<Opportunity>();
                Set<Id> manualOppQuote = New Set<Id>();
                orgnlOpp =[SELECT Id, Name, SBQQ__PrimaryQuote__c, (SELECT Id,SBQQ__Primary__c FROM SBQQ__Quotes2__r WHERE SBQQ__Primary__c = true) FROM  Opportunity WHERE ID =: opportunityId WITH SECURITY_ENFORCED LIMIT 1];
                renewalQuote.SBQQ__Opportunity2__c = opportunityId; 
                renewalQuote.SBQQ__Primary__c = true;                               
                List<Contract> updateContracts=new List<Contract>();
                for(Contract contract : lstContract){
                    contract.SBQQ__RenewalOpportunity__c= orgnlOpp[0].Id;
                    contract.SBQQ__RenewalQuoted__c=true;
                    contract.SBQQ__RenewalForecast__c=true;
                    updateContracts.add(contract);
                }
                for(Opportunity objOpp : orgnlOpp) {
                    if(objOpp.SBQQ__PrimaryQuote__c!=null){
                        manualOppQuote.add(objOpp.SBQQ__PrimaryQuote__c);
                    }
                    if(renewalQuote != null) {
                        objOpp.SBQQ__PrimaryQuote__c = renewalQuote.Id;
                        objOpp.Pricebook2Id = renewalQuote.SBQQ__PriceBook__c;
                        objOpp.SBQQ__Renewal__c = true;
                        objOpp.SBQQ__RenewedContract__c = masterContractId; 
                    }
                    if(!objOpp.Name.contains(' -Renewal')) {
                        objOpp.Name = objOpp.Name + ' -Renewal';
                    }
                    originalOpp.add(objOpp);                     
                }
                for (Id qId : manualOppQuote) {
                    SBQQ__Quote__c q = new SBQQ__Quote__c(Id = qId, SBQQ__Primary__c = false);
                    quotesToUpdate.add(q);
                  }        
                  if (!quotesToUpdate.isEmpty() && Schema.sObjectType.SBQQ__Quote__c.isUpdateable()) {
                    update quotesToUpdate;
                }

                if(Schema.sObjectType.SBQQ__Quote__c.isUpdateable()){
                    update renewalQuote;
                }                             
                if(!updateContracts.isEmpty()) {
                    database.update(updateContracts);
                }               
                if(!originalOpp.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable()) {
                    database.update(new List<Opportunity>(originalOpp));
                }                
                if (String.isNotBlank(renewalOpportunity.id) && Schema.sObjectType.Opportunity.isDeletable()) {
                    Opportunity renewalOpty = new Opportunity(Id = renewalOpportunity.id);
                    database.delete(renewalOpty);
                }                
            }
            return quoteJSON;
        } 
        catch(Exception e) {            
            if(e.getMessage().contains('The primary quote cannot be changed for the opportunity because an order has been created from the quote.')){
                System.debug('>>> exception quoteJSON: '+e.getMessage() +e.getLineNumber() );
            }
            return 'Exception:'+e.getMessage();
        }
    }    
    private class CreateRenewalContext {
        private String masterContractId;
        private List<Contract> renewedContracts;
        private Boolean returnOnlyQuoteId ;
        private CreateRenewalContext(){
            this.masterContractId = masterContractId;
            this.renewedContracts = renewedContracts;
            this.returnOnlyQuoteId =true;
        }
    }  
    @AuraEnabled(cacheable=true) 
    public static BECPQ__App_Configuration__mdt getCustomMetadata(){
        return EasyCpqQueries.getAppConfigByRecordName('Default');
    }
}