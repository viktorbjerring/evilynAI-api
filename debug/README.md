# Debug

**Prefix:** `/api/debug`
**Authentication:** Bearer JWT required

Introspection and manual manipulation endpoints for development. These expose
internal AI state (transcript, summaries, personality, tools) and allow
direct injection of traits and forced memory operations.

**Not intended for production use.**

## Endpoints

### Introspection

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/debug/transcript` | Current transcript buffer with token count |
| GET | `/api/debug/summaries` | Summaries window and meta-summary |
| GET | `/api/debug/personality` | Core memory personality traits |

### Manipulation

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/debug/trait` | Inject a trait directly into CoreMemory |
| POST | `/api/debug/force-rotation` | Force transcript rotation |
| POST | `/api/debug/force-extraction` | Force memory extraction to long-term |
