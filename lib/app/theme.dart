import 'package:flutter/material.dart';

/// Semantic colours that are not part of Material's scheme.
///
/// The prototype hardcoded Tailwind-ish hexes inline, which meant the HTTP
/// method chips and status pills kept the same values in dark mode and lost
/// contrast. Putting them in a ThemeExtension gives each mode its own value.
@immutable
class CfColors extends ThemeExtension<CfColors> {
  const CfColors({
    required this.get,
    required this.post,
    required this.put,
    required this.patch,
    required this.delete,
    required this.success,
    required this.warning,
    required this.danger,
    required this.proxied,
  });

  final Color get;
  final Color post;
  final Color put;
  final Color patch;
  final Color delete;
  final Color success;
  final Color warning;
  final Color danger;

  /// Cloudflare's "orange cloud".
  final Color proxied;

  static const CfColors light = CfColors(
    get: Color(0xFF15803D),
    post: Color(0xFF1D4ED8),
    put: Color(0xFFB45309),
    patch: Color(0xFF7E22CE),
    delete: Color(0xFFB91C1C),
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    danger: Color(0xFFB91C1C),
    proxied: Color(0xFFF6821F),
  );

  static const CfColors dark = CfColors(
    get: Color(0xFF4ADE80),
    post: Color(0xFF60A5FA),
    put: Color(0xFFFBBF24),
    patch: Color(0xFFC084FC),
    delete: Color(0xFFF87171),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    proxied: Color(0xFFFBA94C),
  );

  Color forMethod(String method) => switch (method.toUpperCase()) {
    'GET' || 'HEAD' => get,
    'POST' => post,
    'PUT' => put,
    'PATCH' => patch,
    'DELETE' => delete,
    _ => warning,
  };

  @override
  CfColors copyWith({
    Color? get,
    Color? post,
    Color? put,
    Color? patch,
    Color? delete,
    Color? success,
    Color? warning,
    Color? danger,
    Color? proxied,
  }) => CfColors(
    get: get ?? this.get,
    post: post ?? this.post,
    put: put ?? this.put,
    patch: patch ?? this.patch,
    delete: delete ?? this.delete,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    proxied: proxied ?? this.proxied,
  );

  @override
  CfColors lerp(ThemeExtension<CfColors>? other, double t) {
    if (other is! CfColors) return this;
    return CfColors(
      get: Color.lerp(get, other.get, t)!,
      post: Color.lerp(post, other.post, t)!,
      put: Color.lerp(put, other.put, t)!,
      patch: Color.lerp(patch, other.patch, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      proxied: Color.lerp(proxied, other.proxied, t)!,
    );
  }
}

extension CfTheme on BuildContext {
  CfColors get cf => Theme.of(this).extension<CfColors>() ?? CfColors.light;
  ColorScheme get scheme => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}

const Color kCloudflareOrange = Color(0xFFF6821F);

ThemeData buildTheme({ColorScheme? dynamicScheme, required Brightness mode}) {
  final scheme =
      dynamicScheme ??
      ColorScheme.fromSeed(seedColor: kCloudflareOrange, brightness: mode);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [mode == Brightness.dark ? CfColors.dark : CfColors.light],
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  );
}
