import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../scope/scope_providers.dart';
import '../zones/zones_providers.dart';

final dnsSearchProvider = StateProvider.autoDispose.family<String, String>(
  (ref, zoneId) => '',
);

final dnsTypeFilterProvider = StateProvider.autoDispose.family<String?, String>(
  (ref, zoneId) => null,
);

class DnsController
    extends
        AutoDisposeFamilyAsyncNotifier<PagedData<DnsRecordResponse>, String> {
  static const int _perPage = 100;

  @override
  Future<PagedData<DnsRecordResponse>> build(String zoneId) async {
    final search = ref.watch(dnsSearchProvider(zoneId));
    final type = ref.watch(dnsTypeFilterProvider(zoneId));
    final page = await _fetch(zoneId, 1, search, type);
    return PagedData(items: page.items, hasMore: page.hasMore);
  }

  Future<CfPage<DnsRecordResponse>> _fetch(
    String zoneId,
    int page,
    String search,
    String? type,
  ) {
    final api = ref.read(cfApiProvider);
    return api.dns.listRecords(
      zoneId: zoneId,
      page: page,
      perPage: _perPage,
      // `search` matches name, content and comment server-side, which beats
      // filtering a truncated first page on the device.
      search: search.isEmpty ? null : search,
      type_: type,
      cancelToken: autoCancelToken(ref),
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));

    final next = await _fetch(
      arg,
      current.page + 1,
      ref.read(dnsSearchProvider(arg)),
      ref.read(dnsTypeFilterProvider(arg)),
    );
    final seen = current.items.map((r) => r.id).toSet();
    state = AsyncData(
      PagedData(
        items: [...current.items, ...next.items.where((r) => seen.add(r.id))],
        hasMore: next.hasMore,
        page: current.page + 1,
      ),
    );
  }

  Future<void> create(DnsRecordPost record) async {
    await ref.read(cfApiProvider).dns.createRecord(zoneId: arg, body: record);
    ref.invalidateSelf();
  }

  /// Named `edit` rather than `update`: AsyncNotifier already defines
  /// `update`, and overriding it with a different signature does not compile.
  Future<void> edit(String recordId, DnsRecordPost record) async {
    await ref
        .read(cfApiProvider)
        .dns
        .updateRecord(zoneId: arg, dnsRecordId: recordId, body: record);
    ref.invalidateSelf();
  }

  Future<void> delete(String recordId) async {
    await ref
        .read(cfApiProvider)
        .dns
        .deleteRecord(zoneId: arg, dnsRecordId: recordId);
    ref.invalidateSelf();
  }

  /// Re-reads one record straight from the API.
  ///
  /// Called when opening the editor: a management app must not offer a Save
  /// button over a list entry that may be minutes stale.
  Future<DnsRecordResponse> readFresh(String recordId) => ref
      .read(cfApiProvider)
      .dns
      .getRecord(
        zoneId: arg,
        dnsRecordId: recordId,
        cancelToken: autoCancelToken(ref),
      );
}

final dnsProvider = AsyncNotifierProvider.autoDispose
    .family<DnsController, PagedData<DnsRecordResponse>, String>(
      DnsController.new,
    );
