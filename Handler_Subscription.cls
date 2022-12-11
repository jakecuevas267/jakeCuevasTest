public without sharing class Handler_Subscription extends TriggerHandler_Class.Template {
	private Map<Id, Solar_System__c> solarSystemUpdateMap = new Map<Id, Solar_System__c>();
	public Map<Id, Subscription__c> newSubscriptionMap;
	public Map<Id, Subscription__c> oldSubscriptionMap;
	public List<Subscription__c> newSubscriptions;
	public List<Subscription__c> oldSubscriptions;

	public override String getTriggerName(){
		return 'Subscription';
	}

	public override void beforeInsert(){
		syncDatesAndStatus();
		checkEffectiveDates();
	}

	public override void afterInsert(){
		populateAfterVariables();
		updateSolarSystems();
	}

	public override void beforeUpdate(){
		syncDatesAndStatus();
		checkEffectiveDates();
	}
	public override void afterUpdate(){
		populateAfterVariables();
		updateSolarSystems();
	}

	public override void afterDelete(){
		populateAfterVariables();
		updateSolarSystems();
	}

	public override void afterUndelete(){
		checkEffectiveDates();
		populateAfterVariables();
		updateSolarSystems();
	}

	private void syncDatesAndStatus(){
		for (Subscription__c newSubscription : newSubscriptions) {
			Subscription__c oldSubscription = newSubscription.Id != null && oldSubscriptionMap != null
				&& oldSubscriptionMap.containsKey(newSubscription.Id)
				? oldSubscriptionMap.get(newSubscription.Id) : new Subscription__c();

			if ((oldSubscription.Start_Date__c != newSubscription.Start_Date__c
					|| oldSubscription.End_Date__c != newSubscription.End_Date__c)
				&& (newSubscription.Start_Date__c <= Date.today()
					&& newSubscription.End_Date__c > Date.today()
					&& newSubscription.Status__c == 'Inactive')
			){
				newSubscription.Status__c = 'Active';
			} else if ((oldSubscription.Start_Date__c != newSubscription.Start_Date__c
					|| oldSubscription.End_Date__c != newSubscription.End_Date__c)
				&& (newSubscription.Start_Date__c <= Date.today()
					&& newSubscription.End_Date__c < Date.today()
					&& newSubscription.Status__c == 'Active')
			){
				newSubscription.Status__c = 'Inactive';
			}

			if (newSubscription.Status__c == 'Inactive' && oldSubscription.Status__c != newSubscription.Status__c
				&& newSubscription.End_Date__c > Date.today()
			){
				//Assumes User can manually deactivate a Subscription
				newSubscription.End_Date__c = Date.today();
			}
		}
	}

	private void checkEffectiveDates(){
		Map<Id, Subscription__c> solarSystemIdSubscriptionMap = new Map<Id, Subscription__c>();
		Subscription__c currentSubscription;

		for (Subscription__c newSubscription : newSubscriptions){
			Subscription__c oldSubscription = newSubscription.Id != null && oldSubscriptionMap != null
				&& oldSubscriptionMap.containsKey(newSubscription.Id)
				? oldSubscriptionMap.get(newSubscription.Id) : new Subscription__c();

			if(newSubscription.Status__c == 'Active'
				&& (oldSubscription.Start_Date__c != newSubscription.Start_Date__c
					|| oldSubscription.End_Date__c != newSubscription.End_Date__c
					|| oldSubscription.Status__c != newSubscription.Status__c)
				&& !solarSystemIdSubscriptionMap.containsKey(newSubscription.Solar_System__c)
			){
				//No null check needed because its a required field
				solarSystemIdSubscriptionMap.put(newSubscription.Solar_System__c, newSubscription);
			} else if (solarSystemIdSubscriptionMap.containsKey(newSubscription.Solar_System__c)){
				newSubscription.addError('There can only be one Subscription Active at a time for a Solar System.'
					+ ' A Subscription is already Active for the date range specified for the given Solar System.');
				solarSystemIdSubscriptionMap.get(newSubscription.Solar_System__c).addError('There can only be one'
					+ ' Subscription Active at a time for a Solar System. A Subscription is already Active for the date'
					+ ' range specified for the given Solar System.');
			}
		}

		for (Subscription__c existingSubscription : [
			SELECT Id, Start_Date__c, End_Date__c, Solar_System__c
			FROM Subscription__c
			WHERE Solar_System__c IN :solarSystemIdSubscriptionMap.keySet()
				AND Status__c = 'Active'
		]){
			currentSubscription = solarSystemIdSubscriptionMap.get(existingSubscription.Solar_System__c);
			//Assuming a new Subscription can start on the day an old one ends
			if (existingSubscription.Id != currentSubscription.Id
				&& currentSubscription.Start_Date__c <= existingSubscription.Start_Date__c
				&& existingSubscription.End_Date__c > currentSubscription.Start_Date__c
			){
				currentSubscription.addError('There can only be one Subscription Active at a time for a Solar System.'
					+ ' A Subscription is already Active for the date range specified for the given Solar System.');
			}
		}
	}

	private void populateAfterVariables(){
		//used to populate all after tense variables in one loop
		List<Subscription__c> subscriptions = isDelete ? oldSubscriptions : newSubscriptions;

		for (Subscription__c modifiedSubscription : subscriptions){
			Subscription__c oldSubscription = isUpdate ? oldSubscriptionMap.get(modifiedSubscription.Id) : new Subscription__c();

			if(oldSubscription.Status__c != modifiedSubscription.Status__c
				&& modifiedSubscription.Status__c == 'Active'
			){
				solarSystemUpdateMap.put(modifiedSubscription.Solar_System__c,
					new Solar_System__c(
						Id = modifiedSubscription.Solar_System__c
						, Active__c = true
						, Subscription_Start_Date__c = modifiedSubscription.Start_Date__c
						, Subscription_End_Date__c = modifiedSubscription.End_Date__c
				));
			} else if (oldSubscription.Status__c != modifiedSubscription.Status__c
				&& modifiedSubscription.Status__c == 'Inactive'
			){
				solarSystemUpdateMap.put(modifiedSubscription.Solar_System__c,
					new Solar_System__c(
						Id = modifiedSubscription.Solar_System__c
						, Active__c = false
						, Subscription_Start_Date__c = null
						, Subscription_End_Date__c = null
				));
			}
		}
	}

	private void updateSolarSystems(){
		//Use queueable jobs to avoid limits as the after trigger scales
		if (!solarSystemUpdateMap.isEmpty()){
			System.enqueueJob(new UpdateRelatedSolarSystem_Queueable(solarSystemUpdateMap.values()));
		}
	}

	public override void setConversions (List<SObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
		if (newList != null) {
			newSubscriptions = new List<Subscription__c>();

			for (SObject so : newList) {
				newSubscriptions.add((Subscription__c) so);
			}
		}
		if (newMap != null) {
			newSubscriptions = new List<Subscription__c>();
			newSubscriptionMap = new Map<Id, Subscription__c>();

			for (Id recId : newMap.keySet()) {
				newSubscriptionMap.put(recId, (Subscription__c) newMap.get(recId));
				newSubscriptions.add((Subscription__c) newMap.get(recId));
			}
		}
		if (oldMap != null) {
			oldSubscriptions = new List<Subscription__c>();
			oldSubscriptionMap = new Map<Id, Subscription__c>();

			for (Id recId : oldMap.keySet()) {
				oldSubscriptionMap.put(recId, (Subscription__c) oldMap.get(recId));
				oldSubscriptions.add((Subscription__c) oldMap.get(recId));
			}
		}
	}
}