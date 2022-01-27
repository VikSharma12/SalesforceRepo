import { LightningElement, track, wire } from 'lwc';
import getRates from '@salesforce/apex/Currencies.getRates';

export default class Currency extends LightningElement {
    @track rates =[];
    allData = [];

    @wire(getRates)
    wiredRates({error, data}){
        if (data){
            for (let key in data){
                this.rates.push({value:data[key], key:key});
            } 
            this.allData = this.rates;
        } else if (error){
                console.log(error);
        }
    }

    updateSearch(e){
        var regex = new RegExp(e.target.value,'gi')
        this.rates = this.allData.filter(
            row => regex.test(row.key)
        );
    }

}