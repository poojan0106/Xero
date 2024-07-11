import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEmailTemplates from '@salesforce/apex/SendListEmailController.getEmailTemplates';
import sendListEmail from '@salesforce/apex/SendListEmailController.sendListEmail';

export default class SendListEmailFromOpp extends LightningElement {
    @api selectedOpportunityIds;
    emailTemplates;
    selectedTemplateId;

    @wire(getEmailTemplates)
    wireEmailTemplates({ error, data }) {
        if (data) {
            this.emailTemplates = data;
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading email templates',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        }
    }

    handleTemplateChange(event) {
        this.selectedTemplateId = event.target.value;
    }

    handleSendListEmail() {
        console.log("handleSendListEmail called");
        const oppIds = this.selectedOpportunityIds;
        if (oppIds.length === 0 || !this.selectedTemplateId) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select at least one opportunity and an email template.',
                    variant: 'error',
                }),
            );
            return;
        }

        sendListEmail({ oppIds: oppIds, emailTemplateId: this.selectedTemplateId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Emails sent successfully',
                        variant: 'success',
                    }),
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error sending emails',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}