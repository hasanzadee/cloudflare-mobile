# Why this app only uses API tokens

Cloudflare offers three ways to authenticate a client. This app supports two of
them, and the omission is deliberate.

| Method | Supported | Why |
|---|---|---|
| **API token** | ✅ primary | Scoped to exactly the permissions you grant, revocable, IP-limitable |
| **Global API key** | ✅ with warnings | Some accounts still only have one. Unrestricted, so it sits behind a typed confirmation |
| **OAuth 2.0** | ❌ removed | See below |

## OAuth was built, worked, and was dropped

Cloudflare opened self-managed OAuth clients in June 2026, and the flow was
implemented here in full: Authorization Code with PKCE, a 128-bit `state` check,
single-flight refresh, and sixteen tests covering state mismatch, user refusal,
a missing code and a 200 carrying no token. It ran.

It was removed because the setup cost falls on the wrong person. To use it you
must:

1. register an OAuth client in the Cloudflare dashboard;
2. own a domain, because Cloudflare's client form **rejects custom-scheme
   redirect URLs** and requires `https://` — which a phone app cannot own;
3. host something at that domain to bounce the callback back to the app;
4. and, to let anyone other than your own account members sign in, pass
   domain-ownership verification to make the client "public".

That is four prerequisites before the first login, against an API token that
takes two taps from the app's own onboarding — which opens the dashboard with
the right permissions already ticked.

For an app whose whole point is *manage Cloudflare from your phone*, the token
path is simply better: fewer moving parts, narrower permissions, and nothing to
keep running.

## What was learned, in case it is ever revisited

These cost real time to establish and are not documented anywhere obvious:

- **The endpoints are not discoverable.** `/.well-known/oauth-authorization-server`
  on `dash.cloudflare.com` serves the dashboard SPA, not RFC 8414 metadata.
  The real ones, found by probing:
  - authorize: `https://dash.cloudflare.com/oauth2/auth` — a bogus client id
    redirects to `/oauth/error?error=invalid_client`, proving it validates.
  - token: `https://dash.cloudflare.com/oauth2/token` — `POST` answers 401. A
    `GET` there returns 404, which makes the endpoint look absent.
- **Public PKCE clients are supported**: the client form offers
  `None (PKCE)` as the token authentication method.
- **Custom schemes are rejected.** `io.cfmgr.app://oauth/callback` is cleared by
  the form; only `https://` is accepted.
- **Private vs public is about who may *use* the client**, not who registers it.
  A private client works immediately for members of the creating account; end
  users never register anything.

The implementation is in git history if it is ever wanted back:

```bash
git log --oneline --all -- lib/auth/data/oauth_client.dart
```
