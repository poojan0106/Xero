/**
*   Created By : Yogesh 
**/
public with sharing class XeroAPI {
    
	//@description Retrieve a Xero Contact
    public static XeroContact getContact(String xeroId) {
        
        String resourceName = 'Contacts';
        // Callout to Xero to retrieve a single Contact
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
            
            // Now serialise the response and reutrn
            return xeroContacts[0];
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving contact: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
    //@description Retrieve perticular invoice //GET https://api.xero.com/api.xro/2.0/Invoices/9b9ba9e5-e907-4b4e-8210-54d82b0aa479/OnlineInvoice
    public static String getOnlineInvoice(String invoiceId, String accessToken) {
                
        String resourceName = 'Invoices';
        String onlineInvoice = 'OnlineInvoice';
        
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName  + '/' + invoiceId + '/'+onlineInvoice, null, null, accessToken); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), 'OnlineInvoices');
            System.debug('jsonSerialized : '+jsonSerialized);
            List<XeroOnlineInvoice> onlineInvoiceResponse = (List<XeroOnlineInvoice>) JSON.deserialize(jsonSerialized, List<XeroOnlineInvoice>.class);
            
            //Return only url string 
            return onlineInvoiceResponse[0].OnlineInvoiceUrl;
            //return (List<XeroOnlineInvoice>) JSON.deserialize(jsonSerialized, List<XeroOnlineInvoice>.class);
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
        
    }

    //@description Retrieve modified invoices from Xero
    public static List<XeroContact> getContacts() {
        
        String resourceName = 'Contacts';
        
        // Callout to Xero to retrieve contacts
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            // Now serialise the response and reutrn
            return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class); 
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving contacts: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
    //@description Send a XeroContact to Xero
    public static XeroContact sendContact (XeroContact xeroContact, String accessToken) {
        
        String resourceName = 'Contacts';
        
        // Send the Contact to Xero
        HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroContact.serialize(), null, accessToken);
        
        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;
        
        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {
            
            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else { 
            
            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
            
            // Now serialise the response
            List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
            
            // If success
            if (isSuccess) {
                
                return xeroContacts[0];
            }
            // else, process the error
            else {
                
                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';
                
                if (xeroContacts[0].ValidationErrors != null && !xeroContacts[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(xeroContacts[0].ValidationErrors);
                }
                
                throw new XeroApiException(xeroError);
            }
        }
    }

	//@description Send a XeroPayment to Xero
    public static XeroPayment sendPayment(XeroPayment xeroPayment, String accessToken) {
        String resourceName = 'Payments';
        
        // Send the Invoice to Xero as an Invoice
        HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroPayment.serialize(), null, accessToken);
        
        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;
        
        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {
            
            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else {
            
            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
            // Replace date to Date_X key name Written By Yogesh
            String jsonOut = jsonSerialized.replaceAll('"Date":','"Date_X":');
            System.debug('!!Yogi2020 jsonOut OG: '+jsonOut);
            //
            // Now serialise the response
            List<XeroPayment> xeroPayments = (List<XeroPayment>) JSON.deserialize(jsonOut, List<XeroPayment>.class);
            
            // If success
            if (isSuccess) {
                
                return xeroPayments[0];
            }
            // else, process the error
            else {
                
                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';
                
                if (xeroPayments[0].ValidationErrors != null && !xeroPayments[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(xeroPayments[0].ValidationErrors);
                }
                
                //XeroErrorLog_ByRes.createErrorLogForXeroCalloutXeroAPi(response.getStatusCode(), response.getStatus(), xeroError);
                //Savepoint sp = Database.setSavepoint();
                //Database.rollback(sp);
                throw new XeroApiException(xeroError);
            }
        }
    }
    
    //@description Retrieve invoice from Xero
    public static XeroInvoice getInvoice(String xeroId) {
        
        String resourceName = 'Invoices';
        
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
            
            // Now serialise the response and reutrn
            return xeroInvoices[0];
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
 	//@description Retrieve modified invoices from Xero
    public static List<XeroInvoice> getInvoices() {
        
        return getInvoices(null);
    }
    
    
 	//@description Retrieve modified invoices from Xero
    public static List<XeroInvoice> getInvoices(Integer daysAgo) {
        
        String resourceName = 'Invoices';
        
        Map<String, String> modifiedHeader = null;
        
        if (daysAgo != null) {
            
            // Build the modified header
            modifiedHeader = new Map<String, String>{
                'If-Modified-Since' => getModifiedDateFilterFormatted(daysAgo)
                    };
                        }
        
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName, null, modifiedHeader); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            // Now serialise the response and reutrn
            return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class); 
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoices: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }

    // Written By Yogesh, for update xero to sf //this method use to get of xero modified invoice to particular date 
    public static List<XeroInvoice> getModifiedInvoices(DateTime dt) {
        
        String resourceName = 'Invoices';
        
        Map<String, String> modifiedHeader = null;
        
        dt = dt.addDays(-7); //Get invoices to update in the last week
        
        if (dt != null) 
        {
            
            System.debug('@@@ String.valueOf(dt) = '+String.valueOf(dt));
            
            // Build the modified header
            String strDate = String.valueOf(dt.date());
            String strTime = String.valueOf(dt.time());
            String strDateTime = strDate+'T'+strTime;
            
            System.debug('@@@ strDateTime = '+strDateTime);
            
            modifiedHeader = new Map<String, String> {'If-Modified-Since' => strDateTime};
            
        }
        
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName, null, modifiedHeader); 
        
        if (response.getStatusCode() < 300) {
            
            
            //YOgesh
            //String responseBody = response.getBody().replace('\"PaidDate\":', '\"Date\":');
            //String jsonSerialized = XeroUtils.generateJsonStringForParsing(responseBody, resourceName);
            //jsonSerialized.replace('\"Date\":', '\"PaidDate\":');
            
            //orignal comment 
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            // Now serialise the response and reutrn
            
            
            System.debug('!!Yogi2020 jsonSerialized OG: '+jsonSerialized);
            
            // Replace date to Date_X key name Written By Yogesh
            String jsonOut = jsonSerialized.replaceAll('"Date":','"Date_X":');
            System.debug('!!Yogi2020 jsonOut OG: '+jsonOut);
            //
            return (List<XeroInvoice>) JSON.deserialize(jsonOut, List<XeroInvoice>.class); 
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoices: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
    
    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve invoice from Xero
    **/
    /*
    public static Blob getInvoiceAsPdf(String xeroId) {
        
        String resourceName = 'Invoices';
        
        // Callout to Xero to retrieve invoice
        HttpResponse response = XeroCalloutService.executeCallout(
            'GET', resourceName + '/' + xeroId, 
            null, 
            new Map<String, String>{'Accept' => 'application/pdf'}
        ); 
        
        if (response.getStatusCode() < 300) {
            
            return response.getBodyAsBlob();
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    */
    
    // @description Send a Salesforce Invoice to Xero as an Invoice
    public static XeroInvoice sendInvoice (XeroInvoice xeroInvoice, String accessToken) {
        
        String resourceName = 'Invoices';
        
        // Send the Invoice to Xero as an Invoice
        HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroInvoice.serialize(),null,accessToken);
        
        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;
        
        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {
            
            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else {
            
            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
            // Replace date to Date_X key name Written By Yogesh
            String jsonOut = jsonSerialized.replaceAll('"Date":','"Date_X":');
            System.debug('!!Yogi2020 jsonOut OG: '+jsonOut);
            //
            // Now serialise the response
            List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonOut, List<XeroInvoice>.class);
            
            // If success
            if (isSuccess) {
                
                return xeroInvoices[0];
            }
            // else, process the error
            else {
                
                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';
                
                if (xeroInvoices[0].ValidationErrors != null && !xeroInvoices[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(xeroInvoices[0].ValidationErrors);
                }
                
                throw new XeroApiException(xeroError);
            }
        }
    }
    
 	//@description Retrieve the latest Xero ID to use for the Xero Tenant ID
    public static String getXeroTenantId () {
        
        // Callout to Xero to retrieve contacts
        HttpResponse response = XeroCalloutService.executeCallout('GET', 'connections'); 
        
        if (response.getStatusCode() < 300) {
            
            // Retrieve the Xero Connection
            List<XeroConnection> xeroConnections = (List<XeroConnection>) JSON.deserialize(response.getBody(), List<XeroConnection>.class);
            
            system.debug('### Latest Xero Tenant ID is:' + xeroConnections[0].tenantId);
            
            // Now serialise the response and reutrn
            return xeroConnections[0].tenantId;
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving connections: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
 	//@description For a given number of days ago, set the invoice filter
    public static String getModifiedDateFilterFormatted (Integer daysAgo) {
        
        // Go back the # days ago
        Date modifiedDate = System.today().addDays(daysAgo * -1);
        
        // Format the date into correct xero format
        // https://developer.xero.com/documentation/api/invoices#get
        return ((DateTime)modifiedDate).format('yyyy-MM-dd') + 'T00:00:00';
    } 
    
    public static Blob getInvoiceAsPdf(String xeroId, String accessToken) {

        String resourceName = 'Invoices';

        // Callout to Xero to retrieve invoice
        HttpResponse response = XeroCalloutService.executeCallout(
            'GET', resourceName + '/' + xeroId, 
            null, 
            new Map<String, String>{'Accept' => 'application/pdf'},
            accessToken
        ); 

        if (response.getStatusCode() < 300) {

            return response.getBodyAsBlob();
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
    //added by yogesh 19-04-2021
    //
    public static List<XeroPrepayment> getPrepayments() {

        String resourceName = 'Prepayments';
        
        // Callout to Xero to retrieve contacts
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            // Now serialise the response and reutrn
            return (List<XeroPrepayment>) JSON.deserialize(jsonSerialized, List<XeroPrepayment>.class); 
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving PrePayment: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    /*
    public static List<XeroPrepayment> getPrepayment(String prePaymentId_1, String prePaymentId_2) {
        
        String resourceName = 'Prepayments';
        
        String prePaymentXeroId = '';
        if(String.isNotBlank(prePaymentId_1) && String.isNotBlank(prePaymentId_2))
        {
            System.debug('both are not blank : prepay 1 :  '+prePaymentId_1 + 'prepay 2 : '+prePaymentId_2);
            prePaymentXeroId = '?IDs='+prePaymentId_1 +','+ prePaymentId_2;
        }
        else
        {
            if(String.isNotBlank(prePaymentId_1))
            {
                prePaymentXeroId = prePaymentXeroId + prePaymentId_1;
            }
            if(String.isNotBlank(prePaymentId_2))
            {
                prePaymentXeroId = prePaymentXeroId + prePaymentId_2;
            }
        }
       
        System.debug('prePaymentXeroId url : '+prePaymentXeroId);
        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + prePaymentXeroId); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            List<XeroPrepayment> XeroPrepayment_lst = (List<XeroPrepayment>) JSON.deserialize(jsonSerialized, List<XeroPrepayment>.class);
            
            // Now serialise the response and reutrn
            return XeroPrepayment_lst;
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving XeroPrepayment: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    */
    
    public static List<XeroPrepayment> getSinglePrepayment(String prePaymentId, String accessToken) {
        
        String resourceName = 'Prepayments';

        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + prePaymentId,null,null,accessToken); 
        
        if (response.getStatusCode() < 300) {
            
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
            
            List<XeroPrepayment> XeroPrepayment_lst = (List<XeroPrepayment>) JSON.deserialize(jsonSerialized, List<XeroPrepayment>.class);
            
            // Now serialise the response and reutrn
            return XeroPrepayment_lst;
        }
        else {
            
            // Throw exception
            throw new XeroApiException(
                'Error retrieving XeroPrepayment: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
                response.getBody()
            );
        }
    }
    
    
    
    
    public static XeroPrepaymentsAllocation SendPrepaymentsAllocations(String prePaymentXeroId, XeroPrepaymentsAllocation XeroPrepaymentObj, String accessToken) {

        String resourceName = 'Allocations';
       	String urlForPrePayments = 'Prepayments/'+prePaymentXeroId+'/Allocations';

        // Send the Invoice to Xero as an Invoice
        HttpResponse response = XeroCalloutService.executeCallout('PUT', urlForPrePayments, XeroPrepaymentObj.serialize(),null,accessToken);
        
        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;
        
        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {
            
            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else {
            
            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
            // Replace date to Date_X key name Written By Yogesh
            String jsonOut = jsonSerialized.replaceAll('"Date":','"Date_X":');
            System.debug('!!Yogi2020 jsonOut OG: '+jsonOut);
            //
            // Now serialise the response
            List<XeroPrepaymentsAllocation> XeroPrepaymentsAllocation_lst = (List<XeroPrepaymentsAllocation>) JSON.deserialize(jsonOut, List<XeroPrepaymentsAllocation>.class);
            
            // If success
            if (isSuccess) {
                
                return XeroPrepaymentsAllocation_lst[0];
            }
            // else, process the error
            else {
                
                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';
                
                if (XeroPrepaymentsAllocation_lst[0].ValidationErrors != null && !XeroPrepaymentsAllocation_lst[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(XeroPrepaymentsAllocation_lst[0].ValidationErrors);
                }
                
                //XeroErrorLog_ByRes.createErrorLogForXeroCalloutXeroAPi(response.getStatusCode(), response.getStatus(), xeroError);
                //Savepoint sp = Database.setSavepoint();
                //Database.rollback(sp);
                throw new XeroApiException(xeroError);
            }
        }
    }
    
    public class XeroApiException extends Exception { }
}