/*************************************************************************
* @description       : Apex class to manage Custom Metadata record update
* @author            : Amit Aher - Bluvium
* @group             : Ashwini Singh - Sr.Solution Architect
                     : Rahul Deshmukh - Business Analyst
                     : Kavita Kore - Technical Lead
                     : Amit Aher - Sr.Salesforce Developer
                     : Roshan Jambhule - Salesforce Developer
                     : Nitesh Lande - Salesforce Developer
                     : Ankita varma - Tech Assistant
* @test class        : EasyCpqMdtMngrTest
* @last modified on  : 12-05-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
***************************************************************************/
@isTest
public class EasyCpqMdtMngrTest {
  /**
   * @description: This test method validates the functionality of upserting metadata records using the EasyCpqMdtMngr class.
   *              It verifies that the metadata deployment job ID is not null after the upsert operation.
   * @author: Amit Aher - Bluvium
   */
  @isTest
  public static void upsertMetadataTest() {
    Test.startTest();
    App_Configuration__mdt appConfigMdt = TestDataFactory.getAppConfigRecord(
      'Default'
    );
    String jobId = EasyCpqMdtMngr.upsertMetadata(
      new List<App_Configuration__mdt>{
        new App_Configuration__mdt(
          Id = appConfigMdt.Id,
          DeveloperName = appConfigMdt.DeveloperName,
          MasterLabel = appConfigMdt.MasterLabel
        )
      }
    );
    Test.stopTest();
    System.assertNotEquals(
      null,
      jobId,
      'Metadata deployment job ID should not be null.'
    );
  }
  /**
   * @description: This method tests the handleResult method of the Metadata.DeployCallback interface implemented
   *               by the EasyCpqMdtMngr class. It simulates the deployment result of custom metadata and verifies the behavior of the handleResult method under different scenarios.
   * @author: Amit Aher - Bluvium
   * @return: void
   */

  @isTest
  static void handleCallbackTest() {
    // Instantiate the callback.
    Metadata.DeployCallback callback = new EasyCpqMdtMngr();
    // Create test result and context objects.
    Metadata.DeployResult result = new Metadata.DeployResult();
    result.status = Metadata.DeployStatus.Succeeded;
    Metadata.DeployMessage messageObj = new Metadata.DeployMessage();
    messageObj.changed = true;
    messageObj.success = true;
    messageObj.fullName = '';
    messageObj.componentType = 'CustomMetadata';
    messageObj.fullName = 'VAT_Rate.SreeVardhan3';
    Metadata.DeployDetails deployDetailsObj = new Metadata.DeployDetails();
    deployDetailsObj.componentSuccesses.add(messageObj);
    result.details = deployDetailsObj;
    Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();

    // Invoke the callback's handleResult method.
    callback.handleResult(result, context);
    System.assertEquals(
      true,
      EasyCpqMdtMngr.isMetadataUpdated,
      'Metadata deployment should be successful.'
    );

    // Test scenario where metadata deployment fails
    result.status = Metadata.DeployStatus.Failed;
    callback.handleResult(result, context);
    System.assertEquals(
      false,
      EasyCpqMdtMngr.isMetadataUpdated,
      'Metadata deployment should fail.'
    );
  }
  /**
   * @description: This test method provides additional coverage for utility methods by testing the parsing
   *               of custom metadata values into appropriate data types.
   * @author: Roshan Jambhule- Bluvium
   */

  @isTest
  static void additionalTestCoverage() {
    // Additional test coverage for utility methods
    Test.startTest();
    try {
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.DateTime,
        String.valueOf(System.now())
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Percent,
        '0'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Double,
        '0'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Integer,
        '1'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.Base64,
        'dGVzdA=='
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.String,
        'Test'
      );
      EasyCpqMdtMngr.parseValue(
        new Metadata.CustomMetadataValue(),
        Schema.DisplayType.DateTime,
        'Error'
      );
    } catch (Exception ex) {
      System.assert(false, 'Exception should not be thrown during parsing.');
    }
    Test.stopTest();
  }
}
