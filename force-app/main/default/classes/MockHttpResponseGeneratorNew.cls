@isTest
global class MockHttpResponseGeneratorNew implements HttpCalloutMock {
     // Implement this interface method
     
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        System.debug('req : ' + req);
        // Create a fake response
       if(req.getEndpoint().startsWithIgnoreCase('https://api.xero.com/api.xro/2.0/'+'invoices')
          	|| req.getEndpoint().contains('OnlineInvoice') )
        		{
                    system.debug('inside Invoice');
            HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'  \"Id\": \"74040457-1368-4c85-971f-07c95053de21\",'+
		'  \"Status\": \"OK\",'+
		'  \"ProviderName\": \"DemoApp\",'+
		'  \"DateTimeUTC\": \"\\/Date(1526024821332)\\/\",'+
		'  \"Invoices\": ['+
		'    {'+
		'      \"Type\": \"ACCREC\",'+
		'      \"InvoiceID\": \"a4fe025e-0e69-4d56-a7f4-5aaa12ea6287\",'+
		'      \"InvoiceNumber\": \"INV-0075\",'+
		'      \"Reference\": \"\",'+
		'      \"Prepayments\": [],'+
		'      \"Overpayments\": [],'+
		'      \"AmountDue\": 0.00,'+
		'      \"AmountPaid\": 0.00,'+
		'      \"SentToContact\": false,'+
		'      \"CurrencyRate\": 1.000000,'+
		'      \"HasErrors\": false,'+
		'      \"IsDiscounted\": false,'+
		'      \"Contact\": {'+
		'        \"ContactID\": \"b7a9f13b-f738-4301-90db-9d3a8ce5f239\",'+
		'        \"ContactNumber\": \"0010k00000c8rPxAAI\",'+
		'        \"ContactStatus\": \"ACTIVE\",'+
		'        \"Name\": \"Kunal\",'+
		'        \"EmailAddress\": \"\",'+
		'        \"BankAccountDetails\": \"\",'+
		'        \"Addresses\": ['+
		'          {'+
		'            \"AddressType\": \"STREET\",'+
		'            \"City\": \"\",'+
		'            \"Region\": \"\",'+
		'            \"PostalCode\": \"\",'+
		'            \"Country\": \"\"'+
		'          },'+
		'          {'+
		'            \"AddressType\": \"POBOX\",'+
		'            \"City\": \"\",'+
		'            \"Region\": \"\",'+
		'            \"PostalCode\": \"\",'+
		'            \"Country\": \"\"'+
		'          }'+
		'        ],'+
		'        \"Phones\": ['+
		'          {'+
		'            \"PhoneType\": \"DEFAULT\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"DDI\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"FAX\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"MOBILE\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          }'+
		'        ],'+
		'        \"UpdatedDateUTC\": \"\\/Date(1525953251687+0000)\\/\",'+
		'        \"ContactGroups\": [],'+
		'        \"IsSupplier\": false,'+
		'        \"IsCustomer\": true,'+
		'        \"SalesTrackingCategories\": [],'+
		'        \"PurchasesTrackingCategories\": [],'+
		'        \"ContactPersons\": [],'+
		'        \"HasValidationErrors\": false'+
		'      },'+
		'      \"DateString\": \"2018-05-11T00:00:00\",'+
		'      \"Date\": \"\\/Date(1525996800000+0000)\\/\",'+
		'      \"DueDateString\": \"2018-05-14T00:00:00\",'+
		'      \"DueDate\": \"\\/Date(1526256000000+0000)\\/\",'+
		'      \"Status\": \"AUTHORISED\",'+
		'      \"LineAmountTypes\": \"Inclusive\",'+
		'      \"LineItems\": ['+
		'        {'+
		'          \"Description\": \"Total debt $1452.00 accepted $XXXXX Saved $XXXXX\",'+
		'          \"UnitAmount\": 1452.00,'+
		'          \"TaxType\": \"TAX001\",'+
		'          \"TaxAmount\": 132.00,'+
		'          \"LineAmount\": 1452.00,'+
		'          \"AccountCode\": \"200\",'+
		'          \"Tracking\": [],'+
		'          \"Quantity\": 1.0000,'+
		'          \"LineItemID\": \"8a91148a-9ba9-407b-9b1e-f9ab793f97db\",'+
		'          \"ValidationErrors\": []'+
		'        }'+
		'      ],'+
		'      \"SubTotal\": 1320.00,'+
		'      \"TotalTax\": 132.00,'+
		'      \"Total\": 1452.00,'+
		'      \"UpdatedDateUTC\": \"\\/Date(1526024821067+0000)\\/\",'+
		'      \"CurrencyCode\": \"INR\"'+
		'    }'+
		'  ]'+
		'}');
        res.setStatusCode(200);
        return res;
        }
        else if(req.getEndpoint().startsWithIgnoreCase('https://api.xero.com/api.xro/2.0/'+'contacts'))
                {
                    system.debug('inside Contact');
                    HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody('{'+
                    ' \"Id\": \"194d4e53-3c70-4f16-8ea5-5f12e6c7b211\",'+
                    ' \"Status\": \"OK\",'+
                    ' \"ProviderName\": \"Test App\",'+
                    ' \"DateTimeUTC\": \"\\/Date(1526630465014)\\/\",'+
                    ' \"Contacts\": ['+
                    '   {'+
                    '     \"ContactID\": \"ec35967a-62c9-4638-9182-ae58980ffa49\",'+
                    '     \"ContactNumber\": \"003N000001BolmEIAR\",'+
                    '     \"ContactStatus\": \"ACTIVE\",'+
                    '     \"Name\": \"dsjvf skeiufgdsj\",'+
                    '     \"EmailAddress\": \"\",'+
                    '     \"BankAccountDetails\": \"\",'+
                    '     \"Addresses\": ['+
                    '       {'+
                    '         \"AddressType\": \"STREET\",'+
                    '         \"City\": \"\",'+
                    '         \"Region\": \"\",'+
                    '         \"PostalCode\": \"\",'+
                    '         \"Country\": \"\"'+
                    '       },'+
                    '       {'+
                    '         \"AddressType\": \"POBOX\",'+
                    '         \"City\": \"\",'+
                    '         \"Region\": \"\",'+
                    '         \"PostalCode\": \"\",'+
                    '         \"Country\": \"\"'+
                    '       }'+
                    '     ],'+
                    '     \"Phones\": ['+
                    '       {'+
                    '         \"PhoneType\": \"DEFAULT\",'+
                    '         \"PhoneNumber\": \"\",'+
                    '         \"PhoneAreaCode\": \"\",'+
                    '         \"PhoneCountryCode\": \"\"'+
                    '       },'+
                    '       {'+
                    '         \"PhoneType\": \"DDI\",'+
                    '         \"PhoneNumber\": \"\",'+
                    '         \"PhoneAreaCode\": \"\",'+
                    '         \"PhoneCountryCode\": \"\"'+
                    '       },'+
                    '       {'+
                    '         \"PhoneType\": \"FAX\",'+
                    '         \"PhoneNumber\": \"\",'+
                    '         \"PhoneAreaCode\": \"\",'+
                    '         \"PhoneCountryCode\": \"\"'+
                    '       },'+
                    '       {'+
                    '         \"PhoneType\": \"MOBILE\",'+
                    '         \"PhoneNumber\": \"\",'+
                    '         \"PhoneAreaCode\": \"\",'+
                    '         \"PhoneCountryCode\": \"\"'+
                    '       }'+
                    '     ],'+
                    '     \"UpdatedDateUTC\": \"\\/Date(1526017954263+0000)\\/\",'+
                    '     \"ContactGroups\": [],'+
                    '     \"IsSupplier\": false,'+
                    '     \"IsCustomer\": true,'+
                    '     \"SalesTrackingCategories\": [],'+
                    '     \"PurchasesTrackingCategories\": [],'+
                    '     \"ContactPersons\": [],'+
                    '     \"HasValidationErrors\": false'+
                    '   }'+
                    ' ]'+
                    '}');
                    res.setStatusCode(200);
                    return res;
                }
         else if(req.getEndpoint().startsWithIgnoreCase('https://api.xero.com/api.xro/2.0/'+'Payments'))
         {
             system.debug('inside  Payment');
              		HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
             		res.setBody('{  "Id": "ff0b29c8-c1c3-4f67-8dde-bae6e21c36df",  "Status": "OK",  "ProviderName": "SFDC_Test_KonnectLearning",  "DateTimeUTC": "",  "Payments": [    {      "PaymentID": "bc06234c-b82b-4862-8c28-550101caee7a",      "Date": "",      "BankAmount": 10767.80,      "Amount": 10767.80,      "CurrencyRate": 1.000000,      "PaymentType": "ACCRECPAYMENT",      "Status": "AUTHORISED",      "UpdatedDateUTC": "",      "HasAccount": true,      "IsReconciled": false,      "Account": {        "AccountID": "f9c0c364-973b-4af9-a72d-041723c0efe3",        "Code": "123456",        "Name": "Payment"      },      "Invoice": {        "Type": "ACCREC",        "InvoiceID": "49cf2d8b-0268-4d8c-9ce8-ba568d3e3e5c",        "InvoiceNumber": "INV-0143",        "Reference": "",        "Prepayments": [],        "Overpayments": [],        "AmountDue": 0.00,        "AmountPaid": 10767.80,        "SentToContact": false,        "CurrencyRate": 1.000000,        "HasErrors": false,        "IsDiscounted": false,        "Contact": {          "ContactID": "97b95a65-896d-4659-9b81-68867368d32f",          "Name": "ARR",          "ContactPersons": [],          "HasValidationErrors": false        },        "DateString": "2018-09-26T00:00:00",        "Date": "",        "DueDateString": "2018-10-26T00:00:00",        "DueDate": "",        "Status": "PAID",        "LineAmountTypes": "Exclusive",        "LineItems": [          {            "Description": "Corporate Table of 8",            "UnitAmount": 9698.00,            "TaxType": "OUTPUT",            "TaxAmount": 969.80,            "LineAmount": 9698.00,            "AccountCode": "200",            "Tracking": [],            "Quantity": 1.0000,            "LineItemID": "11e8d10a-7f19-4f86-9866-3ea0ae697eb1",            "ValidationErrors": []          },          {            "Description": "CharityLocation : 31 Constitution Ave, Canberra ACT 2601 Canberra, Test state 2601AustraliaDates : 4-10-2018 to 15-10-2018",            "UnitAmount": 100.00,            "TaxType": "EXEMPTOUTPUT",            "TaxAmount": 0.00,            "LineAmount": 100.00,            "AccountCode": "200",            "Tracking": [],            "Quantity": 1.0000,            "LineItemID": "7c04cf0d-9499-4230-b7d9-2ef402cd0911",            "ValidationErrors": []          }        ],        "SubTotal": 9798.00,        "TotalTax": 969.80,        "Total": 10767.80,        "UpdatedDateUTC": "",        "CurrencyCode": "AUD",        "FullyPaidOnDate": ""      },      "HasValidationErrors": false    }  ]}');
             		res.setStatusCode(200);
                    return res;
         }
                else
                {
                    return null;
                }
    }    
}