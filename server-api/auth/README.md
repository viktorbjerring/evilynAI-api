# Auth

**Prefix:** `/api`
**Authentication:** None required

Handles password-based login and JWT issuance. All other endpoints (except
`/health`) require a `Bearer <token>` header obtained from this endpoint.

Tokens are signed HS256 JWTs. Expiry is configurable via `JWT_EXPIRY_SECONDS`
(default 30 days).

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/login` | Authenticate and receive a JWT |
