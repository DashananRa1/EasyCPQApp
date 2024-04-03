<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Default</label>
    <values>
    <label>Default</label>
</values>
    <protected>false</protected>
    <values>
        <field>AmendOpportunity_AccountFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;Description&quot;,&quot;sourcefield&quot;:&quot;Description&quot;,&quot;objectName&quot;:&quot;Account&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>AmendOpportunity_OriginalOppFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;StageName&quot;,&quot;sourcefield&quot;:&quot;StageName&quot;,&quot;objectName&quot;:&quot;OriginalOpportunity&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>AmendQuote_AccountFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;AccountNumber&quot;,&quot;sourcefield&quot;:&quot;BECPQ__ReferralCode__c&quot;,&quot;objectName&quot;:&quot;Account&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>AmendQuote_OriginalOppFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;CloseDate&quot;,&quot;sourcefield&quot;:&quot;SBQQ__ExpirationDate__c&quot;,&quot;objectName&quot;:&quot;OriginalOpportunity&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>AmendQuote_OriginalQuoteFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;SBQQ__Notes__c&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Notes__c&quot;,&quot;objectName&quot;:&quot;OriginalQuote&quot;,&quot;index&quot;:&quot;1&quot;},{&quot;targetfield&quot;:&quot;SBQQ__Status__c&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Status__c&quot;,&quot;objectName&quot;:&quot;OriginalQuote&quot;,&quot;index&quot;:&quot;2&quot;}]</value>
    </values>
    <values>
        <field>Auto_Select_Master_Contract__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Generate_New_Amendment_Opportunity__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Generate_New_Renewal_Opportunity__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Maintain_QuoteLine_Groups__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Maintain_QuoteLine_Groups_for_Amendment__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Maintain_QuoteLine_Groups_for_renewal__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>New_Quote_Fields_Setup__c</field>
        <value xsi:type="xsd:string">[{&quot;index&quot;:1,&quot;objectName&quot;:&quot;Account&quot;,&quot;sourcefield&quot;:&quot;BECPQ__ReferralCode__c&quot;,&quot;targetfield&quot;:&quot;AccountNumber&quot;,&quot;datatype&quot;:&quot;String&quot;,&quot;label&quot;:&quot;Referral Code&quot;,&quot;value&quot;:&quot;BECPQ__ReferralCode__c&quot;,&quot;targetdatatype&quot;:&quot;String&quot;,&quot;targetlabel&quot;:&quot;Account Number&quot;,&quot;targetvalue&quot;:&quot;AccountNumber&quot;,&quot;targetname&quot;:&quot;Account Number&quot;},{&quot;index&quot;:1,&quot;targetfield&quot;:&quot;Description&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Introduction__c&quot;,&quot;objectName&quot;:&quot;OriginalOpportunity&quot;},{&quot;index&quot;:1,&quot;objectName&quot;:&quot;OriginalQuote&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Notes__c&quot;,&quot;targetfield&quot;:&quot;Notes is Set from UI Configuration page&quot;,&quot;datatype&quot;:&quot;TextArea&quot;,&quot;label&quot;:&quot;Notes&quot;,&quot;value&quot;:&quot;SBQQ__Notes__c&quot;},{&quot;index&quot;:2,&quot;objectName&quot;:&quot;OriginalQuote&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Status__c&quot;,&quot;targetfield&quot;:&quot;In Review&quot;,&quot;selctedfield&quot;:&quot;&quot;,&quot;datatype&quot;:&quot;Picklist&quot;,&quot;label&quot;:&quot;Status&quot;,&quot;value&quot;:&quot;SBQQ__Status__c&quot;}]</value>
    </values>
    <values>
        <field>RenewalOpportunity_AccountFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;Description&quot;,&quot;sourcefield&quot;:&quot;Description&quot;,&quot;objectName&quot;:&quot;Account&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>RenewalOpportunity_OriginalOppFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;LeadSource&quot;,&quot;sourcefield&quot;:&quot;LeadSource&quot;,&quot;objectName&quot;:&quot;OriginalOpportunity&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>RenewalQuote_AccountFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;AccountNumber&quot;,&quot;sourcefield&quot;:&quot;BECPQ__ReferralCode__c&quot;,&quot;objectName&quot;:&quot;Account&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>RenewalQuote_OriginalOppFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;Description&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Notes__c&quot;,&quot;objectName&quot;:&quot;OriginalOpportunity&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
    <values>
        <field>RenewalQuote_OriginalQuoteFieldSetup__c</field>
        <value xsi:type="xsd:string">[{&quot;targetfield&quot;:&quot;SBQQ__Notes__c&quot;,&quot;sourcefield&quot;:&quot;SBQQ__Introduction__c&quot;,&quot;objectName&quot;:&quot;OriginalQuote&quot;,&quot;index&quot;:&quot;1&quot;}]</value>
    </values>
</CustomMetadata>
