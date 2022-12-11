public class BatchLauncher_Scheduler implements Schedulable {
	private BatchLauncher launcher;
	private Integer batchSize;
	private String batchName;

	public BatchLauncher_Scheduler (BatchLauncher batchLauncherObject, Integer batchSize, String batchName) {
		launcher = batchLauncherObject;
		this.batchSize = batchSize;
		this.batchName = batchName;
	}

	public void execute (SchedulableContext sc) {
		try {
			System.debug('Executing batch...');
			Database.executeBatch(launcher, batchSize);
			System.debug('Batch queued!');
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, 'ERROR: Batch failed.');
			Utilities.sendErrorEmail(e, batchName + ': batch execution failed', batchName + ' failed the call to Database.executeBatch().  Further info below.', true);
		}
	}

	public Id schedule (String cronString) {
		return System.schedule(batchName + ' ' + cronString, cronString, this);
	}
}