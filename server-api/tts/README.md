# TTS (Text-to-Speech)

**Prefix:** `/api/tts`
**Authentication:** Bearer JWT required

Controls TTS audio generation. When the AI produces a response, the backend
optionally synthesizes it as audio and returns a response ID in the chat
response's `audio_url` field. The audio can then be fetched from
`GET /api/tts/fetch/{response_id}`.

Audio is generated asynchronously. A `202 Generating` response means the
audio is not yet ready — poll again after `retry_after` seconds.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/tts/available` | Check TTS availability and list expressions |
| POST | `/api/tts/enable` | Enable or disable TTS |
| GET | `/api/tts/fetch/{response_id}` | Fetch generated audio as MP3 |
