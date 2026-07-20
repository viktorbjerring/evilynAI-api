# EvilynAI API

API specification and documentation tooling for the EvilynAI backend.

## Overview

This repo contains the OpenAPI and AsyncAPI specifications for the EvilynAI REST API and SSE event stream. It can generate HTML documentation from these specs using the Makefile targets below.

## Specs

- **`server-api/openapi.yaml`** — OpenAPI 3.0 spec for all REST endpoints. Individual endpoint definitions are split into per-resource YAML files under `server-api/` and referenced from the root spec.
- **`asyncapi.yaml`** — AsyncAPI 3.0 spec for the Server-Sent Events stream (`GET /api/stream`).

### REST endpoint groups (`server-api/`)

| Folder         | Endpoints                                                                              |
| -------------- | -------------------------------------------------------------------------------------- |
| `auth/`        | Login                                                                                  |
| `chat/`        | Chat, history                                                                          |
| `actions/`     | Pending, get, approve, deny                                                            |
| `tools/`       | List, get, enable/disable, reload, actions, permissions, state                         |
| `tts/`         | Available, enable, fetch audio                                                         |
| `stt/`         | Available                                                                              |
| `stream/`      | SSE stream, device register                                                            |
| `admin/`       | Dream trigger, transcript rotate                                                       |
| `debug/`       | Transcript, working-set, dream status, scheduler status, summaries, personality, trait |
| `health/`      | Health check, logs                                                                     |
| `google-auth/` | Google OAuth start, callback                                                           |
| `system/`      | Ping, notificator, message                                                             |

## Tool schemas (`tool-details/`)

Per-tool YAML files documenting the data each tool exposes to the frontend
via the API — specifically `tool_state` and `details`. One file per tool,
plus `base-tool.yaml` describing the fields every tool includes by default.
(A tool's admin routes are documented separately, under `server-api/tools/`;
the declarative admin-action manifest — see `doc/architecture/TOOLS.md` §8 —
supersedes what used to be hand-maintained here as `user_actions`.)

| File                       | Tool                |
| -------------------------- | ------------------- |
| `base-tool.yaml`           | Base class defaults |
| `notificator-tool.yaml`    | `notificator`       |
| `notebook-tool.yaml`       | `notebook`          |
| `scheduler-tool.yaml`      | `schedule`          |
| `tasks-tool.yaml`          | `tasks`             |
| `ask-the-oracle-tool.yaml` | `ask_the_oracle`    |
| `projects-tool.yaml`       | `projects`          |

## Generating docs

Requires Node.js with `npx` available.

```sh
make docs          # Build all HTML docs and bundle the OpenAPI spec
make docs-bundle   # Bundle $ref references into openapi.bundled.yaml
make docs-asyncapi # Build HTML docs from the AsyncAPI SSE spec
```

Output files:
- `openapi.html` — rendered REST API reference
- `openapi.bundled.yaml` — single-file bundled OpenAPI spec
- `asyncapi-docs/` — rendered SSE event documentation
