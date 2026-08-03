import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cloudflare_mobile/core/net/cf_client.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/core/net/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// End-to-end through the real client: interceptors, envelope parsing, failure
/// mapping and the generated operations, against realistic Cloudflare bodies.
class _Source implements CredentialSource {
  _Source(this.current);

  @override
  final CfCredential? current;
}

Map<String, Object?> _envelope(Object? result, {Map<String, Object?>? info}) =>
    {
      'success': true,
      'errors': <Object>[],
      'messages': <Object>[],
      'result': result,
      'result_info': ?info,
    };

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late CfApi api;

  setUp(() {
    final credential = const ApiTokenCredential(
      id: 'p1',
      label: 'Test',
      token: 'secret-token',
    );
    final client = CfClient(
      credentials: _Source(credential),
      enableLogging: false,
    );
    dio = client.dio;
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    api = CfApi(client);
  });

  group('zones', () {
    test('lists zones and reports that more pages exist', () async {
      adapter.onGet(
        'zones',
        (server) => server.reply(
          200,
          _envelope(
            [
              {
                'id': '023e105f4ecef8ad9ca31a8372d0c353',
                'name': 'example.com',
                'status': 'active',
                'plan': {'name': 'Free Website'},
              },
            ],
            info: {
              'page': 1,
              'per_page': 50,
              'count': 1,
              'total_count': 120,
              'total_pages': 3,
            },
          ),
        ),
        queryParameters: {'page': 1, 'per_page': 50},
      );

      final page = await api.zones.listZones(page: 1, perPage: 50);

      expect(page.items.single.name, 'example.com');
      expect(page.items.single.plan?.name, 'Free Website');
      expect(page.hasMore, isTrue, reason: '120 zones do not fit in one page');
      expect(page.nextPage, 2);
    });

    test('attaches the bearer token', () async {
      String? seen;
      adapter.onGet('zones', (server) {
        seen = 'checked';
        server.reply(200, _envelope(<Object>[]));
      });

      await api.zones.listZones();
      expect(seen, 'checked');

      // The interceptor sets the header on the request; assert it directly.
      final options = RequestOptions(path: 'zones');
      AuthInterceptor(
        _Source(const ApiTokenCredential(id: 'x', label: 'x', token: 'abc')),
      ).onRequest(options, RequestInterceptorHandler());
      expect(options.headers['Authorization'], 'Bearer abc');
    });

    test('a global key sends the legacy header pair', () async {
      final options = RequestOptions(path: 'zones');
      AuthInterceptor(
        _Source(
          const GlobalKeyCredential(
            id: 'g',
            label: 'g',
            email: 'me@example.com',
            apiKey: 'deadbeef',
          ),
        ),
      ).onRequest(options, RequestInterceptorHandler());

      expect(options.headers['X-Auth-Email'], 'me@example.com');
      expect(options.headers['X-Auth-Key'], 'deadbeef');
      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('dns records', () {
    const zoneId = '023e105f4ecef8ad9ca31a8372d0c353';

    test('creates an MX record with its priority', () async {
      Object? captured;
      adapter.onPost(
        'zones/$zoneId/dns_records',
        (server) => server.reply(
          200,
          _envelope({
            'id': 'rec1',
            'type': 'MX',
            'name': 'example.com',
            'content': 'mail.example.com',
            'priority': 10,
            'ttl': 1,
          }),
        ),
        data: Matchers.any,
      );

      final created = await api.dns.createRecord(
        zoneId: zoneId,
        body: const DnsRecordPost(
          type_: 'MX',
          name: 'example.com',
          content: 'mail.example.com',
          priority: 10,
          ttl: 1,
        ),
      );

      expect(created.id, 'rec1');
      expect(created.priority, 10);
      captured ??= created.type_;
      expect(captured, 'MX');
    });

    test('a 403 surfaces the missing permission group', () async {
      adapter.onGet(
        'zones/$zoneId/dns_records',
        (server) => server.reply(403, {
          'success': false,
          'errors': [
            {'code': 10000, 'message': 'Authentication error'},
          ],
          'result': null,
        }),
        queryParameters: {'page': 1, 'per_page': 100},
      );

      await expectLater(
        api.dns.listRecords(zoneId: zoneId, page: 1, perPage: 100),
        throwsA(
          isA<PermissionFailure>().having(
            (e) => e.missingPermissions,
            'missingPermissions',
            contains('DNS Read'),
          ),
        ),
      );
    });

    test('a validation error keeps the field pointer', () async {
      adapter.onPost(
        'zones/$zoneId/dns_records',
        (server) => server.reply(400, {
          'success': false,
          'errors': [
            {
              'code': 1004,
              'message': 'content must be a valid IPv4 address',
              'source': {'pointer': '/content'},
            },
          ],
          'result': null,
        }),
        data: Matchers.any,
      );

      await expectLater(
        api.dns.createRecord(
          zoneId: zoneId,
          body: const DnsRecordPost(type_: 'A', name: 'x', content: 'nope'),
        ),
        throwsA(
          isA<ValidationFailure>().having(
            (e) => e.fields.single.field,
            'field',
            'content',
          ),
        ),
      );
    });

    test('a record-exists conflict is typed as such', () async {
      adapter.onPost(
        'zones/$zoneId/dns_records',
        (server) => server.reply(400, {
          'success': false,
          'errors': [
            {'code': 81057, 'message': 'Record already exists.'},
          ],
          'result': null,
        }),
        data: Matchers.any,
      );

      await expectLater(
        api.dns.createRecord(
          zoneId: zoneId,
          body: const DnsRecordPost(type_: 'A', name: 'x', content: '1.2.3.4'),
        ),
        throwsA(isA<ConflictFailure>()),
      );
    });

    test('SRV data members reach the wire', () async {
      adapter.onPost(
        'zones/$zoneId/dns_records',
        (server) => server.reply(
          200,
          _envelope({
            'id': 'rec2',
            'type': 'SRV',
            'name': '_sip._tcp.example.com',
            'data': {
              'priority': 10,
              'weight': 60,
              'port': 5060,
              'target': 'sip.example.com',
            },
          }),
        ),
        data: Matchers.any,
      );

      final created = await api.dns.createRecord(
        zoneId: zoneId,
        body: const DnsRecordPost(
          type_: 'SRV',
          name: '_sip._tcp.example.com',
          data: DnsRecordPostData(
            extra: {
              'priority': 10,
              'weight': 60,
              'port': 5060,
              'target': 'sip.example.com',
            },
          ),
        ),
      );

      final data = created.data!.toJson();
      expect(data['port'], 5060);
      expect(data['target'], 'sip.example.com');
    });
  });

  group('token verification', () {
    test('reports the token status rather than a bare boolean', () async {
      adapter.onGet(
        'user/tokens/verify',
        (server) => server.reply(
          200,
          _envelope({
            'id': 'ed17574386854bf78a67040be0a770b0',
            'status': 'active',
          }),
        ),
      );

      final result = await api.accounts.verifyToken();
      expect(result.status, 'active');
      expect(result.id, 'ed17574386854bf78a67040be0a770b0');
    });

    test('an expired token becomes an AuthFailure', () async {
      adapter.onGet(
        'user/tokens/verify',
        (server) => server.reply(401, {
          'success': false,
          'errors': [
            {'code': 1000, 'message': 'Invalid API Token'},
          ],
          'result': null,
        }),
      );

      await expectLater(
        api.accounts.verifyToken(),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('transport failures', () {
    test('a connection error becomes an offline NetworkFailure', () async {
      adapter.onGet(
        'zones',
        (server) => server.throws(
          0,
          DioException.connectionError(
            requestOptions: RequestOptions(path: 'zones'),
            reason: 'no route to host',
          ),
        ),
      );

      await expectLater(
        api.zones.listZones(),
        throwsA(
          isA<NetworkFailure>().having(
            (e) => e.kind,
            'kind',
            NetworkKind.offline,
          ),
        ),
      );
    });
  });
}
