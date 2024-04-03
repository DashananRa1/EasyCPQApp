/************************************************************************************************
  @description       :amendOpportunitySettings Component is the child component of amendSetting Component.
                      It contains form to map field values from Opportunity and Account to Amend Opportunity
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
import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAmendOpportunityFields from "@salesforce/apex/AmendSettingController.getAmendOpportunityFields";
export default class AmendOpportunitySetting extends LightningElement {
  @track showSpinner = true;
  @api quoteFieldsList;
  @api accountFieldsList;
  @api opportunityFieldsList;
  @track fieldIndexVsDataType = {};
  @track originalOpportunityField = [];
  @track accountFields = [];
  @track hasError = false;
  oppFieldData = [];
  accountFieldData = [];
  selectedOppFieldDatype;
  searchResults = [];
  @track pickListOptions = [];
  @track selectedSearchIndex = -1;
  @api excludeAccountFields;
  @api excludeOpportunityFields;
  @api excludeQuoteFields;
  @api allowedMappings;

  @wire(getAmendOpportunityFields, {})
  wiredFieldSetup({ error, data }) {
    if (data) {
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
      let originalOpportunityFieldsArr = [],
        accountFieldsArr = [];
      data.forEach((fld) => {
        if (fld.objectName === "OriginalOpportunity") {
          originalOpportunityFieldsArr.push(fld);
        }
        if (fld.objectName === "Account") {
          accountFieldsArr.push(fld);
        }
      });
      this.originalOpportunityField = originalOpportunityFieldsArr;
      this.accountFields = accountFieldsArr;
      this.showSpinner = false;
    } else if (error) {
      console.error("Error: ", error);
      this.showToast("Error", "Error fetching data", "error");
    }
  }

  handleChangeOpportunity(event) {
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
    cloneFields.forEach((fld) => {
      if ("" + fld.index === "" + selectedIndex) {
        this.selectedSearchIndex = selectedIndex;
        let selectedOpt;
        if (selectedRelation === "source") {
          selectedOpt = this.oppFieldData.find(
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
              ? this.accountFieldData.find((opt) => opt.value === selectedValue)
              : this.oppFieldData.find((opt) => opt.value === selectedValue);
          if (selectedOpt) {
            fld.targetdatatype = selectedOpt.datatype;
            fld.targetlabel = selectedOpt.label;
            fld.targetvalue = selectedOpt.value;
            fld.targetname = selectedOpt.name;
            fld.targetfield = selectedOpt.value;
          }
          if (!fld.datatype && fld.sourcefield) {
            let selectedOpt2 = this.oppFieldData.find(
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
  // Generic method to handle the addition of new fields
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

  @api
  amendOpportunityHandleSave() {
    let userOpportunityFields =
      this.template.querySelectorAll("lightning-combobox");
    let isValid = true;
    try {
      userOpportunityFields.forEach((item) => {
        isValid = isValid && item.checkValidity();
      });
      if (!isValid) {
        this.hasError = true;
        return false;
      }
    } catch (Ex) {
      this.showToast(Ex.message, "error", "error");
      console.log("Fail to save the data", Ex.message);
      return false;
    }
    let jsonDataFromOppSetting = [];
    if (userOpportunityFields && userOpportunityFields.length > 0) {
      userOpportunityFields.forEach((fld) => {
        let fieldMapping = {
          index: "",
          objectName: "",
          sourcefield: "",
          targetfield: ""
        };
        let existingMapping = jsonDataFromOppSetting.filter(
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
          jsonDataFromOppSetting.push(fieldMapping);
        } else if (fld.dataset.fieldRel === "target") {
          fieldMapping.targetfield = fld.value;
        }
      });
      return jsonDataFromOppSetting;
    }
    // Return null if no other conditions are met
    return null;
  }

  // Method to show toast message
  showToast(title, message, variant) {
    const evt = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(evt);
  }
  closeErrorPopup() {
    this.hasError = false;
  }
}