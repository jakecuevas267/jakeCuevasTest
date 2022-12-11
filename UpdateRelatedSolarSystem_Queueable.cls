public without sharing class UpdateRelatedSolarSystem_Queueable implements Queueable {
	List<Solar_System__c> solarSystems;

	public UpdateRelatedSolarSystem_Queueable(List<Solar_System__c> passedSolarSystems) {
		solarSystems = passedSolarSystems;
	}

	public void execute(QueueableContext context) {
		if (!solarSystems.isEmpty()){
			update solarSystems;
		}
	}
}