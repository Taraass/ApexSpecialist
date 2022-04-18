@isTest
public with sharing class TestUtils {

    public static void maintenanceRequestTriggerUpdateData(String caseType1, String caseType2) {
        List<Case> validCasesPositive = [SELECT Id FROM Case WHERE Status !=: 'Closed' AND (Type =: caseType1 OR Type =: caseType2)];
        List<Case> casesToUpdate = new List<Case>();
        for(Case c: validCasesPositive){
            c.Status = 'Closed';
            c.OldId__c = c.Id;
            casesToUpdate.add(c);
        }
        update casesToUpdate;
    }

    public static List<Case> createCase(){
        List<Case> caseList = new List<Case>();
        Vehicle__c vehicle = new Vehicle__c(Name = 'Vehicle1');
        insert vehicle;
        for(Integer i = 0; i < 150; i++) {
            Case cRepairType = new Case();
            cRepairType.Type = 'Repair';
            cRepairType.Origin = 'Web';
            cRepairType.Status = 'New';
            cRepairType.Vehicle__c = vehicle.Id;
            caseList.add(cRepairType);
            Case cRMType = new Case();
            cRMType.Type = 'Routine Maintenance';
            cRMType.Origin = 'Web';
            cRMType.Status = 'Working';
            cRMType.Vehicle__c = vehicle.Id;
            caseList.add(cRMType);
        }
        return caseList;
    }

    public static List<Product2> createEquipment(){
        List<Product2> equipmentList = new List<Product2>();
        for(Integer i = 0; i < 3; i++){
            Product2 equipment = new Product2();
            equipment.Name = 'Equipment ' + i;
            equipment.Maintenance_Cycle__c = (i+2)*3;
            equipment.Lifespan_Months__c = i;
            equipment.Replacement_Part__c = true;
            equipmentList.add(equipment);
        }
        return equipmentList;
    }

    public static List<Equipment_Maintenance_Item__c> createEqMaintenance(List<Case> caselist, List<Product2> equipmentList){
        List<Equipment_Maintenance_Item__c> eqMainList = new List<Equipment_Maintenance_Item__c>();
        for(Case c : caseList){
            for(Product2 eq : equipmentList) {
                Equipment_Maintenance_Item__c eqMain = new Equipment_Maintenance_Item__c();
                eqMain.Equipment__c	= eq.Id;
                eqMain.Maintenance_Request__c = c.Id;
                eqMainList.add(eqMain);
            }
        }
        return eqMainList;
    }
    
}