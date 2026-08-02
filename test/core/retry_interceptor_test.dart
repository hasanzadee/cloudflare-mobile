import 'dart:math';
import 'dart:typed_data';

import 'package:cloudflare_mobile/core/net/interceptors/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Counts attempts and replays a scripted sequence of outcomes.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.script);

  /// Each entry is either an int status code or a DioExceptionType.
  final List<Object> script;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final step = script[min(calls, script.length - 1)];
    calls++;

    if (step is DioExceptionType) {
      throw DioException(requestOptions: options, type: step);
    }

    final status = step as int;
    return ResponseBody.fromString(
      '{"success": ${status == 200}, "errors": [], "result": null}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        if (status == 429) 'retry-after': ['1'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWith(
  _ScriptedAdapter adapter, {
  int maxAttempts = 3,
  List<Duration>? slept,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.cloudflare.com/client/v4/'))
    ..httpClientAdapter = adapter;
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      maxAttempts: maxAttempts,
      // Deterministic and instant: the point of these tests is the decision
      // logic, not the wall clock.
      random: Random(1),
      sleep: (d) async => slept?.add(d),
      clock: () => DateTime.utc(2026, 1, 1),
    ),
  );
  return dio;
}

void main() {
  group('RetryInterceptor', () {
    test('retries a 429 and succeeds, honouring Retry-After', () async {
      // The prototype slept on 429 and then forwarded the 429 unchanged, so
      // this scenario used to fail — slowly.
      final adapter = _ScriptedAdapter([429, 200]);
      final slept = <Duration>[];
      final dio = _dioWith(adapter, slept: slept);

      final response = await dio.get<dynamic>('zones');

      expect(response.statusCode, 200);
      expect(adapter.calls, 2);
      expect(slept.single, const Duration(seconds: 1));
    });

    test('retries 5xx with backoff', () async {
      final adapter = _ScriptedAdapter([503, 503, 200]);
      final dio = _dioWith(adapter);

      final response = await dio.get<dynamic>('zones');

      expect(response.statusCode, 200);
      expect(adapter.calls, 3);
    });

    test('gives up after maxAttempts', () async {
      final adapter = _ScriptedAdapter([500]);
      final dio = _dioWith(adapter, maxAttempts: 3);

      await expectLater(
        dio.get<dynamic>('zones'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.calls, 3);
    });

    test('does NOT retry an unsafe method by default', () async {
      // Re-issuing POST /dns_records after a timeout is how duplicate records
      // appear: the first attempt may have succeeded with the reply lost.
      final adapter = _ScriptedAdapter([DioExceptionType.receiveTimeout]);
      final dio = _dioWith(adapter);

      await expectLater(
        dio.post<dynamic>('zones/x/dns_records', data: const {}),
        throwsA(isA<DioException>()),
      );
      expect(adapter.calls, 1);
    });

    test('retries an unsafe method when the call site opts in', () async {
      final adapter = _ScriptedAdapter([500, 200]);
      final dio = _dioWith(adapter);

      final response = await dio.post<dynamic>(
        'zones/x/dns_records',
        data: const {},
        options: Options(extra: {kRetryUnsafeKey: true}),
      );

      expect(response.statusCode, 200);
      expect(adapter.calls, 2);
    });

    test('retries idempotent PUT and DELETE', () async {
      final put = _ScriptedAdapter([500, 200]);
      expect((await _dioWith(put).put<dynamic>('x')).statusCode, 200);
      expect(put.calls, 2);

      final del = _ScriptedAdapter([502, 200]);
      expect((await _dioWith(del).delete<dynamic>('x')).statusCode, 200);
      expect(del.calls, 2);
    });

    test('does not retry a 4xx that is not 429', () async {
      final adapter = _ScriptedAdapter([404]);
      final dio = _dioWith(adapter);

      await expectLater(
        dio.get<dynamic>('zones/nope'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.calls, 1);
    });

    test('stops retrying once the CancelToken is cancelled', () async {
      final adapter = _ScriptedAdapter([500, 200]);
      final token = CancelToken();
      final dio = _dioWith(adapter, slept: null);
      // Cancel while the interceptor is backing off.
      final future = dio.get<dynamic>('zones', cancelToken: token);
      token.cancel();

      await expectLater(future, throwsA(isA<DioException>()));
    });
  });
}
