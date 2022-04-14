trigger MaintenanceRequest on Case (before update, after update) {

    List<Case> validCaseList = new List<Case>();

    if(Trigger.isUpdate && Trigger.isAfter) {
        for(Case cases: Trigger.new){
            if(cases.Status == 'Closed' && (cases.Type == 'Repair' || cases.Type == 'Routine Maintenance')){
                validCaseList.add(cases);
            }
        }

        if(!validCaseList.isEmpty()){
            MaintenanceRequestHelper.createMaintenanceRequestRecord(validCaseList);
        }
    }  
}