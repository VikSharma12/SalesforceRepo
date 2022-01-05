@isTest
private class LoanAfterInsert_Test {
	@isTest
    private static void verifyLoanAfter(){

        //load test data
        Book__c b = new Book__c(
        	Name = 'Test Book',
            Subject__c = 'AWS',
            Number_of_Books_Available__c = 100,
            Number_of_Books_Loaned_Out__c = 0
        );
        insert b;
        
        Reader__c r = new Reader__c(
        	Name = 'Test Reader',
            Subject__c = 'AWS',
            Number_of_Books_Borrowed__c = 0
        );
        insert r;
        
        Loan__c loan = new Loan__c(
        	Name = 'Test Loan',
            Book__c = b.Id,
            Reader__c = r.Id,
            Date_Loaned__c = date.today(),
            Active__c = True
        ); 
        
        insert loan;
        
        //verify results
        Test.startTest();
        	loan.Date_Returned__c = date.today();
        	loan.Active__c = False;
        
        	//update loan to trigger after update handler
        	update loan;
        	
        	//verify happy path results
        	Book__c bCheck = [SELECT Id, Number_of_Books_Available__c, Number_of_Books_Loaned_Out__c FROM Book__c WHERE Id = :b.id];
        	System.assertEquals(0, bCheck.Number_of_Books_Loaned_Out__c);
        	System.assertEquals(100, bCheck.Number_of_Books_Available__c);
        
        	//verify sad path results
        	DmlException dmlError;
        	
        	loan.Active__c = False;
        	loan.Date_Returned__c = null;
        	try{
                update loan;
            }catch(DmlException d){
                dmlError = d;
            }
        	System.assertEquals('An in-active loan must have an return date!', dmlError.getDmlMessage(0));
        
        	loan.Active__c = True;
        	loan.Date_Returned__c = date.today();
			try{
                update loan;
            }catch(DmlException d){
                dmlError = d;
            }
        	System.assertEquals('An active loan cannot have a return date!', dmlError.getDmlMessage(0));
        
        Test.stopTest();
    }
}