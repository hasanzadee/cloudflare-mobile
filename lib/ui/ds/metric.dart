import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'panel.dart';
import 'tone.dart';

/// One number with a label underneath, for rows of totals.
class Metric extends StatelessWidget {
  const Metric({
    required this.label,
    required this.value,
    this.tone = Tone.neutral,
    this.large = false,
    super.key,
  });

  final String label;
  final String value;
  final Tone tone;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final style = large
        ? context.text.headlineMedium
        : context.text.titleMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          style: tabular(style)?.copyWith(
            fontWeight: FontWeight.w700,
            color: tone == Tone.neutral ? null : context.toneColor(tone),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelMedium?.copyWith(
            color: context.scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A change against the previous period, e.g. "+8%".
///
/// Neutral rather than green or red: more requests is not good or bad on its
/// own, and colouring it pretends to know which.
class DeltaBadge extends StatelessWidget {
  const DeltaBadge({required this.ratio, super.key});

  /// Current over previous, minus one. Null when there is no previous period.
  final double? ratio;

  @override
  Widget build(BuildContext context) {
    final r = ratio;
    if (r == null || r.isNaN || r.isInfinite) return const SizedBox.shrink();
    final pct = (r * 100).round();
    final up = pct >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: context.scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            up ? Icons.north_east : Icons.south_east,
            size: 12,
            color: context.scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 2),
          Text(
            '${up ? '+' : ''}$pct%',
            style: tabular(context.text.labelSmall)?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact counts: 1.4M, 12.3k.
String compactCount(num n) {
  final v = n.abs();
  if (v >= 1e9) return '${(n / 1e9).toStringAsFixed(1)}B';
  if (v >= 1e6) return '${(n / 1e6).toStringAsFixed(1)}M';
  if (v >= 1e4) return '${(n / 1e3).toStringAsFixed(0)}k';
  if (v >= 1e3) return '${(n / 1e3).toStringAsFixed(1)}k';
  return '${n.round()}';
}

String compactBytes(num n) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  var v = n.toDouble();
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v >= 100 || i == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)} ${units[i]}';
}
