# OAuth: what is settled and what is not

Cloudflare announced **self-managed OAuth clients** on 3 June 2026. That makes a
real "Sign in with Cloudflare" button possible for a third-party app: the user
is sent to `dash.cloudflare.com`, signs in however they normally do — email and
password, Google, or their organisation's SSO — and the app receives a token
without ever seeing a credential.

The client code is written (`lib/auth/domain/cf_credential.dart` carries the
OAuth case, the manifest registers both redirect strategies, and
`AuthInterceptor` already does single-flight refresh). It is **not enabled**,
because seven things need to be confirmed against a real registration, and
several of them change the design rather than just a constant.

## Confirmed from documentation

- Authorization Code is the only grant available to third-party clients. No
  Client Credentials, Implicit, ROPC or Device flow.
- Public clients use **PKCE** with `token_endpoint_auth_method: none`, i.e. no
  client secret — which is the correct shape for a mobile app.
- Scope names correspond to API-token permission names.
- Clients are either **Private** (usable only by members of the account that
  registered them) or **Public** (usable by any Cloudflare user, subject to
  prerequisites including client-URL domain-ownership verification).
- The endpoints are published as RFC 8414 authorization-server metadata, so they
  should be discovered rather than hardcoded.

## Open questions

| # | Question | Why it matters | How to settle it |
|---|---|---|---|
| 1 | Exact URL of the metadata document | Everything else is read from it | Probe `/.well-known/oauth-authorization-server` on the dash and api origins |
| 2 | Is a custom-scheme redirect (`io.cfmgr.app://oauth/callback`) accepted for a public client, or is an `https` App Link required? | An App Link needs a domain you control and a hosted `assetlinks.json` | Register a test client and try the custom scheme first |
| 3 | Are refresh tokens issued? Is `offline_access` (or an equivalent scope) required? Do they rotate? | Without refresh, users re-authenticate constantly and the UX changes | Complete one exchange and read the response |
| 4 | Access-token lifetime | Tunes the refresh-ahead window | Same exchange |
| 5 | **Does a Public client require domain-ownership verification?** | If yes, this is a hard gate for a community app: every user would have to register their own client. API tokens then stay the documented primary path | Read the client-creation flow in the dashboard |
| 6 | Exact scope strings and how they map to permission-group names | Capability gating misfires if the mapping is wrong | Compare `scopes_supported` against `GET /user/tokens/permission_groups` |
| 7 | Does a revocation endpoint exist, and what are its parameters? | "Sign out everywhere" should actually revoke | Metadata document |

## Design decisions already taken because of these

- **Endpoints are discovered, not hardcoded**, with an overridable constant as a
  fallback so a URL change cannot brick installed builds.
- **Both redirect filters are registered from day one** in
  `AndroidManifest.xml`, driven by `manifestPlaceholders`. Switching between the
  custom scheme and an App Link is a build flag, not a release:

  ```bash
  flutter build apk -Poauth-host=cf.example.com
  ```

- **The client ID is injectable.** Official builds bake one in via
  `--dart-define=CFMGR_OAUTH_CLIENT_ID=`, and Settings lets anyone paste their
  own — which is the escape hatch if question 5 turns out badly, and is required
  anyway for people building from source.

## How to run the spike

1. In the Cloudflare dashboard: **Manage account → OAuth clients → Create**.
   Choose the public/PKCE client type. Requires the Super Administrator,
   Administrator, or OAuth Client Write role.
2. Register `io.cfmgr.app://oauth/callback` as a redirect URI. Note whether the
   form rejects it.
3. Record the client ID, the scopes offered, and whether the dashboard demands
   domain verification before the client can be used by others.
4. Run the authorization flow by hand (browser + `curl` for the token exchange)
   and record the response: token lifetime, refresh token presence, scope list.
5. Write the answers into the table above and open a PR enabling the OAuth path.

Until then, onboarding shows the OAuth option greyed out with a pointer to this
file, rather than pretending it works.
