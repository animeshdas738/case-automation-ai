public with sharing class CaseAISummaryController {
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> getCaseSummary(Id caseId) {
        if (caseId == null) throw new AuraHandledException('caseId required');
        Case c = [SELECT Id, Subject, Description FROM Case WHERE Id = :caseId LIMIT 1];

        // Demo synchronous summarization - replace with IntegrationService.call or real LLM integration
        String summary = 'Demo summary: ' + (c.Subject == null ? '' : c.Subject) + '\n' + (c.Description == null ? '' : c.Description.substring(0, Math.min(200, c.Description.length())));
        List<Map<String,Object>> replies = new List<Map<String,Object>>();
        replies.add(new Map<String,Object>{'tone' => 'concise', 'body' => 'Thanks for contacting support. We are investigating.' , 'confidence' => 0.85});

        Map<String,Object> out = new Map<String,Object>{'summary' => summary, 'suggestedReplies' => replies, 'confidence' => 0.85};
        return out;
    }

    @AuraEnabled
    public static String requestCaseSummaryAsync(Id caseId) {
        if (caseId == null) throw new AuraHandledException('caseId required');
        // Build payload similar to CaseIntegrationQueueable and send via IntegrationService for async processing
        Case c = [SELECT Id, Subject, Description FROM Case WHERE Id = :caseId LIMIT 1];
        Map<String,Object> p = new Map<String,Object>();
        p.put('caseId', c.Id);
        p.put('subject', c.Subject);
        p.put('description', c.Description);
        String payloadJson = JSON.serialize(p);
        String payloadId = 'CaseAiManual-' + c.Id;
        IntegrationService.send('CaseAISummarization', payloadId, payloadJson);
        return payloadId;
    }
}
