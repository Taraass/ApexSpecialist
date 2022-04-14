public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {
        List<Product2> equipments = new List<Product2>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.92165530.1096293658.1649326678-1361659688.1647616186');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for(Object obj: results){
                Map<String, Object> res = (Map<String, Object>) obj;
                Product2 equipment = new Product2();
                equipment.Replacement_Part__c = (Boolean) res.get('replacement');
                equipment.Current_Inventory__c = (Integer) res.get('quantity');
                equipment.Cost__c = (Integer) res.get('cost');
                equipment.Lifespan_Months__c = (Integer) res.get('lifespan');
                equipment.Maintenance_Cycle__c = (Integer) res.get('maintenanceperiod');
                equipment.Name = (String) res.get('name');
                equipment.ExternalId = (String) res.get('sku');
                equipments.add(equipment);  
            }
            
            if(equipments.size()>0) {
                upsert equipments;
            }
        }
    }
}