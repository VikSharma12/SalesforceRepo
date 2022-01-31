import { LightningElement, track } from 'lwc';

export default class ParentComponent extends LightningElement {
    input;
    selected = false;
    @track list = [];
    addInputToList(event)
    {
        console.log("Parent:: addInputToList");
        var temp=this.template.querySelector("lightning-input");
        this.input = temp.value
        console.log(this.input);
        this.list.push(this.input);
        if(this.list !=null){
            this.selected = true;
        }
        console.log(this.list);
    }

    
    handleSelect(event){
        console.log("Parent:: handleSelect");
        event.preventDefault();
        //console.log(event.target);
        if(event.detail !=null){
            this.selected = true;
            this.input  = event.detail;
        }
        console.log("details");
        console.log(event.detail);
        // const selectInput = new CustomEvent ('inputitemselect', {
        //     bubbles : true
        //     });
        // this.dispatchEvent(selectInput);
       //var temp=this.template.querySelector("c-child-component");
        //this.dispatchEvent(new CustomEvent('inputitemselect',{detail: this.input}));

    }
}