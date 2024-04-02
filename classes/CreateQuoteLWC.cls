/***************************************************************************************
 * @description       : Apex Class to Create new Quote from Quick Action button on Opportunity with LWC Component
 * @author            : Nitesh Lande - Bluvium
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
public with sharing class CreateQuoteLWC {
  /**
   * @description: Retrieves an Opportunity record based on the provided Opportunity Id.
   * @author: Nitesh Lande- Bluvium
   * @param: String oppID - The Id of the Opportunity to retrieve.
   * @return: Opportunity - The Opportunity record corresponding to the provided Id.
   */
  @AuraEnabled(cacheable=true)
  public static Opportunity getOpportunity(string oppID) {
    return [
      SELECT AccountId, SBQQ__PrimaryQuote__c
      FROM Opportunity
      WHERE Id = :oppID
      WITH SECURITY_ENFORCED
    ];
  }
  /**
   * @description: This method creates a new quote based on the provided parameters and mappings defined
   *               in custom metadata. It populates the fields of the new quote by mapping fields from
   *               the associated account, opportunity, and original quote. Field values are retrieved
   *               from the respective records and mapped according to the metadata configuration.
   * @author: Nitesh Lande- Bluvium
   * @param: String opportunityId - The Id of the opportunity associated with the new quote.
   * @param: String quoteAccountId - The Id of the account associated with the new quote.
   * @param: String newQuoteId - The Id of the new quote record.
   * @return: ID - The Id of the newly created quote.
   */
  @AuraEnabled
  public static ID createQuoteMethod(
    String opportunityId,
    String quoteAccountId,
    String newQuoteId
  ) {
    SBQQ__Quote__c newQuote = new SBQQ__Quote__c();
    Opportunity oppData = new Opportunity();
    Account accData = new Account();
    BECPQ__App_Configuration__mdt appConfig = EasyCpqQueries.getAppConfigByRecordName(
      'Default'
    );
    String newQuoteFromOppFeildSetup = appConfig.BECPQ__New_Quote_Fields_Setup__c;
    // Set to Store Fields from metadata
    Set<String> accountFieldSet = new Set<String>();
    Set<String> opportunityFieldSet = new Set<String>();
    Set<String> quoteFieldSet = new Set<String>();
    // Map to Store Source and Target Field From metadata
    Map<String, string> accountFieldToQuoteFieldMap = new Map<String, string>();
    Map<String, string> opportunityFieldToQuoteFieldMap = new Map<String, string>();
    Map<String, string> quoteFieldToQuoteFieldMap = new Map<String, string>();
    if (string.isNotBlank(newQuoteFromOppFeildSetup)) {
      for (
        Object obj : (List<Object>) JSON.deserializeUntyped(
          newQuoteFromOppFeildSetup
        )
      ) {
        //convert values to map
        Map<String, Object> data = (Map<String, Object>) obj;
        String objectName = (String) data.get('objectName');
        String sourceField = (String) data.get('sourcefield');
        String targetField = String.valueOf(data.get('targetfield'));
        //add key and Values to map
        if (
          !accountFieldToQuoteFieldMap.containsKey(sourceField) &&
          string.isNotBlank(targetField) &&
          objectName == 'Account'
        ) {
          accountFieldToQuoteFieldMap.put(sourceField, targetField);
        }
        if (
          !opportunityFieldToQuoteFieldMap.containsKey(sourceField) &&
          string.isNotBlank(targetField) &&
          objectName == 'OriginalOpportunity'
        ) {
          opportunityFieldToQuoteFieldMap.put(sourceField, targetField);
        }
        if (
          !quoteFieldToQuoteFieldMap.containsKey(sourceField) &&
          string.isNotBlank(targetField) &&
          objectName == 'OriginalQuote'
        ) {
          quoteFieldToQuoteFieldMap.put(sourceField, targetField);
        }
      }
      //add target Fields to set
      if (!opportunityFieldToQuoteFieldMap.isEmpty()) {
        opportunityFieldSet.addAll(opportunityFieldToQuoteFieldMap.values());
      }
      if (!accountFieldToQuoteFieldMap.isEmpty()) {
        accountFieldSet.addAll(accountFieldToQuoteFieldMap.values());
      }
      if (!quoteFieldToQuoteFieldMap.isEmpty()) {
        quoteFieldSet.addAll(quoteFieldToQuoteFieldMap.values());
      }
    }
    try {
      newQuote = [
        SELECT ID, NAME, SBQQ__Opportunity2__c, SBQQ__SubscriptionTerm__c
        FROM SBQQ__Quote__c
        WHERE ID = :newQuoteId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      if (!accountFieldSet.isEmpty()) {
        String query =
          'SELECT Id,' +
          String.join(new List<String>(accountFieldSet), ',') +
          ' FROM Account WHERE Id = :bindAccountId';
        accData = Database.query(
          query.replace(
            ':bindAccountId',
            '\'' + String.escapeSingleQuotes(quoteAccountId) + '\''
          )
        );
      }
      if (!opportunityFieldSet.isEmpty()) {
        String oppQuery =
          'SELECT AccountId,' +
          String.join(new List<String>(opportunityFieldSet), ',') +
          ' FROM Opportunity WHERE Id = :bindOpportunityId';
        oppData = Database.query(
          oppQuery.replace(
            ':bindOpportunityId',
            '\'' + String.escapeSingleQuotes(opportunityId) + '\''
          )
        );
      }
      //Assign opportunity Fields value To New Quote Fields
      if (!opportunityFieldToQuoteFieldMap.isEmpty()) {
        for (string quoteField : opportunityFieldToQuoteFieldMap.keyset()) {
          newQuote.put(
            quoteField,
            oppData.get(opportunityFieldToQuoteFieldMap.get(quoteField))
          );
        }
      }
      //Assign Account Fields value To New Quote Fields
      if (!accountFieldToQuoteFieldMap.isEmpty()) {
        for (string quoteField : accountFieldToQuoteFieldMap.keyset()) {
          newQuote.put(
            quoteField,
            accData.get(accountFieldToQuoteFieldMap.get(quoteField))
          );
        }
      }
      //Assign New Quote Fields Value as per Field Mapping
      String objectType = 'SBQQ__Quote__c';
      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      Schema.SObjectType objectSchema = schemaMap.get(objectType);
      Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe()
        .fields.getMap();
      if (!quoteFieldToQuoteFieldMap.isEmpty()) {
        for (String quoteField : quoteFieldToQuoteFieldMap.keySet()) {
          if (fieldMap.containsKey(quoteField)) {
            Schema.DisplayType fieldDataType = fieldMap.get(quoteField)
              .getDescribe()
              .getType();
            Object fieldValue = quoteFieldToQuoteFieldMap.get(quoteField);
            switch on String.valueOf(fieldDataType) {
              when 'DATE' {
                newQuote.put(quoteField, Date.valueOf((String) fieldValue));
              }
              when 'CURRENCY', 'PERCENT' {
                newQuote.put(quoteField, Double.valueOf((String) fieldValue));
              }
              when 'BOOLEAN' {
                newQuote.put(quoteField, Boolean.valueOf((String) fieldValue));
              }
              when 'DATETIME' {
                newQuote.put(quoteField, DateTime.valueOf((String) fieldValue));
              }
              when else {
                newQuote.put(quoteField, fieldValue);
              }
            }
          }
        }
      }
      if (
        newQuote != null &&
        Schema.sObjectType.SBQQ__Quote__c.isUpdateable() &&
        Schema.sObjectType.SBQQ__Quote__c.isCreateable()
      ) {
        update newQuote;
      }
    } catch (Exception e) {
      system.debug(
        'Error When Record Is Not Created-->' +
          e +
          ' Line Number' +
          e.getLineNumber()
      );
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Mapping is not found on mapping page' + e
        )
      );
    }
    return newQuoteId;
  }
}