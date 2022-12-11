@IsTest
private class TriggerHandler_Class_Test {
	private static testMethod void getTriggerNameTest() {
	 	TriggerHandler_Class.Template t = new TemplateExtender();

	 	System.assertEquals('TestTriggerName', t.getTriggerName());
	}

	private static testMethod void beforeInsertTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.beforeInsert();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void beforeUpdateTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.beforeUpdate();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void beforeDeleteTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.beforeDelete();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void afterInsertTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.afterInsert();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void afterUpdateTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.afterUpdate();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void afterDeleteTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.afterDelete();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private static testMethod void afterUndeleteTest() {
		TriggerHandler_Class.Template t = new TemplateExtender();
		String message;

		Test.startTest();
		try {
			t.afterUndelete();
		} catch (Exception e) {
			message = e.getMessage();
		}
		Test.stopTest();

		System.assert(message == null);
	}

	private class TemplateExtender extends TriggerHandler_Class.Template {
		public override String getTriggerName() {
			return 'TestTriggerName';
		}

        public override void setConversions (List<SObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
            return;
        }
	}
}