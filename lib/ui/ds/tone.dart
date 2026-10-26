import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// What a piece of UI is saying, independent of which colour says it.
///
/// Screens pick a tone; the theme decides the colour. That keeps "this zone is
/// pending" amber in both modes without every widget reaching into [CfColors]
/// and choosing its own shade.
enum Tone { neutral, success, warning, danger, info, brand }

extension ToneColors on BuildContext {
  /// Foreground for text, icons and strokes.
  Color toneColor(Tone tone) => switch (tone) {
    Tone.neutral => scheme.onSurfaceVariant,
    Tone.success => cf.success,
    Tone.warning => cf.warning,
    Tone.danger => cf.danger,
    Tone.info => cf.post,
    Tone.brand => cf.proxied,
  };

  /// A quiet wash of the same hue, for pills and callout backgrounds.
  Color toneWash(Tone tone) => tone == Tone.neutral
      ? scheme.surfaceContainerHigh
      : toneColor(tone).withValues(
          alpha: Theme.of(this).brightness == Brightness.dark ? 0.16 : 0.11,
        );
}

/// Black or white, whichever reads on a solid [background].
///
/// Material's brightness estimate puts the dark theme's coral danger on the
/// "dark" side and paints white on it, which barely passes for legible. A
/// luminance cut-off picks black there and still picks white on the deeper
/// light-theme reds.
Color onFill(Color background) =>
    background.computeLuminance() > 0.28 ? Colors.black : Colors.white;
