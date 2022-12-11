public abstract without sharing class BatchLauncher implements Database.Batchable<SObject>, Database.Stateful {
	@TestVisible protected String queryString;
	private Boolean rerunJob = false;
	protected String objectString;
	protected Datetime startTime;
	protected Integer count;
	private Id reRunId;

	protected BatchLauncher(){}

	public virtual Database.QueryLocator start(Database.BatchableContext bc) {
		Database.QueryLocator result = null;

		try {
			startTime = Datetime.now();
			result = Database.getQueryLocator(queryString);
		} catch (System.QueryException qe) {
			System.debug(LoggingLevel.ERROR, queryString);
			System.abortJob(bc.getJobId());
		}

		return result;
	}

	public virtual void execute (Database.BatchableContext bc, List<SObject> scope) {
		List<Database.SaveResult> results = new List<Database.SaveResult>();
		List<SObject> toUpdate = new List<SObject>();
		if (bc != null) {
			reRunId = bc.getJobId();
		}

		try {
			toUpdate = processRecords(scope);
			results = Database.update(toUpdate, false);
		} catch (Exception e) {
			if (!e.getMessage().contains('ENTITY_IS_DELETED')) {
				if (reRunId != null){
					System.abortJob(reRunId);
				}
			}
		}

		processSaveResults(results);
	}

	protected void processSaveResults (List<Database.SaveResult> results) {
		Integer resultCount = 0;
		for (Database.SaveResult result : results) {
			if (result.isSuccess()) {
				count++;
			} else {
				List<Database.Error> errList = result.getErrors();

				for (Database.Error err : errList) {
					if (err.getMessage().contains('UNABLE_TO_LOCK_ROW')) {
						rerunJob = true;
					} else {
						System.debug(err.getMessage());
					}
				}
			}

			resultCount++;
		}
	}

	public abstract List<SObject> processRecords (List<SObject> scope);

	public virtual void finish(Database.BatchableContext bc) {
		if (reRunId != null && rerunJob) {
			String rerunClassName = [
				SELECT ApexClass.Name
				FROM AsyncApexJob
				WHERE Id = :reRunId
			].ApexClass.Name;

			BatchRunner batchObj = (BatchRunner) System.Type.forName(rerunClassName).newInstance();
			Datetime schDt = Datetime.now().addMinutes(5);
			String sch = schDt.second() + ' ' + schDt.minute() + ' ' + schDt.hour()
				+ ' ' + schDt.day() + ' ' + schDt.month() + ' ? ' + schDt.year();
			try {
				new BatchRunner_Scheduler (
					batchObj
					, 5
					, rerunClassName + ' ' + Integer.valueOf((Math.random() * 1000))
				).schedule(sch);
			} catch (Exception e) {
				System.debug('Problem Rescheduling job: ' + rerunClassName);
			}
		}
	}
}