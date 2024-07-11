public class XeroContact {

    public String ContactID;
	public String ContactStatus;
	public String Name;
	public String FirstName;
	public String LastName;
    public String ContactNumber;
	public String EmailAddress;
	public String BankAccountDetails;
	public List<Address> Addresses;
	public List<Phone> Phones;
	public String UpdatedDateUTC;
	public Boolean IsSupplier;
	public Boolean IsCustomer;
	public Boolean HasAttachments;
	public Boolean HasValidationErrors;
    public List<XeroValidationError> ValidationErrors;
    
    public class Address {
        public String AddressType; // POBOX, STREET
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String City;
        public String Region;
        public String PostalCode;
        public String Country;
        public String AttentionTo;
        
        public Address (Account account, String addressType, String addressLine1) {
            
            this.AddressType = addressType;
            
            if (addressType == 'POBOX') {
                //as a postal adress
                if(AddressLine1 != '')
                {
                    this.AddressLine1 = addressLine1;
                }
                this.AddressLine2 = account.BillingStreet;
                this.City = account.BillingCity;
                this.Region = account.BillingState;
                this.PostalCode = account.BillingPostalCode;
                this.Country = account.BillingCountry;
            }
           
        }
    }

    public class Phone {

        public String PhoneType; // DEFAULT, DDI, MOBILE, FAX
        public String PhoneNumber;
        //public String PhoneAreaCode;
        //public String PhoneCountryCode;

        public Phone(String phoneNumber, String phoneType) {

            this.PhoneType = phoneType;
            this.PhoneNumber = phoneNumber;
        }   
    }
    
    // Constructor to convert Salesforce Account
    // To a Xero Contact
    public XeroContact(Account account) {

        
        if(account.Xero_ID__c != null && account.Xero_ID__c != '' )
        {
            this.ContactID = account.Xero_ID__c;
        }
        
        //this.ContactStatus = 'ACTIVE';
        //this.Name = account.Name;
        
        this.EmailAddress = account.Xero_Email__c;
        this.Addresses = new List<Address>();
        this.Phones = new List<Phone>();

        if(account.Name != null && account.Name != ''){
            this.Name = account.Name;
        }
        
        if(account != null)
        {
            this.addAddresses(account); 
        }

        String PhoneType = 'DEFAULT';
        this.addPhones(account.Phone,PhoneType);
    }

    
    public XeroContact(String xeroContactId) {
        this.ContactID = xeroContactId;
    }

    public void addAddresses(Account account) {

        String addressLine1 = '';
       /* if(account.Name != contact.LastName){
            addressLine1 = account.Name;
        }*/
        
        if (String.isNotBlank(account.BillingStreet)) {
            
            System.debug('!!!@@@ addressLine1 :'+addressLine1);
            System.debug('!!!@@@ contact.account.BillingStreet :'+account.BillingStreet);
 
            this.Addresses.add(new Address(account, 'POBOX', addressLine1));
        }

    }

    public void addPhones(String Phone, String PhoneType) {

        if (String.isNotBlank(Phone)) {
            this.Phones.add(new Phone(Phone, PhoneType));
        }
        
		/*
        if (String.isNotBlank(account.Fax)) {
            this.Phones.add(new Phone(account.Fax, 'FAX'));
        }

        if (!account.Contacts.isEmpty() && String.isNotBlank(account.Contacts[0].MobilePhone)) {
            this.Phones.add(new Phone(account.Contacts[0].MobilePhone, 'MOBILE'));
        }*/
    }

    // Serialise to JSON String for Xero
    public String serialize() {
        return JSON.serialize(this, true);
    }

}