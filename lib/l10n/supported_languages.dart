/// Languages the app ships, in the order the picker shows them.
///
/// English leads because it is the default. The rest are ordered by their own
/// endonym, not by English name — someone looking for Turkish scans for
/// "Türkçe".
///
/// This lives under `lib/l10n/` rather than next to the settings it feeds
/// because CI fails on non-Latin text anywhere else in `lib/`, and rightly so:
/// every other such string belongs in an ARB file. A language picker is the
/// one place that must render names in their own script, so it sits with the
/// rest of the localisation data instead of being carved out of the rule.
library;

const Map<String, String> kSupportedLanguages = {
  'en': 'English',
  'az': 'Azərbaycanca',
  'de': 'Deutsch',
  'es': 'Español',
  'fr': 'Français',
  'tr': 'Türkçe',
  'ru': 'Русский',
  'zh': '中文',
};
