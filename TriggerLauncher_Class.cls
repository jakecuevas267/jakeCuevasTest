public class TriggerLauncher_Class {

	public static void Run(TriggerHandler_Class.Template handler) {
		if (Trigger.isBefore) {
			if (Trigger.isInsert){
				handler.setTense(TriggerHandler_Class.Tense.BeforeInsert);
				handler.setConversions(Trigger.new, null, null);
				handler.beforeInsert();
			} else if (Trigger.isUpdate){
				handler.setTense(TriggerHandler_Class.Tense.BeforeUpdate);
				handler.setConversions(null, Trigger.newMap, Trigger.oldMap);
				handler.beforeUpdate();
			} else if (Trigger.isDelete){
				handler.setTense(TriggerHandler_Class.Tense.BeforeDelete);
				handler.setConversions(null, null, Trigger.oldMap);
				handler.beforeDelete();
			}
		} else if (Trigger.isAfter) {
			if (Trigger.isInsert){
				handler.setTense(TriggerHandler_Class.Tense.AfterInsert);
				handler.setConversions(null, Trigger.newMap, null);
				handler.afterInsert();
			} else if (Trigger.isUpdate){
				handler.setTense(TriggerHandler_Class.Tense.AfterUpdate);
				handler.setConversions(null, Trigger.newMap, Trigger.oldMap);
				handler.afterUpdate();
			} else if (Trigger.isDelete){
				handler.setTense(TriggerHandler_Class.Tense.AfterDelete);
				handler.setConversions(null, null, Trigger.oldMap);
				handler.afterDelete();
			} else if (Trigger.isUndelete){
				handler.setTense(TriggerHandler_Class.Tense.AfterUndelete);
				handler.setConversions(null, Trigger.newMap, null);
				handler.afterUndelete();
			}
		}

		dumpLimits();
	}

	private static void dumpLimits () {
		LoggingLevel level = LoggingLevel.DEBUG;
		System.debug(level, '----Limits Dump----');
		System.debug(level, 'SOQL Queries:......' + Limits.getQueries() + '/' + Limits.getLimitQueries());
		System.debug(level, 'SOQL Rows:.........' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());
		System.debug(level, 'CPU Time:..........' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
		System.debug(level, 'Email invocations:.' + Limits.getEmailInvocations() + '/' + Limits.getLimitEmailInvocations());
		System.debug(level, 'DML Statements:....' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
		System.debug(level, 'DML Rows:..........' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows());
	}
}