import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'panel.dart';
import 'tone.dart';

/// A panel holding a vertical list of rows separated by inset hairlines.
class RowGroup extends StatelessWidget {
  const RowGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Panel(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(indent: 60, height: 0.6),
          children[i],
        ],
      ],
    ),
  );
}

/// One destination: icon in a tinted square, title, optional detail on the
/// right, chevron.
class NavRow extends StatelessWidget {
  const NavRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.meta,
    this.tone = Tone.neutral,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Short trailing detail: a count, an expiry, a state.
  final String? meta;
  final Tone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.sm, Gap.md),
      child: Row(
        children: [
          IconTile(icon: icon, tone: tone),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (meta != null)
            Padding(
              padding: const EdgeInsets.only(left: Gap.sm),
              child: Text(
                meta!,
                style: tabular(
                  context.text.labelLarge,
                )?.copyWith(color: context.scheme.onSurfaceVariant),
              ),
            ),
          Icon(Icons.chevron_right, color: context.scheme.outline),
        ],
      ),
    ),
  );
}

/// An icon on a rounded tinted square — the leading mark of rows and tiles.
class IconTile extends StatelessWidget {
  const IconTile({
    required this.icon,
    this.tone = Tone.neutral,
    this.size = 36,
    super.key,
  });

  final IconData icon;
  final Tone tone;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: context.toneWash(tone),
      borderRadius: BorderRadius.circular(size * 0.32),
    ),
    child: Icon(
      icon,
      size: size * 0.53,
      color: tone == Tone.neutral
          ? context.scheme.onSurface
          : context.toneColor(tone),
    ),
  );
}

/// A big square button for actions people reach for under pressure.
///
/// [active] fills it with the tone, so "Under attack is on" is visible from
/// across the room rather than encoded in a switch's thumb position.
class ActionTile extends StatelessWidget {
  const ActionTile({
    required this.icon,
    required this.label,
    this.caption,
    this.tone = Tone.neutral,
    this.active = false,
    this.busy = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? caption;
  final Tone tone;
  final bool active;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.toneColor(tone);
    final fg = active ? onFill(accent) : context.scheme.onSurface;

    return Panel(
      onTap: busy ? null : onTap,
      color: active ? accent : null,
      borderColor: active ? accent : null,
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.sm, Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            child: busy
                ? SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: active ? fg : accent,
                    ),
                  )
                : Icon(icon, color: active ? fg : accent, size: 24),
          ),
          const SizedBox(height: Gap.sm),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleSmall?.copyWith(color: fg),
          ),
          Text(
            caption ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tabular(context.text.labelSmall)?.copyWith(
              color: active
                  ? fg.withValues(alpha: 0.8)
                  : context.scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tinted note with an optional action: a warning, a recommendation, an
/// incident.
class Callout extends StatelessWidget {
  const Callout({
    required this.tone,
    required this.title,
    this.body,
    this.icon,
    this.action,
    this.onAction,
    super.key,
  });

  final Tone tone;
  final String title;
  final String? body;
  final IconData? icon;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final fg = context.toneColor(tone);
    return Panel(
      color: context.toneWash(tone),
      borderColor: fg.withValues(alpha: 0.25),
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.md, Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? _defaultIcon, color: fg, size: 20),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.titleSmall?.copyWith(color: fg),
                ),
                if (body != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    body!,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: Gap.sm),
                  InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        action!,
                        style: context.text.labelLarge?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: fg,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData get _defaultIcon => switch (tone) {
    Tone.danger => Icons.error_outline,
    Tone.warning => Icons.warning_amber_rounded,
    Tone.success => Icons.check_circle_outline,
    _ => Icons.info_outline,
  };
}

/// A grey block standing in for content that is still loading.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({this.width, this.height = 14, this.radius = 6, super.key});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: context.scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
