/***************************************************************************************
 * @description       : This class implements the InstallHandler interface to execute specific actions during the installation or upgrade of the package.
 * @author            : Nitesh Lande - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : EasyCpqQueriesTest
 * @created Date      : 09-21-2023
 * @last modified on  : 03-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 ****************************************************************************************/
public class PostDeploymentClass implements InstallHandler {
  public void onInstall(InstallContext context) {
    if (context.previousVersion() == null) {
      SBQQ__CustomAction__c action = new SBQQ__CustomAction__c(
        Name = 'All Subscription And Asset',
        SBQQ__Active__c = true,
        SBQQ__BrandButton__c = false,
        SBQQ__ConditionsMet__c = 'All',
        SBQQ__Default__c = false,
        SBQQ__Description__c = 'All Subscription And Asset',
        SBQQ__DisplayOrder__c = 1,
        SBQQ__Label__c = 'All Subscription And Asset',
        SBQQ__Location__c = 'Quote',
        SBQQ__Page__c = 'Quote Line Editor',
        SBQQ__URLTarget__c = 'Popup',
        SBQQ__Type__c = 'Button',
        SBQQ__URL__c = '/apex/BECPQ__SubscriptionAndAsset?Id={!SBQQ__Quote__c.Id}'
      );
      insert action;
      User u = [SELECT Id, Email FROM User WHERE Id = :context.installerID()];
      String toAddress = u.Email;
      String[] toAddresses = new List<String>{ toAddress };
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setReplyTo('support@package.dev');
      mail.setSenderDisplayName('My Package Support');
      mail.setSubject('Package install successful');
      mail.setPlainTextBody('Thanks for installing the package.');
      Messaging.sendEmail(new List<Messaging.Email>{ mail });
    } else if (context.previousVersion().compareTo(new Version(1, 0)) == 0) {
      SBQQ__CustomAction__c action = new SBQQ__CustomAction__c(
        Name = 'All Subscription And Asset',
        SBQQ__Active__c = true,
        SBQQ__BrandButton__c = false,
        SBQQ__ConditionsMet__c = 'All',
        SBQQ__Default__c = false,
        SBQQ__Description__c = 'All Subscription And Asset',
        SBQQ__DisplayOrder__c = 1,
        SBQQ__Label__c = 'All Subscription And Asset',
        SBQQ__Location__c = 'Quote',
        SBQQ__Page__c = 'Quote Line Editor',
        SBQQ__URLTarget__c = 'Popup',
        SBQQ__Type__c = 'Button',
        SBQQ__URL__c = '/apex/BECPQ__SubscriptionAndAsset?Id={!SBQQ__Quote__c.Id}'
      );
      insert action;
    }
    if (context.isUpgrade()) {
      SBQQ__CustomAction__c action = new SBQQ__CustomAction__c(
        Name = 'All Subscription And Asset',
        SBQQ__Active__c = true,
        SBQQ__BrandButton__c = false,
        SBQQ__ConditionsMet__c = 'All',
        SBQQ__Default__c = false,
        SBQQ__Description__c = 'All Subscription And Asset',
        SBQQ__DisplayOrder__c = 1,
        SBQQ__Label__c = 'All Subscription And Asset',
        SBQQ__Location__c = 'Quote',
        SBQQ__Page__c = 'Quote Line Editor',
        SBQQ__URLTarget__c = 'Popup',
        SBQQ__Type__c = 'Button',
        SBQQ__URL__c = '/apex/BECPQ__SubscriptionAndAsset?Id={!SBQQ__Quote__c.Id}'
      );
      insert action;
    }
    if (context.isPush()) {
      SBQQ__CustomAction__c action = new SBQQ__CustomAction__c(
        Name = 'All Subscription And Asset',
        SBQQ__Active__c = true,
        SBQQ__BrandButton__c = false,
        SBQQ__ConditionsMet__c = 'All',
        SBQQ__Default__c = false,
        SBQQ__Description__c = 'All Subscription And Asset',
        SBQQ__DisplayOrder__c = 1,
        SBQQ__Label__c = 'All Subscription And Asset',
        SBQQ__Location__c = 'Quote',
        SBQQ__Page__c = 'Quote Line Editor',
        SBQQ__URLTarget__c = 'Popup',
        SBQQ__Type__c = 'Button',
        SBQQ__URL__c = '/apex/BECPQ__SubscriptionAndAsset?Id={!SBQQ__Quote__c.Id}'
      );
      insert action;
    }
  }
}