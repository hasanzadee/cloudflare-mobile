import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../scope/scope_providers.dart';

/// Accumulated pages plus enough state for an infinite list to behave.
class PagedData<T> {
  const PagedData({
    this.items = const [],
    this.hasMore = false,
    this.loadingMore = false,
    this.page = 1,
  });

  final List<T> items;
  final bool hasMore;
  final bool loadingMore;
  final int page;

  PagedData<T> copyWith({
    List<T>? items,
    bool? hasMore,
    bool? loadingMore,
    int? page,
  }) => PagedData<T>(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    page: page ?? this.page,
  );
}

/// Free-text filter, applied server-side via the `name` query parameter.
final zoneSearchProvider = StateProvider.autoDispose<String>((ref) => '');

class ZonesController extends AutoDisposeAsyncNotifier<PagedData<Zone>> {
  static const int _perPage = 50;

  @override
  Future<PagedData<Zone>> build() async {
    final scope = ref.watch(scopeProvider);
    final search = ref.watch(zoneSearchProvider);
    final page = await _fetch(1, scope.accountId, search);
    return PagedData(items: page.items, hasMore: page.hasMore);
  }

  Future<CfPage<Zone>> _fetch(int page, String? accountId, String search) {
    final api = ref.read(cfApiProvider);
    return api.zones.listZones(
      page: page,
      perPage: _perPage,
      name: search.isEmpty ? null : search,
      accountId: accountId,
      cancelToken: autoCancelToken(ref),
    );
  }

  /// Loads the next page and appends it.
  ///
  /// The prototype only ever requested page 1 with `per_page: 50`, so an
  /// account with more zones simply appeared to have 50.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final scope = ref.read(scopeProvider);
      final search = ref.read(zoneSearchProvider);
      final next = await _fetch(current.page + 1, scope.accountId, search);
      final seen = current.items.map((z) => z.id).toSet();
      state = AsyncData(
        PagedData(
          items: [...current.items, ...next.items.where((z) => seen.add(z.id))],
          hasMore: next.hasMore,
          page: current.page + 1,
        ),
      );
    } on Object catch (e, st) {
      // Keep what we already have; the tail widget shows the retry.
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final zonesProvider =
    AsyncNotifierProvider.autoDispose<ZonesController, PagedData<Zone>>(
      ZonesController.new,
    );

final zoneDetailsProvider = FutureProvider.autoDispose.family<Zone, String>((
  ref,
  zoneId,
) {
  final api = ref.watch(cfApiProvider);
  return api.zones.getZone(zoneId: zoneId, cancelToken: autoCancelToken(ref));
});
