public with sharing class ActionFunctionCaseNotificationController {
	
	public string caseId {get;set;}
	public Map<Id, CaseWrapper> mCaseWrappers {get;set;} { mCaseWrappers = new Map<Id, CaseWrapper>();}
	
	public void addCaseId(){
		Case tmpCase = [SELECT Id, caseNumber, status, priority, owner.name, account.name, contact.name,
							(SELECT Id, commentBody, createdBy.Name, createdDate
							FROM CaseComments
							ORDER BY CreatedDate desc
							LIMIT 5)
						FROM Case
						WHERE Id = :caseId];
		CaseWrapper cw = new CaseWrapper();
		cw.c = tmpCase;
		cw.ts = system.now();
		mCaseWrappers.put(cw.c.Id, cw);
	}
	
	public List<CaseWrapper> getCases(){
		List<CaseWrapper> cases = mCaseWrappers.values();
		cases.sort();
		return cases;
	}
	
	public List<CaseData> getStatusData(){
		List<CaseData> statusData = new List<CaseData>();
		List<AggregateResult> arStatuses = [SELECT status status, COUNT(Id) nRecs
											FROM Case
											WHERE isClosed = false
											GROUP BY status];
		for(AggregateResult ar : arStatuses){
			statusData.add(new CaseData((string)ar.get('status'), (integer)ar.get('nRecs')));
		}
		return statusData;
	}
	
	public List<CaseData> getPriorityData(){
		List<CaseData> priorityData = new List<CaseData>();
		List<AggregateResult> arPriorities = [SELECT priority priority, COUNT(Id) nRecs
											FROM Case
											WHERE isClosed = false
											GROUP BY priority];
		for(AggregateResult ar : arPriorities){
			priorityData.add(new CaseData((string)ar.get('priority'), (integer)ar.get('nRecs')));
		}
		return priorityData;
	}
	
	public class CaseData{
		public string value {get;private set;}
		public integer nRecs {get;private set;}
		
		public CaseData(string val, integer n){
			value = val;
			nRecs = n;
		}
	}
	
	
	
	public class CaseWrapper implements Comparable{
		public Case c {get;set;}
		public DateTime ts {get;set;}
		
		//Return a descending timestamp sort, with the latest timestamp first after sort
		public integer compareTo(Object compareTo){
			CaseWrapper wrapperCompareTo = (CaseWrapper)compareTo;
			if(ts == wrapperCompareTo.ts){
				return 0;
			}else if(ts > wrapperCompareTo.ts){
				return -1;
			}else{
				return 1;
			}
		}
	}
}