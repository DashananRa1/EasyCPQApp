/************************************************************************************************
  @description       :RenewalLWC Component is  used to Create New Amend Quote from Opportunity Object 
                      as same as Standard Way of creating new Renewal Process 
  @author            : Roshan Jambhule - Bluvium
  @group             : Ashwini Singh - Sr.Solution Architectgit
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita Verma - Tech Assistant
  @last modified on  : 03-01-2024
  @last modified by  : Roshan Jambhule - Bluvium
 **************************************************************************************************/
import { LightningElement, track, wire, api } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getFieldLableAndFieldAPI from "@salesforce/apex/CreateRenewLWC.getFieldLableAndFieldAPI";
import getCustomMetadata from "@salesforce/apex/CreateRenewLWC.getCustomMetadata";
import getContracts from "@salesforce/apex/CreateRenewLWC.getContracts";
import renewContract from "@salesforce/apex/CreateRenewLWC.renewContract";
import renewContractUpdate from "@salesforce/apex/CreateRenewLWC.renewContractUpdate";
import ACCOUNT_ID from "@salesforce/schema/Opportunity.AccountId";
import OPP_ID from "@salesforce/schema/Opportunity.Id";
import ACCOUNT_Name from "@salesforce/schema/Opportunity.Account.Name";
import RENEWED_CONTRACT_ID from "@salesforce/schema/Opportunity.SBQQ__RenewedContract__c";

export default class RenewLWC extends NavigationMixin(LightningElement) {
  @api recordId;
  @api navigateToList;
  @track contracts = [];
  @track selectedcontracts = [];
  @track updatedcontracts = [];
  @track columns = [];
  @track data = [];
  @track preSelectedRows = [];
  @track contractNew = [];

  errorMessage;
  exceptionMessage;
  noActiveContractFound = false;
  displayactivecontracts = true;
  displayerrormsg = false;
  isModalOpen = false;
  isLoading = false;
  autoSelectMasterContract = false;
  showMasterContractError = true;
  accId;
  oppRecordId;
  contractID;
  masterContractId;
  accName;

  connectedCallback() {
    this.handleClick();
  }

  @wire(getCustomMetadata)
  myCustomSettings({ error, data }) {
    if (data) {
      this.autoSelectMasterContract =
        data.BECPQ__Auto_Select_Master_Contract__c;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [ACCOUNT_ID, OPP_ID, ACCOUNT_Name, RENEWED_CONTRACT_ID]
  })
  wiredAccounts({ error, data }) {
    if (data) {
      this.accId = data.fields.AccountId.value;
      this.oppRecordId = data.fields.Id.value;
      this.accName = getFieldValue(data, ACCOUNT_Name);
      this.title = "Active Contracts for Account " + this.accName;
      this.masterContractId = data.fields.SBQQ__RenewedContract__c.value;
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getContracts, { accId: "$accId" })
  wiredContracts({ error, data }) {
    if (data) {
      this.contracts = data;
      this.data = data;
      if (data && data.length === 0) {
        this.displayactivecontracts = false;
        this.noActiveContractFound = true;
      }
      if (this.autoSelectMasterContract) {
        this.contracts.forEach((element) => {
          if (element.Id === this.masterContractId) {
            this.contractNew.push(element.Id);
          }
        });
        this.preSelectedRows = this.contractNew;
      }
    } else if (error) {
      console.error(error);
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
        console.error(error);
      });
  }

  handleChangeCheckbox() {
    var con = [];
    var tempselctcontractsList;
    if (this.autoSelectMasterContract) {
      this.showMasterContractError = true;
      tempselctcontractsList = this.template
        .querySelector("lightning-datatable")
        .getSelectedRows();
      tempselctcontractsList.forEach((currentItem) => {
        con.push(currentItem.Id);
        if (currentItem.Id === this.masterContractId) {
          this.showMasterContractError = false;
        }
      });
      if (this.showMasterContractError) {
        con.push(this.masterContractId);
        this.preSelectedRows = con;
        this.displayactivecontracts = true;
        const event = new ShowToastEvent({
          title: "Info",
          message: "Master Contract can't be deselected",
          variant: "info"
        });
        this.dispatchEvent(event);
      }
    }
  }

  submitDetails() {
    let tempselctcontracts = [];
    let tempselctcontracts2 = [];
    this.isModalOpen = true;
    this.displayactivecontracts = false;
    this.noActiveContractFound = false;
    tempselctcontracts = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows();
    tempselctcontracts.forEach((currentItem) => {
      tempselctcontracts2.push(currentItem);
    });
    this.selectedcontracts = tempselctcontracts2;
    if (this.autoSelectMasterContract) {
      this.isModalOpen = false;
      this.handleRenewal();
    }
  }

  submitMasterContractDetails() {
    this.handleRenewal();
  }
  handleRenewal() {
    this.masterContractId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].Id;
    this.masterContractQuoteId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].SBQQ__Quote__c;
    this.masterContractOppId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].SBQQ__Opportunity__c;
    this.masterContractAccId = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows()[0].AccountId;
    if (this.masterContractId == null || this.masterContractId === "") {
      const event = new ShowToastEvent({
        title: "Please select any Contract",
        variant: "Error",
        mode: "dismissable"
      });
      this.dispatchEvent(event);
    } else {
      this.isLoading = true;
      renewContractUpdate({
        lstContractUpdate: this.selectedcontracts,
        oppId: this.oppRecordId
      }).then((result) => {
        let modifiedcontracts = [];
        modifiedcontracts = result;
        this.updatedcontracts = modifiedcontracts;
        renewContract({
          masterContractId: this.masterContractId,
          opportunityId: this.oppRecordId,
          lstContract: this.updatedcontracts,
          masterContOppId: this.masterContractOppId,
          masterContQuoteId: this.masterContractQuoteId,
          masterContAccId: this.masterContractAccId
        })
          .then((innerResult) => {
            if (!innerResult.includes("Exception")) {
              let dataQuote = JSON.parse(innerResult);
              let url =
                window.location.origin + "/apex/SBQQ__sb?id=" + dataQuote[0].Id;
              this[NavigationMixin.Navigate]({
                type: "standard__webPage",
                attributes: {
                  url: url
                }
              });
            } else {
              this.displayactivecontracts = true;
              this.noActiveContractFound = false;
              this.isModalOpen = false;
              const event = new ShowToastEvent({
                title: "Error",
                message:
                  "Contract cannot be renewed from an Opportunity if ‘Generate New Renewal Opportunity is false’. Renew from the contract!",
                variant: "error"
              });
              this.dispatchEvent(event);
              this.closeModal();
            }
          })
          .catch((error) => {
            console.error(error);
            const event = new ShowToastEvent({
              title: "Error",
              message: "Error creating Renewal. Please Contact System Admin",
              variant: "error"
            });
            this.dispatchEvent(event);
          });
      });
    }
  }

  cancelDetails() {
    this.isModalOpen = false;
    this.displayactivecontracts = true;
  }
  closeModal() {
    this.isModalOpen = false;
    window.history.back();
    return false;
  }
}