import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Header and body keys that must never reach a log, a diagnostic string, or
/// the clipboard.
const Set<String> kSecretHeaders = {
  'authorization',
  'x-auth-key',
  'x-auth-email',
  'x-auth-user-service-key',
  'cookie',
  'set-cookie',
};

const Set<String> kSecretBodyKeys = {
  'access_token',
  'refresh_token',
  'id_token',
  'client_secret',
  'code',
  'code_verifier',
  'value', // Workers secret / KV value
  'secret',
  'password',
  'private_key',
  'api_key',
  'token',
};

const String kRedacted = '<redacted>';

/// Replaces secret-looking values anywhere in a decoded JSON structure.
Object? redactJson(Object? node) {
  if (node is Map) {
    return node.map(
      (k, v) => MapEntry(
        k,
        kSecretBodyKeys.contains(k.toString().toLowerCase())
            ? kRedacted
            : redactJson(v),
      ),
    );
  }
  if (node is List) return node.map(redactJson).toList();
  return node;
}

Map<String, Object?> redactHeaders(Map<String, Object?> headers) => headers.map(
      (k, v) => MapEntry(
        k,
        kSecretHeaders.contains(k.toLowerCase()) ? kRedacted : v,
      ),
    );

/// Redacts a free-form string that may embed a token, for the rare case where
/// a message interpolates one.
String redactText(String input) {
  var out = input.replaceAll(
    RegExp('Bearer\\s+[A-Za-z0-9_.\\-]+', caseSensitive: false),
    'Bearer $kRedacted',
  );
  out = out.replaceAll(
    RegExp('(access_token|refresh_token|code)=[^&\\s]+', caseSensitive: false),
    '\$1=$kRedacted',
  );
  return out;
}

/// Debug-only request logger.
///
/// The prototype declared `pretty_dio_logger` and never used it; that package
/// prints headers verbatim, which would have written the API token into logcat.
/// This one redacts and is compiled out of release builds.
class RedactingLogInterceptor extends Interceptor {
  const RedactingLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
      debugPrint('  headers: ${redactHeaders(options.headers)}');
      if (options.data != null) {
        debugPrint('  body: ${_preview(options.data)}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '← ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri.path}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '× ${err.response?.statusCode ?? err.type.name} '
        '${err.requestOptions.method} ${err.requestOptions.uri.path}',
      );
    }
    handler.next(err);
  }

  String _preview(Object? data) {
    try {
      if (data is Map || data is List) {
        final text = jsonEncode(redactJson(data));
        return text.length > 500 ? '${text.substring(0, 500)}…' : text;
      }
    } on Object {
      // Non-encodable bodies (streams, form data) are not worth logging.
    }
    return '<${data.runtimeType}>';
  }
}
