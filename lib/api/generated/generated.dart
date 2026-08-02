// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import '../../core/net/cf_client.dart';
import 'ops/accounts_api.dart';
import 'ops/cache_api.dart';
import 'ops/dns_api.dart';
import 'ops/zones_api.dart';

export 'models.dart';
export 'ops/accounts_api.dart';
export 'ops/cache_api.dart';
export 'ops/dns_api.dart';
export 'ops/zones_api.dart';

/// Typed entry point to the allowlisted Cloudflare operations.
///
/// Endpoints outside the allowlist remain reachable through the
/// schema-aware explorer and [CfClient.sendRaw].
class CfApi {
  CfApi(this.client);

  final CfClient client;
  late final accounts = AccountsApi(client);
  late final cache = CacheApi(client);
  late final dns = DnsApi(client);
  late final zones = ZonesApi(client);
}
