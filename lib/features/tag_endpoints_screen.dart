import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/catalog.dart';
import '../core/ui.dart';
import 'endpoint_runner_screen.dart';

class TagEndpointsScreen extends ConsumerWidget {
  final String tag;
  const TagEndpointsScreen({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(catalogProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tag)),
      body: cat.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (c) {
          final list = c.byTag[tag] ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Пусто'));
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final e = list[i];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => EndpointRunnerScreen(endpoint: e),
                  ));
                },
                leading: MethodChip(e.method),
                title: HighlightedPath(e.path),
                subtitle: e.summary.isEmpty
                    ? null
                    : Text(
                        e.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: e.deprecated
                              ? Theme.of(context).colorScheme.error
                              : null,
                          decoration: e.deprecated
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                trailing: e.deprecated
                    ? const Icon(Icons.warning_amber, color: Colors.orange)
                    : const Icon(Icons.chevron_right),
              );
            },
          );
        },
      ),
    );
  }
}
