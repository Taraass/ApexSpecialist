@isTest
global without sharing class WarehouseCalloutServiceTest {
    
    @isTest
    static void calloutServiceTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        List<Product2> prod = [SELECT Id FROM Product2 WHERE Name = 'Fuse 20A' OR Name = 'Cooling Fan'];
        System.assertEquals(2, prod.size());
    } 
}