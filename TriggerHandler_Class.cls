public class TriggerHandler_Class {
	public enum Tense {
		BeforeInsert,
		AfterInsert,
		BeforeUpdate,
		AfterUpdate,
		BeforeDelete,
		AfterDelete,
		AfterUndelete
	}

	public abstract class Template {
		@TestVisible
		protected TriggerHandler_Class.Tense tense;
		protected Boolean isBefore {protected get; private set;}
		protected Boolean isAfter {protected get; private set;}
		protected Boolean isInsert {protected get; private set;}
		protected Boolean isUpdate {protected get; private set;}
		protected Boolean isDelete {protected get; private set;}
		protected Boolean isUndelete {protected get; private set;}

		public Template(){}
		public abstract String getTriggerName();
		public abstract void setConversions(List<SObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
		public virtual void beforeInsert(){}
		public virtual void beforeUpdate(){}
		public virtual void beforeDelete(){}
		public virtual void afterInsert(){}
		public virtual void afterUpdate(){}
		public virtual void afterDelete(){}
		public virtual void afterUndelete(){}

		public void setTense (TriggerHandler_Class.Tense tense) {
			this.tense = tense;
			isBefore = (tense == TriggerHandler_Class.Tense.BeforeInsert || tense == TriggerHandler_Class.Tense.BeforeUpdate || tense == TriggerHandler_Class.Tense.BeforeDelete);
			isAfter = !isBefore;
			isInsert = (tense == TriggerHandler_Class.Tense.BeforeInsert || tense == TriggerHandler_Class.Tense.AfterInsert);
			isUpdate = (tense == TriggerHandler_Class.Tense.BeforeUpdate || tense == TriggerHandler_Class.Tense.AfterUpdate);
			isDelete = (tense == TriggerHandler_Class.Tense.BeforeDelete || tense == TriggerHandler_Class.Tense.AfterDelete);
			isUndelete = (tense == TriggerHandler_Class.Tense.AfterUndelete);
		}
	}
}