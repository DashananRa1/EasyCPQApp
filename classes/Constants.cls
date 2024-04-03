/***************************************************************************************
 * @description       : This Class is Used to Store Constant Variable Used For Other Class
 * @author            : Nitesh Lande - Bluvium
 * @test class        :
 * @created Date      : 09-21-2023
 * @last modified on  : 11-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
****************************************************************************************/
public with sharing class Constants {
    public static final String APP_CONFIGURAION_NAME = 'Default';   
    public static final String QUOTE_OBJECT_NAME = 'Quote';
    public static final String OPPORTUNITY_OBJECT_NAME = 'Opportunity';
    public static final String ORDER_OBJECT_NAME = 'Order';
    public static final String NAME_SPACE = System.Label.NamespaceBECPQ;

    public static Set<String> oppFieldList = Schema.SObjectType.Opportunity.fields.getMap().keySet();
    
    public static Set<String> quoteFieldList = Schema.SObjectType.SBQQ__Quote__c.fields.getMap().keySet();
}