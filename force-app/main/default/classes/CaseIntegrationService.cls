public with sharing class CaseIntegrationService {
    public static void enqueueForCases(List<Id> caseIds) {
        if (caseIds == null || caseIds.isEmpty()) return;
        try {
            System.enqueueJob(new CaseIntegrationService.CaseIntegrationQueueable(caseIds));
        } catch (Exception e) {
            // best-effort: log local exception (integration framework handles operators/DLQ)
            System.debug('Failed to enqueue CaseIntegrationQueueable: ' + e.getMessage());
        }
    }

    public class CasePayload {
        public String caseId;
        public String subject;
        public String description;
        public String priority;
        public String status;
        public Map<String,Object> contact;
        public List<String> recentComments;
    }

    public class CaseIntegrationQueueable implements Queueable, Database.AllowsCallouts {
        private List<Id> caseIds;
        public CaseIntegrationQueueable(List<Id> ids) { this.caseIds = ids; }

        public void execute(QueueableContext ctx) {
            List<Case> cases = [SELECT Id, Subject, Description, Priority, Status, ContactId, AccountId FROM Case WHERE Id IN :caseIds];
            List<CaseIntegrationService.CasePayload> payloads = new List<CaseIntegrationService.CasePayload>();
            for (Case c : cases) {
                CaseIntegrationService.CasePayload p = new CaseIntegrationService.CasePayload();
                p.caseId = c.Id;
                p.subject = c.Subject;
                p.description = c.Description;
                p.priority = c.Priority;
                p.status = c.Status;
                // fetch recent comments
                List<CaseComment> comments = [SELECT Id, CommentBody FROM CaseComment WHERE ParentId = :c.Id ORDER BY CreatedDate DESC LIMIT 5];
                p.recentComments = new List<String>();
                for (CaseComment cc : comments) p.recentComments.add(cc.CommentBody);
                payloads.add(p);
            }

            // send each payload via IntegrationService (one per case for idempotency)
            for (CaseIntegrationService.CasePayload p : payloads) {
                String payloadJson = JSON.serialize(p);
                String payloadId = 'CaseAI-' + p.caseId;
                IntegrationService.send('CaseAISummarization', payloadId, payloadJson);
            }
        }
    }

}
