/************************************************************************************************
  @description       :Amend Settings Component where We Have added the Amend Opportunity
                     and Amend Quote LWC Component as Tab
  @author            : Roshan Jambhule - Bluvium
  @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita Varma - Tech Assistant
  @last modified on  : 02-22-2024
  @last modified by  : Roshan Jambhule - Bluvium
 *******************************************************/
import { LightningElement, api, track } from "lwc";
import setAmendMetadataFields from "@salesforce/apex/AmendSettingController.setAmendMetadataFields";
import getAmendOpportunityFields from "@salesforce/apex/AmendSettingController.getAmendOpportunityFields";
import getAmendQuoteFields from "@salesforce/apex/AmendSettingController.getAmendQuoteFields";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AmendSetting extends LightningElement {
  @api quoteFieldsList;
  @api accountFieldsList;
  @api opportunityFieldsList;
  showModal = true;
  amendQuoteDataFromMetadata;
  amendOppDataFromMetadata;
  quoteDataFromParent;
  oppDataFromParent;
  @track hasError = false;
  @api excludeAccountFields;
  @api excludeOpportunityFields;
  @api excludeQuoteFields;
  @api allowedMappings;

  connectedCallback() {
    getAmendQuoteFields()
      .then((result) => {
        this.amendQuoteDataFromMetadata = result;
      })
      .catch((error) => {
        console.log(error);
      });

    getAmendOpportunityFields()
      .then((result) => {
        this.amendOppDataFromMetadata = result;
      })
      .catch((error) => {
        console.log(error);
      });
  }
  closeErrorPopup() {
    this.hasError = false;
  }

  handleSave() {
    const amendQuoteSettingComponent = this.template.querySelector(
      "c-amend-quote-setting"
    );
    const amendOpportunitySettingComponent = this.template.querySelector(
      "c-amend-opportunity-setting"
    );

    // data get from AmmdQuoteSetting and AmmdOpportunitySetting child Components using optional chaining
    const quoteData = amendQuoteSettingComponent?.amendQuoteHandleSave?.();
    const opportunityData =
      amendOpportunitySettingComponent?.amendOpportunityHandleSave?.();
    if (amendQuoteSettingComponent && !quoteData) {
      this.hasError = true;
      return;
    }
    if (amendOpportunitySettingComponent && !opportunityData) {
      this.hasError = true;
      return;
    }
    if (typeof opportunityData === "undefined") {
      this.oppDataFromParent = this.amendOppDataFromMetadata;
      this.quoteDataFromParent = quoteData;
    } else {
      this.oppDataFromParent = opportunityData;
      this.quoteDataFromParent = quoteData;
    }

    setAmendMetadataFields({
      quoteJsonStr: JSON.stringify(this.quoteDataFromParent),
      opportunityJsonStr: JSON.stringify(this.oppDataFromParent)
    })
      .then((result) => {
        const event = new ShowToastEvent({
          title: "Amend settings data saved successfully...",
          result,
          variant: "Success",
          mode: "dismissable"
        });
        this.dispatchEvent(event);
        location.reload(true);
      })
      .catch((error) => {
        console.error("Error updating metadata: ", error);
        const event = new ShowToastEvent({
          title:
            "Error updating metadata:" + error.bodyy
              ? error.body.message
              : error.message,
          variant: "Error",
          mode: "dismissable"
        });
        this.dispatchEvent(event);
      });
  }
  handleModalClose() {
    this.showModal = false;
    location.reload(true);
  }
}