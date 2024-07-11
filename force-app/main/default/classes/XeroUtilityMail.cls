/*
* Author - Princee Soni
* Date - 
*
*/ 

public class XeroUtilityMail {
    
    public static Blob pdfBlobs;
    public static String TName;
    
    Public static void confirmationEmail (Id WoId,String InvNumber,Id InvId,String emailAdd,String InvUrl,String strTemplate, Id ContactId)
    {

        system.debug('test : ' +WoId +'test : ' + InvNumber+'test : ' + InvId+'test : ' +emailAdd +'test : ' +InvUrl );
        Attachment a = [select id,ParentId,Name,Body,BodyLength from Attachment where parentid = :WoId order by CreatedDate desc limit 1];
        List<String> mailId = new List<String>();
        if(!String.isEmpty(emailAdd))
        {
            mailId.add(emailAdd);
        }
        EmailTemplate emailTemp = [Select Body, htmlValue, Subject From EmailTemplate where DeveloperName =:strTemplate];
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        List<Messaging.SingleEmailMessage> email =new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        String tempSubject = emailTemp.Subject;
        tempSubject = tempSubject.replace('@invNumber', InvNumber);
        
        String tempBody = emailTemp.htmlValue;
        tempBody = tempBody.replace('@invUrl', InvUrl);
        tempBody = tempBody.replace('@invNumber', InvNumber);
        tempBody = tempBody.remove(']]>');
        tempBody = tempBody.remove('<![CDATA[');
        // Changes By sakina on 24th June 2024
        // msg.setSubject(tempSubject);
        // msg.setHtmlBody(tempBody); 
        msg.setTemplateId(emailTemp.Id);
        // Changes By sakina on 24th June 2024

        if(String.isNotBlank(system.Label.xero_orgwide_email))
        {
        	msg.setOrgWideEmailAddressId(system.Label.xero_orgwide_email);
        }
        
        msg.setToAddresses(mailId);
        msg.setSaveAsActivity(TRUE);
        msg.SetwhatId(Id.valueOf(InvId));
        msg.setTargetObjectId(ContactId);

        if(a != null ){
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.filename = a.Name;
            efa.setBody(a.Body);
            fileAttachments.add(efa);    
        } 
        msg.setFileAttachments(fileAttachments);
        email.add(msg);
        if(email != Null)
        {
            Messaging.sendEmail(email);
        }
        
    }
}