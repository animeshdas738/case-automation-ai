Case Automation — Implementation Notes

This folder contains Apex and metadata that wire Salesforce Cases into the SFDC Smart Integration Hub and persist AI suggestions.

Quick setup
1. Deploy metadata to a scratch org or sandbox:
   - sfdx force:source:push -u <org>
2. Create a Named Credential for your AI Backend and set its API name to the value expected by the Integration framework (or update IntegrationConstants.DEFAULT_NAMED_CREDENTIAL to match).
3. Replace the shared secret in `AICallbackRest` with a secure value and configure the AI Backend to call the REST endpoint `/services/apexrest/ai/callback` with that header.
4. Create an `Integration_Endpoint__c` record if you want to test via IntegrationService endpoints; otherwise, tests use HttpCalloutMock.

Testing the flow
- Create a Case. The trigger will enqueue `CaseIntegrationQueueable` which serializes Case info and calls `IntegrationService.send('CaseAISummarization', 'CaseAI-<CaseId>', payload)`.
- The integration framework will perform the callout to your AI Backend; configure AI Backend to call back to `/services/apexrest/ai/callback` with the JSON result.
- The callback will create a `Case_AI_Suggestion__c` record and update the Case with `AI_Summary__c` and `AI_Confidence__c` where available.

Security notes
- Replace the simple header-based secret with OAuth/JWT verification and use Named Credential with an Auth Provider to perform secure callouts.
- Ensure payloads are redacted for PII before leaving Salesforce if required.

Next work
- Build an LWC to surface suggestions inline on the Case page with Accept/Edit/Reject actions.
- Add unit tests and mock callouts for the new Apex classes.
