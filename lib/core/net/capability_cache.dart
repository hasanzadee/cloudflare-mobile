import 'failure.dart';

/// Remembers which permission groups the current credential does not have.
///
/// Found the hard way against the live API: a token scoped to one product
/// answers 403 for everything else, and a UI that re-asks on every screen visit
/// gets the account rate-limited — Cloudflare throttles repeated failed
/// authorization far more aggressively than ordinary traffic. Three tabs
/// refreshing was enough to start collecting 429s.
///
/// So a denial is recorded once and answered locally afterwards. The record is
/// scoped to a credential and cleared whenever that changes, because the whole
/// point of re-issuing a token is to gain a permission.
class CapabilityCache {
  CapabilityCache({this.ttl = const Duration(hours: 12)});

  /// Denials are not permanent: a permission can be added to a token without
  /// the token itself changing.
  final Duration ttl;

  final Map<String, DateTime> _denied = {};
  String? _credentialId;

  /// Drops everything when the active credential changes.
  void bind(String? credentialId) {
    if (credentialId == _credentialId) return;
    _credentialId = credentialId;
    _denied.clear();
  }

  /// Forgets a denial, e.g. after the user re-issued the token.
  void forget(Iterable<String> permissions) {
    for (final p in permissions) {
      _denied.remove(p);
    }
  }

  void clear() => _denied.clear();

  void recordDenied(Iterable<String> permissions, {DateTime? now}) {
    final at = now ?? DateTime.now();
    for (final p in permissions) {
      _denied[p] = at;
    }
  }

  /// Permissions from [required] already known to be missing.
  Set<String> missingFrom(Iterable<String> required, {DateTime? now}) {
    if (required.isEmpty) return const {};
    final at = now ?? DateTime.now();
    final out = <String>{};
    for (final p in required) {
      final deniedAt = _denied[p];
      if (deniedAt == null) continue;
      if (at.difference(deniedAt) > ttl) {
        _denied.remove(p);
        continue;
      }
      out.add(p);
    }
    return out;
  }

  /// Throws without touching the network when the call is known to be refused.
  void guard(Set<String> required, {String? path, DateTime? now}) {
    final missing = missingFrom(required, now: now);
    if (missing.isEmpty) return;
    throw PermissionFailure(
      missingPermissions: missing,
      httpStatus: 403,
      requestPath: path,
    );
  }
}
