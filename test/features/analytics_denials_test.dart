import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/features/analytics/analytics_denials.dart';
import 'package:flutter_test/flutter_test.dart';

/// Found on a real account: a token scoped to some zones made Pulse show
/// "zones [ten ids] are not authorized" as the whole traffic card, and the zone
/// screen print "Actor '…' does not have permission '…analytics.read'". The
/// GraphQL API refuses with a 200 and an errors array, never a 403.
void main() {
  const a = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
  const b = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
  const c = 'cccccccccccccccccccccccccccccccc';

  ValidationFailure graphqlError(String message) =>
      ValidationFailure([FieldError(null, message, 0)], httpStatus: 200);

  group('analyticsDeniedIds', () {
    test('reads the zones out of a zoneTag_in refusal', () {
      final ids = analyticsDeniedIds(
        graphqlError('zones [$a $b] are not authorized'),
      );
      expect(ids, {a, b});
    });

    test('recognises the single-zone "Actor" form', () {
      final ids = analyticsDeniedIds(
        graphqlError(
          "Actor 'com.cloudflare.api.token.$c' does not have permission "
          "'com.cloudflare.api.account.zone.analytics.read' for zone $a",
        ),
      );
      expect(ids, contains(a));
    });

    test('a 403 counts as denied with no zone named', () {
      expect(analyticsDeniedIds(const PermissionFailure()), isEmpty);
    });

    test('an ordinary GraphQL error is not a denial', () {
      expect(
        analyticsDeniedIds(graphqlError('unknown field "pageViewz"')),
        isNull,
      );
      expect(
        analyticsDeniedIds(const NetworkFailure(NetworkKind.offline)),
        isNull,
      );
    });
  });

  group('queryDroppingDenied', () {
    test('asks again without the refused zones', () async {
      final calls = <List<String>>[];
      final out = await queryDroppingDenied([a, b, c], (zones) async {
        calls.add(zones);
        if (zones.contains(b)) {
          throw graphqlError('zones [$b] are not authorized');
        }
        return {'ok': zones.length};
      });

      expect(calls, [
        [a, b, c],
        [a, c],
      ]);
      expect(out.denied, {b});
      expect(out.results, [
        {'ok': 2},
      ]);
    });

    test(
      'every zone refused leaves no results and all of them denied',
      () async {
        final out = await queryDroppingDenied([a, b], (zones) async {
          throw graphqlError('zones [${zones.join(' ')}] are not authorized');
        });
        expect(out.results, isEmpty);
        expect(out.denied, {a, b});
      },
    );

    test('a refusal naming none of the batch denies the batch, once', () async {
      var calls = 0;
      final out = await queryDroppingDenied([a, b], (zones) async {
        calls++;
        throw const PermissionFailure();
      });
      expect(calls, 1);
      expect(out.denied, {a, b});
    });

    test('other failures are not swallowed', () {
      expect(
        queryDroppingDenied([a], (_) async {
          throw const ServerFailure(httpStatus: 502);
        }),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
