/************************************************************************************************
  @description       :newQuoteCopy Component is use for Mapping the data from Account, Opportunity and 
                      Quote to Fresh Quote and Fresh Opportunity when new Quote is created.
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
 *************************************************************************************************/
import { LightningElement, api, track } from "lwc";
import getQuoteFields from "@salesforce/apex/NewQuoteSettingController.getQuoteFields";
import setQuoteFields from "@salesforce/apex/NewQuoteSettingController.setQuoteFields";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class NewQuoteCopy extends NavigationMixin(LightningElement) {
  @track showModal = true;
  showSpinner = true;
  quoteFieldDataFromOpp = [];
  quoteFieldDataFromAcc = [];
  quoteFieldDataFromQuote = [];
  @track originalOpportunityField = [];
  @track accountFields = [];
  @track originalQuoteFields = [];
  @api quoteFieldsList;
  @api accountFieldsList;
  @api opportunityFieldsList;
  quoteFieldData = [];
  oppFieldData = [];
  accountFieldData = [];
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
    this.quoteFieldsList.forEach((fld) => {
      if (fld.createable && !this.excludeQuoteFields.includes(fld.value)) {
        this.quoteFieldData.push(fld);
      }
    });
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
  }
  showToastMessage(msg = undefined, variant = "") {
    const event = new ShowToastEvent({
      title: msg,
      variant: variant,
      mode: "dismissable"
    });
    this.dispatchEvent(event);
  }  
  getQuoteFieldSetup() {
    getQuoteFields()
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
          "There is no Field Mapping found for New Quote" + error.message,
          "error",
          "error"
        );
        console.log("error from catch block:-> ", error);
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }
  // mapping of value to new Quote
  handleChangeQuote(event) {
    const selectedIndex = Number(event.target.dataset.fieldIndex);
    const selectedObject = event.target.dataset.objectName;
    const selectedValue = event.target.value;
    const selectedRelation = event.target.dataset.fieldRel;
    try {
      if (selectedObject === "OriginalOpportunity") {
        let cloneOriginalOppotunityFields = JSON.parse(
          JSON.stringify(this.originalOpportunityField)
        );
        cloneOriginalOppotunityFields.forEach((fld) => {
          if (fld.index === selectedIndex) {
            this.selectedSearchIndex = selectedIndex;
            let selectedOpt;
            if (selectedRelation === "source") {
              selectedOpt = this.quoteFieldData.filter((opt) => {
                if (opt.value === selectedValue) {
                  this.selectedSearchValue = selectedValue;
                  return opt;
                }
                return false; 
              });
              if (selectedOpt && selectedOpt.length > 0) {
                fld.datatype = selectedOpt[0].datatype;
                fld.sourcefield = selectedOpt[0].value;
                fld.label = selectedOpt[0].label;
                fld.value = selectedOpt[0].value;
                fld.name = selectedOpt[0].name;
                fld.targetfield = "";
              }
            } else if (selectedRelation === "target") {
              selectedOpt = this.oppFieldData.filter((opt) => {
                if (opt.value === selectedValue) {
                  this.selectedSearchValue = selectedValue;
                  return opt;
                }
                return false;
              });
              if (selectedOpt && selectedOpt.length > 0) {
                fld.targetdatatype = selectedOpt[0].datatype;
                fld.targetlabel = selectedOpt[0].label;
                fld.targetvalue = selectedOpt[0].value;
                fld.targetname = selectedOpt[0].name;
                fld.targetfield = selectedOpt[0].value;
              }
              if (!fld.datatype && fld.sourcefield) {
                let selectedOpt2 = this.quoteFieldData.filter((opt) => {
                  if (opt.value === fld.sourcefield) {
                    return opt;
                  }
                  return false; 
                });
                if (selectedOpt2 && selectedOpt2.length > 0) {
                  fld.datatype = selectedOpt2[0].datatype;
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
        this.originalOpportunityField = cloneOriginalOppotunityFields;
      } else if (selectedObject === "Account") {
        let cloneOriginalAccountFields = JSON.parse(
          JSON.stringify(this.accountFields)
        );
        cloneOriginalAccountFields.forEach((fld) => {
          if (fld.index === selectedIndex) {
            this.selectedSearchIndex = selectedIndex;
            let selectedOpt;
            if (selectedRelation === "source") {
              selectedOpt = this.quoteFieldData.filter((opt) => {
                if (opt.value === selectedValue) {
                  this.selectedSearchValue = selectedValue;
                  return opt;
                }
                return false; 
              });
              if (selectedOpt && selectedOpt.length > 0) {
                fld.datatype = selectedOpt[0].datatype;
                fld.sourcefield = selectedOpt[0].value;
                fld.label = selectedOpt[0].label;
                fld.value = selectedOpt[0].value;
                fld.name = selectedOpt[0].name;
                fld.targetfield = "";
              }
            } else if (selectedRelation === "target") {
              console.log("Target");
              selectedOpt = this.accountFieldData.filter((opt) => {
                if (opt.value === selectedValue) {
                  this.selectedSearchValue = selectedValue;
                  return opt;
                }
                return false; 
              });
              if (selectedOpt && selectedOpt.length > 0) {
                fld.targetdatatype = selectedOpt[0].datatype;
                fld.targetlabel = selectedOpt[0].label;
                fld.targetvalue = selectedOpt[0].value;
                fld.targetname = selectedOpt[0].name;
                fld.targetfield = selectedOpt[0].value;
              }
              if (!fld.datatype && fld.sourcefield) {
                let selectedOpt2 = this.quoteFieldData.filter((opt) => {
                  if (opt.value === fld.sourcefield) {
                    return opt;
                  }
                  return false; 
                });
                if (selectedOpt2 && selectedOpt2.length > 0) {
                  fld.datatype = selectedOpt2[0].datatype;
                }
              }
              if (
                fld.datatype &&
                !this.allowedMappings[fld.datatype].includes(fld.targetdatatype)
              ) {
                event.target.setCustomValidity(
                  "Invalid field selection for mapping. Data type not Compatible"
                );
                event.target.blur();
              } else {
                event.target.setCustomValidity("");
                event.target.blur();
              }
            }
            
          }
        });
        this.accountFields = cloneOriginalAccountFields;
      } else if (selectedObject === "OriginalQuote") {
        let cloneOriginalQuoteFields = JSON.parse(
          JSON.stringify(this.originalQuoteFields)
        );
        cloneOriginalQuoteFields.forEach((fld) => {
          if (fld.index == selectedIndex) {
            this.selectedSearchIndex = selectedIndex;
            let selectedOpt = this.quoteFieldData.filter(
              (opt) => opt.value === selectedValue
            );
            if (selectedOpt && selectedOpt.length > 0) {
              fld.datatype = selectedOpt[0].datatype;
              fld.sourcefield = selectedOpt[0].value;
              fld.label = selectedOpt[0].label;
              fld.value = selectedOpt[0].value;
              fld.name = selectedOpt[0].name;
              fld.targetfield = "";
            }            
            return selectedOpt.length > 0;
          }
          return undefined;
        });
        this.originalQuoteFields = cloneOriginalQuoteFields;        
      }
    } catch (Ex) {
      console.log("Error:::", Ex);
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
  // delete function for quote tab
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

  closeErrorPopup() {
    this.hasError = false;
  }
  // to update input data to custom metadata
  newQuoteHandleSave() {
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
      this.showToastMessage(Ex.message, "error", "error");
      return false;
    }
    let userQuoteFields = this.template.querySelectorAll("[data-id]");
    let jsonDataFromQuoteSetting = [];
    jsonDataFromQuoteSetting = [
      ...JSON.parse(JSON.stringify(this.accountFields)),
      ...JSON.parse(JSON.stringify(this.originalOpportunityField)),
      ...JSON.parse(JSON.stringify(this.originalQuoteFields))
    ];
    if (userQuoteFields && userQuoteFields.length > 0) {
      userQuoteFields.forEach((fld) => {
        let fieldMapping = {
          index: "",
          objectName: "",
          sourcefield: "",
          targetfield: "",
          name: ""
        };
        let fieldIndex = Number(fld.dataset.fieldIndex);
        let existingMapping = jsonDataFromQuoteSetting.filter(
          (fldMap) =>
            (fldMap.index === fieldIndex ||
              fldMap.index === fld.dataset.fieldIndex) &&
            fldMap.objectName === fld.dataset.objectName
        );
        if (existingMapping.length === 0) {
          fieldMapping.index = fld.dataset.fieldIndex;
          fieldMapping.objectName = fld.dataset.objectName;
          jsonDataFromQuoteSetting.push(fieldMapping);
        } else {
          fieldMapping = existingMapping[0];
        }
        if (fld.dataset.fieldRel === "source") {
          fieldMapping.sourcefield = fld.value;
        } else if (fld.dataset.fieldRel === "target") {
          fieldMapping.targetfield = fld.value;
          fieldMapping.name = fld.name;
        }
      });
    }    
    setQuoteFields({
      jsonStr: JSON.stringify(jsonDataFromQuoteSetting)
    })
      .then((result) => {
        if (result.startsWith("jobId:")) {
          location.reload(true);
          this.showToastMessage(
            "New Quote data saved successfully...",
            "success",
            "success"
          );
        }
        this.showSpinner = true;
      })
      .catch((error) => {
        this.showToastMessage(
          "There is no Field Mapping found for New Quote Record" +
            error.message,
          "Error",
          "Error"
        );
      })
      .finally(() => {
        this.showSpinner = false;
      });   
    return true;
  }

  handleModalClose() {
    this.showModal = false;
    location.reload(true);
  }
}