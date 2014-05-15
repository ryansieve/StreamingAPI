@isTest
private class RemoteActionCaseNotificationTest {

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
        
        	Case c1 = RemoteActionCaseNotificationsController.returnCase(case1.Id);
        	system.assertEquals(c1.Id, case1.Id);
        	system.assertEquals(c1.status, case1.status);
        	
        	Case c2 = RemoteActionCaseNotificationsController.returnCase(case2.Id);
        	system.assertEquals(c2.Id, case2.Id);
        	system.assertEquals(c2.status, case2.status);
        	
        	
        test.stopTest();
    }
}