import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/state.dart';
import 'dns_screen.dart';

final _zonesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(cfApiProvider);
  if (api == null) return [];
  return api.listZones();
});

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones = ref.watch(_zonesProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(_zonesProvider),
      child: zones.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text('$e', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Center(
              child: FilledButton(
                onPressed: () => ref.invalidate(_zonesProvider),
                child: const Text('Повторить'),
              ),
            ),
          ],
        ),
        data: (data) {
          if (data.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 80),
                Center(child: Text('Нет зон в этом аккаунте')),
              ],
            );
          }
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final z = data[i] as Map<String, dynamic>;
              final status = (z['status'] ?? '').toString();
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: status == 'active' ? Colors.green : Colors.orange,
                  child: const Icon(Icons.public, color: Colors.white, size: 18),
                ),
                title: Text(z['name']?.toString() ?? '—'),
                subtitle: Text(
                    'plan: ${(z['plan'] is Map ? z['plan']['name'] : '—')}  •  $status'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => DnsScreen(
                      zoneId: z['id']?.toString() ?? '',
                      zoneName: z['name']?.toString() ?? '',
                    ),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
