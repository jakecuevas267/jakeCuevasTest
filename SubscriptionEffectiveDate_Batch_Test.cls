@IsTest
private class SubscriptionEffectiveDate_Batch_Test {
	static testMethod void updateSubscriptionInactiveTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];

		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-7)
			, End_Date__c = Date.today()
			, Status__c = 'Active'
			, Name = 'Test Subscription 1'
		);

		Test.startTest();
		Database.executeBatch(new SubscriptionEffectiveDate_Batch());
		Test.stopTest();

		System.assertEquals('Inactive', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 1'
			LIMIT 1
		].Status__c);
	}

	static testMethod void updateSubscriptionActiveTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];

		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today()
			, End_Date__c = Date.today().addDays(7)
			, Status__c = 'Inactive'
			, Name = 'Test Subscription 1'
		);

		Test.startTest();
		Database.executeBatch(new SubscriptionEffectiveDate_Batch());
		Test.stopTest();

		System.assertEquals('Active', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 1'
			LIMIT 1
		].Status__c);
	}

	static testMethod void unchangedSubscriptionInactiveTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];

		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-14)
			, End_Date__c = Date.today().addDays(-7)
			, Status__c = 'Inactive'
			, Name = 'Test Subscription 1'
		);

		Test.startTest();
		Database.executeBatch(new SubscriptionEffectiveDate_Batch());
		Test.stopTest();

		System.assertEquals('Inactive', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 1'
			LIMIT 1
		].Status__c);
	}


	static testMethod void unchangedSubscriptionActiveTest(){
		Solar_System__c testSolarSystem = [SELECT Id FROM Solar_System__c WHERE Name = 'Test Solar System' LIMIT 1];
		Customer testCustomer = [SELECT Id FROM Customer WHERE Name = 'Test Customer' LIMIT 1];

		insert new Subscription__c(
			Solar_System__c = testSolarSystem.Id
			, Customer__c = testCustomer.Id
			, Start_Date__c = Date.today().addDays(-1)
			, End_Date__c = Date.today().addDays(7)
			, Status__c = 'Active'
			, Name = 'Test Subscription 1'
		);

		Test.startTest();
		Database.executeBatch(new SubscriptionEffectiveDate_Batch());
		Test.stopTest();

		System.assertEquals('Active', [
			SELECT Status__c
			FROM Subscription__c
			WHERE Name = 'Test Subscription 1'
			LIMIT 1
		].Status__c);
	}

	@TestSetup
	static void createTestData() {
		Test.startTest();
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System', Active__c = false);
		Solar_System__c testSolarSystem2 = new Solar_System__c(Name = 'Test Solar System 2', Active__c = false);
		Customer testCustomer = new Customer(Name = 'Test Customer');
		Customer testCustomer2 = new Customer(Name = 'Test Customer 2');

		insert new List<Solar_System__c>{testSolarSystem, testSolarSystem2};
		insert new List<Customer>{testCustomer, testCustomer2};
		Test.stopTest();
	}
}