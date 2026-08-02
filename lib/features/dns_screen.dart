import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/cf_api.dart';
import '../core/state.dart';

final _dnsProvider =
    FutureProvider.autoDispose.family<List<dynamic>, String>((ref, zoneId) async {
  final api = ref.watch(cfApiProvider);
  if (api == null) return [];
  return api.listDns(zoneId);
});

class DnsScreen extends ConsumerWidget {
  final String zoneId;
  final String zoneName;
  const DnsScreen({super.key, required this.zoneId, required this.zoneName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(_dnsProvider(zoneId));
    return Scaffold(
      appBar: AppBar(title: Text(zoneName)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Запись'),
        onPressed: () => _editDialog(context, ref, null),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(_dnsProvider(zoneId)),
        child: records.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('$e', textAlign: TextAlign.center),
            ],
          ),
          data: (rows) {
            if (rows.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(child: Text('Нет DNS-записей')),
                ],
              );
            }
            return ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final r = rows[i] as Map<String, dynamic>;
                return ListTile(
                  title: Text('${r['type']}  ${r['name']}'),
                  subtitle: Text(r['content']?.toString() ?? '—'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') {
                        await _editDialog(context, ref, r);
                      } else if (v == 'delete') {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Удалить?'),
                            content: Text('${r['type']} ${r['name']}'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Отмена')),
                              FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Удалить')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          try {
                            await ref.read(cfApiProvider)!.deleteDns(zoneId, r['id'].toString());
                            ref.invalidate(_dnsProvider(zoneId));
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$e')));
                            }
                          }
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Изменить')),
                      PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _editDialog(
      BuildContext context, WidgetRef ref, Map<String, dynamic>? record) async {
    final type = TextEditingController(text: record?['type']?.toString() ?? 'A');
    final name = TextEditingController(text: record?['name']?.toString() ?? '');
    final content = TextEditingController(text: record?['content']?.toString() ?? '');
    final ttl = TextEditingController(text: record?['ttl']?.toString() ?? '1');
    bool proxied = (record?['proxied'] == true);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: 20 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (ctx, setLocal) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(record == null ? 'Новая DNS-запись' : 'Изменить DNS-запись',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(controller: type, decoration: const InputDecoration(labelText: 'Тип (A, CNAME, TXT, MX, AAAA…)')),
              const SizedBox(height: 12),
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Имя (sub.example.com или @)')),
              const SizedBox(height: 12),
              TextField(controller: content, decoration: const InputDecoration(labelText: 'Содержимое (IP/host/text)')),
              const SizedBox(height: 12),
              TextField(controller: ttl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'TTL (1 = auto)')),
              SwitchListTile(
                value: proxied,
                title: const Text('Через прокси Cloudflare (orange cloud)'),
                onChanged: (v) => setLocal(() => proxied = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Row(children: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
                const Spacer(),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Сохранить')),
              ]),
            ],
          ),
        ),
      ),
    );

    if (saved != true) return;
    final body = {
      'type': type.text.trim(),
      'name': name.text.trim(),
      'content': content.text.trim(),
      'ttl': int.tryParse(ttl.text) ?? 1,
      'proxied': proxied,
    };
    try {
      if (record == null) {
        await ref.read(cfApiProvider)!.createDns(zoneId, body);
      } else {
        await ref.read(cfApiProvider)!.updateDns(zoneId, record['id'].toString(), body);
      }
      ref.invalidate(_dnsProvider(zoneId));
    } on CFException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
