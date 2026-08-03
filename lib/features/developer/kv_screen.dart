// Cloudflare's KV entry type is called `Key`, and so is Flutter's widget key.
// Only the former is needed here.
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../core/net/failure.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/failure_text.dart';
import 'developer_providers.dart';

/// Keys in one KV namespace, with the value behind a tap.
///
/// This is the only cursor-paginated listing in the app: KV does not use page
/// numbers, it hands back an opaque cursor. CfResultInfo already models that,
/// so the paging code here is the same shape as everywhere else.
class KvScreen extends ConsumerStatefulWidget {
  const KvScreen({
    required this.accountId,
    required this.namespaceId,
    required this.title,
    super.key,
  });

  final String accountId;
  final String namespaceId;
  final String title;

  @override
  ConsumerState<KvScreen> createState() => _KvScreenState();
}

class _KvScreenState extends ConsumerState<KvScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final key = (accountId: widget.accountId, namespaceId: widget.namespaceId);
    final keys = ref.watch(kvKeysProvider(key));

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: l.kvSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: AsyncView<CfPage<Key>>(
              value: keys,
              onRetry: () => ref.invalidate(kvKeysProvider(key)),
              isEmpty: (d) => d.items.isEmpty,
              builder: (page) {
                final query = _search.text.trim().toLowerCase();
                final shown = query.isEmpty
                    ? page.items
                    : page.items
                          .where(
                            (k) => (k.name ?? '').toLowerCase().contains(query),
                          )
                          .toList();

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(kvKeysProvider(key)),
                  child: ListView.separated(
                    itemCount: shown.length + (page.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      if (i >= shown.length) {
                        return ListTile(
                          dense: true,
                          title: Text(
                            l.kvMoreKeys,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      final k = shown[i];
                      return ListTile(
                        leading: const Icon(Icons.key_outlined, size: 20),
                        title: Text(
                          k.name ?? '—',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: k.expiration == null
                            ? null
                            : Text(
                                '${l.kvExpires} '
                                '${DateTime.fromMillisecondsSinceEpoch(k.expiration!.toInt() * 1000)}',
                              ),
                        onTap: k.name == null
                            ? null
                            : () => _openValue(k.name!),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openValue(String keyName) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _KvValueSheet(
        accountId: widget.accountId,
        namespaceId: widget.namespaceId,
        keyName: keyName,
      ),
    );
    ref.invalidate(
      kvKeysProvider((
        accountId: widget.accountId,
        namespaceId: widget.namespaceId,
      )),
    );
  }
}

class _KvValueSheet extends ConsumerStatefulWidget {
  const _KvValueSheet({
    required this.accountId,
    required this.namespaceId,
    required this.keyName,
  });

  final String accountId;
  final String namespaceId;
  final String keyName;

  @override
  ConsumerState<_KvValueSheet> createState() => _KvValueSheetState();
}

class _KvValueSheetState extends ConsumerState<_KvValueSheet> {
  final _value = TextEditingController();
  bool _loaded = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final args = (
      accountId: widget.accountId,
      namespaceId: widget.namespaceId,
      keyName: widget.keyName,
    );
    final value = ref.watch(kvValueProvider(args));

    // The editor is populated once; retyping must not be clobbered by a rebuild.
    if (!_loaded && value.hasValue) {
      _loaded = true;
      _value.text = value.value ?? '';
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  widget.keyName,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (value.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (value.hasError)
            FailureView(
              error: value.error!,
              onRetry: () => ref.invalidate(kvValueProvider(args)),
            )
          else
            TextField(
              controller: _value,
              minLines: 6,
              maxLines: 20,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: InputDecoration(labelText: l.kvValue),
            ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _busy || !value.hasValue ? null : _save,
                  child: Text(l.commonSave),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _busy ? null : _delete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(kvActionsProvider)
          .write(
            accountId: widget.accountId,
            namespaceId: widget.namespaceId,
            keyName: widget.keyName,
            value: _value.text,
          );
      if (mounted) Navigator.of(context).pop();
    } on CfFailure catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = failureMessage(context, e);
        });
      }
    }
  }

  Future<void> _delete() async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.commonDelete),
        content: Text(widget.keyName),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(kvActionsProvider)
          .delete(
            accountId: widget.accountId,
            namespaceId: widget.namespaceId,
            keyName: widget.keyName,
          );
      if (mounted) Navigator.of(context).pop();
    } on CfFailure catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = failureMessage(context, e);
        });
      }
    }
  }
}
