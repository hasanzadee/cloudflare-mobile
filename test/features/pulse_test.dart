import 'package:cloudflare_mobile/features/pulse/pulse_providers.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pulse turns GraphQL groups into fixed hourly buckets. The API leaves out
/// hours with no traffic rather than returning zero, so a series built by
/// position — "the 24th group is the current hour" — would shift every quiet
/// hour's neighbours to the wrong place on the sparkline.
void main() {
  final now = DateTime.utc(2026, 10, 26, 15);

  Map<String, Object?> group(DateTime at, {int requests = 0, int cached = 0}) =>
      {
        'dimensions': {'datetime': at.toIso8601String()},
        'sum': {
          'requests': requests,
          'cachedRequests': cached,
          'bytes': requests * 100,
          'threats': 0,
        },
      };

  test('places groups by timestamp, not by position', () {
    final z = bucketZone([
      group(now, requests: 5),
      group(now.subtract(const Duration(hours: 3)), requests: 7),
    ], now);

    expect(z.requests.length, kPulseHours);
    expect(z.requests.last, 5);
    expect(z.requests[kPulseHours - 1 - 3], 7);
    expect(z.totalRequests, 12);
    expect(z.requests.where((r) => r == 0).length, kPulseHours - 2);
  });

  test('the 24 hours before the window count as the previous period', () {
    final z = bucketZone([
      group(now, requests: 10),
      group(now.subtract(const Duration(hours: 30)), requests: 4),
      group(now.subtract(const Duration(hours: 47)), requests: 4),
      // Outside both windows: ignored rather than folded in.
      group(now.subtract(const Duration(hours: 60)), requests: 999),
    ], now);

    expect(z.totalRequests, 10);
    expect(z.previousRequests, 8);
  });

  test('malformed groups are skipped, not fatal', () {
    final z = bucketZone([
      'nonsense',
      {'dimensions': <String, Object?>{}, 'sum': <String, Object?>{}},
      {
        'dimensions': {'datetime': 'not a date'},
        'sum': {'requests': 3},
      },
      group(now, requests: 2),
    ], now);

    expect(z.totalRequests, 2);
  });

  test('totals sum zones and compare with the previous day', () {
    final a = bucketZone([
      group(now, requests: 30, cached: 15),
      group(now.subtract(const Duration(hours: 25)), requests: 20),
    ], now);
    final b = bucketZone([
      group(now.subtract(const Duration(hours: 1)), requests: 10, cached: 5),
      group(now.subtract(const Duration(hours: 26)), requests: 20),
    ], now);

    final t = PulseTraffic({'a': a, 'b': b});
    expect(t.total.totalRequests, 40);
    expect(t.cacheRatio, closeTo(0.5, 1e-9));
    expect(t.delta, closeTo(0.0, 1e-9));
  });

  test('no previous traffic means no delta, not infinity', () {
    final t = PulseTraffic({
      'a': bucketZone([group(now, requests: 3)], now),
    });
    expect(t.delta, isNull);
  });

  test('zone tags are written into the query only after validation', () {
    final q = pulseQuery(['023e105f4ecef8ad9ca31a8372d0c353']);
    expect(q, contains('zoneTag_in: ["023e105f4ecef8ad9ca31a8372d0c353"]'));
  });
}
