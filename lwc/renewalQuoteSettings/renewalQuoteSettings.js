/************************************************************************************************
  @description       :RenwalQuoteSettings Component is the child component of amendSetting Component.
                      It contains form to map field values from Opportunity, Account and Quote to Renewal Quote.
  @author            : Roshan Jambhule - Bluvium
  @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita Varma - Tech Assistant
  @last modified on  : 02-27-2024
  @last modified by  : Roshan Jambhule - Bluvium
 ***********************************************************************************************************/
import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRenewalQuoteFields from "@salesforce/apex/RenewalSettingController.getRenewalQuoteFields";
export default class RenewalQuoteSettings extends LightningElement {
  @track showSpinner = true;
  @api quoteFieldsList;
  @api accountFieldsList;
  @api opportunityFieldsList;
  @track originalOpportunityField = [];
  @track accountFields = [];
  @track originalQuoteFields = [];
  @track fieldIndexVsDataType = {};
  quoteFieldData = [];
  oppFieldData = [];
  accountFieldData = [];
  selectedQuoteFieldDatype;
  searchResults = [];
  @track pickListOptions = [];
  @track selectedSearchIndex = -1;
  @track hasError = false;
  @api excludeAccountFields;
  @api excludeOpportunityFields;
  @api excludeQuoteFields;
  @api allowedMappings;

  connectedCallback() {
    this.fetchData().then(() => {      
      this.getQuoteFieldSetup();
    });
  }
  async fetchData() {
    this.accountFieldsList.forEach((fld) => {
      if (fld.createable && !this.excludeAccountFields.includes(fld.value)) {
        this.accountFieldData.push(fld);
      }
    });
    this.opportunityFieldsList.forEach((fld) => {
      if (
        fld.createable &&
        !this.excludeOpportunityFields.includes(fld.value)
      ) {
        this.oppFieldData.push(fld);
      }
    });
    this.quoteFieldsList.forEach((fld) => {
      if (fld.createable && !this.excludeQuoteFields.includes(fld.value)) {
        this.quoteFieldData.push(fld);
      }
    });
  }  
  getQuoteFieldSetup() {
    getRenewalQuoteFields()
      .then((result) => {
        if (result) {
          this.accountFields.forEach((fld) => {
            if (fld.createable) {
              this.accountFieldData.push(fld);
            }
          });

          this.originalOpportunityField.forEach((fld) => {
            if (fld.createable) {
              this.oppFieldData.push(fld);
            }
          });

          this.originalQuoteFields.forEach((fld) => {
            if (fld.createable) {
              this.quoteFieldData.push(fld);
            }
          });

          let originalOpportunityFieldsArr = [],
            accountFieldsArr = [],
            originalQuoteFieldsArr = [];
          result.forEach((fld) => {
            if (fld.objectName === "OriginalOpportunity") {
              originalOpportunityFieldsArr.push(fld);
            }
            if (fld.objectName === "Account") {
              accountFieldsArr.push(fld);
            }
            if (fld.objectName === "OriginalQuote") {
              originalQuoteFieldsArr.push(fld);
            }
          });
          this.showSpinner = false;
          this.originalOpportunityField = originalOpportunityFieldsArr;
          this.accountFields = accountFieldsArr;
          this.originalQuoteFields = originalQuoteFieldsArr;
        }
      })
      .catch((error) => {
        this.showToastMessage(
          "There is no Field Mapping found for RenewalQuoteSettings" +
            error.message,
          "error",
          "error"
        );
        console.log("error from catch block:-> ", error);
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }

  handleChangeQuote(event) {
    const selectedIndex = event.target.dataset.fieldIndex;
    const selectedObject = event.target.dataset.objectName;
    const selectedValue = event.target.value;
    const selectedRelation = event.target.dataset.fieldRel;
    let fieldsArray;
    let cloneFields;
    switch (selectedObject) {
      case "OriginalOpportunity":
        fieldsArray = this.originalOpportunityField;
        break;
      case "Account":
        fieldsArray = this.accountFields;
        break;
      case "OriginalQuote":
        fieldsArray = this.originalQuoteFields;
        break;
      default:
        return;
    }
    cloneFields = JSON.parse(JSON.stringify(fieldsArray));
    try {
      cloneFields.forEach((fld) => {
        if (Number(fld.index) === Number(selectedIndex)) {
          this.selectedSearchIndex = selectedIndex;
          let selectedOpt;
          if (selectedRelation === "source") {
            selectedOpt = this.quoteFieldData.find(
              (opt) => opt.value === selectedValue
            );
            if (selectedOpt) {
              fld.datatype = selectedOpt.datatype;
              fld.sourcefield = selectedOpt.value;
              fld.label = selectedOpt.label;
              fld.value = selectedOpt.value;
              fld.name = selectedOpt.name;
              fld.targetfield = "";
            }
          } else if (selectedRelation === "target") {
            selectedOpt =
              selectedObject === "Account"
                ? this.accountFieldData.find(
                    (opt) => opt.value === selectedValue
                  )
                : selectedObject === "OriginalOpportunity"
                  ? this.oppFieldData.find((opt) => opt.value === selectedValue)
                  : this.quoteFieldData.find(
                      (opt) => opt.value === selectedValue
                    );
            if (selectedOpt) {
              fld.targetdatatype = selectedOpt.datatype;
              fld.targetlabel = selectedOpt.label;
              fld.targetvalue = selectedOpt.value;
              fld.targetname = selectedOpt.name;
              fld.targetfield = selectedOpt.value;
            }
            if (!fld.datatype && fld.sourcefield) {
              let selectedOpt2 = this.quoteFieldData.find(
                (opt) => opt.value === fld.sourcefield
              );
              if (selectedOpt2) {
                fld.datatype = selectedOpt2.datatype;
              }
            }
            if (
              fld.datatype &&
              this.allowedMappings[fld.datatype] &&
              !this.allowedMappings[fld.datatype].includes(fld.targetdatatype)
            ) {
              event.target.setCustomValidity(
                "Invalid field selection for mapping. Data type not Compatible."
              );
              event.target.blur();
            } else {
              event.target.setCustomValidity("");
              event.target.blur();
            }
          }
        }
      });
    } catch (Ex) {
      console.log("Exccc::", Ex.message);
    }

    switch (selectedObject) {
      case "OriginalOpportunity":
        this.originalOpportunityField = cloneFields;
        break;
      case "Account":
        this.accountFields = cloneFields;
        break;
      case "OriginalQuote":
        this.originalQuoteFields = cloneFields;
        break;
      default:
        console.error(`Unexpected value of selectedObject: ${selectedObject}`);
    }
  }  
  handleNewField(objectName, fieldList) {
    if (fieldList.length > 0) {
      let lastElement = fieldList.at(-1);
      fieldList.push({
        index: parseInt(lastElement.index, 15) + 1,
        objectName,
        sourcefield: "",
        targetfield: "",
        selctedfield: ""
      });
    } else {
      fieldList.push({
        index: 1,
        objectName,
        sourcefield: "",
        targetfield: "",
        selctedfield: ""
      });
    }
  }

  handleNewFieldForAccount() {
    this.handleNewField("Account", this.accountFields);
  }
  handleNewFieldForOpportunity() {
    this.handleNewField("OriginalOpportunity", this.originalOpportunityField);
  }
  handleNewFieldForQuote() {
    this.handleNewField("OriginalQuote", this.originalQuoteFields);
  }

  handleRemoveFieldForOpportunity(event) {
    let objectName = event.target.dataset.objectName;
    this.originalOpportunityField.splice(
      event.target.dataset.fieldIndex - 1,
      1
    );
    let fldData = [];
    this.originalOpportunityField.forEach((fld, index) => {
      fldData.push({
        index: index + 1,
        targetfield: fld.targetfield,
        sourcefield: fld.sourcefield,
        objectName: fld.objectName
      });
    });

    if (this.originalOpportunityField.length === 0) {
      fldData.push({
        index: 1,
        objectName,
        sourcefield: "",
        targetfield: ""
      });
    }
    this.originalOpportunityField = fldData;
  }

  handleRemoveFieldForAccount(event) {
    let objectName = event.target.dataset.objectName;
    this.accountFields.splice(event.target.dataset.fieldIndex - 1, 1);
    let fldDataforAcc = [];
    this.accountFields.forEach((fld, index) => {
      fldDataforAcc.push({
        index: index + 1,
        targetfield: fld.targetfield,
        sourcefield: fld.sourcefield,
        objectName: fld.objectName
      });
    });

    if (this.accountFields.length === 0) {
      fldDataforAcc.push({
        index: 1,
        objectName,
        sourcefield: "",
        targetfield: ""
      });
    }
    this.accountFields = fldDataforAcc;
  }  
  handleRemoveFieldForQuote(event) {
    let objectName = event.target.dataset.objectName;
    this.originalQuoteFields.splice(event.target.dataset.fieldIndex - 1, 1);
    let fldDataforQuote = [];
    this.originalQuoteFields.forEach((fld, index) => {
      fldDataforQuote.push({
        index: index + 1,
        targetfield: fld.targetfield,
        sourcefield: fld.sourcefield,
        objectName: fld.objectName
      });
    });

    if (this.originalQuoteFields.length === 0) {
      fldDataforQuote.push({
        index: 1,
        objectName,
        sourcefield: "",
        targetfield: ""
      });
    }
    this.originalQuoteFields = fldDataforQuote;
  }

  @api
  renwalQuoteHandleSave() {
    let userQuoteFields = this.template.querySelectorAll("lightning-combobox");
    let isValid = true;
    try {
      userQuoteFields.forEach((item) => {
        isValid = isValid && item.checkValidity();
      });
      if (!isValid) {
        this.hasError = true;
        return false;
      }
    } catch (Ex) {
      console.log("Errror::::", Ex.message);
      this.showToastMessage(Ex.message, "error", "error");
      return false;
    }
    let jsonDataFromQuoteSetting = [];
    if (userQuoteFields && userQuoteFields.length > 0) {
      userQuoteFields.forEach((fld) => {
        let fieldMapping = {
          index: "",
          objectName: "",
          sourcefield: "",
          targetfield: ""
        };

        let existingMapping = jsonDataFromQuoteSetting.filter(
          (fldMap) =>
            fldMap.index === fld.dataset.fieldIndex &&
            fldMap.objectName === fld.dataset.objectName
        );
        if (existingMapping.length === 0) {
          fieldMapping.index = fld.dataset.fieldIndex;
          fieldMapping.objectName = fld.dataset.objectName;
        } else {
          fieldMapping = existingMapping[0];
        }
        if (fld.dataset.fieldRel === "source") {
          fieldMapping.sourcefield = fld.value;
          jsonDataFromQuoteSetting.push(fieldMapping);
        } else if (fld.dataset.fieldRel === "target") {
          fieldMapping.targetfield = fld.value;
        }
      });
      return jsonDataFromQuoteSetting;
    }    
    return null;
  }  
  showToastMessage(msg = undefined, variant = "") {
    const event = new ShowToastEvent({
      title: msg,
      variant: variant,
      mode: "dismissable"
    });
    this.dispatchEvent(event);
  }
  closeErrorPopup() {
    this.hasError = false;
  }
}