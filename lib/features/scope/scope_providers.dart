import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';

/// What the user is currently looking at.
///
/// The prototype kept account and zone ids as free-text fields in Settings and
/// never propagated the zone the user had just tapped, so the API explorer
/// could not pre-fill anything. Scope is app state here, and every scoped
/// screen reads it.
class AppScope {
  const AppScope({
    this.accountId,
    this.accountName,
    this.zoneId,
    this.zoneName,
  });

  final String? accountId;
  final String? accountName;
  final String? zoneId;
  final String? zoneName;
}

class ScopeController extends Notifier<AppScope> {
  @override
  AppScope build() => const AppScope();

  /// Changing account clears the zone: a zone belongs to exactly one account,
  /// so keeping it would leave the UI pointed at something invisible.
  void setAccount(String? id, String? name) =>
      state = AppScope(accountId: id, accountName: name);

  void setZone(String? id, String? name) => state = AppScope(
    accountId: state.accountId,
    accountName: state.accountName,
    zoneId: id,
    zoneName: name,
  );
}

final scopeProvider = NotifierProvider<ScopeController, AppScope>(
  ScopeController.new,
);

/// A CancelToken bound to the provider's lifetime, so navigating away aborts
/// in-flight requests rather than letting them complete into nothing.
CancelToken autoCancelToken(Ref ref) {
  final token = CancelToken();
  ref.onDispose(token.cancel);
  return token;
}

/// Accounts the active credential can see.
final accountsProvider = FutureProvider.autoDispose<List<Account>>((ref) async {
  final api = ref.watch(cfApiProvider);
  final page = await api.accounts.listAccounts(
    perPage: 50,
    cancelToken: autoCancelToken(ref),
  );
  return page.items;
});

/// Status of the active credential, from `GET /user/tokens/verify`.
///
/// The prototype called this endpoint and threw away everything except
/// `success`, so an expired or disabled token looked identical to a working one
/// until the next request failed.
final tokenStatusProvider = FutureProvider.autoDispose<String?>((ref) async {
  final api = ref.watch(cfApiProvider);
  final result = await api.accounts.verifyToken(
    cancelToken: autoCancelToken(ref),
  );
  return result.status;
});
