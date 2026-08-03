import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/cf_error_codes.dart';
import '../../core/net/envelope.dart';
import '../../core/net/paginator.dart';
import '../scope/scope_providers.dart';

/// All of these are account-scoped, so they wait for an account to be chosen
/// in the ScopeBar rather than guessing one.
final workerScriptsProvider = FutureProvider.autoDispose
    .family<CfPage<WorkerScriptListWorkersItem>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listScripts(accountId: accountId, cancelToken: autoCancelToken(ref));
    });

final workerRoutesProvider = FutureProvider.autoDispose
    .family<CfPage<Route>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listRoutes(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final cronTriggersProvider = FutureProvider.autoDispose
    .family<
      WorkerCronTriggerGetCronTriggersResult,
      ({String accountId, String script})
    >((ref, key) {
      return ref
          .watch(cfApiProvider)
          .workers
          .getCronTriggers(
            accountId: key.accountId,
            scriptName: key.script,
            cancelToken: autoCancelToken(ref),
          );
    });

final pagesProjectsProvider = FutureProvider.autoDispose
    .family<CfPage<Project>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listPagesProjects(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

final pagesDeploymentsProvider = FutureProvider.autoDispose
    .family<CfPage<Deployment>, ({String accountId, String project})>((
      ref,
      key,
    ) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listPagesDeployments(
            accountId: key.accountId,
            projectName: key.project,
            cancelToken: autoCancelToken(ref),
          );
    });

final kvNamespacesProvider = FutureProvider.autoDispose
    .family<CfPage<Namespace>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listKvNamespaces(
            accountId: accountId,
            perPage: 100,
            cancelToken: autoCancelToken(ref),
          );
    });

final d1DatabasesProvider = FutureProvider.autoDispose
    .family<CfPage<DatabaseResponse>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listD1Databases(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

final r2BucketsProvider = FutureProvider.autoDispose
    .family<R2ListBucketsResult, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listR2Buckets(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

typedef KvNamespaceKey = ({String accountId, String namespaceId});
typedef KvValueKey = ({String accountId, String namespaceId, String keyName});

/// KV is cursor-paginated rather than page-numbered — the only such listing in
/// the app. CfResultInfo already carries the cursor, so nothing special here.
final kvKeysProvider = FutureProvider.autoDispose
    .family<CfPage<Key>, KvNamespaceKey>((ref, key) {
      return ref
          .watch(cfApiProvider)
          .workers
          .listKvKeys(
            accountId: key.accountId,
            namespaceId: key.namespaceId,
            limit: 1000,
            cancelToken: autoCancelToken(ref),
          );
    });

/// A KV value is arbitrary bytes, not an envelope — the client hands back the
/// raw body and it is shown as text.
final kvValueProvider = FutureProvider.autoDispose.family<String, KvValueKey>((
  ref,
  key,
) async {
  final env = await ref
      .watch(cfApiProvider)
      .workers
      .readKvValue(
        accountId: key.accountId,
        namespaceId: key.namespaceId,
        keyName: key.keyName,
        cancelToken: autoCancelToken(ref),
      );
  return env.result?.toString() ?? '';
});

class KvActions {
  const KvActions(this._ref);

  final Ref _ref;

  /// Writes a KV value.
  ///
  /// Goes through the raw client rather than the generated method: this is one
  /// of 22 endpoints in the spec whose request body is `multipart/form-data`,
  /// and the generator only emits typed bodies for `application/json`. Rather
  /// than teach it a shape used by a handful of endpoints, the call is made
  /// directly and the limitation is written down.
  Future<void> write({
    required String accountId,
    required String namespaceId,
    required String keyName,
    required String value,
  }) async {
    final response = await _ref
        .read(cfClientProvider)
        .sendRaw(
          method: 'PUT',
          path:
              'accounts/$accountId/storage/kv/namespaces/$namespaceId'
              '/values/${Uri.encodeComponent(keyName)}',
          body: FormData.fromMap({'value': value, 'metadata': '{}'}),
        );
    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw failureFromEnvelope(
        CfEnvelope.fromBody(response.data, httpStatus: status),
        requestPath: 'kv write',
        missingPermissions: const {'Workers KV Storage Write'},
      );
    }
    _ref.invalidate(
      kvValueProvider((
        accountId: accountId,
        namespaceId: namespaceId,
        keyName: keyName,
      )),
    );
  }

  Future<void> delete({
    required String accountId,
    required String namespaceId,
    required String keyName,
  }) async {
    await _ref
        .read(cfApiProvider)
        .workers
        .deleteKvValue(
          accountId: accountId,
          namespaceId: namespaceId,
          keyName: keyName,
        );
  }
}

final kvActionsProvider = Provider<KvActions>(KvActions.new);

/// Runs SQL against a D1 database.
///
/// An action rather than a provider: a query has side effects, so caching or
/// auto-retrying it would be wrong.
class D1Actions {
  const D1Actions(this._ref);

  final Ref _ref;

  Future<CfPage<QueryResultResponse>> query({
    required String accountId,
    required String databaseId,
    required String sql,
    List<String> params = const [],
  }) {
    return _ref
        .read(cfApiProvider)
        .workers
        .queryD1(
          accountId: accountId,
          databaseId: databaseId,
          // D1 takes bound parameters as strings. Using them rather than
          // interpolating into the statement is the only sane defence against
          // a value the user typed.
          body: BatchQuery(sql: sql, params: params),
        );
  }
}

final d1ActionsProvider = Provider<D1Actions>(D1Actions.new);
