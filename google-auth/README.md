# Google OAuth

**Prefix:** `/api/auth/google`
**Authentication:** Bearer JWT (or `?token=`) for the start endpoint; none for the callback (Google redirects here)

Browser-based OAuth re-authorization for Google Workspace tool integrations
(Calendar, Tasks, Gmail, etc.). Enables re-auth from a mobile browser without
needing local machine or terminal access.

**Flow:**

```
1. GET /api/auth/google/{tool_name}?token=<jwt>
      → redirects to Google consent screen
2. User approves in browser
3. Google redirects to GET /api/auth/google/{tool_name}/callback?code=...
      → token written to disk
      → toolset reloaded
      → success page shown
```

The `tool_name` must correspond to a registered tool that exposes
`credentials_path`, `google_scopes`, and `token_path` in its `debug_info`.

## Endpoints

| Method | Path | Authentication | Description |
|--------|------|----------------|-------------|
| GET | `/api/auth/google/{tool_name}` | Bearer JWT or `?token=` | Start OAuth flow |
| GET | `/api/auth/google/{tool_name}/callback` | None | OAuth redirect callback |
