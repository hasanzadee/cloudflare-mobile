/// Mapping of Cloudflare error codes onto typed failures.
///
/// There is no machine-readable list of error codes in `openapi.json`, and
/// Cloudflare does not publish an exhaustive one. This table is therefore
/// empirical and expected to grow: add a code when you observe it, and add a
/// test alongside it. Anything unmatched falls back to the HTTP status, which
/// is why an incomplete table degrades gracefully rather than misclassifying.
library;

import 'envelope.dart';
import 'failure.dart';

/// Codes that mean "the credential itself is not acceptable".
const Set<int> kAuthErrorCodes = {
  6003, // Invalid request headers
  6103, // Invalid format for X-Auth-Key header
  6111, // Invalid format for Authorization header
  9103, // Unknown or expired credentials
  9106, // Missing X-Auth-Key, X-Auth-Email or Authorization headers
  9109, // Invalid access token
  10000, // Authentication error
  10001, // Unable to authenticate request
};

/// Codes that mean "authenticated, but this credential may not do that".
const Set<int> kPermissionErrorCodes = {
  9109, // also used for insufficient scope on token auth
  10000, // used both ways; HTTP status disambiguates
};

/// Codes that mean "the addressed object does not exist".
const Set<int> kNotFoundErrorCodes = {
  1049, // zone not found (varies by product)
  7000, // No route for that URI
  7003, // Could not route to path — usually a malformed identifier
  81044, // DNS record not found
};

/// Codes that mean "something equivalent already exists".
const Set<int> kConflictErrorCodes = {
  81053, // record already exists
  81057, // record already exists
  81058, // an A, AAAA or CNAME record with that host already exists
};

/// Turns a non-successful envelope into a typed failure.
///
/// [missingPermissions] lets the calling repository name the permission group
/// its endpoint needs, because Cloudflare never says which one is absent.
CfFailure failureFromEnvelope(
  CfEnvelope env, {
  String? requestPath,
  Set<String> missingPermissions = const {},
}) {
  final errors = env.errors;
  final codes = env.errorCodes;
  final status = env.httpStatus;

  // Field-level validation: Cloudflare points at the offending member with a
  // JSON pointer, which lets the form highlight the exact input.
  final pointed = errors
      .expand((e) => e.flattened)
      .where((e) => e.pointer != null && e.pointer!.isNotEmpty)
      .map((e) => FieldError(e.pointer, e.message, e.code))
      .toList();
  if (pointed.isNotEmpty) {
    return ValidationFailure(
      pointed,
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (status == 403 || (status == 401 && missingPermissions.isNotEmpty)) {
    return PermissionFailure(
      missingPermissions: missingPermissions,
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (codes.any(kAuthErrorCodes.contains) || status == 401) {
    return AuthFailure(
      AuthReason.invalid,
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (codes.any(kConflictErrorCodes.contains) || status == 409) {
    return ConflictFailure(
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (codes.any(kNotFoundErrorCodes.contains) || status == 404) {
    return NotFoundFailure(
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (status == 429) {
    return RateLimitFailure(
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (status != null && status >= 500) {
    return ServerFailure(
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  if (status == 400 || status == 422) {
    return ValidationFailure(
      errors
          .expand((e) => e.flattened)
          .map((e) => FieldError(e.pointer, e.message, e.code))
          .toList(),
      errors: errors,
      httpStatus: status,
      requestPath: requestPath,
    );
  }

  return UnknownFailure(
    errors: errors,
    httpStatus: status,
    requestPath: requestPath,
  );
}
