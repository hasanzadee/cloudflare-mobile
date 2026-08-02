// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import 'package:dio/dio.dart';

import '../../../core/net/cf_client.dart';
import '../../../core/net/envelope.dart';
import '../../../core/net/paginator.dart';
import '../models.dart';

/// Accounts, users and tokens
class AccountsApi {
  const AccountsApi(this._client);

  final CfClient _client;

  /// `GET /user/tokens/verify`
  /// Verify Token
  Future<UserApiTokensVerifyTokenResult> verifyToken({
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/user/tokens/verify',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
    );
    return UserApiTokensVerifyTokenResult.fromJson(_env.resultAsMap);
  }

  /// `GET /accounts`
  /// List Accounts
  Future<CfPage<Account>> listAccounts({
    String? name,
    num? page,
    num? perPage,
    String? direction,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts',
      query: <String, Object?>{
        'name': name,
        'page': page,
        'per_page': perPage,
        'direction': direction,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Account Settings Read'},
    );
    return CfPage.from(_env, Account.fromJson);
  }

  /// `GET /accounts/{account_id}`
  /// Account Details
  Future<Account> getAccount({
    required String accountId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Account Settings Read'},
    );
    return Account.fromJson(_env.resultAsMap);
  }

  /// `GET /user`
  /// User Details
  Future<UserUserDetailsResult> getUser({
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/user',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'User Details Read'},
    );
    return UserUserDetailsResult.fromJson(_env.resultAsMap);
  }

  /// `GET /user/tokens/permission_groups`
  /// List Token Permission Groups
  Future<CfPage<PermissionGroupsListPermissionGroupsItem>>
  listPermissionGroups({
    String? name,
    String? scope,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/user/tokens/permission_groups',
      query: <String, Object?>{'name': name, 'scope': scope, ...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'API Tokens Read'},
    );
    return CfPage.from(_env, PermissionGroupsListPermissionGroupsItem.fromJson);
  }
}
