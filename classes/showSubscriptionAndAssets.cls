public with sharing class showSubscriptionAndAssets {
     string id {get;set;}

    public showSubscriptionAndAssets(ApexPages.StandardController controller) {
       this.id=ApexPages.CurrentPage().getparameters().get('id');
    }

}