/// Hand-written GraphQL for the Analytics API.
///
/// Every document here is deliberately small and asks for one screen's worth of
/// data. Cloudflare bills GraphQL by complexity and enforces per-dataset limits,
/// so one fat query is not the optimisation it looks like.
library;

/// How far back a screen is looking. Cloudflare exposes different datasets at
/// different resolutions, and asking a 1-hour dataset for 30 days simply
/// returns nothing — the dataset name has to follow the range.
enum AnalyticsRange {
  last24h(hours: 24, label: '24 hours', bucket: 'httpRequests1hGroups'),
  last7d(hours: 24 * 7, label: '7 days', bucket: 'httpRequests1dGroups'),
  last30d(hours: 24 * 30, label: '30 days', bucket: 'httpRequests1dGroups');

  const AnalyticsRange({
    required this.hours,
    required this.label,
    required this.bucket,
  });

  final int hours;
  final String label;

  /// Dataset whose bucket size suits this range.
  final String bucket;

  DateTime get since => DateTime.now().toUtc().subtract(Duration(hours: hours));

  /// The 1-day datasets are keyed by date, the 1-hour one by datetime.
  bool get isDaily => bucket.contains('1d');

  String get sinceParam => isDaily
      ? since.toIso8601String().split('T').first
      : '${since.toIso8601String().split('.').first}Z';

  String get untilParam {
    final now = DateTime.now().toUtc();
    return isDaily
        ? now.toIso8601String().split('T').first
        : '${now.toIso8601String().split('.').first}Z';
  }
}

/// Requests, bandwidth, cached share and threats over time.
String trafficQuery(AnalyticsRange range) =>
    '''
query Traffic(\$zoneTag: String!, \$since: ${range.isDaily ? 'Date' : 'Time'}!, \$until: ${range.isDaily ? 'Date' : 'Time'}!) {
  viewer {
    zones(filter: { zoneTag: \$zoneTag }) {
      series: ${range.bucket}(
        limit: 1000
        filter: { ${range.isDaily ? 'date_geq: \$since, date_leq: \$until' : 'datetime_geq: \$since, datetime_leq: \$until'} }
        orderBy: [${range.isDaily ? 'date_ASC' : 'datetime_ASC'}]
      ) {
        dimensions { ${range.isDaily ? 'date' : 'datetime'} }
        sum {
          requests
          cachedRequests
          bytes
          cachedBytes
          threats
          pageViews
        }
        uniq { uniques }
      }
    }
  }
}
''';

/// Totals plus the breakdowns worth showing on a phone.
String breakdownQuery(AnalyticsRange range) =>
    '''
query Breakdown(\$zoneTag: String!, \$since: ${range.isDaily ? 'Date' : 'Time'}!, \$until: ${range.isDaily ? 'Date' : 'Time'}!) {
  viewer {
    zones(filter: { zoneTag: \$zoneTag }) {
      totals: ${range.bucket}(
        limit: 1000
        filter: { ${range.isDaily ? 'date_geq: \$since, date_leq: \$until' : 'datetime_geq: \$since, datetime_leq: \$until'} }
      ) {
        sum {
          requests
          cachedRequests
          bytes
          cachedBytes
          threats
          countryMap { clientCountryName requests threats }
          responseStatusMap { edgeResponseStatus requests }
          contentTypeMap { edgeResponseContentTypeName requests bytes }
        }
        uniq { uniques }
      }
    }
  }
}
''';

/// Recent firewall activity, for the security screen.
const String firewallEventsQuery = r'''
query FirewallEvents($zoneTag: String!, $since: Time!, $until: Time!) {
  viewer {
    zones(filter: { zoneTag: $zoneTag }) {
      firewallEventsAdaptiveGroups(
        limit: 100
        filter: { datetime_geq: $since, datetime_leq: $until }
        orderBy: [count_DESC]
      ) {
        count
        dimensions {
          action
          source
          clientCountryName
          clientRequestHTTPHost
        }
      }
    }
  }
}
''';
