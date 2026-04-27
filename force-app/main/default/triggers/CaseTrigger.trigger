trigger CaseTrigger on Case (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Id> ids = new List<Id>();
        for (Case c : Trigger.new) ids.add(c.Id);
        // enqueue for asynchronous processing to avoid callout limits in trigger
        CaseIntegrationService.enqueueForCases(ids);
    }
}
