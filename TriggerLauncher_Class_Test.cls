@IsTest
private class TriggerLauncher_Class_Test {
	static testMethod void testInsert(){
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

		Test.startTest();
		try {
			insert testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void testUpdate(){
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
			testSubscription.Name = 'Updated Name';
			update testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void testDelete(){
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
			delete testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	static testMethod void testUndelete(){
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
		delete testSubscription;

		Test.startTest();
		try {
			undelete testSubscription;
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	@TestSetup
	static void createTestData() {
		Test.startTest();
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System');
		Customer testCustomer = new Customer(Name = 'Test Customer');

		insert testSolarSystem;
		insert testCustomer;
		Test.stopTest();
	}
}