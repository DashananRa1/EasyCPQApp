/************************************************************************************************
  @description       :Core Settings Component where we can configure 
                      Checkboxes for different Process like Amend and Renewal
  @author            : Roshan Jambhule - Bluvium
  @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Ankita Varma - Tech Assistant
  @last modified on  : 02-22-2024
  @last modified by  : Roshan Jambhule - Bluvium
 *******************************************************/
import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import UserManualURL from "@salesforce/label/c.User_s_Manual_URL";
import getAllAppConfigurationObjFields from "@salesforce/apex/CoreSettingController.getAddittionSettingDataFromMetadata";
import setAppConfigurationCheckboxValues from "@salesforce/apex/CoreSettingController.setAddittionSettingDataFromMetadata";

export default class CoreSetting extends LightningElement {
  isAutoSelectMasterContract = false;
  isGenerateNewAmendmentOpportunity = false;
  isGenerateNewRenewalOpportunity = false;
  isMaintainQuoteLineGroup = false;
  isMaintainQuoteLineGroupForRenewal = false;
  isMaintainQuoteLineGroupForAmendment = false;
  quoteStage = "";
  URL = { UserManualURL };
  dataPush = [];
  appConfig;

  @wire(getAllAppConfigurationObjFields, { recordName: "Default" })
  wiredAppConfig({ error, data }) {
   
    if (data) {
      this.appConfig = data;
      if (
        this.appConfig &&
        this.appConfig.BECPQ__Auto_Select_Master_Contract__c === true
      ) {
       
        this.isAutoSelectMasterContract = true;
      }
      if (
        this.appConfig &&
        this.appConfig.BECPQ__Generate_New_Amendment_Opportunity__c === true
      ) {
        this.isGenerateNewAmendmentOpportunity = true;
        console.log('this.isGenerateNewAmendmentOpportunity>',this.isGenerateNewAmendmentOpportunity);

      }
      if (
        this.appConfig &&
        this.appConfig.BECPQ__Generate_New_Renewal_Opportunity__c === true
      ) {
        this.isGenerateNewRenewalOpportunity = true;
      }
      if (this.appConfig && this.appConfig.BECPQ__Maintain_QuoteLine_Groups__c) {
        this.isMaintainQuoteLineGroup = true;
      }
      if (this.appConfig && this.appConfig.BECPQ__Maintain_QuoteLine_Groups_for_Amendment__c) {
        this.isMaintainQuoteLineGroupForAmendment = true;
      }
      if (this.appConfig && this.appConfig.BECPQ__Maintain_QuoteLine_Groups_for_renewal__c) {
        this.isMaintainQuoteLineGroupForRenewal = true;
      }
      if (this.appConfig && this.appConfig.BECPQ__Quote_Stage__c) {
        this.quoteStage = this.appConfig.BECPQ__Quote_Stage__c;
      }
    } else if (error) {
      console.error(error);
    }
  }

  handleMaintainQuoteLineGroupForRenewal(event){
    this.isMaintainQuoteLineGroupForRenewal = event.target.checked;
  }

  handleMaintainQuoteLineGroupForAmendment(event){
    this.isMaintainQuoteLineGroupForAmendment = event.target.checked;
  }

  handleStageChange(event) {
    this.quoteStage = event.target.value;
  }

  handleAutoSelectMasterContractChange(event) {
    this.isAutoSelectMasterContract = event.target.checked;
    if(this.isAutoSelectMasterContract && this.isGenerateNewRenewalOpportunity)
    {
      this.isGenerateNewRenewalOpportunity = false;
      this.showToast(
            "Warning",
            "Only one of the Renewal Setting can be used...",
            "Warning"
          );
    }
  }

  handleGenerateNewAmendmentOpportunityChange(event) {
    this.isGenerateNewAmendmentOpportunity = event.target.checked;
    console.log( 'this.isGenerateNewAmendmentOpportunity', this.isGenerateNewAmendmentOpportunity);
  }

  handleGenerateNewRenewalOpportunityChange(event) {
    this.isGenerateNewRenewalOpportunity = event.target.checked;
    if(this.isAutoSelectMasterContract && this.isGenerateNewRenewalOpportunity)
    {
      this.isAutoSelectMasterContract = false;
      this.showToast(
            "Warning",
            "Only one of the Renewal Setting can be used...",
            "Warning"
          );
    }
  }
  handleMaintainQuoteLineGroup(event) {
    this.isMaintainQuoteLineGroup = event.target.checked;
  }

  updateCheckboxFieldValues() {
    const jsonData = {
      recordId: this.appConfig.Id,
      isAutoSelectMasterContract: this.isAutoSelectMasterContract,
      isGenerateNewAmendmentOpportunity: this.isGenerateNewAmendmentOpportunity,
      isGenerateNewRenewalOpportunity: this.isGenerateNewRenewalOpportunity,
      isMaintainQuoteLineGroup: this.isMaintainQuoteLineGroup,
      isMaintainQuoteLineGroupForAmendment : this.isMaintainQuoteLineGroupForAmendment,
      isMaintainQuoteLineGroupForRenewal : this.isMaintainQuoteLineGroupForRenewal,
      quoteStage: this.quoteStage
    };

    this.dataPush = JSON.stringify(jsonData);
    setAppConfigurationCheckboxValues({ jsonStr: this.dataPush })
      .then((result) => {
        console.log('Data1',JSON.stringify(result));
        if (result.startsWith("jobId:")) {
          this.showToast(
            "Success",
            "Core settings saved successfully...",
            "Success"
          );
          window.location.reload();
        }
      })
      .catch((error) => {
        console.error("Error setting checkbox field values:", error);
        this.showToast(
          "Error",
          "Failed to update the config..." + error,
          "Error"
        );
      });
  }

  refreshAppConfig() {
    getAllAppConfigurationObjFields({ recordName: "Default" })
      .then((data) => {
        this.appConfig = data;
        this.showToast(
          "Success",
          "Core settings saved successfully...",
          "Success"
        );
      })
      .catch((error) => {
        console.error("Error retrieving app configuration:", error);
        this.showToast(
          "Error",
          "Failed to update the config..." + error,
          "Error"
        );
      });
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: message,      
      variant: variant
    });
    this.dispatchEvent(event);
  }
}