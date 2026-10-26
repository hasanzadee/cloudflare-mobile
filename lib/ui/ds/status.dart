import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'tone.dart';

/// A small filled circle that says healthy, attention or broken at a glance.
class StatusDot extends StatelessWidget {
  const StatusDot({required this.tone, this.size = 9, super.key});

  final Tone tone;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: context.toneColor(tone),
      shape: BoxShape.circle,
      border: Border.all(color: context.toneWash(tone), width: size / 3),
    ),
  );
}

/// A compact label on a tinted background: zone status, plan, SSL mode.
class StatusPill extends StatelessWidget {
  const StatusPill(
    this.label, {
    this.tone = Tone.neutral,
    this.icon,
    super.key,
  });

  final String label;
  final Tone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = tone == Tone.neutral
        ? context.scheme.onSurface
        : context.toneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: context.toneWash(tone),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
