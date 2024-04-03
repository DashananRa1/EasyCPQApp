/************************************************************************************************
  @description       :CreateNewQuote Component is  used to Create New Quote from Opportunity Object 
                      as same as Standard Way of creating new Quote
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
 *******************************************************/
import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import createQuote from "@salesforce/apex/QuoteCreationController.createQuote";
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const OPP_FIELDS = [
  "Opportunity.Id",
  "Opportunity.AccountId",
  "Opportunity.StageName",
  "Opportunity.Pricebook2Id"
];

export default class CreateNewQuote extends NavigationMixin(LightningElement) {
  @api recordId; // opportunity record id
  @track startDate;
  @track expirationDate;
  @track paymentTerm = "Net 30";
  @track type = "Quote";
  @track errorMsg;
  @track oppId;
  @track accountId;
  @track newQuoteId;
  @track priceBookId;
  @track isLoaded = false;
  displayerrormsg = false;
  displaydata = true;
  errorMessage;
  quoteFieldsExist = false;

  // to get current Opportunities Details
  @wire(getRecord, { recordId: "$recordId", fields: OPP_FIELDS })
  opportunity(result) {
    if (result.data) {
      this.oppId = result.data.id;
      this.accountId = result.data.fields.AccountId.value;
      this.priceBookId = result.data.fields.Pricebook2Id.value;
      let rightNow = new Date();      
      rightNow.setMinutes(
        new Date().getMinutes() - new Date().getTimezoneOffset()
      );      
      rightNow.setDate(rightNow.getDate() + 30);
      let yyyyMmDd = rightNow.toISOString().slice(0, 10);
      this.startDate = yyyyMmDd;
      this.expirationDate = yyyyMmDd;
      if (result.data.fields.StageName.value === "8-Closed/Won") {
        this.displaydata = false;
        this.displayerrormsg = true;
        this.errorMessage = "Opp is closed Won";
      }
    } else if (result.error) {
      console.log(result.error);
    }
  }  
  handleSuccess(event) {
    this.newQuoteId = event.detail.id;

    if (this.newQuoteId) {
      createQuote({
        opportunityId: this.oppId,
        quoteAccountId: this.accountId,
        newQuoteId: this.newQuoteId
      })
        .then((result) => {
          if (result) {
            this.showNotification();
            this.isLoaded = false;
            this.navigateToQuote();
          } else {
            this.handleError(
              "Error creating New Quote. Please Contact System Admin"
            );
          }
        })
        .catch((error) => {
          this.handleError(error.body.message);
        });
    }
  }
  handleError(message) {
    this.isLoaded = false;
    this.displayerrormsg = true;
    this.errorMessage = message;
    const event = new ShowToastEvent({
      title: "Error",
      message: message,
      variant: "error"
    });
    this.dispatchEvent(event);
  }
  handleCancel() {
    window.history.back();
    return false;
  }
  navigateToQuote() {
    const redirectUrl = `/apex/sbqq__sb?scontrolCaching=1&id=${this.newQuoteId}#quote/le?qId=${this.newQuoteId}`;
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: redirectUrl
      }
    });
  }
  showNotification() {
    const evt = new ShowToastEvent({
      title: "Quote was created.",
      message: "",
      variant: "success"
    });
    this.dispatchEvent(evt);
  }
}