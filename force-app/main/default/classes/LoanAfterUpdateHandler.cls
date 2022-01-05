public class LoanAfterUpdateHandler {
	List<Loan__c> newLoan;
    
    //constructor - List of the new Loan records is expected as input
    public LoanAfterUpdateHandler(List<Loan__c> newTriggerLoan){
        newLoan = newTriggerLoan;
    }
    
    //update reader and book records accordingly
    public void LoanAfterUpdate(){
        
            Set<Id> bookIds = new Set<Id>();
            Set<Id> readerIds = new Set<Id>();
            
            //update lists
            List<Book__c> updateBooks = new List<Book__c>();
            List<Reader__c> updateReaders = new List<Reader__c>();
            
            // Find all unique referenced books and readers
            for (Loan__c loan : newLoan) {
                bookIds.add(loan.Book__c);
                readerIds.add(loan.Reader__c);
            }
            // Load the unique book and reader records so we have access to the needed fields
            Map<Id, Book__c> booksById = new Map<Id, Book__c>(
                [SELECT Id, Number_of_Books_Available__c, Number_of_Books_Loaned_Out__c FROM Book__c WHERE Id IN :bookIds]);
            Map<Id, Reader__c> readersById = new Map<Id, Reader__c>(
                [SELECT Id, Number_of_Books_Borrowed__c FROM Reader__c WHERE Id IN :readerIds]);
            
            for (Loan__c loan : newLoan){
                //check if loan is inactive and has a return date
                if(loan.Active__c == False && loan.Date_Returned__c != null){
                    //adjust book and reader number fields
                    Book__c b = booksById.get(loan.Book__c);
                    b.Number_of_Books_Available__c = b.Number_of_Books_Available__c + 1;
                    b.Number_of_Books_Loaned_Out__c = b.Number_of_Books_Loaned_Out__c - 1;
                    updateBooks.add(b);
                    
                    Reader__c r = readersById.get(loan.Reader__c);
                    r.Number_of_Books_Borrowed__c = r.Number_of_Books_Borrowed__c - 1;
                    updateReaders.add(r);
                } else if(loan.Active__c == False && loan.Date_Returned__c == null){
                    loan.addError('An in-active loan must have an return date!');
                    return;
                } else if(loan.Active__c == True && loan.Date_Returned__c != null){
                    loan.addError('An active loan cannot have a return date!');
                    return;
                }
                
            }
            update updateBooks;
            update updateReaders;
       
    }
}