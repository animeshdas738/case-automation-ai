# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

---

## Requirements Overview — Case Automation (AI Summarization + Auto-Response)

This repository holds design artifacts and implementation scaffolding for a Support Automation solution that performs AI-based Case Summarization and generates suggested (or automated) responses for Salesforce Cases.

### Functional Requirements
- Summarize incoming Cases into concise, human-readable summaries (1-4 lines).
- Extract key facts (issue type, product, urgency, environment, steps to reproduce) as structured fields.
- Produce one or more suggested replies with a confidence score and tone variations (concise, empathetic, detailed).
- Provide a Lightning UI component for agents to view summaries, edit replies, and accept/reject suggestions.
- Persist AI outputs and an audit trail in Salesforce (custom object or Case fields).
- Support manual trigger (agent click) and automatic triggers (on Case creation or new inbound message).

### Non-functional Requirements
- Security: PII must be redacted before transit; all traffic encrypted in transit and at rest.
- Privacy & Compliance: configurable retention and deletion of AI logs; vendor contract requirements for data handling.
- Latency: suggestions should be available within a reasonable SLA (asynchronous flow acceptable for longer runs).
- Reliability & Scalability: design for retries, dead-letter handling, and queueing for bursts.
- Observability: logging, metrics, and alerts for errors, model drift, and acceptance rates.

### Success Metrics
- Reduction in agent time-to-first-response (measured in minutes).
- Suggested-reply acceptance rate (accepted vs edited vs rejected).
- Accuracy of summaries in sampled human evaluations (target > 85% acceptable).
- Cost per processed Case within budget constraints.

### Next Steps
1. Map Salesforce Case fields and minimal payload for the AI service.
2. Build a small AI backend prototype (Node.js/Express or serverless) with a safe prompt and JSON output schema.
3. Implement Salesforce integration (Named Credential, Apex callout or Platform Event) and a simple LWC to display suggestions.
4. Run a pilot with a limited support queue; collect feedback and metrics.
