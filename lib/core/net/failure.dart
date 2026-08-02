/// Typed failures.
///
/// The prototype rendered every error as `Text('$e')`, which turned a missing
/// token permission and an unreachable network into the same wall of text. The
/// distinction that matters most is [PermissionFailure]: it is recoverable by
/// the user, and the UI can offer to re-issue the credential with the missing
/// permission rather than showing a bare 403.
library;

import 'envelope.dart';

enum NetworkKind { offline, timeout, tls, dns, cancelled, unknown }

enum AuthReason { missing, invalid, expired, malformed }

sealed class CfFailure implements Exception {
  const CfFailure({
    this.errors = const [],
    this.httpStatus,
    this.requestPath,
  });

  /// Raw Cloudflare errors, kept so diagnostics can be copied verbatim.
  final List<CfApiError> errors;
  final int? httpStatus;
  final String? requestPath;

  /// Short, user-facing summary. Screens localize around this, they never
  /// print the exception itself.
  String get summary;

  String? get documentationUrl =>
      errors.map((e) => e.documentationUrl).whereType<String>().firstOrNull;

  @override
  String toString() =>
      '$runtimeType(${httpStatus ?? '-'}): $summary${errors.isEmpty ? '' : ' ${errors.join('; ')}'}';
}

class NetworkFailure extends CfFailure {
  const NetworkFailure(this.kind, {super.requestPath, super.httpStatus});

  final NetworkKind kind;

  @override
  String get summary => switch (kind) {
        NetworkKind.offline => 'No internet connection',
        NetworkKind.timeout => 'Cloudflare did not respond in time',
        NetworkKind.tls => 'Could not establish a secure connection',
        NetworkKind.dns => 'Could not resolve api.cloudflare.com',
        NetworkKind.cancelled => 'Request cancelled',
        NetworkKind.unknown => 'Network error',
      };
}

class AuthFailure extends CfFailure {
  const AuthFailure(
    this.reason, {
    super.errors,
    super.httpStatus,
    super.requestPath,
  });

  final AuthReason reason;

  @override
  String get summary => switch (reason) {
        AuthReason.missing => 'No credential is active',
        AuthReason.invalid => 'Credential was rejected by Cloudflare',
        AuthReason.expired => 'Credential has expired',
        AuthReason.malformed => 'Credential is malformed',
      };
}

/// The credential authenticated fine but is not allowed to do this.
///
/// [missingPermissions] is best-effort: Cloudflare does not name the missing
/// permission group in the error body, so it is inferred from which call failed.
class PermissionFailure extends CfFailure {
  const PermissionFailure({
    this.missingPermissions = const {},
    super.errors,
    super.httpStatus,
    super.requestPath,
  });

  final Set<String> missingPermissions;

  @override
  String get summary => missingPermissions.isEmpty
      ? 'This credential is not permitted to do that'
      : 'Credential is missing: ${missingPermissions.join(', ')}';
}

class RateLimitFailure extends CfFailure {
  const RateLimitFailure({
    this.retryAfter,
    super.errors,
    super.httpStatus,
    super.requestPath,
  });

  final Duration? retryAfter;

  @override
  String get summary => retryAfter == null
      ? 'Rate limited by Cloudflare'
      : 'Rate limited — retry in ${retryAfter!.inSeconds}s';
}

class FieldError {
  const FieldError(this.pointer, this.message, this.code);
  final String? pointer;
  final String message;
  final int code;

  /// `#/name` -> `name`, so a form can highlight the offending input.
  String? get field {
    final p = pointer;
    if (p == null || p.isEmpty) return null;
    final parts = p.split('/').where((s) => s.isNotEmpty && s != '#');
    return parts.isEmpty ? null : parts.last;
  }
}

class ValidationFailure extends CfFailure {
  const ValidationFailure(
    this.fields, {
    super.errors,
    super.httpStatus,
    super.requestPath,
  });

  final List<FieldError> fields;

  @override
  String get summary => fields.isEmpty
      ? 'Cloudflare rejected the request'
      : fields.map((f) => f.message).join('; ');
}

class NotFoundFailure extends CfFailure {
  const NotFoundFailure({super.errors, super.httpStatus, super.requestPath});

  @override
  String get summary => 'Not found';
}

class ConflictFailure extends CfFailure {
  const ConflictFailure({super.errors, super.httpStatus, super.requestPath});

  @override
  String get summary => errors.isEmpty
      ? 'Conflicts with something that already exists'
      : errors.first.message;
}

class ServerFailure extends CfFailure {
  const ServerFailure({super.errors, super.httpStatus, super.requestPath});

  @override
  String get summary => 'Cloudflare returned a server error';
}

class UnknownFailure extends CfFailure {
  const UnknownFailure({
    this.detail,
    super.errors,
    super.httpStatus,
    super.requestPath,
  });

  final String? detail;

  @override
  String get summary =>
      detail ?? (errors.isEmpty ? 'Unexpected error' : errors.first.message);
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
