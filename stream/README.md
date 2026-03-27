# Stream

**Prefix:** `/api`
**Authentication:** Bearer JWT via header **or** `?token=` query parameter

Real-time event delivery via Server-Sent Events (SSE). Clients open a
persistent `GET /api/stream` connection and receive events as they occur.

The query-param token fallback exists because the browser's native `EventSource`
API cannot set custom headers.

## SSE Event Types

| Event type | When fired |
|------------|-----------|
| `chat` | User message sent or AI response received |
| `typing` | AI is generating a response |
| `audio` | TTS audio is available |
| `queue_update` | Action added to queue or status changed |
| `tool_action` | A tool was executed |
| `error` | An error occurred |

## FCM Fallback

When no SSE client is connected, certain events (chat messages) fall back to
Firebase Cloud Messaging (FCM). Register a device token using
`POST /api/device/register`.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/stream` | Open SSE connection |
| POST | `/api/device/register` | Register an FCM device token |
