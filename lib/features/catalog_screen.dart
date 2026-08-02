import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/catalog.dart';
import '../core/ui.dart';
import 'tag_endpoints_screen.dart';
import 'endpoint_runner_screen.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});
  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(catalogProvider);
    return Scaffold(
      body: cat.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка загрузки: $e')),
        data: (catalog) => _buildContent(catalog),
      ),
    );
  }

  Widget _buildContent(Catalog c) {
    final theme = Theme.of(context);
    final isSearching = _query.trim().isNotEmpty;
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Каталог API'),
          floating: true,
          snap: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${c.all.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              controller: _searchCtrl,
              hintText: 'Поиск: путь, summary, тег...',
              leading: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.search),
              ),
              trailing: _query.isEmpty
                  ? null
                  : [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                    ],
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
        if (isSearching)
          _searchResults(c)
        else
          _categoryList(c),
      ],
    );
  }

  Widget _searchResults(Catalog c) {
    final q = _query.toLowerCase().trim();
    final results = c.all
        .where((e) =>
            e.path.toLowerCase().contains(q) ||
            e.summary.toLowerCase().contains(q) ||
            e.tag.toLowerCase().contains(q) ||
            e.operationId.toLowerCase().contains(q))
        .take(300)
        .toList();
    if (results.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('Ничего не найдено')),
      );
    }
    return SliverList.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => _EndpointTile(results[i]),
    );
  }

  Widget _categoryList(Catalog c) {
    final cats = c.tagsByCategory.keys.toList()..sort();
    return SliverList.builder(
      itemCount: cats.length,
      itemBuilder: (_, i) {
        final cat = cats[i];
        final tags = c.tagsByCategory[cat]!;
        final total =
            tags.fold<int>(0, (sum, t) => sum + (c.byTag[t]?.length ?? 0));
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                cat.substring(0, 1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            title: Text(
              cat,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${tags.length} тегов · $total эндпоинтов'),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: tags.map((t) {
              final endpoints = c.byTag[t]!;
              return ListTile(
                dense: true,
                title: Text(t),
                trailing: Text(
                  '${endpoints.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TagEndpointsScreen(tag: t),
                  ));
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _EndpointTile extends StatelessWidget {
  final Endpoint e;
  const _EndpointTile(this.e);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => EndpointRunnerScreen(endpoint: e),
        ));
      },
      leading: MethodChip(e.method),
      title: HighlightedPath(e.path),
      subtitle: Text(
        '${e.summary.isNotEmpty ? e.summary : e.operationId} · ${e.tag}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: e.deprecated
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).hintColor,
          decoration: e.deprecated ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
