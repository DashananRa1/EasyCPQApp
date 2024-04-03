/************************************************************************************************
  @description       :amendLWC Component is  used to Create New Amend Quote from Opportunity Object 
                      as same as Standard Way of creating new amend 
  @author            : Roshan Jambhule - Bluvium
  @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita Varma - Tech Assistant
  @last modified on  : 03-01-2024
  @last modified by  : Roshan Jambhule - Bluvium
 ***************************************************************************************************/
import { LightningElement, track, wire, api } from "lwc";
import getContracts from "@salesforce/apex/CreateAmendLWC.getContracts";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import amendContract from "@salesforce/apex/CreateAmendLWC.amendContract";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import ACCOUNT_ID from "@salesforce/schema/Opportunity.AccountId";
import ACCOUNT_Name from "@salesforce/schema/Opportunity.Account.Name";
import OPP_ID from "@salesforce/schema/Opportunity.Id";
import getFieldLableAndFieldAPI from "@salesforce/apex/CreateAmendLWC.getFieldLableAndFieldAPI";
import { NavigationMixin } from "lightning/navigation";

export default class AmendLWC extends NavigationMixin(LightningElement) {
  errorMessage;
  displayerrormsg = false;
  isLoading = false;
  accId;
  oppRecordId;
  accName;
  contractID;
  contractOppId;
  contractQuoteId;
  contractAccId;
  displayactivecontracts = true;
  noActiveContractFound = false;

  @api recordId;
  @api navigateToList;
  @track contracts;
  @track contractFields;
  @track contractWrapper;
  @track columns = [];
  data = [];
  showdattabel = false;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [ACCOUNT_ID, OPP_ID, ACCOUNT_Name]
  })
  wiredAccounts({ error, data }) {
    if (data) {
      this.accId = data.fields.AccountId.value;
      this.error = undefined;
      this.oppRecordId = data.fields.Id.value;
      this.accName = getFieldValue(data, ACCOUNT_Name);
      this.title = "Active Contracts for Account " + this.accName;
    } else if (error) {
      this.error = error;
      this.accId = undefined;
      this.oppRecordId = undefined;
    }
  }

  connectedCallback() {
    this.handleClick();
  }

  @wire(getContracts, { accId: "$accId" })
  wiredContracts({ error, data }) {
    if (data) {
      this.data = data;
      if (data && data.length === 0) {
        this.displayactivecontracts = false;
        this.noActiveContractFound = true;
      }
      this.error = undefined;
      this.showSpinner = false;
    } else if (error) {
      this.error = error;
      this.contracts = undefined;
    }
  }
  handleClick() {
    getFieldLableAndFieldAPI()
      .then((data) => {
        let fieldSet = JSON.parse(data);
        let arr = [];
        for (let index = 0; index < fieldSet.length; index++) {
          arr.push({
            label: Object.keys(fieldSet[index])[0],
            fieldName: Object.values(fieldSet[index])[0]
          });
        }
        this.columns = arr;
      })
      .catch((error) => {
        this.showError(error);
      });
  }
  handleChangeRadio(event) {
    this.contractID = event.target.value;
  }
  closeModal() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.recordId,
        actionName: "view"
      }
    });
  }
  submitDetails() {
    let contractID, contractOppId, contractQuoteId, contractAccId;
    contractID = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].Id;
    contractOppId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].SBQQ__Opportunity__c;
    contractQuoteId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].SBQQ__Quote__c;
    contractAccId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].AccountId;

    if (contractID == null || contractID === "") {
      const evt = new ShowToastEvent({
        title: "Please select any Contract",
        variant: "Error",
        mode: "dismissable"
      });
      this.dispatchEvent(evt);
    } else {
      this.isLoading = true;
      //validaity check for all Usecases if any satisfy then amend
      amendContract({
        contractId: contractID,
        opportunityId: this.oppRecordId,
        contractOpportunityID: contractOppId,
        contractAccountId: contractAccId,
        contractQuoteId: contractQuoteId
      })
        .then((result) => {
          this.isLoading = false;
          if (!result.includes("Exception")) {
            let obj = JSON.parse(result);
            let url = window.location.origin + "/apex/SBQQ__sb?id=" + obj.Id;
            this[NavigationMixin.Navigate]({
              type: "standard__webPage",
              attributes: {
                url: url
              }
            });
            this.isLoading = false;
          } else {
            this.isLoading = false;
            const errorEvent = new ShowToastEvent({
              title: "Error",
              message:
                "Contract cannot be amended from an Opportunity if ‘Always Generate New Amendment Opportunity is false’. Amend from the contract!",
              variant: "error"
            });
            this.dispatchEvent(errorEvent);
          }
        })
        .catch((error) => {
          const errorEvent = new ShowToastEvent({
            title: "Error",
            message: "Error creating Amendment. Please Contact System Admin",
            error,
            variant: "error"
          });
          this.dispatchEvent(errorEvent);
        });
    }
  }

  hideErrorMessage() {
    this.displayerrormsg = false;
  }
}