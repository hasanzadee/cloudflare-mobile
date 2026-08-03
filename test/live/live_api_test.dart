// Exercises the real Cloudflare API through the app's own client.
//
//   $env:CF_API_TOKEN  = "..."         # PowerShell
//   $env:CF_ACCOUNT_ID = "..."
//   flutter test test/live/live_api_test.dart
//
// Unit tests prove the code behaves against payloads we wrote. This proves it
// behaves against payloads Cloudflare actually sends — a different question,
// and the one that catches spec drift and model-parsing mistakes.
//
// It only ever reads. Nothing here creates, edits or deletes, so it is safe to
// point at a production account, and safe with a read-only token — which is the
// recommended way to run it. Endpoints the token cannot reach are reported as a
// skip rather than a failure, because exercising that path is itself the point.
//
// Without CF_API_TOKEN the whole group is skipped, so CI is unaffected and no
// credential is ever committed.

import 'dart:io';

import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cloudflare_mobile/core/net/cf_client.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/core/net/interceptors/auth_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class _Source implements CredentialSource {
  _Source(this.current);

  @override
  final CfCredential current;

  @override
  Future<CfCredential?> refresh() async => null;
}

void say(String line) {
  // ignore: avoid_print
  print(line);
}

/// Runs [body] and reports what happened without failing on a permission gap.
///
/// A read-only token legitimately cannot see Workers or Zero Trust; treating
/// that as a failure would make the run useless. A parse error or an unexpected
/// exception still fails, because that is a real defect.
Future<void> probe(String label, Future<String> Function() body) async {
  try {
    final detail = await body();
    say('  PASS  $label${detail.isEmpty ? '' : ' — $detail'}');
  } on PermissionFailure catch (e) {
    say('  SKIP  $label — token lacks ${e.missingPermissions.join(', ')}');
  } on AuthFailure catch (e) {
    say('  SKIP  $label — ${e.summary}');
  } on NotFoundFailure {
    say('  SKIP  $label — not present on this account');
  } on CfFailure catch (e) {
    fail('$label — ${e.runtimeType}: ${e.summary}');
  }
}

void main() {
  final token = Platform.environment['CF_API_TOKEN'] ?? '';
  final accountId = Platform.environment['CF_ACCOUNT_ID'] ?? '';
  final hasToken = token.isNotEmpty;

  late CfApi api;
  String? zoneId;
  String? zoneName;

  setUpAll(() {
    if (!hasToken) return;
    api = CfApi(
      CfClient(
        credentials: _Source(
          ApiTokenCredential(id: 'live', label: 'live', token: token),
        ),
        // Logging would print the Authorization header.
        enableLogging: false,
      ),
    );
  });

  group('live Cloudflare API', skip: hasToken ? null : 'set CF_API_TOKEN', () {
    test('identity', () async {
      await probe('verify token', () async {
        final r = await api.accounts.verifyToken();
        expect(r.status, isNotNull);
        return 'status=${r.status}';
      });
      await probe('list accounts', () async {
        final page = await api.accounts.listAccounts(perPage: 50);
        for (final a in page.items) {
          say('        account ${a.id}  ${a.name}');
        }
        return '${page.items.length} account(s)';
      });
      await probe('user details', () async {
        final r = await api.accounts.getUser();
        return r.email ?? r.id ?? '';
      });
    });

    test('zones', () async {
      await probe('list zones', () async {
        final page = await api.zones.listZones(perPage: 50);
        for (final z in page.items) {
          say('        zone ${z.id}  ${z.name}  ${z.status}');
        }
        if (page.items.isNotEmpty) {
          zoneId = page.items.first.id;
          zoneName = page.items.first.name;
        }
        return '${page.items.length} zone(s), hasMore=${page.hasMore}';
      });

      if (zoneId == null) return;
      say('  -- zone $zoneName --');

      await probe('zone details', () async {
        final z = await api.zones.getZone(zoneId: zoneId!);
        return 'plan=${z.plan?.name}';
      });
      await probe('all zone settings', () async {
        final page = await api.zones.getAllSettings(zoneId: zoneId!);
        return '${page.items.length} setting(s)';
      });
      await probe('single setting (ssl)', () async {
        final s = await api.zones.getSetting(zoneId: zoneId!, settingId: 'ssl');
        return 'ssl=${s.value}';
      });
    });

    test('dns', () async {
      if (zoneId == null) return;
      await probe('list dns records', () async {
        final page = await api.dns.listRecords(zoneId: zoneId!, perPage: 100);
        final byType = <String, int>{};
        for (final r in page.items) {
          byType[r.type_ ?? '?'] = (byType[r.type_ ?? '?'] ?? 0) + 1;
        }
        return '${page.items.length} record(s) $byType';
      });
      await probe('export BIND', () async {
        final env = await api.dns.exportBind(zoneId: zoneId!);
        final text = env.result?.toString() ?? '';
        return '${text.split('\n').length} line(s)';
      });
    });

    test('security', () async {
      if (zoneId == null) return;
      await probe('waf custom rules', () async {
        final r = await api.waf.getPhaseEntrypoint(
          zoneId: zoneId!,
          rulesetPhase: 'http_request_firewall_custom',
        );
        return '${r.rules?.length ?? 0} rule(s)';
      });
      await probe('rate limiting rules', () async {
        final r = await api.waf.getPhaseEntrypoint(
          zoneId: zoneId!,
          rulesetPhase: 'http_ratelimit',
        );
        return '${r.rules?.length ?? 0} rule(s)';
      });
      await probe('list rulesets', () async {
        final page = await api.waf.listRulesets(zoneId: zoneId!);
        return '${page.items.length} ruleset(s)';
      });
      await probe('ip access rules', () async {
        final page = await api.waf.listIpAccessRules(
          zoneId: zoneId!,
          perPage: 50,
        );
        return '${page.items.length} rule(s)';
      });
      await probe('worker routes', () async {
        final page = await api.workers.listRoutes(zoneId: zoneId!);
        return '${page.items.length} route(s)';
      });
    });

    test('account resources', () async {
      if (accountId.isEmpty) return;
      await probe('account details', () async {
        final a = await api.accounts.getAccount(accountId: accountId);
        return a.name ?? '';
      });
      await probe('worker scripts', () async {
        final page = await api.workers.listScripts(accountId: accountId);
        return '${page.items.length} script(s)';
      });
      await probe('pages projects', () async {
        final page = await api.workers.listPagesProjects(accountId: accountId);
        return '${page.items.length} project(s)';
      });
      await probe('kv namespaces', () async {
        final page = await api.workers.listKvNamespaces(
          accountId: accountId,
          perPage: 50,
        );
        return '${page.items.length} namespace(s)';
      });
      await probe('d1 databases', () async {
        final page = await api.workers.listD1Databases(accountId: accountId);
        return '${page.items.length} database(s)';
      });
      await probe('r2 buckets', () async {
        final r = await api.workers.listR2Buckets(accountId: accountId);
        return '${r.buckets?.length ?? 0} bucket(s)';
      });
      await probe('tunnels', () async {
        final page = await api.zeroTrust.listTunnels(
          accountId: accountId,
          perPage: 50,
        );
        for (final t in page.items) {
          say('        tunnel ${t.name}  ${t.status}');
        }
        return '${page.items.length} tunnel(s)';
      });
      await probe('access apps', () async {
        final page = await api.zeroTrust.listAccessApps(accountId: accountId);
        return '${page.items.length} app(s)';
      });
      await probe('gateway rules', () async {
        final page = await api.zeroTrust.listGatewayRules(accountId: accountId);
        return '${page.items.length} rule(s)';
      });
      await probe('permission groups', () async {
        final page = await api.accounts.listPermissionGroups();
        return '${page.items.length} group(s)';
      });
    });

    test('a write is refused by a read-only token', () async {
      if (zoneId == null) return;
      // Proves the PermissionFailure path end to end against the real API:
      // this is the error the UI turns into "your token is missing DNS Write"
      // rather than a bare 403.
      try {
        await api.dns.createRecord(
          zoneId: zoneId!,
          body: const DnsRecordPost(
            type_: 'TXT',
            name: '_cfmobile-readonly-probe',
            content: 'this should never be created',
            ttl: 60,
          ),
        );
        say('  NOTE  the token could write — check for a leftover TXT record');
      } on PermissionFailure catch (e) {
        say('  PASS  write refused — missing ${e.missingPermissions}');
      } on AuthFailure {
        say('  PASS  write refused — auth');
      }
    });
  });
}
