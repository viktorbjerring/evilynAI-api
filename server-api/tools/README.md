# Tools

**Prefix:** `/api/tools`
**Authentication:** Bearer JWT required

Inspect registered tools and manage their runtime permission configuration.

Each tool exposes one or more **actions** (e.g. `notebook_write`). Actions
have a default permission of either `immediate` (executes without approval) or
`requires_approval` (queued in `/actions`). The permission can be overridden at
runtime and the override is persisted to `permission_overrides.json`.

## Endpoints

| Method | Path                                    | Description                                                         |
| ------ | --------------------------------------- | ------------------------------------------------------------------- |
| GET    | `/`                                     | List all registered tools with status                               |
| GET    | `/{tool_name}`                          | Full tool detail including actions and effective permissions         |
| GET    | `/{tool_name}/details`                  | Extended tool detail including user actions                         |
| GET    | `/{tool_name}/actions`                  | The actions a given tool has set up, with permissions               |
| POST   | `/{tool_name}/{action_name}/permission` | Set permissions for an action                                       |
| DELETE | `/{tool_name}/{action_name}/permission` | Clear permissions for an action                                     |
| GET    | `/{tool_name}/current_state`            | Info about the tools underlying modules current state               |
| GET    | `/{tool_name}/user_action`              | Schema about what actions the user can make bypassing the AI        |
| POST   | `/{tool_name}/user_action`              | Execute a user action bypassing the AI                              |
| POST   | `/{tool_name}/enable`                   | Re-enable a manually disabled tool                                  |
| POST   | `/{tool_name}/disable`                  | Disable a tool (removes it from LLM definitions)                    |
| POST   | `/reload`                               | Reload the tool registry (picks up code and env changes)            |

## Permission override example

```http
POST /api/tools/notebook/write/permission
Authorization: Bearer <token>
Content-Type: application/json

{"permission": "immediate"}
```

This causes `notebook_write` to execute without queuing until the override is
reset or the backend restarts (overrides are persisted to disk).
