@isTest
public class QKXERO_Mock {


    private static HTTPResponse respond(HTTPRequest req, Integer code, String status, String body, Map<String, String> responseHeaders) {

        HttpResponse res = new HttpResponse();
        for (String key : responseHeaders.keySet()) {
            res.setHeader(key, responseHeaders.get(key));
        }
        res.setBody(body);
        res.setStatusCode(code);
        res.setStatus(status);
        return res;
    }


/*    public class Generic implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String body;
        protected Map<String, String> responseHeaders;

        public Generic(Integer code, String status, String body, Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.body = body;
            this.responseHeaders = responseHeaders;
        }

        public HTTPResponse respond(HTTPRequest req) {
            return QKXERO_Mock.respond(req, this.code, this.status, this.body, this.responseHeaders);
        }
    }*/

    public class GenericXeroInvoiceSuccess implements HttpCalloutMock {
        protected Integer code = 200;
        protected String status = 'OK';
        protected String body = '{'+
        '\n  \"Id\": \"5975c95a-5204-4381-80c7-1fdb2d6b8227\",'+
        '\n  \"Status\": \"OK\",'+
        '\n  \"ProviderName\": \"QKXERO_Mock\",'+
        '\n  \"DateTimeUTC\": \"\\/Date(1499829277755)\\/\",'+
        '\n  \"Invoices\": ['+
        '\n    {'+
        '\n      \"Type\": \"ACCREC\",'+
        '\n      \"InvoiceID\": \"cc2f7c1c-2c8a-431a-9617-3524abe9cedd\",'+
        '\n      \"InvoiceNumber\": \"INV-0007\",'+
        '\n      \"Reference\": \"\",'+
        '\n      \"Prepayments\": [],'+
        '\n      \"Overpayments\": [],'+
        '\n      \"AmountDue\": 1319.00,'+
        '\n      \"AmountPaid\": 0.00,'+
        '\n      \"SentToContact\": false,'+
        '\n      \"CurrencyRate\": 1.000000,'+
        '\n      \"HasErrors\": false,'+
        '\n      \"IsDiscounted\": false,'+
        '\n      \"Contact\": {'+
        '\n        \"ContactID\": \"3878fbf4-7a62-421e-87f7-fbfa577317fb\",'+
        '\n        \"ContactStatus\": \"ACTIVE\",'+
        '\n        \"Name\": \"New Account\",'+
        '\n        \"FirstName\": \"\",'+
        '\n        \"LastName\": \"\",'+
        '\n        \"EmailAddress\": \"accounts@ridgewayuniversity.edu\",'+
        '\n        \"BankAccountDetails\": \"\",'+
        '\n        \"Addresses\": ['+
        '\n          {'+
        '\n            \"AddressType\": \"STREET\",'+
        '\n            \"City\": \"\",'+
        '\n            \"Region\": \"\",'+
        '\n            \"PostalCode\": \"\",'+
        '\n            \"Country\": \"\",'+
        '\n            \"AttentionTo\": \"\"'+
        '\n          },'+
        '\n          {'+
        '\n            \"AddressType\": \"POBOX\",'+
        '\n            \"City\": \"\",'+
        '\n            \"Region\": \"\",'+
        '\n            \"PostalCode\": \"\",'+
        '\n            \"Country\": \"\",'+
        '\n            \"AttentionTo\": \"\"'+
        '\n          }'+
        '\n        ],'+
        '\n        \"Phones\": ['+
        '\n          {'+
        '\n            \"PhoneType\": \"DEFAULT\",'+
        '\n            \"PhoneNumber\": \"\",'+
        '\n            \"PhoneAreaCode\": \"\",'+
        '\n            \"PhoneCountryCode\": \"\"'+
        '\n          },'+
        '\n          {'+
        '\n            \"PhoneType\": \"DDI\",'+
        '\n            \"PhoneNumber\": \"\",'+
        '\n            \"PhoneAreaCode\": \"\",'+
        '\n            \"PhoneCountryCode\": \"\"'+
        '\n          },'+
        '\n          {'+
        '\n            \"PhoneType\": \"FAX\",'+
        '\n            \"PhoneNumber\": \"\",'+
        '\n            \"PhoneAreaCode\": \"\",'+
        '\n            \"PhoneCountryCode\": \"\"'+
        '\n          },'+
        '\n          {'+
        '\n            \"PhoneType\": \"MOBILE\",'+
        '\n            \"PhoneNumber\": \"\",'+
        '\n            \"PhoneAreaCode\": \"\",'+
        '\n            \"PhoneCountryCode\": \"\"'+
        '\n          }'+
        '\n        ],'+
        '\n        \"UpdatedDateUTC\": \"\\/Date(1499399835950+0000)\\/\",'+
        '\n        \"ContactGroups\": [],'+
        '\n        \"IsSupplier\": false,'+
        '\n        \"IsCustomer\": true,'+
        '\n        \"DefaultCurrency\": \"AUD\",'+
        '\n        \"SalesTrackingCategories\": [],'+
        '\n        \"PurchasesTrackingCategories\": [],'+
        '\n        \"ContactPersons\": [],'+
        '\n        \"HasValidationErrors\": false'+
        '\n      },'+
        '\n      \"DateString\": \"2017-07-06T00:00:00\",'+
        '\n      \"Date\": \"\\/Date(1499299200000+0000)\\/\",'+
        '\n      \"DueDateString\": \"2017-07-26T00:00:00\",'+
        '\n      \"DueDate\": \"\\/Date(1501027200000+0000)\\/\",'+
        '\n      \"Status\": \"DRAFT\",'+
        '\n      \"LineAmountTypes\": \"Exclusive\",'+
        '\n      \"LineItems\": ['+
        '\n        {'+
        '\n          \"UnitAmount\": 163.00,'+
        '\n          \"LineAmount\": 163.00,'+
        '\n          \"Tracking\": [],'+
        '\n          \"Quantity\": 1.0000,'+
        '\n          \"LineItemID\": \"0ffc0401-0a57-4ac2-b0ec-55c8c8ff81e6\",'+
        '\n          \"ValidationErrors\": []'+
        '\n        },'+
        '\n        {'+
        '\n          \"UnitAmount\": 34.00,'+
        '\n          \"LineAmount\": 1156.00,'+
        '\n          \"Tracking\": [],'+
        '\n          \"Quantity\": 34.0000,'+
        '\n          \"LineItemID\": \"8cee5f89-1ed2-4828-92b7-595f55997123\",'+
        '\n          \"ValidationErrors\": []'+
        '\n        }'+
        '\n      ],'+
        '\n      \"SubTotal\": 1319.00,'+
        '\n      \"TotalTax\": 0.00,'+
        '\n      \"Total\": 1319.00,'+
        '\n      \"UpdatedDateUTC\": \"\\/Date(1499829277647+0000)\\/\",'+
        '\n      \"CurrencyCode\": \"AUD\",'+
        '\n      \"StatusAttributeString\": \"OK\",'+
        '\n      \"Warnings\": []'+
        '\n    }'+
        '\n  ]'+
        '\n}';
        protected Map<String, String> responseHeaders = new Map<String, String>();


        public HTTPResponse respond(HTTPRequest req) {
            return QKXERO_Mock.respond(req, this.code, this.status, this.body, this.responseHeaders);
        }
    }

    public class GenericXeroContactSuccess implements HttpCalloutMock {
        protected Integer code = 200;
        protected String status = 'OK';
        protected String body = '{'+
        '\n  \"Id\": \"752ad538-c0e0-4d75-a212-d28b4db8837b\",'+
        '\n  \"Status\": \"OK\",'+
        '\n  \"ProviderName\": \"Exablaze Xero\",'+
        '\n  \"DateTimeUTC\": \"\\/Date(1499835436511)\\/\",'+
        '\n  \"Contacts\": ['+
        '\n    {'+
        '\n      \"ContactID\": \"8ff0ddc6-4e33-4120-883c-a00f8fb9ac20\",'+
        '\n      \"ContactStatus\": \"ACTIVE\",'+
        '\n      \"Name\": \"Benchmark 1\",'+
        '\n      \"EmailAddress\": \"\",'+
        '\n      \"BankAccountDetails\": \"\",'+
        '\n      \"Addresses\": ['+
        '\n        {'+
        '\n          \"AddressType\": \"STREET\",'+
        '\n          \"City\": \"\",'+
        '\n          \"Region\": \"\",'+
        '\n          \"PostalCode\": \"\",'+
        '\n          \"Country\": \"\"'+
        '\n        },'+
        '\n        {'+
        '\n          \"AddressType\": \"POBOX\",'+
        '\n          \"City\": \"\",'+
        '\n          \"Region\": \"\",'+
        '\n          \"PostalCode\": \"\",'+
        '\n          \"Country\": \"\"'+
        '\n        }'+
        '\n      ],'+
        '\n      \"Phones\": ['+
        '\n        {'+
        '\n          \"PhoneType\": \"DEFAULT\",'+
        '\n          \"PhoneNumber\": \"\",'+
        '\n          \"PhoneAreaCode\": \"\",'+
        '\n          \"PhoneCountryCode\": \"\"'+
        '\n        },'+
        '\n        {'+
        '\n          \"PhoneType\": \"DDI\",'+
        '\n          \"PhoneNumber\": \"\",'+
        '\n          \"PhoneAreaCode\": \"\",'+
        '\n          \"PhoneCountryCode\": \"\"'+
        '\n        },'+
        '\n        {'+
        '\n          \"PhoneType\": \"FAX\",'+
        '\n          \"PhoneNumber\": \"\",'+
        '\n          \"PhoneAreaCode\": \"\",'+
        '\n          \"PhoneCountryCode\": \"\"'+
        '\n        },'+
        '\n        {'+
        '\n          \"PhoneType\": \"MOBILE\",'+
        '\n          \"PhoneNumber\": \"\",'+
        '\n          \"PhoneAreaCode\": \"\",'+
        '\n          \"PhoneCountryCode\": \"\"'+
        '\n        }'+
        '\n      ],'+
        '\n      \"UpdatedDateUTC\": \"\\/Date(1499753880647+0000)\\/\",'+
        '\n      \"ContactGroups\": [],'+
        '\n      \"IsSupplier\": false,'+
        '\n      \"IsCustomer\": false,'+
        '\n      \"SalesTrackingCategories\": [],'+
        '\n      \"PurchasesTrackingCategories\": [],'+
        '\n      \"ContactPersons\": [],'+
        '\n      \"HasValidationErrors\": false,'+
        '\n      \"StatusAttributeString\": \"OK\"'+
        '\n    }'+
        '\n  ]'+
        '\n}';
        protected Map<String, String> responseHeaders = new Map<String, String>();


        public HTTPResponse respond(HTTPRequest req) {
            return QKXERO_Mock.respond(req, this.code, this.status, this.body, this.responseHeaders);
        }
    }

    public class GenericXeroPdfSuccess implements HttpCalloutMock {
        protected Integer code = 200;
        protected String status = 'OK';
        protected String body = '';// Empty PDF
        protected Map<String, String> responseHeaders = new Map<String, String>();


        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse response = QKXERO_Mock.respond(req, this.code, this.status, this.body, this.responseHeaders);
            response.setBodyAsBlob(Blob.valueOf(this.body));
            return response;
        }
    }




}