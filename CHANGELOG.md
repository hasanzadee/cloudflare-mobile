# Changelog

Notable changes per release. Dates are ISO-8601.

## [Unreleased]

## [1.0.0] — 2026-08-03

First public release. The project began as a 15-file prototype that could list
zones, edit DNS records and fire a raw API request; almost none of that code
survives.

### Added

- **Zones** — list with server-side search, pagination past the old 50-zone
  ceiling, zone hub with plan, status and nameservers.
- **DNS** — all 21 record types with per-type structured forms (SRV's
  service/proto/priority/weight/port/target, CAA's flags/tag/value, and so on),
  proxy toggle inline, TTL, comments, tags, search, BIND export.
- **Cache** — purge by URL, host, prefix or tag, and purge-everything behind a
  type-to-confirm gate.
- **Zone settings** — SSL/TLS mode, HSTS, minimum TLS version, cache level,
  security level and 15 more.
- **Analytics** — traffic, cache hit ratio, threats, status codes, top
  countries, content types and firewall events, over a hand-written GraphQL
  layer because the Analytics API is absent from the OpenAPI description.
- **Security** — WAF custom rules and rate limiting (enable, disable, delete),
  IP access rules (list, create, delete).
- **Developer platform** — Workers scripts, routes and cron triggers; Pages
  projects and deployments; KV namespaces with key browse, read, edit, delete;
  D1 with a SQL console that gates destructive statements; R2 buckets.
- **Zero Trust** — tunnels with live connector status, Access applications and
  policies, Gateway rules.
- **Traffic, TLS and email** — page rules, load balancers, waiting rooms,
  certificate packs, custom hostnames, DNSSEC, email routing, Turnstile,
  notification policies.
- **API explorer** — every one of the 3240 endpoints, with forms built from the
  endpoint's own schema: typed inputs, enum dropdowns, required flags, ranges
  and a pre-filled request body.
- **Multi-profile credentials** — API tokens and Global API keys, switchable
  without signing out, each encrypted separately.
- **PIN and biometric unlock** — AES-256-GCM under a PBKDF2-HMAC-SHA256 key
  (210 000 iterations, derived in a background isolate). Biometrics are bound to
  an Android Keystore key with `setUserAuthenticationRequired`, unwrapped
  through `BiometricPrompt` with a `CryptoObject`, so the TEE enforces them
  rather than the UI.
- **Token wizard** — opens the Cloudflare dashboard with the right permissions
  pre-ticked via a template URL; presets for full access, DNS-only and
  read-only. A 403 names the missing permission group and offers a link that
  adds it.
- **Eight languages** — English (default), Azerbaijani, German, Spanish,
  French, Turkish, Russian, Chinese.
- **Appearance** — Material 3 with dynamic colour, light/dark/system, adaptive
  icon with a monochrome variant, configurable auto-lock.
- `FLAG_SECURE` on by default, `allowBackup=false`, no telemetry of any kind.

### Fixed

Carried over from the prototype, each of these was silent:

- The rate-limit interceptor waited for `Retry-After` and then passed the 429
  through without retrying, so throttled requests simply failed.
- `per_page` was hardcoded and `result_info` was parsed but never read, so
  everything past the first page of zones and records was invisible.
- Biometric unlock stored a random key next to the ciphertext it protected; the
  fingerprint prompt was a UI gate with no cryptographic effect.
- PBKDF2 ran on the UI isolate, freezing the frame for seconds on unlock.
- Release builds were signed with the debug key.
- The token template deep link used three permission keys that do not exist
  (`dns_records`, `cache_purge`, `waf`). The dashboard drops unknown keys
  without comment, so "create a token" produced one missing DNS, cache purge and
  firewall.
- The account picker awaited an `autoDispose` provider from a callback; with no
  listener the provider was disposed mid-flight and its `CancelToken` cancelled
  the request, so the button did nothing at all.
- The zone chip only rendered once a zone was already selected and had no tap
  handler, making every zone-scoped screen unreachable without a detour through
  the Zones tab.
- The "read + write" token link claimed more than the format can deliver.
  Cloudflare's template URLs accept 27 keys and Zone WAF is not among them, so
  a token made from that button still could not open the Security tab. Eight
  such groups are now listed as a checklist instead of being silently omitted.
- `FailureView` took an `onFixPermissions` callback that no caller ever passed,
  so the offer to re-create a token existed only in the widget's source.
- Signing in left the home screen reading "problem" until the app was
  restarted: the shell replaced onboarding a moment before a credential
  existed, and nothing invalidated the providers holding that first failure.
- Toggling a WAF rule always failed. The Ruleset API replaces rather than
  merges, so `{enabled: false}` on its own was rejected for a missing action
  and expression.
- The loading skeleton was a `ListView`, which throws when `AsyncView` is
  nested in a page that already scrolls — the analytics charts went red for as
  long as the request was in flight.
- Locking hid nothing. The lock screen replaces what `home` renders, but pushed
  routes sit above it, so "Lock now" and auto-lock both left the previous
  screen fully visible.
- The splash screen never drew: the stock template wraps the icon in `<bitmap>`,
  which accepts only a raster, and this icon is a vector.

### Security

- Certificates are deliberately **not** pinned; release builds do not trust
  user-installed CAs instead. Rationale in the README.
- There is deliberately **no offline write queue**. A DNS change queued at 09:00
  and applied silently at 14:00 is the worst bug this app could ship.

[Unreleased]: https://github.com/hasanzadee/cloudflare-mobile/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/hasanzadee/cloudflare-mobile/releases/tag/v1.0.0
