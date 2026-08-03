import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/application/auth_providers.dart';

/// Appearance and language, persisted.
///
/// Both default to following the system, which is what most people want and
/// costs nothing. The overrides exist because "most people" is not everyone:
/// a phone set to a language you can read is not the same as a technical app
/// you would rather read in English.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.useDynamicColor = true,
    this.blockScreenshots = true,
    this.autoLock = const Duration(minutes: 1),
  });

  final ThemeMode themeMode;

  /// Null means "follow the system".
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
      locale: localeTag == null || localeTag.isEmpty ? null : Locale(localeTag),
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
