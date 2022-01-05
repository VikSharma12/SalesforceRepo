public class LoanBeforeInsertHandler {
	List<Loan__c> newLoan;
    
    //constructor - List of the new Loan records is expected as input
    public LoanBeforeInsertHandler(List<Loan__c> newTriggerLoan){
        newLoan = newTriggerLoan;
    }
    
    //validate records and update book/reader accordingly
    public void LoanBeforeInsert(){
        	
            Set<Id> bookIds = new Set<Id>();
            Set<Id> readerIds = new Set<Id>();
            
            //update lists
            List<Book__c> updateBooks = new List<Book__c>();
            List<Reader__c> updateReaders = new List<Reader__c>();
        	List<Task> reminders = new List<Task>();
            
            // Find all unique referenced books and readers
            for (Loan__c loan : newLoan) {
                bookIds.add(loan.Book__c);
                readerIds.add(loan.Reader__c);
            }
        
            // Load the unique book and reader records so we have access to the required fields
            Map<Id, Book__c> booksById = new Map<Id, Book__c>(
                [SELECT Id, Subject__c, Number_of_Books_Available__c, Number_of_Books_Loaned_Out__c FROM Book__c WHERE Id IN :bookIds]);
            Map<Id, Reader__c> readersById = new Map<Id, Reader__c>(
                [SELECT Id, Subject__c, Number_of_Books_Borrowed__c FROM Reader__c WHERE Id IN :readerIds]);
            
            // validate records
            for (Loan__c loan : newLoan) {
                //Check that the newly created loans have matching book and reader subjects
                if (booksById.get(loan.Book__c).Subject__c !=
                    readersById.get(loan.Reader__c).Subject__c) {
                    loan.addError('Subject of Book and Reader must be the same!');
                    return;
                } 
                //check if books are available
                If (booksById.get(loan.Book__c).Number_of_Books_Available__c <= 0){
                    loan.addError('There are no copies of that book available!');
                    return;
                }
                
                //adjust book and reader number fields
                Book__c b = booksById.get(loan.Book__c);
                b.Number_of_Books_Available__c = b.Number_of_Books_Available__c - 1;
                b.Number_of_Books_Loaned_Out__c = b.Number_of_Books_Loaned_Out__c + 1;
                updateBooks.add(b);
                
                Reader__c r = readersById.get(loan.Reader__c);
                r.Number_of_Books_Borrowed__c = r.Number_of_Books_Borrowed__c + 1;
                updateReaders.add(r);
                
                //create reminder task
                Task reminder = new Task();
                reminder.subject = 'Remind Revol to return book';
                reminder.ActivityDate = date.today() + 14;
                reminder.Description = 'The loan name is: '+loan.Name;
                reminders.add(reminder);
            }
            update updateBooks;
            update updateReaders;
        	insert reminders;

    }
}