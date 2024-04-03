/***************************************************************************************
 * @description       : This Class is controller is used in SubscriptionAndAssets Vf Page
 * @author            : Nitesh Lande(Bluvium)
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

public with sharing class GetSubscriptionAndAssets {
  /***************************************************************
   * @description quoteId It describes quote id
   **************************************************************/
  public string quoteId { get; set; }
  /***************************************************************
   * @description accId It describes account id
   **************************************************************/
  public string accId { get; set; }
  /***************************************************************
   * @description accName It describes account name
   **************************************************************/
  public string accName { get; set; }
  /***************************************************************
   * @description acclist It describes list of account
   **************************************************************/
  public List<Account> acclist { get; set; }
  /***************************************************************
   * @description subscriptionList It describes subscription list
   **************************************************************/
  public List<SBQQ__Subscription__c> subscriptionList { get; set; }
  /***************************************************************
   * @description assetList It describes asset list
   **************************************************************/
  public List<Asset> assetList { get; set; }
  /***************************************************************
   * @description subFieldApiName It describes string of sub api names
   **************************************************************/
  public List<string> subFieldApiName { get; set; }
  /***************************************************************
   * @description assetFieldApiName It describes string of asset api names
   **************************************************************/
  public List<string> assetFieldApiName { get; set; }
  /**
   * @description : Called to get asset and subscription
   * @param controller
   */
  public GetSubscriptionAndAssets(ApexPages.StandardController controller) {
    quoteId = ApexPages.currentPage().getParameters().get('id');
    if (string.isNotBlank(quoteId)) {
      SBQQ__Quote__c[] quoteData = [
        SELECT id, SBQQ__Account__c, SBQQ__Account__r.Name
        FROM SBQQ__Quote__c
        WHERE ID = :quoteId
        WITH SECURITY_ENFORCED
      ];
      if (quoteData.size() > 0) {
        accId = quoteData[0].SBQQ__Account__c;
        accName = quoteData[0].SBQQ__Account__r.Name;
      }
    }
  }

  public void toShowSubscriptionAndAssets() {
    List<string> subscriptionFields = new List<string>();
    List<string> assetFields = new List<string>();
    try {
      for (
        Schema.FieldSetMember subField : SObjectType.SBQQ__Subscription__c.FieldSets.SubscriptionFieldSet.getFields()
      ) {
        subscriptionFields.add(subField.getFieldPath());
      }
      subFieldApiName = new List<String>(SubscriptionFields);

      for (
        Schema.FieldSetMember assetField : SObjectType.Asset.FieldSets.AssetFieldSet.getFields()
      ) {
        assetFields.add(assetField.getFieldPath());
      }
      assetFieldApiName = new List<String>(assetFields);
      Schema.SObjectType schemaSub = Schema.getGlobalDescribe()
        .get('SBQQ__Subscription__c');
      Map<String, Schema.SObjectField> fields = SchemaSub.getDescribe()
        .fields.getMap();
      List<String> fieldList = new List<String>{ 'SBQQ__Account__c' };
      fieldList.addAll(SubscriptionFields);
      if (!CRUD_FLS_CheckUtility.checkReadAccess(fieldList, fields)) {
        throw new AuraHandledException('Permission missing for quote fields.');
      }

      Schema.SObjectType schemaAsset = Schema.getGlobalDescribe().get('Asset');
      Map<String, Schema.SObjectField> fieldsAsset = SchemaAsset.getDescribe()
        .fields.getMap();
      List<String> fieldListAsset = new List<String>{ 'AccountId' };
      fieldListAsset.addAll(assetFields);
      if (!CRUD_FLS_CheckUtility.checkReadAccess(fieldListAsset, fieldsAsset)) {
        throw new AuraHandledException('Permission missing for quote fields.');
      }
      String subscriptionquery = 'SELECT Id, ';
      subscriptionquery += string.join(subscriptionFields, ', ');
      subscriptionquery += ' FROM SBQQ__Subscription__c WHERE SBQQ__Account__c =:accId WITH SECURITY_ENFORCED';
      String assetquery = 'SELECT Id, ';
      assetquery += string.join(assetFields, ', ');
      assetquery += ' FROM Asset WHERE AccountId =:accId WITH SECURITY_ENFORCED';
      subscriptionList = Database.query(
        String.escapeSingleQuotes(subscriptionquery)
      );
      assetList = Database.query(String.escapeSingleQuotes(assetquery));
    } catch (Exception e) {
      system.debug(LoggingLevel.ERROR, 'Exception:' + e.getMessage());
    }
  }
}