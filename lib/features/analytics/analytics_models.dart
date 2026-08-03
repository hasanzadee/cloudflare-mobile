/// Parsing for the Analytics GraphQL responses.
///
/// Written by hand, like the queries: analytics is absent from the OpenAPI
/// description, so there is nothing to generate from. Parsing stays tolerant
/// for the same reason the generated models are — a missing dimension should
/// cost one point on a chart, not the whole screen.
library;

num? _num(Object? v) => switch (v) {
  final num n => n,
  final String s => num.tryParse(s),
  _ => null,
};

int _int(Object? v) => _num(v)?.toInt() ?? 0;

Map<String, Object?>? _map(Object? v) =>
    v is Map ? v.map((k, value) => MapEntry(k.toString(), value)) : null;

List<Map<String, Object?>> _list(Object? v) => v is List
    ? v
          .whereType<Map<Object?, Object?>>()
          .map((e) => e.map((k, value) => MapEntry(k.toString(), value)))
          .toList()
    : const [];

/// One bucket of the time series.
class TrafficPoint {
  const TrafficPoint({
    required this.at,
    required this.requests,
    required this.cachedRequests,
    required this.bytes,
    required this.cachedBytes,
    required this.threats,
    required this.uniques,
  });

  final DateTime at;
  final int requests;
  final int cachedRequests;
  final int bytes;
  final int cachedBytes;
  final int threats;
  final int uniques;

  double get cacheHitRatio => requests == 0 ? 0 : cachedRequests / requests;

  static TrafficPoint? fromJson(Map<String, Object?> json) {
    final dims = _map(json['dimensions']) ?? const {};
    final raw = dims['datetime'] ?? dims['date'];
    final at = DateTime.tryParse(raw?.toString() ?? '');
    if (at == null) return null;

    final sum = _map(json['sum']) ?? const {};
    final uniq = _map(json['uniq']) ?? const {};
    return TrafficPoint(
      at: at,
      requests: _int(sum['requests']),
      cachedRequests: _int(sum['cachedRequests']),
      bytes: _int(sum['bytes']),
      cachedBytes: _int(sum['cachedBytes']),
      threats: _int(sum['threats']),
      uniques: _int(uniq['uniques']),
    );
  }

  /// Digs the series out of `viewer.zones[0].series`.
  static List<TrafficPoint> listFrom(Map<String, Object?> data) {
    final viewer = _map(data['viewer']);
    final zones = _list(viewer?['zones']);
    if (zones.isEmpty) return const [];
    return _list(
      zones.first['series'],
    ).map(TrafficPoint.fromJson).whereType<TrafficPoint>().toList();
  }
}

/// A labelled count, used for every breakdown.
class NamedCount {
  const NamedCount(this.label, this.value, {this.secondary = 0});

  final String label;
  final int value;

  /// Threats for a country, bytes for a content type — whatever pairs with it.
  final int secondary;
}

/// Totals and breakdowns for the selected range.
class TrafficSummary {
  const TrafficSummary({
    this.requests = 0,
    this.cachedRequests = 0,
    this.bytes = 0,
    this.cachedBytes = 0,
    this.threats = 0,
    this.uniques = 0,
    this.countries = const [],
    this.statuses = const [],
    this.contentTypes = const [],
  });

  final int requests;
  final int cachedRequests;
  final int bytes;
  final int cachedBytes;
  final int threats;
  final int uniques;

  final List<NamedCount> countries;
  final List<NamedCount> statuses;
  final List<NamedCount> contentTypes;

  double get cacheHitRatio => requests == 0 ? 0 : cachedRequests / requests;
  double get cachedBandwidthRatio => bytes == 0 ? 0 : cachedBytes / bytes;

  static TrafficSummary fromJson(Map<String, Object?> data) {
    final viewer = _map(data['viewer']);
    final zones = _list(viewer?['zones']);
    if (zones.isEmpty) return const TrafficSummary();

    // The API returns one group per bucket even when no dimensions were asked
    // for, so the totals have to be summed rather than read from [0].
    var requests = 0;
    var cached = 0;
    var bytes = 0;
    var cachedBytes = 0;
    var threats = 0;
    var uniques = 0;
    final countries = <String, ({int requests, int threats})>{};
    final statuses = <String, int>{};
    final contentTypes = <String, ({int requests, int bytes})>{};

    for (final group in _list(zones.first['totals'])) {
      final sum = _map(group['sum']) ?? const {};
      requests += _int(sum['requests']);
      cached += _int(sum['cachedRequests']);
      bytes += _int(sum['bytes']);
      cachedBytes += _int(sum['cachedBytes']);
      threats += _int(sum['threats']);
      uniques += _int((_map(group['uniq']) ?? const {})['uniques']);

      for (final c in _list(sum['countryMap'])) {
        final name = c['clientCountryName']?.toString() ?? '??';
        final prev = countries[name] ?? (requests: 0, threats: 0);
        countries[name] = (
          requests: prev.requests + _int(c['requests']),
          threats: prev.threats + _int(c['threats']),
        );
      }
      for (final s in _list(sum['responseStatusMap'])) {
        final code = s['edgeResponseStatus']?.toString() ?? '?';
        statuses[code] = (statuses[code] ?? 0) + _int(s['requests']);
      }
      for (final t in _list(sum['contentTypeMap'])) {
        final name = t['edgeResponseContentTypeName']?.toString() ?? 'other';
        final prev = contentTypes[name] ?? (requests: 0, bytes: 0);
        contentTypes[name] = (
          requests: prev.requests + _int(t['requests']),
          bytes: prev.bytes + _int(t['bytes']),
        );
      }
    }

    List<NamedCount> top(Map<String, ({int requests, int threats})> source) {
      final list =
          source.entries
              .map(
                (e) => NamedCount(
                  e.key,
                  e.value.requests,
                  secondary: e.value.threats,
                ),
              )
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      return list.take(10).toList();
    }

    final statusList =
        statuses.entries.map((e) => NamedCount(e.key, e.value)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final typeList =
        contentTypes.entries
            .map(
              (e) =>
                  NamedCount(e.key, e.value.requests, secondary: e.value.bytes),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return TrafficSummary(
      requests: requests,
      cachedRequests: cached,
      bytes: bytes,
      cachedBytes: cachedBytes,
      threats: threats,
      uniques: uniques,
      countries: top(countries),
      statuses: statusList.take(8).toList(),
      contentTypes: typeList.take(8).toList(),
    );
  }
}

/// One row of firewall activity.
class FirewallEvent {
  const FirewallEvent({
    required this.count,
    required this.action,
    required this.source,
    required this.country,
    required this.host,
  });

  final int count;
  final String action;
  final String source;
  final String country;
  final String host;

  static List<FirewallEvent> listFrom(Map<String, Object?> data) {
    final viewer = _map(data['viewer']);
    final zones = _list(viewer?['zones']);
    if (zones.isEmpty) return const [];

    return _list(zones.first['firewallEventsAdaptiveGroups']).map((g) {
      final dims = _map(g['dimensions']) ?? const {};
      return FirewallEvent(
        count: _int(g['count']),
        action: dims['action']?.toString() ?? '—',
        source: dims['source']?.toString() ?? '—',
        country: dims['clientCountryName']?.toString() ?? '??',
        host: dims['clientRequestHTTPHost']?.toString() ?? '',
      );
    }).toList();
  }
}
