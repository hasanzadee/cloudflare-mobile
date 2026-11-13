/// Gateway DNS queries as a live log.
///
/// Cloudflare has no streaming endpoint for Gateway logs short of Logpush, so
/// the log is a poll of `gatewayResolverQueriesAdaptiveGroups` grouped down to
/// the second. Two things shape everything below:
///
/// - Queries land in the dataset about a minute after they happen, and late
///   rows keep arriving for a while. Each poll therefore re-reads a few
///   minutes it has already seen, and [mergeDnsLog] folds those re-reads in by
///   key instead of appending duplicates.
/// - The dataset is sampled. `count` is an estimate that can change between
///   polls for the same row, so a re-read replaces the count rather than
///   adding to it.
library;

/// What Gateway did with a query, folded from the dataset's eleven codes into
/// the four a person scanning the log cares about.
enum DnsDecision { allowed, blocked, overridden, unknown }

/// Codes from the `resolverDecision` description in the GraphQL schema:
/// (0 unknown) (1 allowedByQueryName) (2 blockedByQueryName)
/// (3 blockedByCategory) (4 allowedOnNoLocation) (5 allowedOnNoPolicyMatch)
/// (6 blockedAlwaysCategory) (7 overrideForSafeSearch) (8 overrideApplied)
/// (9 blockedRule) (10 allowedRule). Codes added later read as unknown rather
/// than being guessed into a bucket.
DnsDecision dnsDecisionOf(int code) => switch (code) {
  1 || 4 || 5 || 10 => DnsDecision.allowed,
  2 || 3 || 6 || 9 => DnsDecision.blocked,
  7 || 8 => DnsDecision.overridden,
  _ => DnsDecision.unknown,
};

/// The codes behind each filter chip, sent as `resolverDecision_in` so the
/// server applies the filter before the row limit does. Filtering on the
/// device instead would leave a "Blocked" view nearly empty on any account
/// whose traffic is mostly allowed.
const Map<DnsDecision, List<int>> kDnsDecisionCodes = {
  DnsDecision.allowed: [1, 4, 5, 10],
  DnsDecision.blocked: [2, 3, 6, 9],
  DnsDecision.overridden: [7, 8],
};

class DnsLogEntry {
  const DnsLogEntry({
    required this.at,
    required this.query,
    required this.code,
    required this.count,
    this.policy = '',
    this.location = '',
    this.country = '',
    this.categories = const [],
    this.resolvedIps = const [],
  });

  final DateTime at;
  final String query;
  final int code;
  final int count;
  final String policy;
  final String location;
  final String country;
  final List<String> categories;
  final List<String> resolvedIps;

  DnsDecision get decision => dnsDecisionOf(code);

  /// Every dimension the query groups by, so two rows share a key exactly
  /// when Cloudflare would have grouped them together.
  String get key => [
    at.millisecondsSinceEpoch,
    query,
    code,
    policy,
    location,
    country,
    categories.join(','),
    resolvedIps.join(','),
  ].join('|');

  /// One group from the GraphQL answer, or null for anything malformed —
  /// a log that drops an odd row beats one that shows nothing.
  static DnsLogEntry? tryParse(Object? group) {
    if (group is! Map) return null;
    final d = group['dimensions'];
    if (d is! Map) return null;
    final at = DateTime.tryParse('${d['datetime']}');
    final query = d['queryName'];
    if (at == null || query is! String || query.isEmpty) return null;
    final code = d['resolverDecision'];
    final count = group['count'];
    return DnsLogEntry(
      at: at.toUtc(),
      query: query,
      code: code is num ? code.toInt() : 0,
      count: count is num ? count.toInt() : 1,
      policy: _string(d['policyName']),
      location: _string(d['locationName']),
      country: _string(d['srcIpCountry']),
      categories: _strings(d['categoryNames']),
      resolvedIps: _strings(d['resolvedIps']),
    );
  }

  static String _string(Object? v) => v is String ? v : '';

  static List<String> _strings(Object? v) => v is List
      ? [
          for (final e in v)
            if (e is String && e.isNotEmpty) e,
        ]
      : const [];
}

/// Rows from a GraphQL answer shaped like [gatewayDnsLogQuery]'s.
List<DnsLogEntry> parseDnsLog(Map<String, Object?> data) {
  final viewer = data['viewer'];
  final accounts = viewer is Map ? viewer['accounts'] : null;
  if (accounts is! List || accounts.isEmpty) return const [];
  final account = accounts.first;
  final groups = account is Map
      ? account['gatewayResolverQueriesAdaptiveGroups']
      : null;
  if (groups is! List) return const [];
  return [for (final g in groups) ?DnsLogEntry.tryParse(g)];
}

/// The most rows the log keeps. A phone does not need more to answer "what
/// is being blocked right now", and an unbounded list grows for as long as
/// the screen stays open.
const int kDnsLogCap = 500;

/// [fresh] folded into [current]: re-read rows replace their earlier copy,
/// new rows join, newest first, at most [cap].
List<DnsLogEntry> mergeDnsLog(
  List<DnsLogEntry> current,
  List<DnsLogEntry> fresh, {
  int cap = kDnsLogCap,
}) {
  final byKey = <String, DnsLogEntry>{
    for (final e in current) e.key: e,
    for (final e in fresh) e.key: e,
  };
  final merged = byKey.values.toList()..sort((a, b) => b.at.compareTo(a.at));
  return merged.length > cap ? merged.sublist(0, cap) : merged;
}

/// How far back the first read goes.
const Duration kDnsLogBacklog = Duration(minutes: 30);

/// How much of the already-seen window each poll reads again, for the rows
/// that arrive late.
const Duration kDnsLogOverlap = Duration(minutes: 3);

/// The `filter` argument for one poll.
Map<String, Object?> dnsLogFilter({
  required DateTime since,
  required DateTime until,
  DnsDecision? decision,
  String search = '',
}) {
  final term = search.trim();
  return {
    'datetime_geq': _time(since),
    'datetime_leq': _time(until),
    if (decision != null && kDnsDecisionCodes[decision] != null)
      'resolverDecision_in': kDnsDecisionCodes[decision],
    // ilike, so "Google" finds google.com; the term goes in a variable, never
    // into the document, so it cannot change the query's shape.
    if (term.isNotEmpty) 'queryName_ilike': '%$term%',
  };
}

String _time(DateTime t) => '${t.toUtc().toIso8601String().split('.').first}Z';

const String gatewayDnsLogQuery = r'''
query GatewayDnsLog(
  $accountTag: string!
  $filter: AccountGatewayResolverQueriesAdaptiveGroupsFilter_InputObject!
) {
  viewer {
    accounts(filter: { accountTag: $accountTag }) {
      gatewayResolverQueriesAdaptiveGroups(
        limit: 200
        filter: $filter
        orderBy: [datetime_DESC]
      ) {
        count
        dimensions {
          datetime
          queryName
          resolverDecision
          policyName
          locationName
          srcIpCountry
          categoryNames
          resolvedIps
        }
      }
    }
  }
}
''';
