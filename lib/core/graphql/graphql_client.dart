import 'package:dio/dio.dart';

import '../net/cf_client.dart';
import '../net/failure.dart';

/// Minimal client for Cloudflare's GraphQL Analytics API.
///
/// Analytics is the one product that is not in `spec/openapi.json` at all — the
/// REST endpoint `/zones/{id}/analytics/dashboard` is marked deprecated and the
/// live data lives behind `POST /client/v4/graphql`. So the generator cannot
/// help here and the queries are written by hand.
///
/// There are about a dozen of them, which is well under the point where a
/// GraphQL codegen package would pay for itself: it would add a build step and
/// a schema download to save writing a handful of strings.
class CfGraphQL {
  const CfGraphQL(this._client);

  final CfClient _client;

  static const String path = 'graphql';

  /// Runs a query and returns the `data` object.
  ///
  /// GraphQL answers 200 with an `errors` array rather than an HTTP error, so
  /// the failure has to be dug out of the body — the envelope machinery used
  /// everywhere else does not apply.
  Future<Map<String, Object?>> query(
    String document, {
    Map<String, Object?> variables = const {},
    CancelToken? cancelToken,
    Set<String> missingPermissions = const {'Analytics Read'},
  }) async {
    final response = await _client.sendRaw(
      method: 'POST',
      path: path,
      body: {'query': document, 'variables': variables},
      cancelToken: cancelToken,
    );

    final status = response.statusCode ?? 0;
    final body = switch (response.data) {
      final Map<Object?, Object?> m => m.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      _ => const <String, Object?>{},
    };

    if (status == 403 || status == 401) {
      throw PermissionFailure(
        missingPermissions: missingPermissions,
        httpStatus: status,
        requestPath: path,
      );
    }
    if (status == 429) {
      throw const RateLimitFailure(httpStatus: 429, requestPath: path);
    }

    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      final messages = errors
          .whereType<Map<Object?, Object?>>()
          .map((e) => e['message']?.toString() ?? 'unknown')
          .toList();
      // A GraphQL error is usually a bad field or a dataset the plan does not
      // include, which is closer to validation than to a server fault.
      throw ValidationFailure(
        [for (final m in messages) FieldError(null, m, 0)],
        httpStatus: status,
        requestPath: path,
      );
    }

    if (status < 200 || status >= 300) {
      throw ServerFailure(httpStatus: status, requestPath: path);
    }

    final data = body['data'];
    return switch (data) {
      final Map<Object?, Object?> m => m.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      _ => const <String, Object?>{},
    };
  }
}
