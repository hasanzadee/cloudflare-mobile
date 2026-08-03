import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/application/auth_providers.dart';

/// Languages the app ships, in the order the picker shows them.
///
/// English leads because it is the default. The rest are alphabetical by their
/// own endonym, not by English name — a Turkish speaker looks for "Türkçe".
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

/// Appearance and language, persisted.
///
/// Language defaults to English rather than the system: this is a technical
/// tool whose vocabulary — zone, purge, ruleset — is English in the dashboard
/// and in every piece of Cloudflare documentation, and a translation of it is a
/// preference, not an improvement. Picking "System" is one tap away.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.useDynamicColor = true,
    this.blockScreenshots = true,
    this.autoLock = const Duration(minutes: 1),
  });

  final ThemeMode themeMode;

  /// Null means "follow the system", which is a deliberate choice the user made
  /// rather than the absence of one — see [AppSettingsController._restore].
  final Locale? locale;

  /// Material You. Off falls back to the Cloudflare-orange seed, which is what
  /// the app looks like on devices without dynamic colour anyway.
  final bool useDynamicColor;

  final bool blockScreenshots;
  final Duration autoLock;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    bool? useDynamicColor,
    bool? blockScreenshots,
    Duration? autoLock,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: clearLocale ? null : (locale ?? this.locale),
    useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    blockScreenshots: blockScreenshots ?? this.blockScreenshots,
    autoLock: autoLock ?? this.autoLock,
  );
}

/// Auto-lock choices offered in Settings.
const List<Duration> kAutoLockChoices = [
  Duration.zero,
  Duration(seconds: 30),
  Duration(minutes: 1),
  Duration(minutes: 5),
  Duration(minutes: 30),
  Duration(days: 3650),
];

class AppSettingsController extends Notifier<AppSettings> {
  static const _kTheme = 'ui.theme_mode';
  static const _kLocale = 'ui.locale';
  static const _kDynamic = 'ui.dynamic_color';
  static const _kSecure = 'ui.block_screenshots';
  static const _kAutoLock = 'ui.auto_lock_seconds';

  SharedPreferences? _prefs;

  @override
  AppSettings build() {
    // Preferences load asynchronously; the app renders with defaults for one
    // frame and then settles. Blocking the first frame on disk would be worse.
    _restore();
    return const AppSettings();
  }

  Future<void> _restore() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    _prefs = prefs;

    final localeTag = prefs.getString(_kLocale);
    final lockSeconds = prefs.getInt(_kAutoLock);

    state = AppSettings(
      themeMode: switch (prefs.getString(_kTheme)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      // Three distinct states, and collapsing any two of them loses something:
      // absent means the user has never chosen (English), empty means they
      // chose "System", and a tag is an explicit language.
      locale: switch (localeTag) {
        null => const Locale('en'),
        '' => null,
        final tag => Locale(tag),
      },
      useDynamicColor: prefs.getBool(_kDynamic) ?? true,
      blockScreenshots: prefs.getBool(_kSecure) ?? true,
      autoLock: lockSeconds == null
          ? const Duration(minutes: 1)
          : Duration(seconds: lockSeconds),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setString(_kTheme, mode.name);
  }

  Future<void> setLocale(Locale? locale) async {
    state = state.copyWith(locale: locale, clearLocale: locale == null);
    await _prefs?.setString(_kLocale, locale?.languageCode ?? '');
  }

  Future<void> setDynamicColor({required bool enabled}) async {
    state = state.copyWith(useDynamicColor: enabled);
    await _prefs?.setBool(_kDynamic, enabled);
  }

  Future<void> setBlockScreenshots({required bool enabled}) async {
    state = state.copyWith(blockScreenshots: enabled);
    await _prefs?.setBool(_kSecure, enabled);
  }

  Future<void> setAutoLock(Duration duration) async {
    state = state.copyWith(autoLock: duration);
    await _prefs?.setInt(_kAutoLock, duration.inSeconds);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );
