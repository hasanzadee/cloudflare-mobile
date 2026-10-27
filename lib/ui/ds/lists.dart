import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'panel.dart';
import 'rows.dart';
import 'tone.dart';

/// One row of a long, lazily built list that should still read as a single
/// rounded group.
///
/// [RowGroup] builds all of its children at once, which is right for six
/// destinations and wrong for four hundred DNS records. This gives each row
/// its own slice of the group's shape — rounded on top for the first, at the
/// bottom for the last — so a `ListView.builder` can draw one at a time.
class GroupedItem extends StatelessWidget {
  const GroupedItem({
    required this.index,
    required this.count,
    required this.child,
    this.dividerIndent = Gap.lg,
    super.key,
  });

  final int index;
  final int count;
  final Widget child;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(20);
    final first = index == 0;
    final last = index == count - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
      child: Material(
        color: context.scheme.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.vertical(
          top: first ? r : Radius.zero,
          bottom: last ? r : Radius.zero,
        ),
        child: Column(
          children: [
            if (!first) Divider(indent: dividerIndent, height: 0.6),
            child,
          ],
        ),
      ),
    );
  }
}

/// A filled, borderless search box — the outlined form field reads as
/// "fill this in", which a filter is not.
class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final none = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: onClear == null || controller.text.isEmpty
            ? null
            : IconButton(icon: const Icon(Icons.close), onPressed: onClear),
        filled: true,
        fillColor: context.scheme.surfaceContainerLow,
        border: none,
        enabledBorder: none,
        focusedBorder: none.copyWith(
          borderSide: BorderSide(color: context.scheme.primary, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

/// What an empty list says: what belongs here, and the button that adds it.
///
/// v1 printed "No rules in this phase yet" in the middle of a blank screen,
/// with the way to add one hidden in a floating button the eye had already
/// skipped.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.body,
    this.action,
    this.onAction,
    this.tone = Tone.neutral,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? action;
  final VoidCallback? onAction;
  final Tone tone;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(Gap.xl * 1.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTile(icon: icon, tone: tone, size: 64),
          const SizedBox(height: Gap.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.text.titleMedium,
          ),
          if (body != null) ...[
            const SizedBox(height: Gap.xs),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: Gap.lg),
            FilledButton.tonalIcon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(action!),
            ),
          ],
        ],
      ),
    ),
  );
}
