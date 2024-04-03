trigger QuotelineTrigger on SBQQ__QuoteLine__c (After insert) {
    if (Trigger.isAfter && Trigger.isInsert) {        
        QuoteLineTriggerHandler.afterInsert(Trigger.New);
    }
}