# Architecture Diagram — Case Automation: AI-based Summarization & Auto-Response

Below is a system architecture diagram in Mermaid for quick viewing in Markdown renderers that support Mermaid. It describes the components and the data flow for the AI-based Case Summarization and Auto-Response solution.

```mermaid
flowchart LR
  subgraph Salesforce
    A[Case Record] --> B[Platform Event / Apex Trigger]
    B --> C[Named Credential / External Callout]
    D[LWC on Case Page] <-- E[Case_AI_Suggestion__c]
    D --> B
    %% notes: trigger on create/comment and user action are represented by flow direction
  end

  subgraph Ingress
    C --> F[AI Backend API]
    B --> F
  end

  subgraph AIBackend
    F --> G[Preprocessor<br/>redact, clean, truncate]
    G --> H[LLM Provider<br/>OpenAI / Anthropic / Private]
    H --> I[Postprocessor<br/>validate JSON schema, score]
    I --> J[Result Store<br/>DB / S3 & Metrics]
    I --> K[Webhook<br/>Callback to Salesforce]
  end

  subgraph Queueing
    F --> Q[Message Queue<br/>optional]
    Q --> F
    Q --> Retry[Retry<br/>Dead-letter]
  end

  subgraph Monitoring
    J --> M[Metrics & Alerts]
    J --> L[Audit Logs<br/>redacted]
  end

  K --> E
  I --> D

  style Salesforce fill:#f9f,stroke:#333,stroke-width:1px
  style AIBackend fill:#efe,stroke:#333,stroke-width:1px
  style Ingress fill:#eef,stroke:#333,stroke-width:1px
  style Queueing fill:#ffe,stroke:#333,stroke-width:1px
  style Monitoring fill:#fff0f0,stroke:#333,stroke-width:1px
```

Explanation:
- Salesforce triggers an outbound call when a Case is created or updated (Apex trigger, Flow, or Platform Event).
- The outbound call uses a Named Credential to authenticate to the AI Backend API.
- The AI Backend preprocesses text (PII redaction, truncation), calls an LLM provider with a robust prompt, and postprocesses/validates the returned JSON.
- Results are stored in a result store and sent back to Salesforce via a callback endpoint or Platform Event, and surfaced in the LWC on the Case page.
- Optional queueing and retry mechanisms handle scale and transient errors.
- Monitoring and audit logs track usage and help with compliance.

This mermaid diagram is viewable in compatible Markdown viewers (GitHub may need file extension and repo settings to render Mermaid). For other renderers, see the PlantUML file.
