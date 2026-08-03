# Contributing

## Getting set up

Flutter 3.44+, JDK 17, Android SDK (compile/target 36, min 26).

```bash
flutter pub get
flutter test
flutter run
```

`android/local.properties` is gitignored — Flutter writes it for you. It used to
be committed with one machine's absolute paths, which broke every fresh clone.

## The generated client

`lib/api/generated/` is produced by `tool/openapi/generate.dart` and must not be
edited by hand. To add an endpoint, add it to `tool/openapi/allowlist.yaml` and
regenerate:

```bash
dart run tool/openapi/generate.dart
```

Commit the regenerated output. CI runs the generator and fails on any diff, so
the committed code cannot drift from `spec/openapi.json`.

An allowlist entry looks like:

```yaml
- id: dns-records-for-a-zone-create-dns-record   # operationId from the spec
  as: createRecord                               # Dart method name
  group: dns                                     # lands on DnsApi
  perms: [DNS Write]                             # named in 403 errors
  union: flatten                                 # how to treat anyOf bodies
```

`perms` matters more than it looks: Cloudflare does not say which permission
group is missing on a 403, so this list is the only way the UI can tell a user
what to fix.

## House rules

- **No `Text('$e')`.** Every async surface goes through `AsyncView`, and errors
  go through `failureMessage`. If a failure mode has no useful message yet, add
  a case to `CfFailure` rather than printing the exception.
- **No user-visible string literals in Dart.** Add them to `lib/l10n/app_en.arb`
  (the template) *and every other locale*. CI fails on Cyrillic outside
  `lib/l10n/`, and `test/features/localization_test.dart` fails if any locale is
  missing a key, drops a placeholder, or is still verbatim English.
- **Never retry a non-idempotent request** without an explicit opt-in at the
  call site, and think about duplicates before you add one.
- **No offline write queue.** See `docs/architecture.md`; this is a stated
  non-goal.
- **Nothing that logs, copies or displays a secret** may bypass the redactor in
  `core/net/interceptors/redaction.dart`.
- Run `dart format` and `flutter analyze --fatal-infos` before pushing; CI
  enforces both.

## Translations

The app ships English, Azerbaijani, German, Spanish, French, Turkish, Russian
and Chinese. Everything except English was written by someone who is not a
native speaker — **corrections are as welcome as new languages**, and neither
needs an issue first.

To add a language, copy `lib/l10n/app_en.arb` to `app_<code>.arb`, set
`@@locale`, translate the values, drop the `@key` metadata blocks (only the
template needs them), and add the code with its endonym to
`kSupportedLanguages` in `lib/app/app_settings.dart`. Then:

```bash
flutter gen-l10n && flutter test test/features/localization_test.dart
```

Two things the test will hold you to. Placeholders such as `{count}` must
survive translation — losing one is a crash, not a typo. And plural forms use
your language's real CLDR categories: Russian needs `one/few/other`, German and
French need `one/other`, Turkish and Chinese need only `other`. Leave Cloudflare
product names (Workers, Pages, R2, Zero Trust, Turnstile) in English; that is
what they are called everywhere.

## Tests

| Kind | Where | Runs on |
|---|---|---|
| Unit | `test/core`, `test/features` | every push |
| Generated model round-trips | `test/generated` (emitted) | every push |
| Mocked end-to-end through the real client | `test/integration` | every push |
| Real app on a real device | `integration_test/` | main and on demand |

`integration_test/app_test.dart` drives the actual widget tree on a device with
the transport mocked, so it needs no Cloudflare account. Add to it when you add
a screen — that suite is what proves the app still starts.

Adding a failure mode? Add a case to `test/core/failure_mapping_test.dart`. The
error-code table is empirical and grows by observation.
