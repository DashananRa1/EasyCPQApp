/***************************************************************************************
 * @description       : Apex Class to Create Amend Quote and Amend Opportunity from Quick Action button
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
public with sharing class CreateAmendLWC {
  @AuraEnabled
  // Create Map of Label and fieldName to use this map in columns of datatable
  public static string getFieldLableAndFieldAPI() {
    List<Map<String, String>> listOfFieldSet = new List<Map<String, String>>();
    try {
      for (Schema.FieldSetMember fieldset : SObjectType.Contract.FieldSets.Amend.getFields()) {
        Map<String, String> lableAPIMap = new Map<String, String>();
        lableAPIMap.put(fieldset.getLabel(), fieldset.getFieldPath());
        listOfFieldSet.add(lableAPIMap);
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return JSON.serialize(listOfFieldSet);
  }
  @AuraEnabled(cacheable=true)
  public static List<Contract> getContracts(String accId) {
    try {
      List<Contract> conList;
      // Create a set to store the field paths
      Set<String> fieldPaths = new Set<String>();
      // Loop through the field set members and add their field paths to the set
      for (Schema.FieldSetMember f : SObjectType.Contract.FieldSets.Amend.getFields()) {
        fieldPaths.add(f.getFieldPath());
      }
      Schema.SObjectType schema = Schema.getGlobalDescribe().get('Contract');
      Map<String, Schema.SObjectField> fields = schema.getDescribe().Fields.getMap();
      List<String> fieldList = new List<String>{'AccountId','SBQQ__Opportunity__c','SBQQ__Quote__c'};
      fieldList.addAll(fieldPaths);
      if (!CRUD_FLS_CheckUtility.checkReadAccess(fieldList, fields)) {
        throw new AuraHandledException('Permission missing for quote fields.');
      }
      String query ='SELECT Id,AccountId, SBQQ__Opportunity__c, SBQQ__Quote__c ,' +String.join(new List<String>(fieldPaths), ', ') +' FROM Contract WHERE AccountId = :accId WITH SECURITY_ENFORCED';
      conList = Database.query(String.escapeSingleQuotes(query));
      return conList;
    } 
    catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static string amendContract(String contractId,String opportunityId,String contractOpportunityID,String contractAccountId,String contractQuoteId) {
    SBQQ__Quote__c amendQuote = new SBQQ__Quote__c();
    Opportunity amendOpportunity = new Opportunity();
    Opportunity manualOpportunity = new Opportunity();
    String quoteId;
    //Variable For AmendQuoteSetting
    Account accData = new Account();
    Opportunity oppData = new Opportunity();
    SBQQ__Quote__c originalQuoteData = new SBQQ__Quote__c();
    Set<Id> manualOppQuote = New Set<Id>();
    //Variable For AmmendOpportunity Setting
    Account accDataForAmendOpp = new Account();
    Opportunity originaloppDataForAmmendOpp = new Opportunity();
    String quoteJSON;
    AmendContext context = new AmendContext();
    try {      
      App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName('Default');
      Boolean newAmendOpportunity = appConfig.Generate_New_Amendment_Opportunity__c;
      Boolean mainQlGroup = appConfig.Maintain_QuoteLine_Groups_for_Amendment__c;       
      Integer contractCount = [SELECT COUNT() FROM Contract WHERE SBQQ__Opportunity__c =:opportunityId WITH SECURITY_ENFORCED];        
        if (contractCount > 0 && !newAmendOpportunity) {
          system.debug('Execute only if the Checkbox false and opportunity is Ordered');
          throw new AuraHandledException('The primary quote cannot be changed for the opportunity because an order has been created from the quote.');
        } 
        else {
          quoteJSON = SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractAmender',contractId,JSON.serialize(context));
        }
      Map<String, Object> quoteJSONMap = (Map<String, Object>) JSON.deserializeUntyped(quoteJSON);
      quoteId = (String) quoteJSONMap.get('Id');
      amendQuote = [
        SELECT
          ID,
          NAME,
          SBQQ__Opportunity2__c,
          SBQQ__SubscriptionTerm__c,
          SBQQ__PriceBook__c
        FROM SBQQ__Quote__c
        WHERE ID = :quoteId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      amendOpportunity = [
        SELECT ID, NAME
        FROM Opportunity
        WHERE ID = :amendQuote.SBQQ__Opportunity2__c
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      // for Amend Quote Setting Quote Field (Querying Data From Custom metadata)
      string opportunityFields = appConfig.AmendQuote_OriginalOppFieldSetup__c;
      string accountFields = appConfig.AmendQuote_AccountFieldSetup__c;
      string originalQuoetFields = appConfig.AmendQuote_OriginalQuoteFieldSetup__c;
      // for Amend Opportunity Setting Quote Field (Querying Data From Custom metadata)
      string originalOpptoAmendOppFieldsMapping = appConfig.AmendOpportunity_OriginalOppFieldSetup__c;
      string accountToAmmendOpportunityFieldsMapping = appConfig.AmendOpportunity_AccountFieldSetup__c;
      // Ammend Quote Setting
      set<string> originalOpportunityFieldSet = new Set<string>();
      set<string> accountFieldSet = new Set<string>();
      set<string> originlQuoteFieldSet = new Set<string>();
      // Ammend Opportunity Setting
      set<string> originalOpportunityFieldSetForAmmendOpp = new Set<string>();
      set<string> accountFieldSetForAmmendOpp = new Set<string>();
      // Map for Amend Quote
      Map<String, string> quoteFieldToOpportunityFieldMap = new Map<String, string>();
      Map<String, string> quoteFieldToAccountFieldMap = new Map<String, string>();
      Map<String, string> quoteFieldToOrigQuoteFieldsMap = new Map<String, string>();
      // Map for Amend Opportunity
      Map<String, string> originalOppToAmmendOppFieldMap = new Map<String, string>();
      Map<String, string> accToAmendOppFieldMap = new Map<String, string>();
      if (string.isNotBlank(opportunityFields)) {
        for (
          Object obj : (List<Object>) JSON.deserializeUntyped(opportunityFields)
        ) {
          //convert values to map
          Map<String, Object> data = (Map<String, Object>) obj;
          String sourceField = (String) data.get('sourcefield');
          string targetField = (String) data.get('targetfield');
          if (
            !quoteFieldToOpportunityFieldMap.containsKey(sourceField) &&
            string.isNotBlank(targetField)
          ) {
            quoteFieldToOpportunityFieldMap.put(sourceField, targetField);
          }
        }
      }
      if (string.isNotBlank(accountFields)) {
        for (
          Object obj : (List<Object>) JSON.deserializeUntyped(accountFields)
        ) {
          //convert values to map
          Map<String, Object> data = (Map<String, Object>) obj;
          String sourceField = (String) data.get('sourcefield');
          string targetField = (String) data.get('targetfield');
          if (
            !quoteFieldToAccountFieldMap.containsKey(sourceField) &&
            string.isNotBlank(targetField)
          ) {
            quoteFieldToAccountFieldMap.put(sourceField, targetField);
          }
        }
      }
      if (string.isNotBlank(originalQuoetFields)) {
        for (
          Object obj : (List<Object>) JSON.deserializeUntyped(
            originalQuoetFields
          )
        ) {
          //convert values to map
          Map<String, Object> data = (Map<String, Object>) obj;
          String sourceField = (String) data.get('sourcefield');
          string targetField = (String) data.get('targetfield');
          if (
            !quoteFieldToOrigQuoteFieldsMap.containsKey(sourceField) &&
            string.isNotBlank(targetField)
          ) {
            quoteFieldToOrigQuoteFieldsMap.put(sourceField, targetField);
          }
        }
      }
      if (!quoteFieldToOpportunityFieldMap.isEmpty()) {
        originalOpportunityFieldSet.addAll(
          quoteFieldToOpportunityFieldMap.values()
        );
      }
      if (!quoteFieldToAccountFieldMap.isEmpty()) {
        accountFieldSet.addAll(quoteFieldToAccountFieldMap.values());
      }
      if (!quoteFieldToOrigQuoteFieldsMap.isEmpty()) {
        originlQuoteFieldSet.addAll(quoteFieldToOrigQuoteFieldsMap.values());
      }

      if (!originalOpportunityFieldSet.isEmpty()) {
        // Define the query with parameterized syntax
        String query =
          'SELECT AccountId, ' +
          String.join(new List<String>(originalOpportunityFieldSet), ', ');
        if (!query.containsIgnoreCase(' Name,')) {
          query += ', Name';
        }
        if (!query.containsIgnoreCase(' SBQQ__PrimaryQuote__c,')) {
          query += ', SBQQ__PrimaryQuote__c';
        }
        query += ' FROM Opportunity WHERE Id = :contractOpportunityID WITH SECURITY_ENFORCED';
        oppData = Database.query(String.escapeSingleQuotes(query));        
      }
      if (opportunityId!=null) {        
        manualOpportunity = [Select AccountId,
                                         Name,
                                         SBQQ__PrimaryQuote__c,
                                         Pricebook2Id 
                                         FROM Opportunity WHERE Id = :opportunityId WITH SECURITY_ENFORCED];       
        if(manualOpportunity.SBQQ__PrimaryQuote__c!=null){
          manualOppQuote.add(manualOpportunity.SBQQ__PrimaryQuote__c);
        }
      }
      if (!accountFieldSet.isEmpty()) {
        String query =
          'SELECT Id,' +
          String.join(new List<String>(accountFieldSet), ',') +
          ' FROM Account WHERE Id=:contractAccountId WITH SECURITY_ENFORCED';
        accData = Database.query(String.escapeSingleQuotes(query));
      }
      if (!originlQuoteFieldSet.isEmpty()) {
        String query =
          'SELECT Id,' +
          String.join(new List<String>(originlQuoteFieldSet), ',') ; 
          if (!query.containsIgnoreCase(' SBQQ__LineItemsGrouped__c,')) {
            query += ', SBQQ__LineItemsGrouped__c';
          }
          query += ' FROM SBQQ__Quote__c WHERE Id=: contractQuoteId WITH SECURITY_ENFORCED';
        originalQuoteData = Database.query(String.escapeSingleQuotes(query));
      }

      if (!quoteFieldToOpportunityFieldMap.isEmpty()) {
        for (string quoteField : quoteFieldToOpportunityFieldMap.keyset()) {
          amendQuote.put(
            quoteField,
            oppData.get(quoteFieldToOpportunityFieldMap.get(quoteField))
          );
        }
      }
        if (!quoteFieldToAccountFieldMap.isEmpty()) {
          for (string quoteField : quoteFieldToAccountFieldMap.keyset()) {
            amendQuote.put(
              quoteField,
              accData.get(quoteFieldToAccountFieldMap.get(quoteField))
            );
          }
        }     

      if (!quoteFieldToOrigQuoteFieldsMap.isEmpty()) {
        for (string quoteField : quoteFieldToOrigQuoteFieldsMap.keyset()) {
          amendQuote.put(
            quoteField,
            originalQuoteData.get(
              quoteFieldToOrigQuoteFieldsMap.get(quoteField)
            )
          );
        }
      }
      // To Put Custom Metadata From AmmedOpporunitySetting To Map And Set
      if (string.isNotBlank(originalOpptoAmendOppFieldsMapping)) {
        for (
          Object obj : (List<Object>) JSON.deserializeUntyped(
            originalOpptoAmendOppFieldsMapping
          )
        ) {
          //convert values to map
          Map<String, Object> data = (Map<String, Object>) obj;
          String sourceField = (String) data.get('sourcefield');
          string targetField = (String) data.get('targetfield');
          if (
            !originalOppToAmmendOppFieldMap.containsKey(sourceField) &&
            string.isNotBlank(targetField)
          ) {
            originalOppToAmmendOppFieldMap.put(sourceField, targetField);
          }
        }
      }

      if (string.isNotBlank(accountToAmmendOpportunityFieldsMapping)) {
        for (
          Object obj : (List<Object>) JSON.deserializeUntyped(
            accountToAmmendOpportunityFieldsMapping
          )
        ) {
          //convert values to map
          Map<String, Object> data = (Map<String, Object>) obj;
          String sourceField = (String) data.get('sourcefield');
          string targetField = (String) data.get('targetfield');
          if (
            !accToAmendOppFieldMap.containsKey(sourceField) &&
            string.isNotBlank(targetField)
          ) {
            accToAmendOppFieldMap.put(sourceField, targetField);
          }
        }
      }

      if (!originalOppToAmmendOppFieldMap.isEmpty()) {
        originalOpportunityFieldSetForAmmendOpp.addAll(
          originalOppToAmmendOppFieldMap.values()
        );
      }
      if (!accToAmendOppFieldMap.isEmpty()) {
        accountFieldSetForAmmendOpp.addAll(accToAmendOppFieldMap.values());
      }
      //Querydata of Original Opp And Account From Fiel Set
      if (!originalOpportunityFieldSetForAmmendOpp.isEmpty()) {
        string query =
          'SELECT  AccountId,' +
          String.join(
            new List<String>(originalOpportunityFieldSetForAmmendOpp),
            ','
          ) +
          ' FROM Opportunity WHERE Id =:OpportunityID WITH SECURITY_ENFORCED';
        originaloppDataForAmmendOpp = Database.query(
          String.escapeSingleQuotes(query)
        );
      }

      if (!accountFieldSetForAmmendOpp.isEmpty()) {
        string query =
          'SELECT Id,' +
          String.join(new List<String>(accountFieldSetForAmmendOpp), ',') +
          ' FROM Account WHERE Id =:contractAccountId WITH SECURITY_ENFORCED';
        accDataForAmendOpp = Database.query(String.escapeSingleQuotes(query));
      }

      // Assigned Field Mapping Here
      if (!originalOppToAmmendOppFieldMap.isEmpty()) {
        for (string ammedOppField : originalOppToAmmendOppFieldMap.keyset()) {
          amendOpportunity.put(
            ammedOppField,
            originaloppDataForAmmendOpp.get(
              originalOppToAmmendOppFieldMap.get(ammedOppField)
            )
          );
        }
      }
      if (!accToAmendOppFieldMap.isEmpty()) {
        for (string ammedOppField : accToAmendOppFieldMap.keyset()) {
          amendOpportunity.put(
            ammedOppField,
            accDataForAmendOpp.get(accToAmendOppFieldMap.get(ammedOppField))
          );
        }
      }
       if(mainQlGroup && originalQuoteData.SBQQ__LineItemsGrouped__c){                
        //QuoteLineAnalyzerTriggerHandler.handleAfterInsert(new List<string>{amendQuote.Id}) ;
          amendQuote.SBQQ__LineItemsGrouped__c = true;
        }     
         if(newAmendOpportunity){                
          if(Schema.sObjectType.SBQQ__Quote__c.isUpdateable()){
            update amendQuote;
          }    
          if(Schema.sObjectType.Opportunity.isUpdateable()){
              update amendOpportunity;
          }                
        }
        if(Test.isRunningTest()){
            IF(newAmendOpportunity){
            	appConfig.Generate_New_Amendment_Opportunity__c = false;
        	} 
        } 
      if (!newAmendOpportunity) {
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();        
        for (Id qId : manualOppQuote) {
          SBQQ__Quote__c q = new SBQQ__Quote__c(Id = qId, SBQQ__Primary__c = false);
          quotesToUpdate.add(q);
        }        
        if (!quotesToUpdate.isEmpty() && Schema.sObjectType.SBQQ__Quote__c.isUpdateable()) {
            update quotesToUpdate;
        }
        if (!manualOpportunity.Name.contains(' -Add-On')) {
          manualOpportunity.Name = manualOpportunity.Name + ' -Add-On';
        }
        manualOpportunity.SBQQ__PrimaryQuote__c = amendQuote.Id;
        manualOpportunity.SBQQ__AmendedContract__c = contractId;
        manualOpportunity.Pricebook2Id = amendQuote.SBQQ__PriceBook__c;
        amendQuote.SBQQ__Opportunity2__c = opportunityId; //current OppId
        amendQuote.SBQQ__Primary__c = true;                
        if (Schema.sObjectType.SBQQ__Quote__c.isUpdateable()) {
          update amendQuote;
        }
        if (Schema.sObjectType.Opportunity.isUpdateable()) {
          update manualOpportunity;
        }
        if (String.isNotBlank(amendOpportunity.Id) && Schema.sObjectType.Opportunity.isDeletable()) {
          Opportunity amendmentOpty = new Opportunity(Id = amendOpportunity.Id);
          database.delete(amendmentOpty);
        }
      }
             
      return quoteJSON;
    } 
    catch (Exception e) {
      if (e.getMessage().contains('The primary quote cannot be changed for the opportunity because an order has been created from the quote.')) {
        System.debug('>>> exception quoteJSON: ' + e.getMessage() + e.getLineNumber());
      }
      return 'Exception:' + e.getMessage();
    }
  }

  @TestVisible
  private class AmendContext {
    @TestVisible
    private Boolean returnOnlyQuoteId;
    @TestVisible
    private AmendContext() {
      this.returnOnlyQuoteId = true;
    }
  }
}
