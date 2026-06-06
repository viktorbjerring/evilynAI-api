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

Every module exposes admin routes under `/api/tools/{tool_name}/module/`,
mounted and JWT-protected by the server. Every module surfaces a root
`GET /` returning `{name, details}` — its `details` payload is module-specific
and documented in the per-module `*-details.yaml` files. Stateful modules add
further endpoints (CRUD, triggers, etc.).

### Doc layout

```
modules/
  ask-the-oracle/
    ask-the-oracle.yaml         # paths fragment: URL suffix → PathItem ref
    ask-the-oracle-details.yaml # GET /  → {name, details}
  notebook/
    notebook.yaml
    notebook-details.yaml
  notificator/
    notificator.yaml
    notificator-details.yaml
  schedule/
    schedule.yaml
    schedule-details.yaml       # GET /
    schedule-schedules.yaml     # GET/POST /schedules
    schedule-schedule.yaml      # DELETE /schedules/{id}
    schedule-trigger.yaml       # POST /schedules/{id}/trigger
  tasks/
    tasks.yaml
    tasks-details.yaml          # GET /
    tasks-lists.yaml            # GET /lists
    tasks-tasks.yaml            # GET/POST /tasks
    tasks-task.yaml             # PATCH/DELETE /tasks/{id}
tools-module.yaml               # ⚙️ generated — do not edit
```

Each `<module>.yaml` is a paths fragment keyed by URL suffix relative to
`/tools/<module>/module/` (empty string = the module root). `make
build-tools-module` collects every `<module>.yaml` into the generated
top-level `tools-module.yaml`, rewriting sibling refs so they resolve from
the aggregator's directory. `openapi.yaml#/paths` merges that file in via a
sibling `$ref` at bundle time.

**Adding an endpoint.** Drop the new PathItem file next to the module's
`<module>.yaml`, add one `<suffix>: { $ref: ./<file>.yaml }` line in
`<module>.yaml`, then re-run `make docs-bundle`. **Adding a module.** Create
the folder with `<module>.yaml` + a `<module>-details.yaml` for the root.
**Updating an endpoint.** Edit only the action's PathItem file.

### Routes

#### `ask-the-oracle` module

| Method | Path                       | Description                                      |
| ------ | -------------------------- | ------------------------------------------------ |
| GET    | `/ask-the-oracle/module/`  | Module details: model, max_tokens, max_turns     |

#### `notebook` module

| Method | Path                  | Description                              |
| ------ | --------------------- | ---------------------------------------- |
| GET    | `/notebook/module/`   | Module details: num_notes + categories   |

#### `notificator` module

| Method | Path                    | Description                  |
| ------ | ----------------------- | ---------------------------- |
| GET    | `/notificator/module/`  | Module details (stateless)   |

#### `schedule` module

| Method | Path                                                | Description                             |
| ------ | --------------------------------------------------- | --------------------------------------- |
| GET    | `/schedule/module/`                                 | Module details: timezone + active count |
| GET    | `/schedule/module/schedules`                        | List active schedules                   |
| POST   | `/schedule/module/schedules`                        | Create a one-off or recurring schedule  |
| DELETE | `/schedule/module/schedules/{schedule_id}`          | Cancel a schedule                       |
| POST   | `/schedule/module/schedules/{schedule_id}/trigger`  | Fire a schedule immediately             |

#### `tasks` module

| Method | Path                              | Description                                       |
| ------ | --------------------------------- | ------------------------------------------------- |
| GET    | `/tasks/module/`                  | Module details: auth state + offline-queue depth  |
| GET    | `/tasks/module/lists`             | List task lists                                   |
| GET    | `/tasks/module/tasks`             | Read tasks (`?task_list_id=&include_completed=`)  |
| POST   | `/tasks/module/tasks`             | Create a task                                     |
| PATCH  | `/tasks/module/tasks/{task_id}`   | Update a task / toggle completion                 |
| DELETE | `/tasks/module/tasks/{task_id}`   | Delete a task (`?task_list_id=`)                  |

The `tasks` module is hybrid online/offline: writes made while the Google
backend is unreachable are queued locally and replayed on reconnect, and
backend failures surface as `502`.
