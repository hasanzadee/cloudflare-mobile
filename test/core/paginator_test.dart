import 'package:cloudflare_mobile/core/net/envelope.dart';
import 'package:cloudflare_mobile/core/net/paginator.dart';
import 'package:flutter_test/flutter_test.dart';

class _Item {
  const _Item(this.id);
  final String id;

  static _Item fromJson(Map<String, Object?> json) =>
      _Item(json['id']?.toString() ?? '');
}

CfEnvelope _envelope(List<String> ids, Map<String, Object?> info) =>
    CfEnvelope.fromBody({
      'success': true,
      'errors': <Object>[],
      'result': [
        for (final id in ids) {'id': id},
      ],
      'result_info': info,
    }, httpStatus: 200);

void main() {
  group('CfPage', () {
    test('parses items and pagination metadata', () {
      final page = CfPage.from(
        _envelope(['a', 'b'], {'page': 1, 'per_page': 2, 'total_count': 5}),
        _Item.fromJson,
      );

      expect(page.items.map((i) => i.id), ['a', 'b']);
      expect(page.hasMore, isTrue);
      expect(page.nextPage, 2);
    });

    test('merge deduplicates by identity', () {
      // Cloudflare can repeat an item across pages when the underlying set
      // changes between requests; appending blindly would show it twice.
      final first = CfPage.from(
        _envelope(['a', 'b'], {'page': 1}),
        _Item.fromJson,
      );
      final second = CfPage.from(
        _envelope(['b', 'c'], {'page': 2}),
        _Item.fromJson,
      );

      final merged = first.merge(second, identity: (i) => i.id);
      expect(merged.items.map((i) => i.id), ['a', 'b', 'c']);
    });
  });

  group('fetchAllPages', () {
    test('walks every page', () async {
      final pages = [
        CfPage.from(
          _envelope(['a'], {'page': 1, 'per_page': 1, 'total_count': 3}),
          _Item.fromJson,
        ),
        CfPage.from(
          _envelope(['b'], {'page': 2, 'per_page': 1, 'total_count': 3}),
          _Item.fromJson,
        ),
        CfPage.from(
          _envelope(['c'], {'page': 3, 'per_page': 1, 'total_count': 3}),
          _Item.fromJson,
        ),
      ];

      final result = await fetchAllPages<_Item>(
        (page) async => pages[page - 1],
      );

      expect(result.items.map((i) => i.id), ['a', 'b', 'c']);
      expect(result.truncated, isFalse);
    });

    test('reports truncation instead of looping forever', () async {
      // A server that always claims another page exists must not hang the app,
      // and the UI has to be able to say "showing the first N".
      final result = await fetchAllPages<_Item>(
        (page) async => CfPage.from(
          _envelope(['x'], {'page': page, 'per_page': 1, 'total_count': 9999}),
          _Item.fromJson,
        ),
        maxPages: 5,
      );

      expect(result.items, hasLength(5));
      expect(result.truncated, isTrue);
    });

    test('stops on an empty page', () async {
      final result = await fetchAllPages<_Item>(
        (page) async => page == 1
            ? CfPage.from(
                _envelope(['a'], {'page': 1, 'per_page': 1, 'total_count': 5}),
                _Item.fromJson,
              )
            : CfPage.from(
                _envelope([], {'page': 2, 'per_page': 1, 'total_count': 5}),
                _Item.fromJson,
              ),
      );

      expect(result.items, hasLength(1));
      expect(result.truncated, isFalse);
    });
  });
}
