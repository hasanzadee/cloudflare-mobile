import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../scope/scope_providers.dart';

final tunnelsProvider = FutureProvider.autoDispose
    .family<CfPage<CfdTunnel>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .zeroTrust
          .listTunnels(
            accountId: accountId,
            perPage: 100,
            cancelToken: autoCancelToken(ref),
          );
    });

/// Live connector list for one tunnel.
///
/// Never cached: "is my tunnel up right now" is exactly the question a stale
/// answer ruins.
final tunnelConnectionsProvider = FutureProvider.autoDispose
    .family<CfPage<TunnelClient>, ({String accountId, String tunnelId})>((
      ref,
      key,
    ) {
      return ref
          .watch(cfApiProvider)
          .zeroTrust
          .listTunnelConnections(
            accountId: key.accountId,
            tunnelId: key.tunnelId,
            cancelToken: autoCancelToken(ref),
          );
    });

final accessAppsProvider = FutureProvider.autoDispose
    .family<CfPage<AppResponse>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .zeroTrust
          .listAccessApps(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

final accessPoliciesProvider = FutureProvider.autoDispose
    .family<CfPage<AppPolicyResponse>, ({String accountId, String appId})>((
      ref,
      key,
    ) {
      return ref
          .watch(cfApiProvider)
          .zeroTrust
          .listAccessPolicies(
            accountId: key.accountId,
            appId: key.appId,
            cancelToken: autoCancelToken(ref),
          );
    });

final gatewayRulesProvider = FutureProvider.autoDispose
    .family<CfPage<Rules>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .zeroTrust
          .listGatewayRules(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });
