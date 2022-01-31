import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement { 
    @api inputitem;

    
    fireSelectEvent(){
        console.log("Child:: fireSelectEvent" + this.inputitem);
        //this.dispatchEvent(new CustomEvent('inputitemselect',{detail: this.inputitem}));
        const event = new CustomEvent('inputitemselect', {
            // detail contains only primitives
            detail: this.inputitem
            });
        this.dispatchEvent(event);
    }
}