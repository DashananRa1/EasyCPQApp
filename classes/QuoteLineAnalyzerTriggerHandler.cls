/***************************************************************************************
 * @description       : This Trigger is on PlatformEvent for maintaining the Group and Groupline for Amend 
 *                      and Renewal Process Platform Event
 * @author            : Kavita Kore - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : QuoteLineAnalyzerTriggerTest
 * @created Date      : 09-21-2023
 * 
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class QuoteLineAnalyzerTriggerHandler {
    public static void handleAfterInsert(List<String> newList) {        
        List<String> quoteIds = new List<STring>();        
        for (String rec : newList) {
            quoteIds.add(rec);
        }
        set<STring> masterQuotes = new Set<String>();
        Map<String, String> masterContractVsQuote = new Map<String, String>();
        set<String> existingProducts = new Set<String>();
        Schema.SObjectType quoteSchema = Schema.getGlobalDescribe().get('SBQQ__Quote__c');
        Map<String, Schema.SObjectField> quoteFields = quoteSchema.getDescribe().fields.getMap();
        if (!CRUD_FLS_CheckUtility.checkReadAccess(new List<STring>{'name','SBQQ__MasterContract__c','SBQQ__LineItemsGrouped__c'},quoteFields)) {
            throw new AuraHandledException('Permission missing for quote fields.');
        }
        Schema.SObjectType contractSchema = Schema.getGlobalDescribe().get('Contract');
        Map<String, Schema.SObjectField> contractFields = contractSchema.getDescribe().fields.getMap();
        if (!CRUD_FLS_CheckUtility.checkReadAccess(new List<STring>{ 'SBQQ__Quote__c' },contractFields)) {
            throw new AuraHandledException('Permission missing for contract fields.');
        }
        Schema.SObjectType opportunitySchema = Schema.getGlobalDescribe().get('Opportunity');
        Map<String, Schema.SObjectField> opportunityFields = opportunitySchema.getDescribe().fields.getMap();
        if (!CRUD_FLS_CheckUtility.checkReadAccess(new List<STring>{ 'SBQQ__RenewedContract__c' },opportunityFields)) {
            throw new AuraHandledException('Permission missing for opportunity fields.');
        }
        for (SBQQ__Quote__c quote : [SELECT
                                    id,
                                    name,
                                    SBQQ__MasterContract__c,
                                    SBQQ__MasterContract__r.SBQQ__Quote__c,
                                    SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.SBQQ__Quote__c
                                    FROM SBQQ__Quote__C
                                    WHERE
                                    id IN :quoteIds
                                    AND (SBQQ__MasterContract__r.SBQQ__Quote__r.SBQQ__LineItemsGrouped__c = TRUE
                                    OR SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.SBQQ__Quote__r.SBQQ__LineItemsGrouped__c = TRUE)
                                    WITH SECURITY_ENFORCED]) {
            if (quote.SBQQ__MasterContract__r.SBQQ__Quote__c != null) {
                masterQuotes.add(quote.SBQQ__MasterContract__r.SBQQ__Quote__c);
            }
            if (quote.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.SBQQ__Quote__c != null) {
                masterQuotes.add(quote.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.SBQQ__Quote__c);
            }
        }
        Schema.SObjectType quoteLineSchema = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> quoteLineFields = quoteLineSchema.getDescribe().fields.getMap();
        if (!CRUD_FLS_CheckUtility.checkReadAccess( new List<STring>{'Name','SBQQ__Quote__c','SBQQ__Group__c','SBQQ__Product__c'},quoteLineFields)) {
            throw new AuraHandledException('Permission missing for quote line fields.');
        }
        Schema.SObjectType quoteLineGroupSchema = Schema.getGlobalDescribe().get('SBQQ__QuoteLineGroup__c');
        Map<String, Schema.SObjectField> quoteLineGroupFields = quoteLineGroupSchema.getDescribe().fields.getMap();
        if (!CRUD_FLS_CheckUtility.checkReadAccess(new List<STring>{'Name',
                                                                    'SBQQ__Quote__c',
                                                                    'SBQQ__Number__c',
                                                                    'SBQQ__NetTotal__c',
                                                                    'SBQQ__ListTotal__c',
                                                                    'SBQQ__CustomerTotal__c'},
                                                                    quoteLineGroupFields)) {
            throw new AuraHandledException('Permission missing for quote line group fields.');
        }
        //Amend Quote With Group Items start
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT
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
                                                WHERE SBQQ__Quote__c IN : masterQuotes AND SBQQ__Group__c != NULL
                                                WITH SECURITY_ENFORCED
                                                ORDER BY createddate DESC];
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
                productIdVsGroupName.put(item.Id, item.SBQQ__Group__r.Name);
                SBQQ__QuoteLineGroup__c newItem = new SBQQ__QuoteLineGroup__c(
                SBQQ__Number__c = item.SBQQ__Group__r.SBQQ__Number__c,
                SBQQ__NetTotal__c = item.SBQQ__Group__r.SBQQ__NetTotal__c,
                SBQQ__ListTotal__c = item.SBQQ__Group__r.SBQQ__ListTotal__c,
                SBQQ__CustomerTotal__c = item.SBQQ__Group__r.SBQQ__CustomerTotal__c);
                newItem.Name = item.SBQQ__Group__r.Name;
                newItem.SBQQ__Quote__c = quoteIds[0]; //quoteId;
                if (!existingGroups.contains(item.SBQQ__Group__r.Name)) {
                existingGroups.add(item.SBQQ__Group__r.Name);
                newQuoteLineGroups.add(newItem);
                }
            }
            set<String> unUtilizedGroups = new Set<STring>();
            if (newQuoteLineGroups.size() > 0 && Schema.sObjectType.SBQQ__QuoteLineGroup__c.isCreateable()) {
                insert newQuoteLineGroups;               
                Map<String, String> groupNameVsId = new Map<String, String>();
                for (SBQQ__QuoteLineGroup__c grp : newQuoteLineGroups) {
                groupNameVsId.put(grp.Name, grp.Id);
                unUtilizedGroups.add(grp.id);
                }
               
                List<SBQQ__QuoteLine__c> newQuoteLines = [SELECT id, 
                                                                name,
                                                                SBQQ__Quote__c,
                                                                SBQQ__Quote__r.SBQQ__Type__c,
                                                                sbqq__Product__c,
                                                                SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c,
                                                                SBQQ__UpgradedSubscription__c,
                                                                SBQQ__UpgradedSubscription__r.SBQQ__QuoteLine__c 
                                                                FROM SBQQ__QuoteLine__c
                                                                WHERE SBQQ__Quote__c = :quoteIds[0] AND
                                                                SBQQ__Group__c= null
                                                                WITH SECURITY_ENFORCED];

                if(newQuoteLines.size()>0){
                    List<SBQQ__QuoteLine__c> qlToUpdate = new List<SBQQ__QuoteLine__c>();
                    if (!CRUD_FLS_CheckUtility.checkUpdateAccess(new Set<STring>{ 'SBQQ__Group__c' },quoteLineFields)) {
                        throw new AuraHandledException('Permission missing for quote line fields.');
                    }                    
                    for (SBQQ__QuoteLine__c newItem : newQuoteLines) {                       
                        if (productIdVsGroupName.containsKey(newItem.SBQQ__UpgradedSubscription__r.SBQQ__QuoteLine__c)) {                            
                            String groupId = groupNameVsId.get(productIdVsGroupName.get(newItem.SBQQ__UpgradedSubscription__r.SBQQ__QuoteLine__c));

                            unUtilizedGroups.remove(groupId);
                            SBQQ__QuoteLine__c itmToPass = new SBQQ__QuoteLine__c();
                            itmToPass.Id = newItem.Id;
                            itmToPass.SBQQ__Group__c = groupId;
                            qlToUpdate.add(itmToPass);
                        }
                        else if (productIdVsGroupName.containsKey(newItem.SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c)) {                           
                            String groupId = groupNameVsId.get(productIdVsGroupName.get(newItem.SBQQ__RenewedSubscription__r.SBQQ__QuoteLine__c));
                            unUtilizedGroups.remove(groupId);
                            SBQQ__QuoteLine__c itmToPass = new SBQQ__QuoteLine__c();
                            itmToPass.Id = newItem.Id;
                            itmToPass.SBQQ__Group__c = groupId;
                            qlToUpdate.add(itmToPass);
                        }
                    }
                    if (qlToUpdate.size() > 0) {
                        if (!CRUD_FLS_CheckUtility.checkUpdateAccess(new Set<STring>{ 'SBQQ__LineItemsGrouped__c' },quoteFields)) {
                            throw new AuraHandledException('Permission missing for quote fields.');
                        }                    
                        if (Schema.sObjectType.SBQQ__QuoteLine__c.isUpdateable()) {
                            update qlToUpdate;
                        }
                    }
                    if (unUtilizedGroups.size() > 0) {                       
                        List<SBQQ__QuoteLineGroup__c> groupsToDelete = new List<SBQQ__QuoteLineGroup__c>();
                        for (String str : unUtilizedGroups) {
                            SBQQ__QuoteLineGroup__c grp = new SBQQ__QuoteLineGroup__c(Id = str);
                            groupsToDelete.add(grp);
                        }
                        if (Schema.sObjectType.SBQQ__QuoteLineGroup__c.isDeletable() && groupsToDelete.size() > 0) {
                            delete groupsToDelete;
                        }
                    }             
                }
            }            
            List<SBQQ__QuoteLine__c> grpQlLines = [SELECT id, 
                                                        name,
                                                        SBQQ__Quote__c, 
                                                        sbqq__Product__c,
                                                        SBQQ__UpgradedSubscription__c,
                                                        SBQQ__UpgradedSubscription__r.SBQQ__QuoteLine__c 
                                                        FROM SBQQ__QuoteLine__c
                                                        WHERE SBQQ__Quote__c = :quoteIds[0] AND 
                                                        SBQQ__Group__c= null
                                                        WITH SECURITY_ENFORCED];
                                
            if(grpQlLines.size()>0 || unUtilizedGroups.size()>0 ){                               
                handleAfterInsert(quoteIds);
            } 
        }         
    }    
}