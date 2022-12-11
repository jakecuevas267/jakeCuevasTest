@IsTest
private class Handler_Subscription_Test{
	static testMethod void syncDatesAndStatusInsertActive(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
			, Name = 'Test Subscription 2'
		);

		Test.startTest();
		insert testSubscription2;
		Test.stopTest();

		System.assertEquals('Active', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 2'
		].Status__c);
	}

	static testMethod void syncDatesAndStatusInsertInactive(){
		Subscription__c testSubscription = [SELECT Id FROM Subscription__c WHERE Name = 'Test Subscription 1'];

		testSubscription.Start_Date__c = Date.today().addDays(-7);
		testSubscription.End_Date__c = Date.today().addDays(-3);

		Test.startTest();
		update testSubscription;
		Test.stopTest();

		System.assertEquals('Inactive', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 1'
		].Status__c);
	}

	static testMethod void syncDatesAndStatusUpdateActive(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(7)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
			, Name = 'Test Subscription 2'
		);

		insert testSubscription2;

		testSubscription2.Start_Date__c = Date.today();
		testSubscription2.End_Date__c = Date.today().addDays(3);

		Test.startTest();
		update testSubscription2;
		Test.stopTest();

		System.assertEquals('Active', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 2'
		].Status__c);
	}

	static testMethod void syncDatesAndStatusUpdateInactive(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
			, Name = 'Test Subscription 2'
		);

		insert testSubscription2;

		testSubscription2.Start_Date__c = Date.today().addDays(-3);
		testSubscription2.End_Date__c = Date.today().addDays(-1);

		Test.startTest();
		update testSubscription2;
		Test.stopTest();

		System.assertEquals('Inactive', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 2'
		].Status__c);
	}

	static testMethod void checkEffectiveDatesInsertTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Test.startTest();
		try {
			Subscription__c testSubscription = new Subscription__c(
				Solar_System__c = testSolarSystem.Id
				, Customer__c = testCustomer.Id
				, Start_Date__c = Date.today().addDays(14)
				, End_Date__c = Date.today().addDays(21)
				, Status__c = 'Active'
			);

			insert testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void checkEffectiveDatesInsertFailTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Test.startTest();
		try {
			Subscription__c testSubscription = new Subscription__c(
				Solar_System__c = testSolarSystem.Id
				, Customer__c = testCustomer.Id
				, Start_Date__c = Date.today()
				, End_Date__c = Date.today().addDays(21)
				, Status__c = 'Active'
			);

			insert testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	static testMethod void checkEffectiveDatesUpdateStatusActiveTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(14)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
		);

		insert testSubscription;

		Test.startTest();
		try {
			testSubscription.Status__c = 'Active';
			update testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void checkEffectiveDatesUpdateStatusInactiveTest(){
		Subscription__c testSubscription = [SELECT Id FROM Subscription__c WHERE Name = 'Test Subscription 1'];

		testSubscription.Status__c = 'Inactive';

		Test.startTest();
		update testSubscription;
		Test.stopTest();

		System.assertEquals(Date.today(),[
			SELECT End_Date__c
			FROM Subscription__c
			WHERE Id = :testSubscription.Id
		].End_Date__c);
	}

	static testMethod void checkEffectiveDatesUpdateStatusFailTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-3)
			, End_Date__c = Date.today().addDays(-1)
			, Status__c = 'Inactive'
		);

		insert testSubscription;

		Test.startTest();
		try {
			testSubscription.Status__c = 'Active';
			testSubscription.Start_Date__c = Date.today();
			testSubscription.End_Date__c = Date.today().addDays(7);
			update testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	static testMethod void checkEffectiveDatesUpdateDateTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(14)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription;

		Test.startTest();
		try {
			testSubscription.Start_Date__c = Date.today().addDays(16);
			update testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void checkEffectiveDatesUpdateDateFailTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		String message;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(14)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription;

		Test.startTest();
		try {
			testSubscription.Start_Date__c = Date.today();
			update testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	static testMethod void checkEffectiveDatesUndeleteTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Subscription__c testSubscription = [SELECT Id FROM Subscription__c WHERE Name = 'Test Subscription 1'];
		String message;

		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(14)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
		);

		insert testSubscription2;
		delete testSubscription2;

		Test.startTest();
		try {
			undelete testSubscription2;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void checkEffectiveDatesUndeleteFailTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Subscription__c testSubscription = [SELECT Id FROM Subscription__c WHERE Name = 'Test Subscription 1'];
		String message;

		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(14)
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription2;
		delete testSubscription;

		testSubscription2.Start_Date__c = Date.today();
		update testSubscription2;

		Test.startTest();
		try {
			undelete testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	static testMethod void insertSolarSystemActiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Test.startTest();
		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void insertSolarSystemInactiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = true
		);

		insert testSolarSystem;

		Test.startTest();
		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
		);

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void updateSolarSystemActiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-3)
			, End_Date__c = Date.today().addDays(-1)
			, Status__c = 'Inactive'
		);

		insert testSubscription;

		testSubscription.Status__c = 'Active';

		Test.startTest();
		update testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void updateSolarSystemInactiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = true
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription;

		testSubscription.Status__c = 'Inactive';

		Test.startTest();
		update testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void deleteSolarSystemActiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription;

		Test.startTest();
		delete testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void deleteSolarSystemInactiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = true
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
		);

		insert testSubscription;

		Test.startTest();
		delete testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void undeleteSolarSystemActiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = false
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		insert testSubscription;

		Test.startTest();
		delete testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void undeleteSolarSystemInactiveTest(){
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];
		Solar_System__c testSolarSystem = new Solar_System__c(
			Name = 'Test Solar System 2'
			, Active__c = true
		);

		insert testSolarSystem;

		Subscription__c testSubscription = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Inactive'
		);

		insert testSubscription;

		Test.startTest();
		delete testSubscription;

		System.assertEquals(1, Limits.getQueueableJobs());
		Test.stopTest();
	}

	static testMethod void checkEffectiveDatesInsertTwoRecordsFailTest(){
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System 2');
		Customer testCustomer = new Customer(Name = 'Test Customer 2');
		String message;

		insert testSolarSystem;
		insert testCustomer;

		Subscription__c testSubscription =  new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(7)
			, Status__c = 'Active'
			, Name = 'Test Subscription 1'
		);
		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(21)
			, Status__c = 'Active'
		);

		Test.startTest();
		try {
			insert new List<Subscription__c>{testSubscription, testSubscription2};
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	static testMethod void checkEffectiveDatesUpdateTwoRecordsFailTest(){
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System 2');
		Customer testCustomer = new Customer(Name = 'Test Customer 2');
		String message;

		insert testSolarSystem;
		insert testCustomer;

		Subscription__c testSubscription =  new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-1)
			, End_Date__c = Date.today().addDays(-3)
			, Status__c = 'Inactive'
			, Name = 'Test Subscription 1'
		);
		Subscription__c testSubscription2 = new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-1)
			, End_Date__c = Date.today().addDays(-3)
			, Status__c = 'Inactive'
		);

		insert new List<Subscription__c>{testSubscription, testSubscription2};

		testSubscription.Status__c = 'Active';
		testSubscription.Start_Date__c = Date.today();
		testSubscription.End_Date__c = Date.today().addDays(3);
		testSubscription2.Status__c = 'Active';
		testSubscription2.Start_Date__c = Date.today();
		testSubscription2.End_Date__c = Date.today().addDays(3);
		Test.startTest();
		try {
			update new List<Subscription__c>{testSubscription, testSubscription2};
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message.contains('There can only be one Subscription Active at a time for a Solar System'));
	}

	@TestSetup
	static void createTestData() {
		Test.startTest();
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System');
		Customer testCustomer = new Customer(Name = 'Test Customer');

		insert testSolarSystem;
		insert testCustomer;

		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(7)
			, Status__c = 'Active'
			, Name = 'Test Subscription 1'
		);
		Test.stopTest();
	}
}