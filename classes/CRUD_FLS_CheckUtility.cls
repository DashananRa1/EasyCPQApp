/***************************************************************************************
 * @description       : This Class is Used to check CRUD and FLS security
 * @author            : Nitesh Lande - Bluvium
 * @group             : Ashwini Singh - Sr.Solution Architect
                      : Rahul Deshmukh - Business Analyst
                      : Kavita Kore - Technical Lead
                      : Amit Aher - Sr.Salesforce Developer
                      : Roshan Jambhule - Salesforce Developer
                      : Nitesh Lande - Salesforce Developer
                      : Ankita Varma - Tech Assistant
 * @test class        : CRUD_FLS_CheckUtilityTest
 * @created Date      : 09-21-2023
 * @last modified on  : 12-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
****************************************************************************************/
public with sharing class CRUD_FLS_CheckUtility {
  /**
   * @description : Class to check read access
   * @param fieldsToRead
   * @param m
   * @return Boolean
   */
  public static Boolean checkReadAccess(
    String[] fieldsToRead,
    Map<String, Schema.SObjectField> m
  ) {
    for (String toRead : fieldsToRead) {
      // Check if the user has read access on the each field
      if (!m.get(toRead).getDescribe().isAccessible()) {
        return false;
      }
    }
    return true;
  }
  /**
   * @description : Class to check create access
   * @param fieldsToCreate
   * @param m
   * @return Boolean
   */
  public static Boolean checkCreateAccess(
    String[] fieldsToCreate,
    Map<String, Schema.SObjectField> m
  ) {
    for (String toCreate : fieldsToCreate) {
      // Check if the user has create access on the each field
      if (!m.get(toCreate).getDescribe().isCreateable()) {
        return false;
      }
    }
    return true;
  }
  /**
   * @description : Class to check update access
   * @param fieldsToUpdate
   * @param m
   * @return Boolean
   */
  public static Boolean checkUpdateAccess(
    Set<String> fieldsToUpdate,
    Map<String, Schema.SObjectField> m
  ) {
    for (String toUpdate : fieldsToUpdate) {
      // Check if the user has update access on the each field
      if (!m.get(toUpdate).getDescribe().isUpdateable()) {
        return false;
      }
    }
    return true;
  }
  /**
   * @description : Class to check delete access
   * @param m
   * @return Boolean
   */
  public static Boolean checkDeleteAccess(Schema.DescribeSObjectResult m) {
    return m.isDeletable();
  }
}