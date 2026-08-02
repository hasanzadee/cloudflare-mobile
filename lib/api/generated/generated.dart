// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import '../../core/net/cf_client.dart';
import 'ops/accounts_api.dart';
import 'ops/cache_api.dart';
import 'ops/dns_api.dart';
import 'ops/waf_api.dart';
import 'ops/workers_api.dart';
import 'ops/zero_trust_api.dart';
import 'ops/zones_api.dart';

export 'models.dart';
export 'ops/accounts_api.dart';
export 'ops/cache_api.dart';
export 'ops/dns_api.dart';
export 'ops/waf_api.dart';
export 'ops/workers_api.dart';
export 'ops/zero_trust_api.dart';
export 'ops/zones_api.dart';

/// Number of operations described by the bundled spec.
///
/// Emitted rather than written by hand so the figure quoted
/// in onboarding cannot drift from the shipped index.
const int kCloudflareOperationCount = 3240;

/// `info.version` of the bundled Cloudflare description.
const String kCloudflareApiVersion = '4.0.0';

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
  late final waf = WafApi(client);
  late final workers = WorkersApi(client);
  late final zeroTrust = ZeroTrustApi(client);
  late final zones = ZonesApi(client);
}
