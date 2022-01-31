import { LightningElement, wire, track, api } from 'lwc';
import getAccounts from '@salesforce/apex/AccountList.getAccounts';

const actions = [
    { label: 'Show Details', name: 'show_details' }
];

const table_columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Description', fieldName: 'Description', type: 'text' },
    { type: 'action', typeAttributes: {rowActions: actions} }];

export default class AccountLwc extends LightningElement {

    @track selected = false;
    @track acc;

    columns = table_columns;

    @wire(getAccounts) accounts;


    handleRowAction(event){
        const row = event.detail.row;
        this.acc = row.Id;
        this.selected = true;
    }

}