# Actions

**Prefix:** `/api/actions`
**Authentication:** Bearer JWT required

Manages the queue of tool actions that require explicit user approval before
execution. When the AI decides to invoke a tool whose permission is set to
`requires_approval`, the action is placed in this queue rather than executed
immediately.

**Lifecycle:**

```
[AI queues action] → PENDING
    ↓
POST /actions/{id}/approve   →  APPROVED  →  AI calls execute_approved → EXECUTED
POST /actions/{id}/deny      →  DENIED
                                            (auto-expired after timeout)  →  EXPIRED
```

Approving or denying an action injects a system message into the AI and
triggers a new inference loop. The AI is then expected to call the internal
`execute_approved` tool for approved actions.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/actions/pending` | List all pending actions |
| GET | `/api/actions/{action_id}` | Get details of a specific action |
| POST | `/api/actions/{action_id}/approve` | Approve an action |
| POST | `/api/actions/{action_id}/deny` | Deny an action |
| POST | `/api/actions/system` | Inject a system message into the AI |
