import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Color & label for HTTP method chips.
class MethodStyle {
  final Color color;
  final IconData icon;
  const MethodStyle(this.color, this.icon);

  static MethodStyle of(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return const MethodStyle(Color(0xFF22C55E), Icons.download_rounded);
      case 'POST':
        return const MethodStyle(Color(0xFF3B82F6), Icons.add_circle_outline);
      case 'PUT':
        return const MethodStyle(Color(0xFFF59E0B), Icons.upload_rounded);
      case 'PATCH':
        return const MethodStyle(Color(0xFFA855F7), Icons.edit_outlined);
      case 'DELETE':
        return const MethodStyle(Color(0xFFEF4444), Icons.delete_outline);
      default:
        return const MethodStyle(Color(0xFF6B7280), Icons.api_outlined);
    }
  }
}

class MethodChip extends StatelessWidget {
  final String method;
  final double width;
  const MethodChip(this.method, {super.key, this.width = 64});

  @override
  Widget build(BuildContext context) {
    final s = MethodStyle.of(method);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: s.color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(
          color: s.color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Highlights `{param}` placeholders in API paths.
class HighlightedPath extends StatelessWidget {
  final String path;
  final TextStyle? baseStyle;
  const HighlightedPath(this.path, {super.key, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = baseStyle ??
        const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.4,
        );
    final spans = <InlineSpan>[];
    final reg = RegExp(r'\{([^}]+)\}');
    var last = 0;
    for (final m in reg.allMatches(path)) {
      if (m.start > last) {
        spans.add(TextSpan(text: path.substring(last, m.start), style: base));
      }
      spans.add(TextSpan(
        text: m.group(0),
        style: base.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ));
      last = m.end;
    }
    if (last < path.length) {
      spans.add(TextSpan(text: path.substring(last), style: base));
    }
    return RichText(text: TextSpan(children: spans));
  }
}

String prettyJson(Object? value) {
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } catch (_) {
    return value?.toString() ?? '';
  }
}

void copyToClipboard(BuildContext ctx, String text, {String? label}) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(label ?? 'Скопировано'),
      duration: const Duration(milliseconds: 1200),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Card section with header.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final List<Widget>? actions;
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...?actions,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Pretty status code chip (2xx green / 4xx orange / 5xx red).
class StatusChip extends StatelessWidget {
  final int code;
  const StatusChip(this.code, {super.key});
  @override
  Widget build(BuildContext context) {
    Color c = Colors.grey;
    if (code >= 200 && code < 300) c = const Color(0xFF22C55E);
    else if (code >= 300 && code < 400) c = const Color(0xFF3B82F6);
    else if (code >= 400 && code < 500) c = const Color(0xFFF59E0B);
    else if (code >= 500) c = const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withValues(alpha: 0.6)),
      ),
      child: Text(
        'HTTP $code',
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
