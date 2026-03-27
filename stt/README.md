# STT (Speech-to-Text)

**Prefix:** `/api/stt`
**Authentication:** Bearer JWT required

Server-side STT is provided by OpenAI Whisper. Audio transcription is also
available inline via `POST /api/chat` (multipart/form-data). This endpoint
only reports availability.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/stt/available` | Check if STT is available |
