/****************************************************************
 * @description       : Lwc Component To Get Scema From Object
 * @author            : Amit Aher - Bluvium
   @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Jaya Rawat - Sr.Quality Analyst
 * @last modified on  : 12-07-2023
 * @last modified by  : Roshan Jambhule
 *****************************************************************/
import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getObjectInfos } from "lightning/uiObjectInfoApi";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import OPPORTUNITY_OBJECT from "@salesforce/schema/Opportunity";
import QUOTE_OBJECT from "@salesforce/schema/SBQQ__Quote__c";
import WEBSITE_URL from "@salesforce/label/c.Website_URL";
import BlOGO from "@salesforce/resourceUrl/Bluvium_B_Logo";
export default class EasyCpqSettings extends LightningElement {
  objectApiNames = [ACCOUNT_OBJECT, OPPORTUNITY_OBJECT, QUOTE_OBJECT];
  webSiteUrl = { WEBSITE_URL };
  bluviumBLogoUrl = BlOGO + "/B_Logo/B_Original_Logo.jpg";
  quoteFields = [];
  accountFields = [];
  opportunityFields = [];
  pickListOptionsQuote = [];
  pickListOptionsAccount = [];
  pickListOptionsOpp = [];
  @api excludeAccountFields = [
    "CreatedById",
    "CreatedDate",
    "DandbCompanyId",
    "Id",
    "IsDeleted",
    "LastModifiedById",
    "LastModifiedDate",
    "LastReferencedDate",
    "LastViewedDate",
    "MasterRecordId",
    "ParentId",
    "SBQQ__PreserveBundle__c",
    "SystemModstamp",
    "OwnerId"
  ];

  @api excludeOpportunityFields = [
    "FiscalYear",
    "FiscalQuarter",
    "Fiscal",
    "HasOpportunityLineItem",
    "ForecastCategory",
    "Id",
    "IsDeleted",
    "IsPrivate",
    "LastAmountChangedHistoryId",
    "LastModifiedById",
    "LastModifiedDate",
    "LastReferencedDate",
    "LastStageChangeDate",
    "LastViewedDate",
    "OwnerId",
    "Pricebook2Id",
    "PushCount",
    "SBQQ__Contracted__c",
    "SBQQ__OrderGroupID__c",
    "SBQQ__Ordered__c",
    "SBQQ__QuotePricebookId__c",
    "SystemModstamp"
  ];
  @api excludeQuoteFields = [
    "Name",
    "SBQQ__Primary__c",
    "SBQQ__Opportunity2__c",
    "SBQQ__Account__c",
    "OwnerId",
    "SBQQ__DefaultTemplate__c",
    "SBQQ__EmailTemplateId__c",
    "LastModifiedById",
    "SBQQ__LastSavedOn__c",
    "SBQQ__LastCalculatedOn__c",
    "SBQQ__Unopened__c",
    "SBQQ__PriceBook__c",
    "SBQQ__PricebookId__c",
    "SBQQ__Ordered__c",
    "SBQQ__OrderGroupID__c",
    "SBQQ__OrderByQuoteLineGroup__c",
    "SBQQ__OrderBy__c",
    "SBQQ__StartDate__c",
    "SBQQ__EndDate__c"
  ];
  @api allowedMappings = {
    String: [
      "String",
      "Number",
      "Currency",
      "Percent",
      "Date",
      "Picklist",
      "Date Time",
      "Reference",
      "Email",
      "Double",
      "Phone",
      "Time"
    ],
    TextArea: [
      "String",
      "Number",
      "Currency",
      "Percent",
      "Date",
      "Picklist",
      "Date Time",
      "Reference",
      "Email",
      "Double",
      "Phone",
      "Time",
      "Url",
      "TextArea",
      "LongTextArea"
    ],
    Currency: ["Currency"],
    Picklist: ["Picklist"],
    Number: ["Number", "Currency", "Percent", "Auto Number", "Phone"],
    Percent: ["Percent", "Currency", "Number"],
    Date: ["Date"],
    DateTime: ["DateTime"],
    Reference: ["Reference", "String"],
    Boolean: ["Boolean"],
    Double: ["Double"],
    Email: ["Email"],
    Phone: ["Phone"],
    Time: ["Time"],
    Url: ["Url"]
  };
  @wire(getObjectInfos, { objectApiNames: "$objectApiNames" })
  objectInfos({ error, data }) {
    try {
      if (data) {
        const mapofField = new Map();
        data.results.forEach((element) => {
          mapofField.set(element.result.apiName, element.result.fields);
        });
        // Storing Account object fields
        Object.entries(mapofField.get("Account")).forEach(([, metadata]) => {
          this.accountFields.push(metadata);
        });
        // Storing Opportunity object fields
        Object.entries(mapofField.get("Opportunity")).forEach(
          ([, metadata]) => {
            this.opportunityFields.push(metadata);
          }
        );
        // Storing SBQQ__Quote__c object fields
        Object.entries(mapofField.get("SBQQ__Quote__c")).forEach(
          ([, metadata]) => {
            this.quoteFields.push(metadata);
          }
        );

        if (this.accountFields && this.accountFields.length > 0) {
          let opts = [];
          this.accountFields.forEach((fld) => {
            opts.push({
              name: fld.label,
              label: fld.label,
              value: fld.apiName,
              datatype: fld.dataType,
              updateable: fld.updateable,
              createable: fld.createable
            });
          });
          this.pickListOptionsAccount = opts;
        }

        if (this.opportunityFields && this.opportunityFields.length > 0) {
          let opts = [];
          this.opportunityFields.forEach((fld) => {
            opts.push({
              name: fld.label,
              label: fld.label,
              value: fld.apiName,
              datatype: fld.dataType,
              updateable: fld.updateable,
              createable: fld.createable
            });
          });
          this.pickListOptionsOpp = opts;
        }

        if (this.quoteFields && this.quoteFields.length > 0) {
          let opts = [];
          this.quoteFields.forEach((fld) => {
            opts.push({
              name: fld.label,
              label: fld.label,
              value: fld.apiName,
              datatype: fld.dataType,
              updateable: fld.updateable,
              createable: fld.createable
            });
          });
          this.pickListOptionsQuote = opts;
        }
      } else if (error) {
        console.error("getObjectInfo > error: ", error);
        this.showToast(
          "Error",
          "An error occurred while fetching object information." +
            error.message,
          "error"
        );
      }
    } catch (Exc) {
      console.log("Exception Exc:", Exc.message);
      this.showToast("Error", "An error occurred: " + Exc.message, "error");
    }
  }
  showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(toastEvent);
  }
}