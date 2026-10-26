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

/// The app's own palette: neutral greys with Cloudflare orange as the single
/// accent.
///
/// A seeded scheme on its own tints every surface orange-beige, which is what
/// made v1 look like a stock template. The surfaces are pinned to neutral
/// values instead, so the accent only appears where it means something — the
/// orange cloud, the primary action, the selected tab.
ColorScheme cfScheme(Brightness mode) {
  final seeded = ColorScheme.fromSeed(
    seedColor: kCloudflareOrange,
    brightness: mode,
  );
  return mode == Brightness.dark
      ? seeded.copyWith(
          primary: kCloudflareOrange,
          onPrimary: const Color(0xFF1C0E02),
          primaryContainer: const Color(0xFF3A1E08),
          onPrimaryContainer: const Color(0xFFFFD6B0),
          surface: const Color(0xFF0C0C0E),
          onSurface: const Color(0xFFF2F2F3),
          onSurfaceVariant: const Color(0xFFA1A1AA),
          surfaceContainerLowest: const Color(0xFF08080A),
          surfaceContainerLow: const Color(0xFF151518),
          surfaceContainer: const Color(0xFF1B1B1F),
          surfaceContainerHigh: const Color(0xFF232328),
          surfaceContainerHighest: const Color(0xFF2B2B31),
          outline: const Color(0xFF52525B),
          outlineVariant: const Color(0xFF26262B),
        )
      : seeded.copyWith(
          // Darker than the brand orange so white text on it stays legible.
          primary: const Color(0xFFC2410C),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFE8D6),
          onPrimaryContainer: const Color(0xFF7C2D12),
          surface: const Color(0xFFF4F4F5),
          onSurface: const Color(0xFF18181B),
          onSurfaceVariant: const Color(0xFF6B6B74),
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainer: const Color(0xFFEFEFF1),
          surfaceContainerHigh: const Color(0xFFE8E8EB),
          surfaceContainerHighest: const Color(0xFFE1E1E5),
          outline: const Color(0xFFA1A1AA),
          outlineVariant: const Color(0xFFE4E4E7),
        );
}

ThemeData buildTheme({ColorScheme? dynamicScheme, required Brightness mode}) {
  final scheme = dynamicScheme ?? cfScheme(mode);
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: mode,
  );
  final text = base.textTheme;

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    extensions: [mode == Brightness.dark ? CfColors.dark : CfColors.light],
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineSmall: text.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primaryContainer,
      height: 68,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => text.labelSmall?.copyWith(
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant, width: 0.6),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 0.6,
      space: 0.6,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 46),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      side: BorderSide(color: scheme.outlineVariant, width: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      isDense: true,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  );
}
