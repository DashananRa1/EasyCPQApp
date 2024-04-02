/***************************************************************************************
 * @description       : This Test class implements the InstallHandler interface to execute specific actions during the installation or upgrade of the package.
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
@isTest
public class PostDeploymentClassTest {
  @isTest
  static void testInstallScript() {
    PostDeploymentClass postinstall = new PostDeploymentClass();
    Test.testInstall(postinstall, null);
    Test.testInstall(postinstall, new Version(1, 0), true);
    SBQQ__CustomAction__c rec = [
      SELECT id, Name
      FROM SBQQ__CustomAction__c
      WHERE name = 'All Subscription And Asset'
      LIMIT 1
    ];
    System.assertEquals('All Subscription And Asset', rec.Name, 'result');
  }
}