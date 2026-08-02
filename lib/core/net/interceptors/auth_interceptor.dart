import 'dart:async';

import 'package:dio/dio.dart';

import '../../../auth/domain/cf_credential.dart';

/// Supplies the currently active credential and knows how to renew it.
///
/// Implemented by the auth layer; kept as a narrow interface so the networking
/// core does not depend on storage, Riverpod, or the OAuth client.
abstract interface class CredentialSource {
  CfCredential? get current;

  /// Exchanges a refresh token for a new access token. Returns null when the
  /// credential cannot be renewed (API token, global key, or refresh failed).
  Future<CfCredential?> refresh();
}

/// Attaches auth headers and renews an expiring OAuth token exactly once, even
/// when several requests discover the expiry simultaneously.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._source, {required Dio dio}) : _dio = dio;

  final CredentialSource _source;

  /// The same Dio the request came from — replaying through a fresh instance
  /// would drop base options and every other interceptor.
  final Dio _dio;

  /// Single-flight guard. Without it, a screen that fires five parallel
  /// requests on resume would trigger five refreshes and — with rotating
  /// refresh tokens — invalidate its own session.
  Future<CfCredential?>? _inFlightRefresh;

  static const String _retriedKey = 'cf_auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var credential = _source.current;

    if (credential is OAuthCredential && credential.needsRefresh) {
      credential = await _refreshOnce() ?? credential;
    }

    if (credential != null) {
      options.headers.addAll(credential.authHeaders);
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    final isOAuth = _source.current is OAuthCredential;

    // A 401 on an OAuth session usually means the token died earlier than its
    // stated expiry. Refresh once and replay; never loop.
    if (status == 401 && isOAuth && !alreadyRetried) {
      final renewed = await _refreshOnce();
      if (renewed != null) {
        final request = err.requestOptions;
        request.extra[_retriedKey] = true;
        request.headers.addAll(renewed.authHeaders);
        try {
          final response = await _dio.fetch<dynamic>(request);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }

    handler.next(err);
  }

  Future<CfCredential?> _refreshOnce() {
    final existing = _inFlightRefresh;
    if (existing != null) return existing;

    final future = _source.refresh().whenComplete(() {
      _inFlightRefresh = null;
    });
    _inFlightRefresh = future;
    return future;
  }
}
