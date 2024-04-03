/**
 * @description       : Test Class For CRUD_FLS_CheckUtility 
 * @author            : Kavita Kore - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @Created Date      : 12-22-2023
 * @last modified on  : 01-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/

@isTest
private class CRUD_FLS_CheckUtilityTest {
  /**
   * @description: This test class validates CRUD access control mechanisms using CRUD_FLS_CheckUtility methods for a test Account object.
   * @author: Nitesh Lande- Bluvium
   */

  @isTest
  static void testCRUDAccess() {
    // Create a test SObject and its fields
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;

    // Get the SObject fields map
    Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Account.fields.getMap();

    // Test read access
    String[] readFields = new List<String>{ 'Name', 'Industry' };
    System.assert(
      CRUD_FLS_CheckUtility.checkReadAccess(readFields, fieldsMap),
      'Assert Failed'
    );

    // Test create access
    String[] createFields = new List<String>{ 'Name', 'Industry' };
    System.assert(
      CRUD_FLS_CheckUtility.checkCreateAccess(createFields, fieldsMap),
      'Assert Failed'
    );

    // Test update access
    String[] updateFields = new List<String>{ 'Name' };
    Set<String> customFields = new Set<string>();
    customFields.addAll(updateFields);
    System.assert(
      CRUD_FLS_CheckUtility.checkUpdateAccess(customFields, fieldsMap),
      'Assert Failed'
    );

    // Test delete access
    String objectTypeName = 'Account'; // Replace with your SObject type
    Schema.SObjectType objectType = Schema.getGlobalDescribe()
      .get(objectTypeName);
    Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
    //Schema.DescribeSObjectResult describeResult = Account.SObjectType.getDescribe();
    System.assert(
      CRUD_FLS_CheckUtility.checkDeleteAccess(describeResult),
      'Assert Failed'
    );

    Profile p = [SELECT Id FROM Profile WHERE Name = 'CPQ Integration User'];
    User gov = new User(
      ProfileId = p.Id,
      Username = 'govuser@example.com',
      Email = 'testuser@example.com',
      Alias = 'govuser',
      EmailEncodingKey = 'UTF-8',
      LastName = 'gov',
      FirstName = 'User',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'America/Los_Angeles'
    );

    System.runAs(gov) {
      // The following code runs as user 'gov'
      System.assertEquals(
        false,
        CRUD_FLS_CheckUtility.checkCreateAccess(createFields, fieldsMap),
        'Assertion Failed'
      );
      System.assertEquals(
        false,
        CRUD_FLS_CheckUtility.checkUpdateAccess(customFields, fieldsMap),
        'Assertion Failed'
      );
    }
  }
}