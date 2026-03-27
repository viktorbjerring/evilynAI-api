# Chat

**Prefix:** `/api`
**Authentication:** Bearer JWT required

Core conversation endpoints. The main chat endpoint accepts both text (JSON)
and audio (multipart/form-data) input. Audio is transcribed server-side via
Whisper before being passed to the AI.

Responses include an optional `audio_url` field containing a TTS response ID
that can be fetched from `GET /api/tts/fetch/{response_id}`.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/chat` | Send a message and get an AI response |
| GET | `/api/chat/history` | Retrieve recent conversation messages |
