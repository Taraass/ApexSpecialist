@isTest
public with sharing class MaintenanceRequestHelperTest {

    @TestSetup
    static void makeData(){
        List<Case> cases = TestUtils.createCase();
        insert cases;
        List<Product2> eq = TestUtils.createEquipment();
        insert eq;
        List<Equipment_Maintenance_Item__c> query = TestUtils.createEqMaintenance(cases, eq);
        insert query;
    } 

    @isTest
    public static void MaintenanceRequestTriggerTestPositive() {
        Test.startTest();
        TestUtils.maintenanceRequestTriggerUpdateData('Repair', 'Routine Maintenance');
        Test.stopTest();
        List<Case> newValidCases = [SELECT Id FROM Case WHERE Status = 'Closed' AND (Type = 'Repair' OR Type = 'Routine Maintenance')];
        List<Equipment_Maintenance_Item__c> validEqMain = [SELECT ID FROM Equipment_Maintenance_Item__c];
        System.assertEquals(300, newValidCases.size(), 'There are more than 0 records as expected!');
    }
    @isTest
    public static void MaintenanceRequestTriggerTestNegative() {
        Test.startTest();
        TestUtils.maintenanceRequestTriggerUpdateData('Electrical', 'Electornic');
        Test.stopTest();
        List<Case> newValidCases = [SELECT Id FROM Case WHERE Status = 'Closed' AND (Type = 'Repair' OR Type = 'Routine Maintenance')];
        System.assertEquals(0, newValidCases.size(), 'The list is not 0 records as expected!');
    }

    @isTest
    public static void createEquipmentMaintenanceItemsTest(){
        TestUtils.maintenanceRequestTriggerUpdateData('Repair', 'Routine Maintenance');
        List<Case> newValidCases = [SELECT Id, OldId__c FROM Case WHERE Status = 'Closed' AND (Type = 'Repair' OR Type = 'Routine Maintenance')];
        Test.startTest();
        MaintenanceRequestHelper.createEquipmentMaintenanceItems(newValidCases);
        Test.stopTest();
        List<Equipment_Maintenance_Item__c> newEqMain = [SELECT Id FROM Equipment_Maintenance_Item__c];
        System.assertEquals(1800, newEqMain.size(), 'The amount of Equipment Maintenance is incorrect');
    }

    @isTest
    public static void getMaintenanceCycleTest(){
        List<Case> caseList = [SELECT Id FROM Case];
        Test.startTest();
        MaintenanceRequestHelper.getMaintenanceCycle(caseList);
        Test.stopTest();
        AggregateResult[] result = [SELECT MIN(Maintenance_Cycle__c) cycle FROM Product2];
        System.assertEquals(6, result[0].get('cycle'), 'The minimum of cycle is wrong');
    }
}