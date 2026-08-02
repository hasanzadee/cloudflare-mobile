import 'package:flutter/material.dart';

import '../core/net/failure.dart';
import '../core/net/interceptors/redaction.dart';
import '../l10n/app_localizations.dart';

/// Turns a typed failure into something a person can act on.
String failureMessage(BuildContext context, Object error) {
  final l = L.of(context);
  return switch (error) {
    NetworkFailure(kind: NetworkKind.offline) => l.errNetworkOffline,
    NetworkFailure(kind: NetworkKind.dns) => l.errNetworkOffline,
    NetworkFailure(kind: NetworkKind.timeout) => l.errNetworkTimeout,
    NetworkFailure() => l.errUnknown,
    AuthFailure() => l.errAuth,
    PermissionFailure(:final missingPermissions) =>
      missingPermissions.isEmpty
          ? l.errAuth
          : l.permMissing(missingPermissions.join(', ')),
    RateLimitFailure() => l.errRateLimited,
    NotFoundFailure() => l.errNotFound,
    ServerFailure() => l.errServer,
    ValidationFailure(:final fields) when fields.isNotEmpty =>
      fields.map((f) => f.message).join('\n'),
    final CfFailure f => f.summary,
    _ => l.errUnknown,
  };
}

/// Diagnostics the user can paste into an issue — redacted, always.
String failureDiagnostics(Object error, StackTrace? stack) {
  final buffer = StringBuffer()..writeln(redactText(error.toString()));
  if (error is CfFailure) {
    buffer
      ..writeln('http: ${error.httpStatus ?? '-'}')
      ..writeln('path: ${error.requestPath ?? '-'}');
    for (final e in error.errors) {
      buffer.writeln('cf: ${e.code} ${redactText(e.message)}');
    }
    final doc = error.documentationUrl;
    if (doc != null) buffer.writeln('docs: $doc');
  }
  return buffer.toString();
}
