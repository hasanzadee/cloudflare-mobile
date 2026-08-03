import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/auth/application/auth_providers.dart';
import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cloudflare_mobile/core/net/cf_client.dart';
import 'package:cloudflare_mobile/core/net/interceptors/auth_interceptor.dart';
import 'package:cloudflare_mobile/features/security/security_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Toggling a WAF rule off failed against the real API with
/// *"action is required to create or update a rule"* and
/// *"expression cannot be blank"*.
///
/// The code sent `{enabled: false}` on the assumption that the Ruleset API
/// merges a partial body. It does not — the update replaces the rule, so the
/// whole thing has to be echoed back, including the fields this app never
/// modelled and keeps in `extra`.
class _Source implements CredentialSource {
  @override
  CfCredential? get current =>
      const ApiTokenCredential(id: 'p1', label: 'Test', token: 'secret');
}

void main() {
  late List<RequestOptions> sent;
  late ProviderContainer container;

  /// A rule shaped like one Cloudflare actually returns, including two keys the
  /// generated model has no field for.
  final rule = ResponseRule.fromJson(const {
    'id': 'rule-1',
    'version': '7',
    'last_updated': '2026-08-01T10:00:00Z',
    'action': 'block',
    'expression': '(http.host eq "example.com")',
    'description': 'vault aze',
    'enabled': true,
    'ref': 'rule-ref-1',
    'logging': {'enabled': true},
    'some_future_field': {'nested': 42},
    'categories': ['a', 'b'],
  });

  setUp(() {
    sent = [];
    final client = CfClient(credentials: _Source(), enableLogging: false);
    // Record and short-circuit: what matters is the request we build, not what
    // Cloudflare would answer.
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          sent.add(options);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'errors': <Object>[],
                'messages': <Object>[],
                'result': <String, Object?>{},
              },
            ),
          );
        },
      ),
    );
    container = ProviderContainer(
      overrides: [cfApiProvider.overrideWithValue(CfApi(client))],
    );
    addTearDown(container.dispose);
  });

  Map<String, Object?> body() => sent.single.data! as Map<String, Object?>;

  test('disabling a rule sends the fields the API demands', () async {
    await container
        .read(securityActionsProvider)
        .setRuleEnabled(
          zoneId: 'z1',
          rulesetId: 'rs1',
          rule: rule,
          enabled: false,
        );

    expect(body()['enabled'], isFalse);
    // The two that produced the error messages.
    expect(body()['action'], 'block');
    expect(body()['expression'], '(http.host eq "example.com")');
  });

  test('the rest of the rule survives the round trip', () async {
    await container
        .read(securityActionsProvider)
        .setRuleEnabled(
          zoneId: 'z1',
          rulesetId: 'rs1',
          rule: rule,
          enabled: false,
        );

    expect(body()['description'], 'vault aze');
    expect(body()['ref'], 'rule-ref-1');
    expect(body()['categories'], ['a', 'b']);
    // Unmodelled fields ride along in `extra`. Dropping them would silently
    // strip configuration from someone else's rule.
    expect(body()['some_future_field'], {'nested': 42});
  });

  test('server-managed fields are not echoed back', () async {
    await container
        .read(securityActionsProvider)
        .setRuleEnabled(
          zoneId: 'z1',
          rulesetId: 'rs1',
          rule: rule,
          enabled: false,
        );

    expect(body().containsKey('version'), isFalse);
    expect(body().containsKey('last_updated'), isFalse);
    // The id belongs in the path, not the body.
    expect(body().containsKey('id'), isFalse);
    expect(sent.single.path, contains('rule-1'));
  });

  test('enabling works the same way round', () async {
    await container
        .read(securityActionsProvider)
        .setRuleEnabled(
          zoneId: 'z1',
          rulesetId: 'rs1',
          rule: rule,
          enabled: true,
        );

    expect(body()['enabled'], isTrue);
    expect(body()['action'], 'block');
  });
}
