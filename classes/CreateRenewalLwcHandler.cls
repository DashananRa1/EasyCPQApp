/***************************************************************************************
 * @description       : This Trigger is on PlatformEvent for maintaining the Group and Groupline for Amend 
 *                      and Renewal Process Platform Event
 * @author            : Nitesh Lande - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : CreateRenewalLwcHandlerTest
 * @created Date      : 02-04-2024 
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class CreateRenewalLwcHandler {
  public static void toMaintainQlGrp(
    List<Contract> ContrList,
    string renewQuoteId
  ) {
    Set<Id> origquoteIds = new Set<Id>();
    for (Contract rec : ContrList) {
      if (rec.SBQQ__Quote__c != null) {
        origquoteIds.add(rec.SBQQ__Quote__c);
      }
    }
    Map<String, String> masterContractVsQuote = new Map<String, String>();
    set<String> existingProducts = new Set<String>();
    Schema.SObjectType quoteSchema = Schema.getGlobalDescribe()
      .get('SBQQ__Quote__c');
    Map<String, Schema.SObjectField> quoteFields = quoteSchema.getDescribe()
      .fields.getMap();
    if (
      !CRUD_FLS_CheckUtility.checkReadAccess(
        new List<STring>{
          'name',
          'SBQQ__MasterContract__c',
          'SBQQ__LineItemsGrouped__c'
        },
        quoteFields
      )
    ) {
      throw new AuraHandledException('Permission missing for quote fields.');
    }
    Schema.SObjectType contractSchema = Schema.getGlobalDescribe()
      .get('Contract');
    Map<String, Schema.SObjectField> contractFields = contractSchema.getDescribe()
      .fields.getMap();
    if (
      !CRUD_FLS_CheckUtility.checkReadAccess(
        new List<STring>{ 'SBQQ__Quote__c' },
        contractFields
      )
    ) {
      throw new AuraHandledException('Permission missing for contract fields.');
    }
    Schema.SObjectType opportunitySchema = Schema.getGlobalDescribe()
      .get('Opportunity');
    Map<String, Schema.SObjectField> opportunityFields = opportunitySchema.getDescribe()
      .fields.getMap();
    if (
      !CRUD_FLS_CheckUtility.checkReadAccess(
        new List<STring>{ 'SBQQ__RenewedContract__c' },
        opportunityFields
      )
    ) {
      throw new AuraHandledException(
        'Permission missing for opportunity fields.'
      );
    }
    Schema.SObjectType quoteLineSchema = Schema.getGlobalDescribe()
      .get('SBQQ__QuoteLine__c');
    Map<String, Schema.SObjectField> quoteLineFields = quoteLineSchema.getDescribe()
      .fields.getMap();
    if (
      !CRUD_FLS_CheckUtility.checkReadAccess(
        new List<STring>{
          'Name',
          'SBQQ__Quote__c',
          'SBQQ__Group__c',
          'SBQQ__Product__c'
        },
        quoteLineFields
      )
    ) {
      throw new AuraHandledException(
        'Permission missing for quote line fields.'
      );
    }
    Schema.SObjectType quoteLineGroupSchema = Schema.getGlobalDescribe()
      .get('SBQQ__QuoteLineGroup__c');
    Map<String, Schema.SObjectField> quoteLineGroupFields = quoteLineGroupSchema.getDescribe()
      .fields.getMap();
    if (
      !CRUD_FLS_CheckUtility.checkReadAccess(
        new List<STring>{
          'Name',
          'SBQQ__Quote__c',
          'SBQQ__Number__c',
          'SBQQ__NetTotal__c',
          'SBQQ__ListTotal__c',
          'SBQQ__CustomerTotal__c'
        },
        quoteLineGroupFields
      )
    ) {
      throw new AuraHandledException(
        'Permission missing for quote line group fields.'
      );
    }
    List<SBQQ__QuoteLine__c> quoteLines = [
      SELECT
        Id,
        Name,
        SBQQ__Quote__c,
        SBQQ__Group__c,
        SBQQ__Group__r.Name,
        SBQQ__Group__r.SBQQ__Number__c,
        SBQQ__Group__r.SBQQ__NetTotal__c,
        SBQQ__Group__r.SBQQ__ListTotal__c,
        SBQQ__Group__r.SBQQ__CustomerTotal__c,
        sbqq__Product__c
      FROM SBQQ__QuoteLine__c
      WHERE SBQQ__Quote__c IN :origquoteIds
      WITH SECURITY_ENFORCED
      ORDER BY createddate DESC
    ];
    if (quoteLines.size() > 0) {
      Map<String, String> productIdVsGroupName = new Map<String, String>();
      Set<String> existingGroups = new Set<String>();
      if (
        !CRUD_FLS_CheckUtility.checkCreateAccess(
          new List<STring>{
            'Name',
            'SBQQ__Quote__c',
            'SBQQ__Number__c',
            'SBQQ__NetTotal__c',
            'SBQQ__ListTotal__c',
            'SBQQ__CustomerTotal__c'
          },
          quoteLineGroupFields
        )
      ) {
        throw new AuraHandledException(
          'Permission missing for quote line group fields.'
        );
      }
      List<SBQQ__QuoteLineGroup__c> newQuoteLineGroups = new List<SBQQ__QuoteLineGroup__c>();
      for (SBQQ__QuoteLine__c item : quoteLines) {
        //productIdVsGroupName.put(item.sbqq__Product__c,item.SBQQ__Group__r.Name);
        productIdVsGroupName.put(item.Id, item.SBQQ__Group__r.Name);
        SBQQ__QuoteLineGroup__c newItem = new SBQQ__QuoteLineGroup__c(
          SBQQ__Number__c = item.SBQQ__Group__r.SBQQ__Number__c,
          SBQQ__NetTotal__c = item.SBQQ__Group__r.SBQQ__NetTotal__c,
          SBQQ__ListTotal__c = item.SBQQ__Group__r.SBQQ__ListTotal__c,
          SBQQ__CustomerTotal__c = item.SBQQ__Group__r.SBQQ__CustomerTotal__c
        );
        newItem.Name = item.SBQQ__Group__r.Name;
        newItem.SBQQ__Quote__c = renewQuoteId; //quoteId;
        if (!existingGroups.contains(item.SBQQ__Group__r.Name)) {
          existingGroups.add(item.SBQQ__Group__r.Name);
          newQuoteLineGroups.add(newItem);
        }
      }
      set<String> unUtilizedGroups = new Set<STring>();
      if (
        newQuoteLineGroups.size() > 0 &&
        Schema.sObjectType.SBQQ__QuoteLineGroup__c.isCreateable()
      ) {
        insert newQuoteLineGroups;
        Map<String, String> groupNameVsId = new Map<String, String>();
        for (SBQQ__QuoteLineGroup__c grp : newQuoteLineGroups) {
          groupNameVsId.put(grp.Name, grp.Id);
          unUtilizedGroups.add(grp.id);
        }
        List<SBQQ__QuoteLine__c> newQuoteLines = [
          SELECT
            id,
            name,
            SBQQ__Quote__c,
            SBQQ__RenewedSubscription__c,
            SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c,
            sbqq__Product__c
          FROM SBQQ__QuoteLine__c
          WHERE SBQQ__Quote__c = :renewQuoteId
          WITH SECURITY_ENFORCED
        ];
        List<SBQQ__QuoteLine__c> quotesToUpdate = new List<SBQQ__QuoteLine__c>();
        if (
          !CRUD_FLS_CheckUtility.checkUpdateAccess(
            new Set<STring>{ 'SBQQ__Group__c' },
            quoteLineFields
          )
        ) {
          throw new AuraHandledException(
            'Permission missing for quote line fields.'
          );
        }
        for (SBQQ__QuoteLine__c newItem : newQuoteLines) {
          if (
            productIdVsGroupName.containsKey(
              newItem.SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c
            )
          ) {
            String groupId = groupNameVsId.get(
              productIdVsGroupName.get(
                newItem.SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c
              )
            );
            unUtilizedGroups.remove(groupId);
            SBQQ__QuoteLine__c itmToPass = new SBQQ__QuoteLine__c();
            itmToPass.Id = newItem.Id;
            itmToPass.SBQQ__Group__c = groupId;
            quotesToUpdate.add(itmToPass);
          }
        }
        if (quotesToUpdate.size() > 0) {
          if (
            !CRUD_FLS_CheckUtility.checkUpdateAccess(
              new Set<STring>{ 'SBQQ__LineItemsGrouped__c' },
              quoteFields
            )
          ) {
            throw new AuraHandledException(
              'Permission missing for quote fields.'
            );
          }
          if (Schema.sObjectType.SBQQ__QuoteLine__c.isUpdateable()) {
            update quotesToUpdate;
          }
        }
        if (unUtilizedGroups.size() > 0) {
          List<SBQQ__QuoteLineGroup__c> groupsToDelete = new List<SBQQ__QuoteLineGroup__c>();
          for (String str : unUtilizedGroups) {
            SBQQ__QuoteLineGroup__c grp = new SBQQ__QuoteLineGroup__c(Id = str);
            groupsToDelete.add(grp);
          }
          if (
            Schema.sObjectType.SBQQ__QuoteLineGroup__c.isDeletable() &&
            groupsToDelete.size() > 0
          ) {
            delete groupsToDelete;
          }
        }
      }
    }
  }
}