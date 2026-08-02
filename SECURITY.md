# Security policy

This app holds credentials that can change DNS, disable security rules and, with
a Global API key, touch billing. Treat security reports accordingly.

## Reporting

Open a [private security advisory](../../security/advisories/new) on GitHub.
Please do not open a public issue for anything that lets an attacker reach a
stored credential.

Expect an acknowledgement within 7 days and an assessment within 30.

## What the app does with your credentials

- Encrypted with AES-256-GCM under a key derived from your PIN
  (PBKDF2-HMAC-SHA256, 210 000 iterations, random 16-byte salt) and stored in
  Keystore-backed `EncryptedSharedPreferences`. The PIN is never stored; only
  `SHA-256` of the derived key, as a fast wrong-PIN check.
- Sent only to `api.cloudflare.com`, in the `Authorization` or
  `X-Auth-Email`/`X-Auth-Key` headers. `dash.cloudflare.com` is opened in a
  browser tab for token creation, which is a normal web navigation and carries
  no app credential.
- Never written to logs. The debug logger redacts auth headers and known secret
  body keys, and every diagnostic string the user can copy passes through the
  same redactor. Release builds do not log requests at all.
- Excluded from cloud backup and device transfer (`allowBackup=false` plus
  explicit data-extraction rules).

## Known limitations, stated plainly

- **A rooted device defeats this.** Keystore protects the biometric-wrapped key
  against app-data extraction, not against an attacker with root and a live
  process to dump.
- **Certificates are not pinned.** See the README for the reasoning. An attacker
  who can install a CA on the device *and* get past `FLAG_SECURE` and the lock
  screen is outside the threat model; release builds do reject user-installed
  CAs.
- **The Global API key cannot be constrained.** If you use one, this app can do
  anything your account can, including delete it. The UI says so and requires a
  typed confirmation, but the risk is inherent to the credential type.
- **Screenshot blocking is user-disablable.** It is on by default.
- **The OAuth path is not enabled.** See `docs/oauth-spike.md`.

## Threat model in one line

Protect stored Cloudflare credentials against someone who picks up an unlocked
or stolen phone, against another app on the device, and against accidental
disclosure through logs, backups and screenshots.
