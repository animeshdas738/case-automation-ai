@RestResource(urlMapping='/ai/callback/*')
global with sharing class AICallbackRest {
    @HttpPost
    global static void receive() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Simple shared-secret header check (replace with OAuth/JWT in production)
        String secret = req.headers.get('X-AI-Secret');
        if (secret == null || secret != 'REPLACE_WITH_SECRET') {
            res.statusCode = 401;
            res.responseBody = Blob.valueOf('Unauthorized');
            return;
        }

        String body = req.requestBody.toString();
        if (String.isBlank(body)) {
            res.statusCode = 400; res.responseBody = Blob.valueOf('Empty body'); return;
        }

        Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(body);
        try {
            // expected fields: caseId, summary, suggestedReplies (list), confidence
            String caseId = (String) m.get('caseId');
            String summary = (String) m.get('summary');
            Decimal confidence = (m.containsKey('confidence') && m.get('confidence') != null) ? Decimal.valueOf(String.valueOf(m.get('confidence'))) : null;
            List<Object> replies = (List<Object>) m.get('suggestedReplies');

            Case_AI_Suggestion__c sug = new Case_AI_Suggestion__c();
            sug.Case__c = caseId;
            sug.Summary__c = summary;
            if (confidence != null) sug.Confidence__c = confidence;
            if (replies != null && !replies.isEmpty()) sug.Suggested_Reply__c = String.valueOf(((Map<String,Object>)replies[0]).get('body'));
            insert sug;

            // update Case fields (best-effort)
            try {
                Case c = new Case(Id = caseId);
                if (!String.isBlank(summary)) c.AI_Summary__c = summary;
                if (confidence != null) c.AI_Confidence__c = confidence;
                update c;
            } catch (Exception ex) { System.debug('Failed to update Case with AI fields: ' + ex.getMessage()); }

            res.statusCode = 200; res.responseBody = Blob.valueOf('OK');
        } catch (Exception e) {
            res.statusCode = 500; res.responseBody = Blob.valueOf('Error: ' + e.getMessage());
        }
    }
}
