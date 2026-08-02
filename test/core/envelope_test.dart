import 'package:cloudflare_mobile/core/net/envelope.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CfEnvelope', () {
    test('parses a successful collection response', () {
      final env = CfEnvelope.fromBody({
        'success': true,
        'errors': <Object>[],
        'messages': <Object>[],
        'result': [
          {'id': 'a'},
          {'id': 'b'},
        ],
        'result_info': {
          'page': 1,
          'per_page': 50,
          'count': 2,
          'total_count': 120,
          'total_pages': 3,
        },
      }, httpStatus: 200);

      expect(env.success, isTrue);
      expect(env.resultAsList, hasLength(2));
      expect(env.resultInfo!.totalCount, 120);
      expect(env.resultInfo!.hasMore, isTrue);
    });

    test('tolerates result_info.count arriving as a string', () {
      // The spec types this as a number, but some endpoints return a string.
      // Being strict here would break the zone list over a counter.
      final info = CfResultInfo.fromJson({
        'page': '2',
        'per_page': '50',
        'count': '50',
        'total_count': '120',
      });

      expect(info!.page, 2);
      expect(info.count, 50);
      expect(info.totalCount, 120);
      expect(info.hasMore, isTrue, reason: '2 * 50 < 120');
    });

    test('hasMore is false when the endpoint reports no pagination', () {
      // Otherwise an infinite list would loop forever on a non-paginated body.
      expect(const CfResultInfo().hasMore, isFalse);
      expect(
        CfResultInfo.fromJson({'page': 1, 'total_pages': 1})!.hasMore,
        isFalse,
      );
    });

    test('cursor pagination is detected', () {
      final info = CfResultInfo.fromJson({
        'cursors': {'after': 'abc123'},
      });
      expect(info!.cursor, 'abc123');
      expect(info.hasMore, isTrue);
    });

    test('collects nested error_chain codes', () {
      final env = CfEnvelope.fromBody({
        'success': false,
        'errors': [
          {
            'code': 1004,
            'message': 'validation failed',
            'error_chain': [
              {'code': 9109, 'message': 'invalid access token'},
            ],
          },
        ],
        'result': null,
      }, httpStatus: 403);

      expect(env.success, isFalse);
      expect(env.errorCodes, containsAll(<int>[1004, 9109]));
    });

    test('wraps a non-envelope body as success', () {
      // GET /dns_records/export answers with a BIND file, not the envelope.
      final env = CfEnvelope.fromBody(
        'example.com. 300 IN A 192.0.2.1',
        httpStatus: 200,
      );
      expect(env.success, isTrue);
      expect(env.result, isA<String>());
    });

    test('a non-envelope body with a 4xx status is not success', () {
      final env = CfEnvelope.fromBody('nope', httpStatus: 404);
      expect(env.success, isFalse);
    });
  });
}
