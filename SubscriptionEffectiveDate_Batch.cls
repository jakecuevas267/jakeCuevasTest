public without sharing class SubscriptionEffectiveDate_Batch extends BatchLauncher implements Database.Batchable<SObject>, Database.Stateful {
	public SubscriptionEffectiveDate_Batch(){
		super();

		queryString = 'SELECT Id, Solar_System__c, Start_Date__c, End_Date__c, Status__c'
			+ ' FROM Subscription__c'
			+ ' WHERE (End_Date__c = TODAY AND Status__c = \'Active\')'
				+ ' OR (Start_Date__c = TODAY AND Status__c = \'Inactive\')';

		objectString = 'Subscription Effective Date Batch Process';
	}

	public override List<SObject> processRecords(List<SObject> scope) {
		Map<Id, Subscription__c> subscriptionUpdateMap = new Map<Id, Subscription__c>();

		for (Subscription__c subscription : (List<Subscription__c>) scope) {
			if (subscription.Start_Date__c == Date.today() && subscription.Status__c == 'Inactive'){
				subscription.Status__c = 'Active';
				subscriptionUpdateMap.put(subscription.Id, subscription);
			} else if (subscription.End_Date__c == Date.today() && subscription.Status__c == 'Active'){
				subscription.Status__c = 'Inactive';
				subscriptionUpdateMap.put(subscription.Id, subscription);
			}
		}

		if (!subscriptionUpdateMap.isEmpty()){
			Database.update(subscriptionUpdateMap.values(), false);
		}

		return new List<SObject>();
	}
}