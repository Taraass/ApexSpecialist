public with sharing class MaintenanceRequestHelper {

    public void createMaintenanceRequestRecord(List<Case> caseList) {
        try{
            List<Case> casesToInsert = new List<Case>();
            Integer cycle = getMaintenanceCycle(caseList) == null ? 0 : getMaintenanceCycle(caseList);
            for(Case item: caseList) {
                if(item.Status == 'Closed' && (item.Type == 'Repair' || item.Type == 'Routine Maintenance')){
                    Case newCase = new Case();
                    newCase.Vehicle__c = item.Vehicle__c;
                    newCase.Status = 'New';
                    newCase.Origin ='Web';
                    newCase.Type = 'Routine Maintenance';
                    newCase.Subject = 'Clone of ' + item.Subject;
                    newCase.Date_Reported__c = Date.today();
                    newCase.OldId__c = item.Id;
                    newCase.Date_Due__c = Date.today().addDays(cycle);
                    casesToInsert.add(newCase);
                }
            }
            if(!casesToInsert.isEmpty()) {
                insert casesToInsert;
                createEquipmentMaintenanceItems(casesToInsert);
            }
        }catch(Exception e) {
                System.debug('Exception occured: ' + e.getMessage());
        }
    }
    
    public static void createEquipmentMaintenanceItems(List<Case> newCases) {
        List<Equipment_Maintenance_Item__c> equipmentsToInsert = new List<Equipment_Maintenance_Item__c>();
        List<Equipment_Maintenance_Item__c> equipmentMainOld = [SELECT ID, Maintenance_Request__c, Equipment__c, Quantity__c FROM Equipment_Maintenance_Item__c];
        for(Case caseItem : newCases) {
            for(Equipment_Maintenance_Item__c eq : equipmentMainOld){
                if(caseItem.OldId__c == eq.Maintenance_Request__c) {
                    Equipment_Maintenance_Item__c qnew = new Equipment_Maintenance_Item__c();
                    qnew.Maintenance_Request__c = caseItem.Id;
                    qnew.Equipment__c = eq.Equipment__c;
                    qnew.Quantity__c = eq.Quantity__c;
                    equipmentsToInsert.add(qnew);
                }
            }
        }
        if(!equipmentsToInsert.isEmpty()){
            insert equipmentsToInsert;
        }
    }

    public static Integer getMaintenanceCycle(List<Case> caseList) {
        List<Equipment_Maintenance_Item__c> eqMain = [SELECT Equipment__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN: caseList];
        Set<Id> eqMainIds = new Set<Id>();
        for(Equipment_Maintenance_Item__c eqMainItems: eqMain){
            eqMainIds.add(eqMainItems.Equipment__c);
        }
        Product2 equipments = [SELECT Maintenance_Cycle__c FROM Product2 WHERE Id IN: eqMainIds ORDER BY Maintenance_Cycle__c LIMIT 1];
        Integer result = Integer.valueOf(equipments.Maintenance_Cycle__c);
        return result;
    }
}