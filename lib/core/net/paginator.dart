import 'envelope.dart';

/// One page of a Cloudflare collection.
///
/// The prototype hardcoded `per_page` and parsed `result_info` into a field
/// nothing read, so anything past the first 50 zones or 100 DNS records was
/// silently dropped. Pagination is a first-class value here so truncation
/// cannot happen by omission.
class CfPage<T> {
  const CfPage({required this.items, required this.info});

  final List<T> items;
  final CfResultInfo info;

  bool get hasMore => info.hasMore;

  /// Next page number for offset-paginated endpoints.
  int get nextPage => (info.page ?? 1) + 1;

  /// Continuation token for cursor-paginated endpoints (Workers KV, some
  /// Zero Trust listings).
  String? get nextCursor => info.cursor;

  static CfPage<T> from<T>(
    CfEnvelope env,
    T Function(Map<String, Object?> json) parse,
  ) {
    final items = <T>[];
    for (final raw in env.resultAsList) {
      if (raw is Map) {
        items.add(parse(raw.map((k, v) => MapEntry(k.toString(), v))));
      }
    }
    return CfPage<T>(items: items, info: env.resultInfo ?? CfResultInfo.empty);
  }

  CfPage<T> merge(CfPage<T> next, {Object? Function(T)? identity}) {
    if (identity == null) {
      return CfPage<T>(items: [...items, ...next.items], info: next.info);
    }
    final seen = items.map(identity).toSet();
    final merged = [
      ...items,
      ...next.items.where((e) => seen.add(identity(e))),
    ];
    return CfPage<T>(items: merged, info: next.info);
  }

  static CfPage<T> empty<T>() =>
      CfPage<T>(items: const [], info: CfResultInfo.empty);
}

/// Fetches one page given a 1-based page number.
typedef PageFetcher<T> = Future<CfPage<T>> Function(int page);

/// Walks every page.
///
/// [maxPages] is a guard, not a preference: a server that always reports
/// `hasMore` would otherwise spin forever. When the cap is hit the caller is
/// told, so the UI can say "showing first N" instead of quietly lying.
Future<({List<T> items, bool truncated})> fetchAllPages<T>(
  PageFetcher<T> fetch, {
  int maxPages = 40,
}) async {
  final all = <T>[];
  var page = 1;
  var truncated = false;

  while (true) {
    final result = await fetch(page);
    all.addAll(result.items);
    if (!result.hasMore || result.items.isEmpty) break;
    if (page >= maxPages) {
      truncated = true;
      break;
    }
    page++;
  }
  return (items: all, truncated: truncated);
}
