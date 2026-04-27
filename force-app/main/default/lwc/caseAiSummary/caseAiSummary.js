import { LightningElement, api, track } from 'lwc';
import getCaseSummary from '@salesforce/apex/CaseAISummaryController.getCaseSummary';
import requestCaseSummaryAsync from '@salesforce/apex/CaseAISummaryController.requestCaseSummaryAsync';

export default class CaseAiSummary extends LightningElement {
    @api recordId;
    @track summaryData;
    @track error;

    connectedCallback() {
        // optionally auto-load
    }

    handleGenerate() {
        this.error = null;
        if (!this.recordId) { this.error = 'No Case recordId available'; return; }
        getCaseSummary({ caseId: this.recordId })
            .then(res => { this.summaryData = res; })
            .catch(err => { this.error = err.body ? err.body.message : JSON.stringify(err); });
    }

    handleRequestAsync() {
        this.error = null;
        if (!this.recordId) { this.error = 'No Case recordId available'; return; }
        requestCaseSummaryAsync({ caseId: this.recordId })
            .then(pid => { this.summaryData = { summary: 'Requested async. payloadId: ' + pid }; })
            .catch(err => { this.error = err.body ? err.body.message : JSON.stringify(err); });
    }
}
