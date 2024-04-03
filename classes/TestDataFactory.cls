/***************************************************************************************
 * @description       : This Class is Test Data Factory For Data
 * @author            : Nitesh Lande - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : CoreSettingControllerTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public with sharing class TestDataFactory {
    /**
    * @description       : This Method Create Account Data   
    * @param             : No Param
    * @return            : accountlist
    **/
    public static List<Account> createAccount(){    
        List<Account> accountlist = new List<Account>();
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        objAccount.AnnualRevenue = 777777777;        
        accountlist.add(objAccount);       
        return accountlist;
    }
    /**
    * @description       : This Method Create Opportunity Data   
    * @param             : List<Account> accountlist
    * @return            : opplist
    **/
    public static List<Opportunity> createOpportunity(List<Account> accountlist){    
        List<Opportunity> opplist = new List<Opportunity>();
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'TestOpp1';
        objOpportunity.AccountId = accountlist.get(0).Id;  
        objOpportunity.StageName = 'Prospecting';
        objOpportunity.StageName = 'Prospecting';
        objOpportunity.Description = 'Description for testing';
        objOpportunity.CloseDate = Date.newInstance(2023, 1, 1);
        opplist.add(objOpportunity);      
        return opplist;
    }  
    /**
    * @description       : This Method Create Opportunity Line Data   
    * @param             : List<Opportunity> opportunitylist,List<Product2> productList,,List<PricebookEntry> pbEntryList
    * @return            : qlinelist
    **/
    public static List<OpportunityLineItem> createOpportunityLines(List<Opportunity> opportunitylist
                                                                    ,List<Product2> productList
                                                                    ,List<PricebookEntry> pbEntryList){      
        List<OpportunityLineItem> oppLinelist = new List<OpportunityLineItem>();   
        //Create Quotelines
        OpportunityLineItem oppLineItem1 = new OpportunityLineItem();                                              
        oppLineItem1.OpportunityId = opportunitylist.get(0).Id;
        oppLineItem1.PricebookEntryId = pbEntryList.get(0).Id;
        oppLineItem1.UnitPrice = 7000;
        oppLineItem1.Quantity = 5;                                                        
        oppLinelist.add(oppLineItem1);
        
        OpportunityLineItem oppLineItem2 = new OpportunityLineItem();
        oppLineItem2.OpportunityId = opportunitylist.get(0).Id;
        oppLineItem2.PricebookEntryId = pbEntryList.get(0).Id;
        oppLineItem2.UnitPrice = 7000;
        oppLineItem2.Quantity = 5;                                                        
        oppLinelist.add(oppLineItem2); 
                                                                
        return oppLinelist;
    }
    /**
    * @description       : This Method get standard PricebookId   
    * @param             : No Param
    * @return            : Id pricebookId
    **/
    public static Id pricebookId = Test.getStandardPricebookId();
    /**
    * @description       : This Method Create Product Data   
    * @param             : No Param
    * @return            : productList
    **/
    public static  List<Product2> createProducts(){    
        List<Product2> productList = new List<Product2>();        
        Product2 pro1 = new Product2(Name ='Test Data Factory Product 1',ProductCode ='FACTORY PRODUCT-1'
                                    ,IsActive =True ,SBQQ__SubscriptionPricing__c ='Fixed Price',SBQQ__SubscriptionTerm__c=12);
        Product2 pro2 = new Product2(Name ='Test Data Factory Product 2',ProductCode ='FACTORY PRODUCT-2'
                                    ,IsActive =True ,SBQQ__SubscriptionPricing__c ='Fixed Price',SBQQ__SubscriptionTerm__c=6);
        Product2 pro3 = new Product2(Name ='Test Data Factory Product 3',ProductCode ='FACTORY PRODUCT-3'
                                    ,IsActive =True ,SBQQ__SubscriptionPricing__c ='Fixed Price',SBQQ__SubscriptionTerm__c=1);
        productList.add(pro1);
        productList.add(pro2);
        productList.add(pro3);        
        return productList;
    }
    /**
    * @description       : This Method Create PriceBookEntry Data   
    * @param             : No Param
    * @return            : pbEntryList
    **/
    public static  List<PricebookEntry> createPricebookEntry(List<Product2> productList){    
       List<PricebookEntry> pbEntryList = new List <PricebookEntry>();        
       // Create Price book entry
       PricebookEntry pbEntry1 = new PricebookEntry(IsActive = true, UnitPrice = 1000
                                                    , Product2Id = productList.get(0).Id, Pricebook2Id = pricebookId);
       PricebookEntry pbEntry2 = new PricebookEntry(IsActive = true, UnitPrice = 2000
                                                    , Product2Id = productList.get(1).Id, Pricebook2Id = pricebookId);
       PricebookEntry pbEntry3 = new PricebookEntry(IsActive = true, UnitPrice = 3000
                                                    , Product2Id = productList.get(2).Id, Pricebook2Id = pricebookId);
       pbEntryList.add(pbEntry1);
       pbEntryList.add(pbEntry2);
       pbEntryList.add(pbEntry3);       
        return pbEntryList;
    }
    /**
    * @description       : This Method Create Pricebook Data   
    * @param             : No Param
    * @return            : pbList
    **/
    public static List<Pricebook2> createPricebook(){    
        List<Pricebook2> pbList = new List <Pricebook2>();      
        Pricebook2 pbook = new Pricebook2(Name ='Custom Price Book', IsActive = true);
        pbList.add(pbook);       
        return pbList;
    }
    /**
    * @description       : This Method Create Quote Data   
    * @param             : List<Opportunity> opplist
    * @return            : quotelist
    **/
    public static List<SBQQ__Quote__c> createQuote(List<Opportunity> opplist){    
        List<SBQQ__Quote__c> quotelist = new List<SBQQ__Quote__c>();
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Opportunity2__c = opplist.get(0).Id;
        quote.SBQQ__Account__c      = opplist.get(0).AccountId;                        
        quote.SBQQ__StartDate__c    = Date.newInstance(2023, 1, 1);
        quote.SBQQ__EndDate__c      = Date.newInstance(2024, 12, 31);
        quote.SBQQ__Status__c       = 'Draft';
        quote.SBQQ__Type__c         = 'Quote';
        quote.SBQQ__Primary__c      = true;
        quote.SBQQ__PriceBook__c    = pricebookId;            
        quotelist.add(quote);        
        return quotelist;
    }
    /**
    * @description       : This Method Create Quote Line Data   
    * @param             : List<SBQQ__Quote__c> quotelist,List<Product2> productList,,List<PricebookEntry> pbEntryList
    * @return            : qlinelist
    **/
    public static List<SBQQ__QuoteLine__c> createquoteLines(List<SBQQ__Quote__c> quotelist,List<Product2> productList
                                                            ,List<PricebookEntry> pbEntryList){      
        List<SBQQ__QuoteLine__c> qlinelist = new List<SBQQ__QuoteLine__c>();   
        //Create Quotelines
        SBQQ__QuoteLine__c qline1 = new SBQQ__QuoteLine__c();
        qline1.SBQQ__Quote__c = quotelist.get(0).Id;
        qline1.SBQQ__StartDate__c = Date.newInstance(2023, 04, 01);
        qline1.SBQQ__EndDate__c = Date.newInstance(2025, 03, 31);
        qline1.SBQQ__Quantity__c = 1;
        qline1.SBQQ__Product__c = productList.get(0).Id;
        qline1.SBQQ__DefaultSubscriptionTerm__c = productList.get(0).SBQQ__SubscriptionTerm__c;
        qline1.SBQQ__ListPrice__c = 1000;
        qline1.SBQQ__PricebookEntryId__c = pbEntryList.get(0).id;
        qline1.SBQQ__Existing__c = false;
        qline1.SBQQ__CarryoverLine__c = false;
        qline1.SBQQ__SubscriptionPricing__c ='Fixed Price';
        qlinelist.add(qline1);
        
        SBQQ__QuoteLine__c qline2 = new SBQQ__QuoteLine__c();
        qline2.SBQQ__Quote__c = quotelist.get(0).Id;
        qline2.SBQQ__StartDate__c = Date.newInstance(2023, 04, 01);
        qline2.SBQQ__EndDate__c = Date.newInstance(2025, 03, 31);
        qline2.SBQQ__Quantity__c = 1;
        qline2.SBQQ__Product__c = productList.get(1).Id;
        qline2.SBQQ__DefaultSubscriptionTerm__c = productList.get(1).SBQQ__SubscriptionTerm__c;
        qline2.SBQQ__ListPrice__c = 2000;
        qline2.SBQQ__PricebookEntryId__c = pbEntryList.get(1).id;
        qline2.SBQQ__Existing__c = false;
        qline2.SBQQ__CarryoverLine__c = false;
        qline1.SBQQ__SubscriptionPricing__c ='Fixed Price';
        qlinelist.add(qline2);
       
        return qlinelist;
    }   
    /**
    * @description       : This Method Create Order Data   
    * @param             : List<SBQQ__Quote__c> quotelist
    * @return            : orderlist
    **/    
    public static List<Order> createOrder(List<SBQQ__Quote__c> quotelist){
        List<Order> orderlist = new List<Order>();
        Order objOrder = new Order();
        objOrder.AccountId = quotelist[0].SBQQ__Account__c;
        objOrder.OpportunityId = quotelist[0].SBQQ__Opportunity2__c;
        objOrder.SBQQ__Quote__c = quotelist[0].Id;
        objOrder.EffectiveDate = Date.newInstance(2023, 1, 1);
        objOrder.EndDate = null;
        objOrder.Status = 'Draft';                        
        objOrder.Pricebook2Id = quotelist[0].SBQQ__PriceBook__c;            
        orderlist.add(objOrder);       
        return orderlist;        
    }
    /**
    * @description       : This Method Create Order Product Data   
    * @param             : List<SBQQ__Quote__c> quotelist
    * @return            : orderlist
    **/
    public static List<OrderItem> createOrderProductLines(List<Order> orderlist,List<SBQQ__QuoteLine__c> qlinelist){        
        List<OrderItem> orderProductlist = new List<OrderItem>();
        OrderItem orderprodline1 = new OrderItem();
        orderprodline1.OrderId = orderlist[0].Id;
        orderprodline1.SBQQ__Status__c = 'Draft';
        orderprodline1.SBQQ__QuoteLine__c = qlinelist[0].Id;
        orderprodline1.ServiceDate = Date.newInstance(2023, 06, 5);
        orderprodline1.EndDate = Date.newInstance(2025, 05, 31);        
        orderprodline1.Quantity = 1;
        orderprodline1.Product2Id = qlinelist[0].SBQQ__Product__c;
        orderprodline1.SBQQ__DefaultSubscriptionTerm__c = qlinelist[0].SBQQ__DefaultSubscriptionTerm__c;
        orderprodline1.UnitPrice=1000;        
        orderprodline1.PricebookEntryId = qlinelist[0].SBQQ__PricebookEntryId__c;        
        orderProductlist.add(orderprodline1);
        
        OrderItem orderprodline2 = new OrderItem();
        orderprodline2.OrderId = orderlist[0].Id;
        orderprodline2.SBQQ__Status__c = 'Draft';
        orderprodline2.SBQQ__QuoteLine__c = qlinelist[1].Id;
        orderprodline2.ServiceDate = Date.newInstance(2023, 06, 01);
        orderprodline2.EndDate = Date.newInstance(2028, 5, 18);        
        orderprodline2.Quantity = 1;
        orderprodline2.Product2Id = qlinelist[1].SBQQ__Product__c;
        orderprodline2.SBQQ__DefaultSubscriptionTerm__c = qlinelist[1].SBQQ__DefaultSubscriptionTerm__c;
        orderprodline2.UnitPrice=1000;                 
        orderprodline2.PricebookEntryId =qlinelist[1].SBQQ__PricebookEntryId__c;        
        orderProductlist.add(orderprodline2);       
        return orderProductlist ;
    }
    /*
    public static List<Revenue_Detail__c> createRevenueDetailsRecord(List<Order> orderlist, List<Product2> productList){
        List<Revenue_Detail__c> revDetail = new List<Revenue_Detail__c>();
        Revenue_Detail__c rd = new Revenue_Detail__c();
        revDetail.add(rd);
          return   revDetail;
    }*/
    
    /**
     * This method instantiates a custom metadata record of type App_Configuration__mdt
     * and sets the Choose_Object__c to 'Order'.
     * The record is not inserted into the database,
     */
    public static App_Configuration__mdt getCustomMetadataRecord() {        
        App_Configuration__mdt appConfig = new App_Configuration__mdt(); 
        appConfig.NamespacePrefix = 'Default';
        appConfig.DeveloperName = 'Default';
        appConfig.Auto_Select_Master_Contract__c = true;
        appConfig.Generate_New_Amendment_Opportunity__c = true;
        appConfig.Generate_New_Renewal_Opportunity__c = true;
        appConfig.Maintain_QuoteLine_Groups__c = true;
        appConfig.Quote_Stage__c = 'Approved';
        return appConfig;
    } 
    /**
     * This method instantiates a custom metadata record of type App_Configuration__mdt
     * and sets the Choose_Object__c to 'Opportunity'.
     * The record is not inserted into the database,
     */
    public static App_Configuration__mdt getCustomMetadataRecordForOppTrigger() {        
        App_Configuration__mdt appConfig = new App_Configuration__mdt(); 
        appConfig.NamespacePrefix = 'Default';
        appConfig.DeveloperName = 'Default';
        appConfig.Auto_Select_Master_Contract__c = true;
        appConfig.Generate_New_Amendment_Opportunity__c = true;
        appConfig.Generate_New_Renewal_Opportunity__c = true;
        appConfig.Maintain_QuoteLine_Groups__c = true;
        appConfig.Quote_Stage__c = 'Approved';
        return appConfig;
    }
    /**
     * This method is use to access custom metadata to cover AdditionSettingTest
     * class.
     * The record is not inserted into the database,
    */
    public static App_Configuration__mdt createAppConfigRecord() {
        App_Configuration__mdt appConfig = new App_Configuration__mdt(
            DeveloperName = 'Default',
            Auto_Select_Master_Contract__c = true,
            Generate_New_Amendment_Opportunity__c = true,
            Generate_New_Renewal_Opportunity__c = true,
            Maintain_QuoteLine_Groups__c = true);
        return appConfig;
    }
    public static App_Configuration__mdt getAppConfigRecord(String developerName) {
        return [SELECT Id, DeveloperName, MasterLabel,
                Auto_Select_Master_Contract__c ,
                Generate_New_Amendment_Opportunity__c ,
                Generate_New_Renewal_Opportunity__c ,
                Maintain_QuoteLine_Groups__c  
                FROM App_Configuration__mdt
                WHERE DeveloperName = :developerName WITH SECURITY_ENFORCED LIMIT 1];
    }
    public static Map<String, Object> getValidJsonDataForQuote() {
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('isAutoSelectMasterContract', true);
        jsonMap.put('isGenerateNewAmendmentOpportunity', true);
        jsonMap.put('isGenerateNewRenewalOpportunity', true);
        jsonMap.put('isMaintainQuoteLineGroup', true);
        return jsonMap;
    }
    public static Map<String, Object> createAppConfigNullRecord() {
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('isAutoSelectMasterContract', null);
        jsonMap.put('isGenerateNewAmendmentOpportunity', null);
        jsonMap.put('isGenerateNewRenewalOpportunity', null);
        jsonMap.put('isMaintainQuoteLineGroup', null);
        return jsonMap;
    }
}
