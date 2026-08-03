import 'package:cloudflare_mobile/core/net/capability_cache.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CapabilityCache', () {
    test('a fresh cache blocks nothing', () {
      final cache = CapabilityCache();
      expect(() => cache.guard({'DNS Read'}), returnsNormally);
    });

    test('a recorded denial is answered without a network call', () {
      // The reason this exists: against the live API, re-asking for a
      // permission the token does not have got the account rate-limited within
      // a couple of screen refreshes.
      final cache = CapabilityCache()..recordDenied({'Workers Scripts Read'});

      expect(
        () => cache.guard({'Workers Scripts Read'}, path: 'accounts/x/workers'),
        throwsA(
          isA<PermissionFailure>()
              .having((e) => e.missingPermissions, 'missing', {
                'Workers Scripts Read',
              })
              .having((e) => e.httpStatus, 'status', 403),
        ),
      );
    });

    test('an unrelated permission still goes to the network', () {
      final cache = CapabilityCache()..recordDenied({'D1 Read'});
      expect(() => cache.guard({'DNS Read'}), returnsNormally);
    });

    test('a call needing several permissions is blocked by any one', () {
      final cache = CapabilityCache()..recordDenied({'Zone WAF Write'});
      expect(
        () => cache.guard({'Zone WAF Read', 'Zone WAF Write'}),
        throwsA(
          isA<PermissionFailure>().having(
            (e) => e.missingPermissions,
            'missing',
            {'Zone WAF Write'},
          ),
        ),
      );
    });

    test('switching credentials forgets everything', () {
      // A different token is exactly the case where the old answer is wrong.
      final cache = CapabilityCache()
        ..bind('profile-a')
        ..recordDenied({'DNS Write'});

      cache.bind('profile-b');

      expect(() => cache.guard({'DNS Write'}), returnsNormally);
    });

    test('re-binding the same credential keeps the cache', () {
      final cache = CapabilityCache()
        ..bind('profile-a')
        ..recordDenied({'DNS Write'})
        ..bind('profile-a');

      expect(
        () => cache.guard({'DNS Write'}),
        throwsA(isA<PermissionFailure>()),
      );
    });

    test('a denial expires, because a token can gain a permission', () {
      final cache = CapabilityCache(ttl: const Duration(hours: 1));
      final t0 = DateTime(2026, 8, 3, 10);
      cache.recordDenied({'DNS Write'}, now: t0);

      expect(
        () => cache.guard({
          'DNS Write',
        }, now: t0.add(const Duration(minutes: 30))),
        throwsA(isA<PermissionFailure>()),
      );
      expect(
        () => cache.guard({'DNS Write'}, now: t0.add(const Duration(hours: 2))),
        returnsNormally,
      );
    });

    test('forget clears a specific denial after re-issuing a token', () {
      final cache = CapabilityCache()..recordDenied({'Cache Purge'});
      cache.forget({'Cache Purge'});
      expect(() => cache.guard({'Cache Purge'}), returnsNormally);
    });

    test('an endpoint that declares no permissions is never blocked', () {
      final cache = CapabilityCache()..recordDenied({'DNS Read'});
      expect(() => cache.guard(const {}), returnsNormally);
    });
  });
}
