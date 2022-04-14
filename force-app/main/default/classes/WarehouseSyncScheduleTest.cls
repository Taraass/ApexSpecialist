@isTest
private with sharing class WarehouseSyncScheduleTest {

    private static String CRON_EXP = '0 0 1 ? * * *'; 

    @isTest
    public static void SyncScheduleTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        String jobId = System.schedule('WarehouseSyncScheduleTest', CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();
        CronTrigger cTId = [SELECT State FROM CronTrigger WHERE Id = :jobID];
        System.assertEquals('WAITING', String.valueOf(cTId.State), 'JobID doesn`t match');
    }
}