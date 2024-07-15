public with sharing class XeroKeepConnection implements Queueable, Database.AllowsCallouts {
    
    public void execute(QueueableContext context) {
        executeCallout();
    }

    public static void executeCallout () {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:Xero/api.xro/2.0/Invoices?page=1&pageSize=1');
        request.setHeader('Accept', 'application/json');
        request.setHeader('xero-tenant-id', Label.Xero_Tenant_Id);
        request.setTimeout(120000);

        system.debug('Xero Callout Endpoint: ' + request.getEndpoint());
        system.debug('Xero Callout Method: ' + request.getMethod());
        system.debug('Xero Callout Body: ' + request.getBody());    

        HttpResponse response = new Http().send(request);

        system.debug('Xero Response Status: ' + response.getStatusCode() + ': ' + response.getStatus());
        system.debug('Xero Response Body: ' + response.getBody());
    }
}