# Health

**Prefix:** `/api`
**Authentication:** `GET /health` — none required. `GET /logs/{source}` — Bearer JWT required.

System health and log retrieval.

## Endpoints

| Method | Path | Authentication | Description |
|--------|------|----------------|-------------|
| GET | `/api/health` | None | Service health check |
| GET | `/api/logs/{source_name}` | Bearer JWT | Retrieve logs from a named source |

## Log sources

Log sources are registered internally. Known sources:
- `AI` — inference engine logs
- `tools` — tool execution logs
