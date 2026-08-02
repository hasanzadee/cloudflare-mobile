import 'package:cloudflare_mobile/core/net/retry_after.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseRetryAfter', () {
    test('reads the delay-seconds form', () {
      expect(parseRetryAfter('30'), const Duration(seconds: 30));
      expect(parseRetryAfter(' 5 '), const Duration(seconds: 5));
    });

    test('clamps a non-positive delay to zero', () {
      expect(parseRetryAfter('0'), Duration.zero);
      expect(parseRetryAfter('-10'), Duration.zero);
    });

    test('reads the HTTP-date form', () {
      // RFC 9110 allows both forms and Cloudflare uses both depending on which
      // edge answered. The prototype only handled integers, so date-form
      // throttles were ignored entirely.
      final now = DateTime.utc(2015, 10, 21, 7, 28, 0);
      expect(
        parseRetryAfter('Wed, 21 Oct 2015 07:28:45 GMT', now: now),
        const Duration(seconds: 45),
      );
    });

    test('a date in the past means retry now', () {
      final now = DateTime.utc(2015, 10, 21, 8);
      expect(
        parseRetryAfter('Wed, 21 Oct 2015 07:28:00 GMT', now: now),
        Duration.zero,
      );
    });

    test('returns null for absent or unparseable values', () {
      expect(parseRetryAfter(null), isNull);
      expect(parseRetryAfter(''), isNull);
      expect(parseRetryAfter('soon'), isNull);
      expect(parseRetryAfter('Wed, 21 Foo 2015 07:28:00 GMT'), isNull);
    });
  });
}
