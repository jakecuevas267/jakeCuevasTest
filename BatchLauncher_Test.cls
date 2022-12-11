@IsTest
private class BatchLauncher_Test {
	static testMethod void testStart(){
		SubscriptionEffectiveDate_Batch testBatch = new SubscriptionEffectiveDate_Batch();
		Id batchId = Database.executeBatch(testBatch);
		Database.QueryLocator result;

		Test.startTest();
		result = testBatch.start(new MockBatchableContext(batchId, null));
		Test.stopTest();

		System.assertNotEquals(null, result);
	}

	static testMethod void testStartFail(){
		SubscriptionEffectiveDate_Batch testBatch = new SubscriptionEffectiveDate_Batch();
		testBatch.queryString = 'null null null';
		Id batchId = Database.executeBatch(testBatch);
		Database.QueryLocator result;

		Test.startTest();
		result = testBatch.start(new MockBatchableContext(batchId, null));
		Test.stopTest();

		System.assertEquals(null, result);
	}

	static testMethod void testExecute(){
		SubscriptionEffectiveDate_Batch testBatch = new SubscriptionEffectiveDate_Batch();
		Id batchId = Database.executeBatch(testBatch);
		String message;

		Test.startTest();
		try{
			testBatch.execute(new MockBatchableContext(batchId, null), new List<SObject>());
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void testExecuteFail(){
		SubscriptionEffectiveDate_Batch testBatch = new SubscriptionEffectiveDate_Batch();
		Id batchId = Database.executeBatch(testBatch);
		String message;

		Test.startTest();
		try{
			testBatch.execute(new MockBatchableContext(batchId, null), null);
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert([
			SELECT COUNT()
			FROM AsyncApexJob
			WHERE JobType='BatchApex'
			AND Status IN ('Processing','Preparing','Queued')
		] == 0);
	}

	static testMethod void testFinish(){
		SubscriptionEffectiveDate_Batch testBatch = new SubscriptionEffectiveDate_Batch();
		Id batchId = Database.executeBatch(testBatch);
		String message;

		Test.startTest();
		try{
			testBatch.finish(new MockBatchableContext(batchId, null));
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	public class MockBatchableContext implements Database.BatchableContext {
		private Id jobId;
		private Id childJobId;

		public MockBatchableContext(Id jobId, Id childJobId) {
			this.jobId = jobId;
			this.childJobId = childJobId;
		}

		public Id getJobId() {
			return jobId;
		}

		public Id getChildJobId() {
			return childJobId;
		}
	}

	public virtual class MockBatchableException extends Exception {}
}