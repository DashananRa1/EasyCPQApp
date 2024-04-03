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
                     : Ankita Verma - Tech Assistant
  @last modified on  : 02-22-2024
  @last modified by  : Roshan Jambhule - Bluvium
 **************************************************************************************************/
import { LightningElement, api, track } from "lwc";
import setRenewalMetadataFields from "@salesforce/apex/RenewalSettingController.setRenewalMetadataFields";
import getRenewalOpportunityFields from "@salesforce/apex/RenewalSettingController.getRenewalOpportunityFields";
import getRenewalQuoteFields from "@salesforce/apex/RenewalSettingController.getRenewalQuoteFields";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RenewalSetting extends LightningElement {
  @track hasError = false;
  @api quoteFieldsList;
  @api accountFieldsList;
  @api opportunityFieldsList;
  showModal = true;
  renewalQuoteDataFromMetadata;
  renewalOppDataFromMetadata;
  quoteDataFromParent;
  oppDataFromParent;
  @api excludeAccountFields;
  @api excludeOpportunityFields;
  @api excludeQuoteFields;
  @api allowedMappings;
  connectedCallback() {
    getRenewalOpportunityFields()
      .then((result) => {
        this.renewalOppDataFromMetadata = result;
      })
      .catch((error) => {
        console.log(error);
      });

    getRenewalQuoteFields()
      .then((result) => {
        this.renewalQuoteDataFromMetadata = result;
      })
      .catch((error) => {
        console.log(error);
      });
  }
  closeErrorPopup() {
    this.hasError = false;
  }
  handleSave() {
    const renewalQuoteSettingComponent = this.template.querySelector(
      "c-renewal-quote-settings"
    );
    const renewalOpportunitySettingComponent = this.template.querySelector(
      "c-renewal-opportunity-setting"
    );
    const quoteData = renewalQuoteSettingComponent?.renwalQuoteHandleSave?.();
    const opportunityData =
      renewalOpportunitySettingComponent?.renwalOpportuntyHandleSave?.();

    if (renewalQuoteSettingComponent && !quoteData) {
      this.hasError = true;
      return;
    }
    if (renewalOpportunitySettingComponent && !opportunityData) {
      this.hasError = true;
      return;
    }
    if (typeof opportunityData === "undefined") {
      this.oppDataFromParent = this.renewalOppDataFromMetadata;
      this.quoteDataFromParent = quoteData;
    } else {
      this.oppDataFromParent = opportunityData;
      this.quoteDataFromParent = quoteData;
    }

    setRenewalMetadataFields({
      quoteJsonStr: JSON.stringify(this.quoteDataFromParent),
      opportunityJsonStr: JSON.stringify(this.oppDataFromParent)
    })
      .then((result) => {
        console.log("Metadata updated successfully: ", result);
        
        const event = new ShowToastEvent({
          title: "Renewal settings data saved successfully...",
          variant: "Success",
          mode: "dismissable"
        });
        this.dispatchEvent(event);
        location.reload(true);
      })
      .catch((error) => {
        console.error('Error updating metadata: ', error);
        const event = new ShowToastEvent({
          title:
            "Error updating metadata:" + error.body
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