@isTest
private class ActionFunctionCaseNotificationTest {

    static testMethod void myUnitTest() {
        Account a = new Account(name = 'test');
        insert a;
        
        Case case1 = new Case(accountid = a.Id, status='New', Priority = 'Medium');
        Case case2 = new Case(accountid = a.Id, status='New', Priority = 'High');
        insert new List<Case>{case1, case2};
        
        
        CaseComment cc1 = new CaseComment(parentId = case1.Id, commentbody = 'test1');
        CaseComment cc2 = new CaseComment(parentId = case2.Id, commentbody = 'test2');
        
        insert new List<CaseComment>{cc1, cc2};
        
        test.startTest();
        
        	ActionFunctionCaseNotificationController con = new ActionFunctionCaseNotificationController();
        	con.caseId = case1.Id;
        	con.addCaseId();
        	
        	con.getCases();
        	con.getPriorityData();
        	con.getStatusData();
        	
        	system.assertEquals(con.mCaseWrappers.keySet().size(), 1, 'We are expecting a case loaded in to the map');
        	
        	con.caseId = case2.Id;
        	con.addCaseId();
        	
        	con.getCases();
        	con.getPriorityData();
        	con.getStatusData();
        	
        	system.assertEquals(con.mCaseWrappers.keySet().size(), 2, 'We are expecting both cases loaded in to the map');
        test.stopTest();
    }
}