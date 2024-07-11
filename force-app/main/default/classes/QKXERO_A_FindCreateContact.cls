public with sharing class QKXERO_A_FindCreateContact {

	@InvocableMethod(label='Find or Create Xero Contact' description='')
	public static void findOrCreateXeroContact (List<Params> inputParams) {
		// Up to 50 future invokes per call. This chunks the sent list into chunks of 45 (limit of 100 callouts). Operations can do up to 2,250 records at once
		Integer runningCount = 0;
		List<Params> paramChunk = new List<Params>();

		System.debug(paramChunk);

		for(Integer i=0; i < inputParams.size(); i++) {
			if(runningCount == 45){
				//futureFindOrCreateXeroContact(JSON.serialize(paramChunk));
				paramChunk = new List<Params>();
				runningCount = 0;
			}
			paramChunk.add(inputParams.get(i));
			runningCount++;
		}

		// Left over chunks
		if(paramChunk.size() > 0){
			//futureFindOrCreateXeroContact(JSON.serialize(paramChunk));
		}
			
		
	}

/*	@Future(callout=true)
	public static void futureFindOrCreateXeroContact (String jsonString) {
		// Up to 100 callouts per async operation.
		List<Params> params = (List<Params>) JSON.deserialize(jsonString, List<Params>.class);
		List<Account> toUpdateAccounts = new List<Account>();

		for(Params param : params){
			List<QKXERO_Contact> contacts = QKXERO_Contact.query('Name == "'+param.lookupName+'"');
			if(contacts.size() > 0){
				toUpdateAccounts.add(new Account(
					Id = param.accountId,
					Xero_Id__c = contacts[0].ContactId
				));
			}else{
				QKXERO_Contact newContact = new QKXERO_Contact();
				newContact.Name = param.lookupName;
				newContact = QKXERO_Contact.saveXero(newContact);
				toUpdateAccounts.add(new Account(
					Id = param.accountId,
					Xero_Id__c = newContact.ContactId
				));
			}
		}

		update toUpdateAccounts;	
	}*/

    //commented By Res cloud 
	@Future(callout=true)
	public static void futureFindOrCreateXeroContact (String jsonString) {
        
		// Up to 100 callouts per async operation.
		/*
		List<Params> params = (List<Params>) JSON.deserialize(jsonString, List<Params>.class);
		List<Id> accountIds = new List<Id>();
		for(Params param : params){
			accountIds.add(param.accountId);
		}

		Map<Id, Account> accounts = new Map<Id, Account>([
			SELECT Id, Name, BillingStreet, BillingCity, BillingCountry, 
			  BillingPostalCode, BillingState, Phone, Xero_Email__c
			FROM Account
			WHERE Id = :accountIds
		]);
		
		List<Account> toUpdateAccounts = new List<Account>();

		List<QKXERO_Contact> contacts = new List<QKXERO_Contact>();

		for(Params param : params){
			Account account = accounts.get(param.accountId);

			QKXERO_Contact contact = new QKXERO_Contact();
			contact.Name = param.lookupName;
			contact.EmailAddress = account.Xero_Email__c;
			
			// Add address information
			QKXERO_Contact.Address address = new QKXERO_Contact.Address();
			address.AddressLine1 = account.BillingStreet;
			address.City = account.BillingCity;
			address.Country = account.BillingCountry;
			address.PostalCode = account.BillingPostalCode;
			address.Region = account.BillingState;
			address.AddressType = 'STREET';

			contact.Addresses = new List<QKXERO_Contact.Address>{address};

			// Add phone information
			QKXERO_Contact.Phone phone = new QKXERO_Contact.Phone();
			phone.PhoneType = 'DEFAULT';
			phone.PhoneNumber = account.Phone;

			contact.Phones = new List<QKXERO_Contact.Phone>{phone};

			

			contacts.add(contact);
		}
		contacts = QKXERO_Contact.saveXero(contacts);
		Map<String, QKXERO_Contact> contactsMap = new Map<String, QKXERO_Contact>();
		for(QKXERO_Contact contact : contacts){
			contactsMap.put(contact.Name, contact);
		}

		for(Params param : params){
			try{
				toUpdateAccounts.add(new Account(
					Id = param.accountId,
					Xero_Id__c = contactsMap.get(param.lookupName).ContactId
				));
			}catch(Exception e){
				// Do nothing
			}
		}

		update toUpdateAccounts;	
		*/
	}

	public class Params {
		@InvocableVariable(required=true)
		public Id accountId;

		@InvocableVariable(required=true)
		public String lookupName;
	}
}