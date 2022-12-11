@IsTest
private class UpdateRelatedSolarSystem_Queueable_Test {
	static testMethod void updateSolarSystemTest(){
		Solar_System__c testSolarSystem = new Solar_System__c(Name = 'Test Solar System');

		insert testSolarSystem;

		testSolarSystem.Name = 'Test Solar System 2';

		Test.startTest();
		System.enqueueJob(new UpdateRelatedSolarSystem_Queueable(new List<Solar_System__c>{testSolarSystem}));
		Test.stopTest();

		System.assertEquals('Test Solar System 2', [
			SELECT Name
			FROM Solar_System__c
			WHERE Id = :testSolarSystem.Id
		].Name);
	}
}