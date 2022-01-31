import { LightningElement, api, wire, track } from 'lwc';
import getCurrentAccount from '@salesforce/apex/AccountList.getCurrentAccount';
import getContacts from '@salesforce/apex/AccountList.getContacts';

export default class AccountDetails extends LightningElement {
    @track myacc = "";
    @track currentAccount;
    @track currentContacts;

    @api
    get acc(){
        return this.myacc;
    }

    set acc(value){
        this.myacc = value;
    }

    @wire(getCurrentAccount, { accountId: '$myacc' })
    wiredCurrentAcount({ error, data }) {
        if (data) {
            this.currentAccount = data;
        }else if (error){
            console.log(error);
        }
    }

    @wire(getContacts, { accountId: '$myacc' })
    wiredContacts({ error, data }){
        if (data){
            this.currentContacts = data;
        }else if (error){
            console.log(error);
        }
    }
}