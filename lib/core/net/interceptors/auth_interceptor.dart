import 'package:dio/dio.dart';

import '../../../auth/domain/cf_credential.dart';

/// Supplies the credential the app is currently acting as.
///
/// Kept as a narrow interface so the networking core does not depend on
/// storage or Riverpod.
///
/// There is deliberately no `refresh` hook: an API token and a Global API key
/// are both long-lived until the user revokes them, so a 401 means "this
/// credential is wrong", not "retry with a new one". Inventing a retry there
/// would only turn a clear error into a silent loop.
abstract interface class CredentialSource {
  CfCredential? get current;
}

/// Attaches the active credential's headers to every request.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._source);

  final CredentialSource _source;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final credential = _source.current;
    if (credential != null) {
      options.headers.addAll(credential.authHeaders);
    }
    handler.next(options);
  }
}
