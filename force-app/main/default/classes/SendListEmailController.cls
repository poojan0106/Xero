public with sharing class SendListEmailController {
    
    public class EmailTemplateOption {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
    }

    @AuraEnabled(cacheable=true)
    public static List<EmailTemplateOption> getEmailTemplates() {
        List<EmailTemplateOption> options = new List<EmailTemplateOption>();
        List<EmailTemplate> emailTemplates = [SELECT Id, Name FROM EmailTemplate];
        
        for (EmailTemplate template : emailTemplates) {
            EmailTemplateOption option = new EmailTemplateOption();
            option.value = template.Id;
            option.label = template.Name;
            options.add(option);
        }
        
        return options;
    }

    @AuraEnabled
    public static void sendListEmail(List<Id> oppIds, Id emailTemplateId) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Id = :emailTemplateId];

        for (Id oppId : oppIds) {
            Opportunity opp = [SELECT Id, Name, Primary_Contact__c, Primary_Contact__r.Email FROM Opportunity WHERE Id = :oppId];

            if (opp.Primary_Contact__r.Email != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{opp.Primary_Contact__r.Email});
                email.setSubject(emailTemplate.Subject);
                
                if (emailTemplate.HtmlValue != null) {
                    email.setHtmlBody(emailTemplate.HtmlValue);
                } else {
                    email.setPlainTextBody(emailTemplate.Body);
                }
                
                emailMessages.add(email);
            }
        }

        if (!emailMessages.isEmpty()) {
            Messaging.sendEmail(emailMessages, false);
        }
    }
}