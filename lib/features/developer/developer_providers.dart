import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
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

/// Runs one SQL statement against a D1 database.
///
/// Deliberately not a provider: a query is an action with side effects, and
/// caching or auto-retrying it would be wrong.
Future<CfPage<QueryResultResponse>> runD1Query(
  Ref ref, {
  required String accountId,
  required String databaseId,
  required String sql,
  List<String> params = const [],
}) {
  return ref
      .read(cfApiProvider)
      .workers
      .queryD1(
        accountId: accountId,
        databaseId: databaseId,
        // D1 takes bound parameters as strings; using them rather than string
        // interpolation is the only sane way to avoid SQL injection from a
        // value the user typed.
        body: BatchQuery(sql: sql, params: params),
      );
}
