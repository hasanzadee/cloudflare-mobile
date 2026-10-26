import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'panel.dart';
import 'tone.dart';

/// One value about to change.
class Change {
  const Change(this.label, {required this.from, required this.to});

  final String label;
  final String from;
  final String to;
}

/// Shows exactly what is about to be written and asks before writing it.
///
/// A switch on a phone is one stray thumb away from turning SSL off for a
/// production zone. v1 wrote zone settings the instant they were touched; every
/// write that changes how a zone serves traffic now comes through here, with
/// the old and new value side by side.
///
/// [typeToConfirm], when set, keeps the button inert until that word is typed —
/// for the handful of changes that are hard to take back.
Future<bool> confirmChanges(
  BuildContext context, {
  required String title,
  required List<Change> changes,
  required String confirmLabel,
  String? note,
  Tone tone = Tone.brand,
  String? typeToConfirm,
}) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ChangeSheet(
      title: title,
      changes: changes,
      confirmLabel: confirmLabel,
      note: note,
      tone: tone,
      typeToConfirm: typeToConfirm,
    ),
  );
  return ok ?? false;
}

class _ChangeSheet extends StatefulWidget {
  const _ChangeSheet({
    required this.title,
    required this.changes,
    required this.confirmLabel,
    required this.note,
    required this.tone,
    required this.typeToConfirm,
  });

  final String title;
  final List<Change> changes;
  final String confirmLabel;
  final String? note;
  final Tone tone;
  final String? typeToConfirm;

  @override
  State<_ChangeSheet> createState() => _ChangeSheetState();
}

class _ChangeSheetState extends State<_ChangeSheet> {
  final _typed = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  bool get _armed {
    final word = widget.typeToConfirm;
    return word == null || _typed.text.trim().toUpperCase() == word;
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final accent = context.toneColor(widget.tone);
    final mono = context.text.bodyMedium?.copyWith(fontFamily: 'monospace');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Gap.xl,
        0,
        Gap.xl,
        Gap.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: context.text.titleLarge),
          if (widget.note != null) ...[
            const SizedBox(height: Gap.xs),
            Text(
              widget.note!,
              style: context.text.bodyMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Gap.lg),
          Panel(
            color: context.scheme.surfaceContainer,
            padding: const EdgeInsets.all(Gap.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final c in widget.changes) ...[
                  Text(
                    c.label,
                    style: context.text.labelMedium?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '−  ${c.from}',
                    style: mono?.copyWith(color: context.cf.danger),
                  ),
                  Text(
                    '+  ${c.to}',
                    style: mono?.copyWith(color: context.cf.success),
                  ),
                  if (c != widget.changes.last) const SizedBox(height: Gap.md),
                ],
              ],
            ),
          ),
          if (widget.typeToConfirm != null) ...[
            const SizedBox(height: Gap.lg),
            TextField(
              controller: _typed,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l.dsTypeToConfirm(widget.typeToConfirm!),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: Gap.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l.commonCancel),
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: onFill(accent),
                  ),
                  onPressed: _armed
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  child: Text(widget.confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
