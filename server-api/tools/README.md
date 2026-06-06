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

## Module admin proxy (`/{tool_name}/module/...`)

Stateful tools back onto a **module** that may expose its own admin routes,
mounted by the server under `/api/tools/{tool_name}/module/`. The server has
no knowledge of what an individual module exposes — it proxies the request and
enforces Bearer JWT auth across the whole module surface. A stateless module
exposes nothing; a stateful one may expose full CRUD.

The two stateful modules currently exposing routes:

### `schedule` module

| Method | Path                                        | Description                          |
| ------ | ------------------------------------------- | ------------------------------------ |
| GET    | `/schedule/module/schedules`                | List active schedules                |
| POST   | `/schedule/module/schedules`                | Create a one-off or recurring schedule |
| DELETE | `/schedule/module/schedules/{schedule_id}`  | Cancel a schedule                    |
| POST   | `/schedule/module/schedules/{schedule_id}/trigger` | Fire a schedule immediately   |

### `tasks` module

| Method | Path                              | Description                                   |
| ------ | --------------------------------- | --------------------------------------------- |
| GET    | `/tasks/module/status`            | Offline write-queue depth + OAuth token state |
| GET    | `/tasks/module/lists`             | List task lists                               |
| GET    | `/tasks/module/tasks`             | Read tasks (`?task_list_id=&include_completed=`) |
| POST   | `/tasks/module/tasks`             | Create a task                                 |
| PATCH  | `/tasks/module/tasks/{task_id}`   | Update a task / toggle completion             |
| DELETE | `/tasks/module/tasks/{task_id}`   | Delete a task (`?task_list_id=`)              |

The `tasks` module is hybrid online/offline: writes made while the Google
backend is unreachable are queued locally and replayed on reconnect, and
backend failures surface as `502`.
