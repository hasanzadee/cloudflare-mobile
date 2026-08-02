# Architecture

```
lib/
  main.dart               root gate + bottom-navigation shell + auto-lock
  app/theme.dart          Material 3, dynamic colour, CfColors ThemeExtension
  api/
    coerce.dart           tolerant JSON coercions used by generated models
    generated/            GENERATED — do not edit
  core/
    net/                  CfClient, envelope, failures, pagination, interceptors
    security/             vault, key derivation, Keystore bridge, FLAG_SECURE
    ext.dart
  auth/
    domain/               CfCredential: API token | global key | OAuth
    data/                 dashboard token-template deep links
    application/          Riverpod providers, credential source
    presentation/         onboarding, lock
  features/<area>/        providers + screens per product area
  ui/                     AsyncView, ScopeBar, failure text, primitives
  l10n/                   app_en.arb (template), app_ru.arb
tool/openapi/             the generator
spec/                     vendored Cloudflare OpenAPI description + lock file
```

## Networking

Everything funnels through `CfClient`, so retry, auth, redaction and envelope
handling exist in exactly one place.

**Retry.** `RetryInterceptor` handles 429 (honouring `Retry-After` in both the
delay-seconds and HTTP-date forms), 5xx and transport timeouts, with exponential
backoff and full jitter. It retries **idempotent methods only** by default;
`POST` opts in explicitly via `Options(extra: {kRetryUnsafeKey: true})`. Blindly
re-issuing `POST /dns_records` after a timeout creates duplicate records,
because the first attempt may well have succeeded with the reply lost on the way
back.

A subtlety worth remembering: `validateStatus` is left at its default. If
non-2xx did not raise a `DioException`, `onError` would never fire and the retry
interceptor would be silently dead — which is exactly the class of bug the
previous implementation had.

**Failures.** A sealed `CfFailure` hierarchy replaces stringly-typed errors.
`PermissionFailure` is the one that earns its keep: Cloudflare never names the
missing permission group on a 403, so each repository declares what its endpoint
needs and the UI can offer to re-issue the token with that permission added.

The error-code table in `cf_error_codes.dart` is empirical and incomplete on
purpose. Unmatched codes fall through to the HTTP status, so an incomplete table
degrades instead of misclassifying.

**Pagination** is a value type (`CfPage`, `CfResultInfo`), not an afterthought.
Parsing is lenient — `result_info.count` is typed as a number in the spec and
arrives as a string from some endpoints, and a zone list should not fail over a
counter.

## Caching, and the one hard rule

There is no persistent cache yet; screens read live and show explicit loading
and error states. When a cache is added it must follow three tiers:

| Tier | Data | Behaviour |
|---|---|---|
| Cache freely | accounts, zone list, spec index, analytics snapshots | render from cache, revalidate in background |
| Cache, revalidate before editing | DNS records, rules, zone settings | list from cache; the editor forces a fresh GET and Save stays disabled until it lands |
| Never cache | purge status, deployment state, tunnel status, KV/D1/R2 reads, token verification | live only |

**There will never be an offline write queue.** No optimistic mutations replayed
later. With no network, write UI is disabled with a visible banner. A DNS change
queued at 09:00 and silently applied at 14:00 — after the user gave up and fixed
it in the web dashboard — is the worst bug this app could ship. This is a stated
non-goal, not an unimplemented feature.

## Credentials

```text
masterKey  = PBKDF2-HMAC-SHA256(pin, salt, 210_000)   never stored
vaultKey   = 32 random bytes                          never stored in the clear
  wrap_pin = AES-GCM(vaultKey, masterKey)
  wrap_bio = AES-GCM(vaultKey, Keystore key)          optional
profile.N  = AES-GCM(profile JSON, vaultKey)
verifier   = SHA-256(masterKey)                       rejects a wrong PIN fast
```

Wrapping the vault key rather than encrypting each secret with the PIN-derived
key is what makes changing the PIN, enabling biometrics later, and holding
several profiles all O(1).

The biometric path goes through `BiometricCryptoPlugin.kt`: an Android Keystore
AES key with `setUserAuthenticationRequired(true)` and
`setInvalidatedByBiometricEnrollment(true)`, unwrapped through a
`BiometricPrompt.CryptoObject`. `local_auth` cannot express this — it returns a
boolean, which makes the sensor a UI gate rather than a cryptographic one.

## State

Riverpod 2 with hand-written `Notifier`/`AsyncNotifier` classes. `family` is
what lets `dnsProvider(zoneId)` exist without threading ids through Settings,
and `autoDispose` gives request cancellation for free: each provider creates a
`CancelToken` and cancels it on dispose, so leaving a screen aborts its
in-flight requests.

`ScopeBar` holds the current account and zone as app state. Changing account
clears the zone, because a zone belongs to exactly one account.

## Deliberate omissions

- **No `go_router`.** The shell is an `IndexedStack`, which already preserves
  each tab's state. `go_router` earns its place when OAuth deep links land.
- **No Drift/offline store.** Adds a codegen and migration surface for a benefit
  the cache policy above deliberately limits.
- **No `freezed` for API models.** The generator emits final code directly.
- **No certificate pinning.** See the README for why.
