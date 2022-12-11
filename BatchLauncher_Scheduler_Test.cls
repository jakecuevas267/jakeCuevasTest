@IsTest
public class BatchLauncher_Scheduler_Test {
	static testMethod void launcherTest () {
		SubscriptionEffectiveDate_Batch launcher = new SubscriptionEffectiveDate_Batch();
		BatchLauncher_Scheduler scheduler = new BatchLauncher_Scheduler(launcher, 200, 'Test Name');
		Id result = scheduler.schedule('0 0 * * * ? *');
		Boolean success;

		System.assertNotEquals(null, result, 'First schedule attempt should have succeeded');

		try {
			result = scheduler.schedule('* * * * * ? *');
			success = true;
		} catch(StringException se) {
			success = false;
		}

		System.assertEquals(false, success, 'Second schedule attempt should have failed');
	}

	static testMethod void executeTest () {
		BatchLauncher_Scheduler scheduler = new BatchLauncher_Scheduler(new SubscriptionEffectiveDate_Batch(), 200, 'Test Name');
		scheduler.execute(null);
		System.assertEquals(0, Limits.getEmailInvocations(),'We shouldn\'t have had an error email');
	}

	static testMethod void executeFailTest () {
		BatchLauncher_Scheduler scheduler = new BatchLauncher_Scheduler(new SubscriptionEffectiveDate_Batch(), 0, 'Test Name');
		Test.startTest();
		scheduler.execute(null);
		System.assertNotEquals(0, Limits.getEmailInvocations(), 'We should have had an error email');
		Test.stopTest();
	}
}