trigger LoanInsert on Loan__c (before insert, after update) {
	//before trigger insert call handler
    if (Trigger.isbefore){
        if (Trigger.isInsert){
            LoanBeforeInsertHandler loanBeforeHandler = new LoanBeforeInsertHandler(Trigger.new);
            loanBeforeHandler.LoanBeforeInsert();
        }
    }
    
    //after trigger insert call handler
    if (Trigger.isAfter){
        if (Trigger.isUpdate){
            LoanAfterUpdateHandler LoanAfterHandler = new LoanAfterUpdateHandler(Trigger.new);
            LoanAfterHandler.LoanAfterUpdate();
        }
    }

}