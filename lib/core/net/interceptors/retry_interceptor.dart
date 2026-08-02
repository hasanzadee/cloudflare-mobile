import 'dart:math';

import 'package:dio/dio.dart';

import '../retry_after.dart';

/// Key used to opt a non-idempotent request into retrying.
const String kRetryUnsafeKey = 'cf_retry_unsafe';

/// Internal attempt counter carried on the request.
const String _attemptKey = 'cf_retry_attempt';

/// Retries transient failures.
///
/// This replaces the prototype's interceptor, which slept for `Retry-After`
/// seconds on a 429 and then forwarded the 429 unchanged — it never retried
/// anything, it only made failures slower.
///
/// Unsafe methods are **not** retried by default. Blindly re-issuing
/// `POST /dns_records` after a timeout is how you end up with duplicate DNS
/// records: the first attempt may well have succeeded with the response lost on
/// the way back. Call sites that know an endpoint is idempotent can opt in with
/// `Options(extra: {kRetryUnsafeKey: true})`.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    this.maxDelay = const Duration(seconds: 8),
    this.maxTotalDelay = const Duration(seconds: 20),
    Random? random,
    Future<void> Function(Duration)? sleep,
    DateTime Function()? clock,
  }) : _dio = dio,
       _random = random ?? Random(),
       _sleep = sleep ?? Future<void>.delayed,
       _clock = clock ?? DateTime.now;

  final Dio _dio;

  /// Total attempts including the first one, so 3 means at most 2 retries.
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;

  /// Ceiling on the summed backoff across all retries of one request, so a
  /// long `Retry-After` cannot hang a screen indefinitely.
  final Duration maxTotalDelay;

  final Random _random;
  final Future<void> Function(Duration) _sleep;
  final DateTime Function() _clock;

  static const Set<String> _idempotent = {
    'GET',
    'HEAD',
    'OPTIONS',
    'PUT',
    'DELETE',
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final attempt = (request.extra[_attemptKey] as int?) ?? 0;

    if (!_shouldRetry(err, attempt)) {
      return handler.next(err);
    }

    final delay = _delayFor(err, attempt);
    final spent = Duration(
      milliseconds: (request.extra['cf_retry_spent_ms'] as int?) ?? 0,
    );
    if (spent + delay > maxTotalDelay) {
      return handler.next(err);
    }

    await _sleep(delay);

    // The token can be cancelled while we were backing off.
    if (request.cancelToken?.isCancelled ?? false) {
      return handler.next(err);
    }

    request.extra[_attemptKey] = attempt + 1;
    request.extra['cf_retry_spent_ms'] = (spent + delay).inMilliseconds;

    try {
      final response = await _dio.fetch<dynamic>(request);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err, int attempt) {
    if (attempt + 1 >= maxAttempts) return false;
    if (err.type == DioExceptionType.cancel) return false;
    if (err.requestOptions.cancelToken?.isCancelled ?? false) return false;

    final method = err.requestOptions.method.toUpperCase();
    final unsafeAllowed = err.requestOptions.extra[kRetryUnsafeKey] == true;
    if (!_idempotent.contains(method) && !unsafeAllowed) return false;

    final status = err.response?.statusCode;
    if (status != null) {
      return status == 429 || status == 408 || status >= 500;
    }

    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };
  }

  Duration _delayFor(DioException err, int attempt) {
    if (err.response?.statusCode == 429) {
      final header = err.response?.headers.value('retry-after');
      final advised = parseRetryAfter(header, now: _clock());
      if (advised != null) {
        return advised > maxTotalDelay ? maxTotalDelay : advised;
      }
    }
    // Exponential backoff with full jitter: picking uniformly in [0, cap)
    // avoids a thundering herd when several screens refresh at once.
    final cap = min(
      baseDelay.inMilliseconds * (1 << attempt),
      maxDelay.inMilliseconds,
    );
    return Duration(milliseconds: _random.nextInt(cap + 1));
  }
}
