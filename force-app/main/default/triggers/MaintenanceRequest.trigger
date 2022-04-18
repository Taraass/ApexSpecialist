trigger MaintenanceRequest on Case (before update, after update) {

    List<Case> validCaseList = new List<Case>();

    if(Trigger.isUpdate && Trigger.isAfter) {
        MaintenanceRequestHelper.createMaintenanceRequestRecord(Trigger.new);
    }
}