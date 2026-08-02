import 'dart:async';

import 'package:dio/dio.dart';

import 'cf_error_codes.dart';
import 'envelope.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/redaction.dart';
import 'interceptors/retry_interceptor.dart';
import 'retry_after.dart';

/// Base URL of the Cloudflare REST API.
const String kCloudflareApiBase = 'https://api.cloudflare.com/client/v4/';

/// The single entry point to the Cloudflare API.
///
/// Everything above this — generated operation classes, repositories, the
/// schema-aware explorer — funnels through [send] or [sendRaw], so retry,
/// auth, redaction and envelope handling exist in exactly one place.
class CfClient {
  CfClient._(this.dio);

  factory CfClient({
    required CredentialSource credentials,
    String baseUrl = kCloudflareApiBase,
    Dio? dio,
    bool enableLogging = true,
  }) {
    final d = dio ?? Dio();
    d.options = d.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      // Cloudflare accepts repeated keys for array parameters; the default
      // `foo[]=` form is rejected by several endpoints.
      listFormat: ListFormat.multi,
      // Deliberately left at the default (2xx only). Dio surfaces non-2xx as a
      // DioException, which is the only way RetryInterceptor.onError ever sees
      // a 429 or a 503. `send` re-parses the body out of the exception, and
      // `sendRaw` opts out per-request for the API explorer.
    );
    d.interceptors.addAll([
      AuthInterceptor(credentials, dio: d),
      RetryInterceptor(dio: d),
      if (enableLogging) const RedactingLogInterceptor(),
    ]);
    return CfClient._(d);
  }

  /// Test seam: wraps an already-configured Dio without adding interceptors.
  factory CfClient.raw(Dio dio) => CfClient._(dio);

  final Dio dio;

  /// Issues a request and returns the parsed envelope.
  ///
  /// Throws a [CfFailure] when the call did not succeed. [missingPermissions]
  /// names the permission group this endpoint needs, so a 403 can be reported
  /// as "your token is missing DNS: Edit" instead of a bare status code —
  /// Cloudflare never names it for us.
  Future<CfEnvelope> send({
    required String method,
    required String path,
    Map<String, Object?>? query,
    Object? body,
    CancelToken? cancelToken,
    bool retryUnsafe = false,
    Set<String> missingPermissions = const {},
    ResponseType responseType = ResponseType.json,
  }) async {
    Response<dynamic> response;
    try {
      response = await dio.request<dynamic>(
        _normalize(path),
        data: body,
        queryParameters: _clean(query),
        cancelToken: cancelToken,
        options: Options(
          method: method.toUpperCase(),
          responseType: responseType,
          extra: retryUnsafe ? {kRetryUnsafeKey: true} : null,
        ),
      );
    } on DioException catch (e) {
      // A response means Cloudflare answered with a non-2xx after retries were
      // exhausted; the body still carries the useful `errors` array.
      final failed = e.response;
      if (failed == null) throw _fromDio(e, path);
      throw _classify(
        failed,
        path: path,
        missingPermissions: missingPermissions,
      );
    }

    final status = response.statusCode ?? 0;
    final env = CfEnvelope.fromBody(response.data, httpStatus: status);
    if (!env.success) {
      throw failureFromEnvelope(
        env,
        requestPath: path,
        missingPermissions: missingPermissions,
      );
    }
    return env;
  }

  static CfFailure _classify(
    Response<dynamic> response, {
    required String path,
    required Set<String> missingPermissions,
  }) {
    final status = response.statusCode ?? 0;
    final env = CfEnvelope.fromBody(response.data, httpStatus: status);
    if (status == 429) {
      return RateLimitFailure(
        retryAfter: parseRetryAfter(response.headers.value('retry-after')),
        errors: env.errors,
        httpStatus: status,
        requestPath: path,
      );
    }
    return failureFromEnvelope(
      env,
      requestPath: path,
      missingPermissions: missingPermissions,
    );
  }

  /// Unfiltered request for the API explorer: never throws on status, so the
  /// user can inspect a 4xx body exactly as Cloudflare returned it.
  Future<Response<dynamic>> sendRaw({
    required String method,
    required String path,
    Map<String, Object?>? query,
    Object? body,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.request<dynamic>(
        _normalize(path),
        data: body,
        queryParameters: _clean(query),
        cancelToken: cancelToken,
        options: Options(
          method: method.toUpperCase(),
          // The explorer must be able to show a 404 body verbatim, and it must
          // not silently retry — the user is inspecting one specific call.
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      final r = e.response;
      if (r != null) return r;
      throw _fromDio(e, path);
    }
  }

  static String _normalize(String path) {
    var p = path.trim();
    if (p.startsWith(kCloudflareApiBase)) {
      p = p.substring(kCloudflareApiBase.length);
    }
    // The base URL already ends in `client/v4/`; a leading slash would make
    // Dio resolve against the host root and drop the version segment.
    while (p.startsWith('/')) {
      p = p.substring(1);
    }
    return p;
  }

  static Map<String, Object?>? _clean(Map<String, Object?>? query) {
    if (query == null) return null;
    final out = <String, Object?>{};
    query.forEach((k, v) {
      if (v == null) return;
      if (v is Iterable && v.isEmpty) return;
      if (v is String && v.isEmpty) return;
      out[k] = v;
    });
    return out.isEmpty ? null : out;
  }

  static CfFailure _fromDio(DioException e, String path) {
    final kind = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => NetworkKind.timeout,
      DioExceptionType.cancel => NetworkKind.cancelled,
      DioExceptionType.badCertificate => NetworkKind.tls,
      DioExceptionType.connectionError => _classifyConnection(e),
      _ => NetworkKind.unknown,
    };
    return NetworkFailure(kind, requestPath: path);
  }

  static NetworkKind _classifyConnection(DioException e) {
    final message = e.message?.toLowerCase() ?? '';
    if (message.contains('failed host lookup') ||
        message.contains('nodename nor servname')) {
      return NetworkKind.dns;
    }
    return NetworkKind.offline;
  }
}
