import { LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountList extends LightningElement {
    accounts = [];
    errorMessage;

    connectedCallback() {
        this.loadAccounts();
    }

    async loadAccounts() {
        try {
            this.accounts = await getAccounts({ limitCount: 10 });
        } catch (error) {
            this.errorMessage = error?.body?.message || 'Unable to load accounts';
        }
    }

    get hasAccounts() {
        return this.accounts.length > 0;
    }
}
