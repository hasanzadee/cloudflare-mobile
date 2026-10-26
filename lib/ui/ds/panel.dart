import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Spacing scale. Four values cover every gap in the app; a fifth would be a
/// sign that two screens are drifting apart.
abstract final class Gap {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

/// The one surface everything sits on: a rounded, hairline-bordered card.
///
/// v1 put content straight on the page between dividers, so nothing had an
/// edge and every screen read as one long list. Grouping into panels is most
/// of what makes the new screens scannable.
class Panel extends StatelessWidget {
  const Panel({
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    this.color,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  static const BorderRadius radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? context.scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: borderColor ?? context.scheme.outlineVariant,
          width: 0.6,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// A heading above a group of panels, with an optional trailing link.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {this.action, this.onAction, super.key});

  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.xs, Gap.xl, Gap.xs, Gap.sm),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: context.text.titleSmall?.copyWith(
              color: context.scheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                action!,
                style: context.text.labelLarge?.copyWith(
                  color: context.scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// Numbers that line up: counts in a column should not shimmy as they change.
TextStyle? tabular(TextStyle? style) =>
    style?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
