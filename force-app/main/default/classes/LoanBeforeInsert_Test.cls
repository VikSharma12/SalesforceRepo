@isTest
private class LoanBeforeInsert_Test {
	@isTest
    private static void verifyLoanBefore(){
        //update list
        List<Book__c> testBooks = new List<Book__c>();
        
        //load test data
        Book__c b = new Book__c(
        	Name = 'Test Book',
            Subject__c = 'AWS',
            Number_of_Books_Available__c = 100,
            Number_of_Books_Loaned_Out__c = 0
        );
        testBooks.add(b);
        
         Book__c b2 = new Book__c(
        	Name = 'Test Book',
            Subject__c = 'Salesforce',
            Number_of_Books_Available__c = 100,
            Number_of_Books_Loaned_Out__c = 0
        );
        
        testBooks.add(b2);
        
        Book__c b3 = new Book__c(
        	Name = 'Test Book',
            Subject__c = 'AWS',
            Number_of_Books_Available__c = 0,
            Number_of_Books_Loaned_Out__c = 0
        );
        
        testBooks.add(b3);
        insert testBooks;
        
        Reader__c r = new Reader__c(
        	Name = 'Test Reader',
            Subject__c = 'AWS',
            Number_of_Books_Borrowed__c = 0
        );
        insert r;
        
        Loan__c loan = new Loan__c(
        	Name = 'Test Loan',
            Book__c = b.Id,
            Reader__c = r.Id
        ); 
        
        Loan__c loan2 = new Loan__c(
        	Name = 'Test Loan2',
            Book__c = b2.Id,
            Reader__c = r.Id
        ); 
        
        Loan__c loan3 = new Loan__c(
        	Name = 'Test Loan3',
            Book__c = b3.Id,
            Reader__c = r.Id
        ); 
        
        //verify results
        Test.startTest();
        	insert loan;
        	
        	//check happy path of successful insert
        	Book__c bCheck = [SELECT Id, Number_of_Books_Available__c, Number_of_Books_Loaned_Out__c FROM Book__c WHERE Id = :b.id];
        	System.assertEquals(1, bCheck.Number_of_Books_Loaned_Out__c);
        	System.assertEquals(99, bcheck.Number_of_Books_Available__c);
        	
        	//check sad path of unsuccessful inserts
        	DmlException dmlError;
        	try{
                insert loan2;
            }catch (DmlException d){
                dmlError = d;
            }
        	
        	System.assertEquals('Subject of Book and Reader must be the same!', dmlError.getDmlMessage(0));
        
        	try{
                insert loan3;
            }catch (DmlException d){
                dmlError = d;
            }
        	
        	System.assertEquals('There are no copies of that book available!', dmlError.getDmlMessage(0));
        Test.stopTest();
    }
}