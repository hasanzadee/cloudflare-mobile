// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import 'dart:convert';

import 'package:cloudflare_mobile/api/generated/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generated models round-trip', () {
    test('Account', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Account.fromJson(json);
      final encoded = model.toJson();
      final again = Account.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AccountManagedBy', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AccountManagedBy.fromJson(json);
      final encoded = model.toJson();
      final again = AccountManagedBy.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AccountSettings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AccountSettings.fromJson(json);
      final encoded = model.toJson();
      final again = AccountSettings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AdaptiveRouting', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AdaptiveRouting.fromJson(json);
      final encoded = model.toJson();
      final again = AdaptiveRouting.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Addresses', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Addresses.fromJson(json);
      final encoded = model.toJson();
      final again = Addresses.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppPolicyResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppPolicyResponse.fromJson(json);
      final encoded = model.toJson();
      final again = AppPolicyResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponse.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseDestinationsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseDestinationsItem.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseDestinationsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseFooterLinksItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseFooterLinksItem.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseFooterLinksItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasApp', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasApp.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasApp.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppCustomAttributesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppCustomAttributesItem.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppCustomAttributesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppCustomAttributesItemSource', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppCustomAttributesItemSource.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppCustomAttributesItemSource.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model =
          AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem.fromJson(
            json,
          );
      final encoded = model.toJson();
      final again =
          AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem.fromJson(
            encoded,
          );
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppCustomClaimsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppCustomClaimsItem.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppCustomClaimsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppCustomClaimsItemSource', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppCustomClaimsItemSource.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppCustomClaimsItemSource.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppHybridAndImplicitOptions', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppHybridAndImplicitOptions.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppHybridAndImplicitOptions.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('AppResponseSaasAppRefreshTokenOptions', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = AppResponseSaasAppRefreshTokenOptions.fromJson(json);
      final encoded = model.toJson();
      final again = AppResponseSaasAppRefreshTokenOptions.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ApprovalGroup', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ApprovalGroup.fromJson(json);
      final encoded = model.toJson();
      final again = ApprovalGroup.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('BatchQuery', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = BatchQuery.fromJson(json);
      final encoded = model.toJson();
      final again = BatchQuery.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Bucket', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Bucket.fromJson(json);
      final encoded = model.toJson();
      final again = Bucket.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('BuildConfig', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = BuildConfig.fromJson(json);
      final encoded = model.toJson();
      final again = BuildConfig.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CacheOptions', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CacheOptions.fromJson(json);
      final encoded = model.toJson();
      final again = CacheOptions.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CertificatePack', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CertificatePack.fromJson(json);
      final encoded = model.toJson();
      final again = CertificatePack.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CertificatePackCertificate', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CertificatePackCertificate.fromJson(json);
      final encoded = model.toJson();
      final again = CertificatePackCertificate.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CertificatePackCertificateGeoRestrictions', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CertificatePackCertificateGeoRestrictions.fromJson(json);
      final encoded = model.toJson();
      final again = CertificatePackCertificateGeoRestrictions.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CertificatePackValidationErrorsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CertificatePackValidationErrorsItem.fromJson(json);
      final encoded = model.toJson();
      final again = CertificatePackValidationErrorsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CfdTunnel', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CfdTunnel.fromJson(json);
      final encoded = model.toJson();
      final again = CfdTunnel.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Configuration', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Configuration.fromJson(json);
      final encoded = model.toJson();
      final again = Configuration.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ConnectionRules', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ConnectionRules.fromJson(json);
      final encoded = model.toJson();
      final again = ConnectionRules.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ConnectionRulesRdp', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ConnectionRulesRdp.fromJson(json);
      final encoded = model.toJson();
      final again = ConnectionRulesRdp.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CookieAttributes', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CookieAttributes.fromJson(json);
      final encoded = model.toJson();
      final again = CookieAttributes.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CorsHeaders', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CorsHeaders.fromJson(json);
      final encoded = model.toJson();
      final again = CorsHeaders.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CreateZoneRulesetRuleBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CreateZoneRulesetRuleBody.fromJson(json);
      final encoded = model.toJson();
      final again = CreateZoneRulesetRuleBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CreateZoneRulesetRuleBodyActionParameters', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CreateZoneRulesetRuleBodyActionParameters.fromJson(json);
      final encoded = model.toJson();
      final again = CreateZoneRulesetRuleBodyActionParameters.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CreateZoneRulesetRuleBodyPosition', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CreateZoneRulesetRuleBodyPosition.fromJson(json);
      final encoded = model.toJson();
      final again = CreateZoneRulesetRuleBodyPosition.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CreateZoneRulesetRuleResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CreateZoneRulesetRuleResult.fromJson(json);
      final encoded = model.toJson();
      final again = CreateZoneRulesetRuleResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('CustomHostname', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = CustomHostname.fromJson(json);
      final encoded = model.toJson();
      final again = CustomHostname.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DatabaseResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DatabaseResponse.fromJson(json);
      final encoded = model.toJson();
      final again = DatabaseResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DeleteZoneRulesetRuleResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DeleteZoneRulesetRuleResult.fromJson(json);
      final encoded = model.toJson();
      final again = DeleteZoneRulesetRuleResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Deployment', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Deployment.fromJson(json);
      final encoded = model.toJson();
      final again = Deployment.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DeploymentDeploymentTrigger', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DeploymentDeploymentTrigger.fromJson(json);
      final encoded = model.toJson();
      final again = DeploymentDeploymentTrigger.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DeploymentDeploymentTriggerMetadata', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DeploymentDeploymentTriggerMetadata.fromJson(json);
      final encoded = model.toJson();
      final again = DeploymentDeploymentTriggerMetadata.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordPatch', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordPatch.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordPatch.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordPatchData', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordPatchData.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordPatchData.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordPost', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordPost.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordPost.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordPostData', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordPostData.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordPostData.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordResponse.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordResponseData', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordResponseData.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordResponseData.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordResponseMeta', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordResponseMeta.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordResponseMeta.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsRecordsForAZoneImportDnsRecordsResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsRecordsForAZoneImportDnsRecordsResult.fromJson(json);
      final encoded = model.toJson();
      final again = DnsRecordsForAZoneImportDnsRecordsResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsResolverSettingsV4', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsResolverSettingsV4.fromJson(json);
      final encoded = model.toJson();
      final again = DnsResolverSettingsV4.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnsResolverSettingsV6', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnsResolverSettingsV6.fromJson(json);
      final encoded = model.toJson();
      final again = DnsResolverSettingsV6.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Dnssec', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Dnssec.fromJson(json);
      final encoded = model.toJson();
      final again = Dnssec.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('DnssecEditDnssecStatusBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = DnssecEditDnssecStatusBody.fromJson(json);
      final encoded = model.toJson();
      final again = DnssecEditDnssecStatusBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Expiration', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Expiration.fromJson(json);
      final encoded = model.toJson();
      final again = Expiration.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ExportsReconciliationInfo', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ExportsReconciliationInfo.fromJson(json);
      final encoded = model.toJson();
      final again = ExportsReconciliationInfo.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ExportsReconciliationRename', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ExportsReconciliationRename.fromJson(json);
      final encoded = model.toJson();
      final again = ExportsReconciliationRename.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ExportsReconciliationTransfer', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ExportsReconciliationTransfer.fromJson(json);
      final encoded = model.toJson();
      final again = ExportsReconciliationTransfer.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ExportsReconciliationTransferPending', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ExportsReconciliationTransferPending.fromJson(json);
      final encoded = model.toJson();
      final again = ExportsReconciliationTransferPending.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ExportsReconciliationWarning', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ExportsReconciliationWarning.fromJson(json);
      final encoded = model.toJson();
      final again = ExportsReconciliationWarning.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('FilterOptions', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = FilterOptions.fromJson(json);
      final encoded = model.toJson();
      final again = FilterOptions.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Filters', () {
      final json = jsonDecode(r'''{"slo":["99.9"]}''') as Map<String, Object?>;
      final model = Filters.fromJson(json);
      final encoded = model.toJson();
      final again = Filters.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('FixedResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = FixedResponse.fromJson(json);
      final encoded = model.toJson();
      final again = FixedResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('GetZoneEntrypointRulesetResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = GetZoneEntrypointRulesetResult.fromJson(json);
      final encoded = model.toJson();
      final again = GetZoneEntrypointRulesetResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('GetZoneRulesetResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = GetZoneRulesetResult.fromJson(json);
      final encoded = model.toJson();
      final again = GetZoneRulesetResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('History', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = History.fromJson(json);
      final encoded = model.toJson();
      final again = History.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('IpAccessRulesForAZoneCreateAnIpAccessRuleBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = IpAccessRulesForAZoneCreateAnIpAccessRuleBody.fromJson(
        json,
      );
      final encoded = model.toJson();
      final again = IpAccessRulesForAZoneCreateAnIpAccessRuleBody.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('IpAccessRulesForAZoneDeleteAnIpAccessRuleBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = IpAccessRulesForAZoneDeleteAnIpAccessRuleBody.fromJson(
        json,
      );
      final encoded = model.toJson();
      final again = IpAccessRulesForAZoneDeleteAnIpAccessRuleBody.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('IpAccessRulesForAZoneDeleteAnIpAccessRuleResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = IpAccessRulesForAZoneDeleteAnIpAccessRuleResult.fromJson(
        json,
      );
      final encoded = model.toJson();
      final again = IpAccessRulesForAZoneDeleteAnIpAccessRuleResult.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('Key', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Key.fromJson(json);
      final encoded = model.toJson();
      final again = Key.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('LandingPageDesign', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = LandingPageDesign.fromJson(json);
      final encoded = model.toJson();
      final again = LandingPageDesign.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Limits', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Limits.fromJson(json);
      final encoded = model.toJson();
      final again = Limits.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ListZoneRulesetsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ListZoneRulesetsItem.fromJson(json);
      final encoded = model.toJson();
      final again = ListZoneRulesetsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('LoadBalancer', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = LoadBalancer.fromJson(json);
      final encoded = model.toJson();
      final again = LoadBalancer.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('LoadBalancerRulesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = LoadBalancerRulesItem.fromJson(json);
      final encoded = model.toJson();
      final again = LoadBalancerRulesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('LoadShedding', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = LoadShedding.fromJson(json);
      final encoded = model.toJson();
      final again = LoadShedding.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('LocationStrategy', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = LocationStrategy.fromJson(json);
      final encoded = model.toJson();
      final again = LocationStrategy.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Match', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Match.fromJson(json);
      final encoded = model.toJson();
      final again = Match.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Mechanisms', () {
      final json =
          jsonDecode(
                r'''{"email":[{"id":"test@example.com"}],"pagerduty":[{"id":"e8133a15-00a4-4d69-aec1-32f70c51f6e5"}],"webhooks":[{"id":"14cc1190-5d2b-4b98-a696-c424cb2ad05f"}]}''',
              )
              as Map<String, Object?>;
      final model = Mechanisms.fromJson(json);
      final encoded = model.toJson();
      final again = Mechanisms.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MechanismsEmailItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MechanismsEmailItem.fromJson(json);
      final encoded = model.toJson();
      final again = MechanismsEmailItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MechanismsPagerdutyItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MechanismsPagerdutyItem.fromJson(json);
      final encoded = model.toJson();
      final again = MechanismsPagerdutyItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MechanismsWebhooksItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MechanismsWebhooksItem.fromJson(json);
      final encoded = model.toJson();
      final again = MechanismsWebhooksItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MfaConfig', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MfaConfig.fromJson(json);
      final encoded = model.toJson();
      final again = MfaConfig.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MigrationStep', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MigrationStep.fromJson(json);
      final encoded = model.toJson();
      final again = MigrationStep.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MigrationStepRenamedClassesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MigrationStepRenamedClassesItem.fromJson(json);
      final encoded = model.toJson();
      final again = MigrationStepRenamedClassesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('MigrationStepTransferredClassesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = MigrationStepTransferredClassesItem.fromJson(json);
      final encoded = model.toJson();
      final again = MigrationStepTransferredClassesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Monitor', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Monitor.fromJson(json);
      final encoded = model.toJson();
      final again = Monitor.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Namespace', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Namespace.fromJson(json);
      final encoded = model.toJson();
      final again = Namespace.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('NotificationFilter', () {
      final json =
          jsonDecode(
                r'''{"origin":{"disable":true},"pool":{"healthy":false}}''',
              )
              as Map<String, Object?>;
      final model = NotificationFilter.fromJson(json);
      final encoded = model.toJson();
      final again = NotificationFilter.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('OauthConfiguration', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OauthConfiguration.fromJson(json);
      final encoded = model.toJson();
      final again = OauthConfiguration.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('OauthConfigurationDynamicClientRegistration', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OauthConfigurationDynamicClientRegistration.fromJson(json);
      final encoded = model.toJson();
      final again = OauthConfigurationDynamicClientRegistration.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('OauthConfigurationGrant', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OauthConfigurationGrant.fromJson(json);
      final encoded = model.toJson();
      final again = OauthConfigurationGrant.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Observability', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Observability.fromJson(json);
      final encoded = model.toJson();
      final again = Observability.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ObservabilityLogs', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ObservabilityLogs.fromJson(json);
      final encoded = model.toJson();
      final again = ObservabilityLogs.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ObservabilityTraces', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ObservabilityTraces.fromJson(json);
      final encoded = model.toJson();
      final again = ObservabilityTraces.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Organization', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Organization.fromJson(json);
      final encoded = model.toJson();
      final again = Organization.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Origin', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Origin.fromJson(json);
      final encoded = model.toJson();
      final again = Origin.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('OriginSteering', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OriginSteering.fromJson(json);
      final encoded = model.toJson();
      final again = OriginSteering.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('OwnershipVerification', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OwnershipVerification.fromJson(json);
      final encoded = model.toJson();
      final again = OwnershipVerification.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('OwnershipVerificationHttp', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = OwnershipVerificationHttp.fromJson(json);
      final encoded = model.toJson();
      final again = OwnershipVerificationHttp.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PageRule', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PageRule.fromJson(json);
      final encoded = model.toJson();
      final again = PageRule.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PageRuleActionsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PageRuleActionsItem.fromJson(json);
      final encoded = model.toJson();
      final again = PageRuleActionsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PageRulesDeleteAPageRuleResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PageRulesDeleteAPageRuleResult.fromJson(json);
      final encoded = model.toJson();
      final again = PageRulesDeleteAPageRuleResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PageRulesEditAPageRuleBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PageRulesEditAPageRuleBody.fromJson(json);
      final encoded = model.toJson();
      final again = PageRulesEditAPageRuleBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PageRulesEditAPageRuleBodyActionsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PageRulesEditAPageRuleBodyActionsItem.fromJson(json);
      final encoded = model.toJson();
      final again = PageRulesEditAPageRuleBodyActionsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PermissionGroupsListPermissionGroupsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PermissionGroupsListPermissionGroupsItem.fromJson(json);
      final encoded = model.toJson();
      final again = PermissionGroupsListPermissionGroupsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PlacementInfo', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PlacementInfo.fromJson(json);
      final encoded = model.toJson();
      final again = PlacementInfo.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PlacementTarget', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PlacementTarget.fromJson(json);
      final encoded = model.toJson();
      final again = PlacementTarget.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Policies', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Policies.fromJson(json);
      final encoded = model.toJson();
      final again = Policies.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Pool', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Pool.fromJson(json);
      final encoded = model.toJson();
      final again = Pool.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PoolSet', () {
      final json =
          jsonDecode(
                r'''{"match":{"topology":{"regions":["WNAM"]}},"name":"wnam-primary","overrides":{"fallback_pool":"9290f38c5d07c2e2f4df57b1f61d4196","pools":["17b5962d775c646f3f9725cbc7a53df4"],"steering_policy":"random"}}''',
              )
              as Map<String, Object?>;
      final model = PoolSet.fromJson(json);
      final encoded = model.toJson();
      final again = PoolSet.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PoolSetOverrides', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PoolSetOverrides.fromJson(json);
      final encoded = model.toJson();
      final again = PoolSetOverrides.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Project', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Project.fromJson(json);
      final encoded = model.toJson();
      final again = Project.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectCanonicalDeployment', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectCanonicalDeployment.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectCanonicalDeployment.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectCanonicalDeploymentDeploymentTrigger', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectCanonicalDeploymentDeploymentTrigger.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectCanonicalDeploymentDeploymentTrigger.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('ProjectCanonicalDeploymentDeploymentTriggerMetadata', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model =
          ProjectCanonicalDeploymentDeploymentTriggerMetadata.fromJson(json);
      final encoded = model.toJson();
      final again =
          ProjectCanonicalDeploymentDeploymentTriggerMetadata.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigs', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigs.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigs.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsPreview', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsPreview.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsPreview.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsPreviewLimits', () {
      final json = jsonDecode(r'''{"cpu_ms":100}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsPreviewLimits.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsPreviewLimits.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsPreviewPlacement', () {
      final json = jsonDecode(r'''{"mode":"smart"}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsPreviewPlacement.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsPreviewPlacement.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsProduction', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsProduction.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsProduction.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsProductionLimits', () {
      final json = jsonDecode(r'''{"cpu_ms":100}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsProductionLimits.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsProductionLimits.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectDeploymentConfigsProductionPlacement', () {
      final json = jsonDecode(r'''{"mode":"smart"}''') as Map<String, Object?>;
      final model = ProjectDeploymentConfigsProductionPlacement.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectDeploymentConfigsProductionPlacement.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('ProjectLatestDeployment', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectLatestDeployment.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectLatestDeployment.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectLatestDeploymentDeploymentTrigger', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectLatestDeploymentDeploymentTrigger.fromJson(json);
      final encoded = model.toJson();
      final again = ProjectLatestDeploymentDeploymentTrigger.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ProjectLatestDeploymentDeploymentTriggerMetadata', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ProjectLatestDeploymentDeploymentTriggerMetadata.fromJson(
        json,
      );
      final encoded = model.toJson();
      final again = ProjectLatestDeploymentDeploymentTriggerMetadata.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('QueryMeta', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = QueryMeta.fromJson(json);
      final encoded = model.toJson();
      final again = QueryMeta.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('QueryMetaTimings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = QueryMetaTimings.fromJson(json);
      final encoded = model.toJson();
      final again = QueryMetaTimings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('QueryResultResponse', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = QueryResultResponse.fromJson(json);
      final encoded = model.toJson();
      final again = QueryResultResponse.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('R2ListBucketsResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = R2ListBucketsResult.fromJson(json);
      final encoded = model.toJson();
      final again = R2ListBucketsResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RandomSteering', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RandomSteering.fromJson(json);
      final encoded = model.toJson();
      final again = RandomSteering.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RequestRule', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RequestRule.fromJson(json);
      final encoded = model.toJson();
      final again = RequestRule.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RequestRuleActionParameters', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RequestRuleActionParameters.fromJson(json);
      final encoded = model.toJson();
      final again = RequestRuleActionParameters.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ResponseRule', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ResponseRule.fromJson(json);
      final encoded = model.toJson();
      final again = ResponseRule.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ResponseRuleActionParameters', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ResponseRuleActionParameters.fromJson(json);
      final encoded = model.toJson();
      final again = ResponseRuleActionParameters.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Route', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Route.fromJson(json);
      final encoded = model.toJson();
      final again = Route.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule.fromJson(json);
      final encoded = model.toJson();
      final again = Rule.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2AuthContext', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2AuthContext.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2AuthContext.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2AuthMethod', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2AuthMethod.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2AuthMethod.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2AzureAd', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2AzureAd.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2AzureAd.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2CloudflareAccountMember', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2CloudflareAccountMember.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2CloudflareAccountMember.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2CommonName', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2CommonName.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2CommonName.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2DevicePosture', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2DevicePosture.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2DevicePosture.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Email', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Email.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Email.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2EmailDomain', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2EmailDomain.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2EmailDomain.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2EmailList', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2EmailList.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2EmailList.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2ExternalEvaluation', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2ExternalEvaluation.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2ExternalEvaluation.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Geo', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Geo.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Geo.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2GithubOrganization', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2GithubOrganization.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2GithubOrganization.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Group', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Group.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Group.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Gsuite', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Gsuite.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Gsuite.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Ip', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Ip.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Ip.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2IpList', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2IpList.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2IpList.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2LinkedAppToken', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2LinkedAppToken.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2LinkedAppToken.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2LoginMethod', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2LoginMethod.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2LoginMethod.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Oidc', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Oidc.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Oidc.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Okta', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Okta.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Okta.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2Saml', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2Saml.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2Saml.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2ServiceToken', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2ServiceToken.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2ServiceToken.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rule2UserRiskScore', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rule2UserRiskScore.fromJson(json);
      final encoded = model.toJson();
      final again = Rule2UserRiskScore.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleAction', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleAction.fromJson(json);
      final encoded = model.toJson();
      final again = RuleAction.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleExposedCredentialCheck', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleExposedCredentialCheck.fromJson(json);
      final encoded = model.toJson();
      final again = RuleExposedCredentialCheck.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleLogging', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleLogging.fromJson(json);
      final encoded = model.toJson();
      final again = RuleLogging.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleMatcher', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleMatcher.fromJson(json);
      final encoded = model.toJson();
      final again = RuleMatcher.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleOverrides', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleOverrides.fromJson(json);
      final encoded = model.toJson();
      final again = RuleOverrides.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleRatelimit', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleRatelimit.fromJson(json);
      final encoded = model.toJson();
      final again = RuleRatelimit.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettings.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsAuditSsh', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsAuditSsh.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsAuditSsh.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsBisoAdminControls', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsBisoAdminControls.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsBisoAdminControls.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsBlockPage', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsBlockPage.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsBlockPage.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsCheckSession', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsCheckSession.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsCheckSession.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsDnsResolvers', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsDnsResolvers.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsDnsResolvers.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsEgress', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsEgress.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsEgress.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsForensicCopy', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsForensicCopy.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsForensicCopy.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsL4override', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsL4override.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsL4override.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsNotificationSettings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsNotificationSettings.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsNotificationSettings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsPayloadLog', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsPayloadLog.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsPayloadLog.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsQuarantine', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsQuarantine.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsQuarantine.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsRedirect', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsRedirect.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsRedirect.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsResolveDnsInternally', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsResolveDnsInternally.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsResolveDnsInternally.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('RuleSettingsUntrustedCert', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = RuleSettingsUntrustedCert.fromJson(json);
      final encoded = model.toJson();
      final again = RuleSettingsUntrustedCert.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rules', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rules.fromJson(json);
      final encoded = model.toJson();
      final again = Rules.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Rules2', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Rules2.fromJson(json);
      final encoded = model.toJson();
      final again = Rules2.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Schedule', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Schedule.fromJson(json);
      final encoded = model.toJson();
      final again = Schedule.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Schedule2', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Schedule2.fromJson(json);
      final encoded = model.toJson();
      final again = Schedule2.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SchemasConnection', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SchemasConnection.fromJson(json);
      final encoded = model.toJson();
      final again = SchemasConnection.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SchemasHeader', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SchemasHeader.fromJson(json);
      final encoded = model.toJson();
      final again = SchemasHeader.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScimConfig', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScimConfig.fromJson(json);
      final encoded = model.toJson();
      final again = ScimConfig.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScimConfigAuthentication', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScimConfigAuthentication.fromJson(json);
      final encoded = model.toJson();
      final again = ScimConfigAuthentication.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScimConfigMapping', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScimConfigMapping.fromJson(json);
      final encoded = model.toJson();
      final again = ScimConfigMapping.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScimConfigMappingOperations', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScimConfigMappingOperations.fromJson(json);
      final encoded = model.toJson();
      final again = ScimConfigMappingOperations.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScriptAndVersionSettingsItem.fromJson(json);
      final encoded = model.toJson();
      final again = ScriptAndVersionSettingsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemAnnotations', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScriptAndVersionSettingsItemAnnotations.fromJson(json);
      final encoded = model.toJson();
      final again = ScriptAndVersionSettingsItemAnnotations.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemExportsReconciliation', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScriptAndVersionSettingsItemExportsReconciliation.fromJson(
        json,
      );
      final encoded = model.toJson();
      final again = ScriptAndVersionSettingsItemExportsReconciliation.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemMigrations', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScriptAndVersionSettingsItemMigrations.fromJson(json);
      final encoded = model.toJson();
      final again = ScriptAndVersionSettingsItemMigrations.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemMigrationsRenamedClassesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model =
          ScriptAndVersionSettingsItemMigrationsRenamedClassesItem.fromJson(
            json,
          );
      final encoded = model.toJson();
      final again =
          ScriptAndVersionSettingsItemMigrationsRenamedClassesItem.fromJson(
            encoded,
          );
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemMigrationsTransferredClassesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model =
          ScriptAndVersionSettingsItemMigrationsTransferredClassesItem.fromJson(
            json,
          );
      final encoded = model.toJson();
      final again =
          ScriptAndVersionSettingsItemMigrationsTransferredClassesItem.fromJson(
            encoded,
          );
      expect(again.toJson(), encoded);
    });
    test('ScriptAndVersionSettingsItemPlacement', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ScriptAndVersionSettingsItemPlacement.fromJson(json);
      final encoded = model.toJson();
      final again = ScriptAndVersionSettingsItemPlacement.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SessionAffinityAttributes', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SessionAffinityAttributes.fromJson(json);
      final encoded = model.toJson();
      final again = SessionAffinityAttributes.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Setting', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Setting.fromJson(json);
      final encoded = model.toJson();
      final again = Setting.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SettingValue', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SettingValue.fromJson(json);
      final encoded = model.toJson();
      final again = SettingValue.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SettingValueStrictTransportSecurity', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SettingValueStrictTransportSecurity.fromJson(json);
      final encoded = model.toJson();
      final again = SettingValueStrictTransportSecurity.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Settings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Settings.fromJson(json);
      final encoded = model.toJson();
      final again = Settings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Settings2', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Settings2.fromJson(json);
      final encoded = model.toJson();
      final again = Settings2.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SingleQuery', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SingleQuery.fromJson(json);
      final encoded = model.toJson();
      final again = SingleQuery.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Source', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Source.fromJson(json);
      final encoded = model.toJson();
      final again = Source.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SourceConfig', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SourceConfig.fromJson(json);
      final encoded = model.toJson();
      final again = SourceConfig.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Ssl', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Ssl.fromJson(json);
      final encoded = model.toJson();
      final again = Ssl.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('SslValidationErrorsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = SslValidationErrorsItem.fromJson(json);
      final encoded = model.toJson();
      final again = SslValidationErrorsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Sslsettings', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Sslsettings.fromJson(json);
      final encoded = model.toJson();
      final again = Sslsettings.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Stage', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Stage.fromJson(json);
      final encoded = model.toJson();
      final again = Stage.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('TailConsumersScript', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = TailConsumersScript.fromJson(json);
      final encoded = model.toJson();
      final again = TailConsumersScript.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Target', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Target.fromJson(json);
      final encoded = model.toJson();
      final again = Target.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('TargetConstraint', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = TargetConstraint.fromJson(json);
      final encoded = model.toJson();
      final again = TargetConstraint.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('TargetCriteriaSelfHostedApp', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = TargetCriteriaSelfHostedApp.fromJson(json);
      final encoded = model.toJson();
      final again = TargetCriteriaSelfHostedApp.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('TopologyMatch', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = TopologyMatch.fromJson(json);
      final encoded = model.toJson();
      final again = TopologyMatch.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('TunnelClient', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = TunnelClient.fromJson(json);
      final encoded = model.toJson();
      final again = TunnelClient.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Universal', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Universal.fromJson(json);
      final encoded = model.toJson();
      final again = Universal.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneEntrypointRulesetBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneEntrypointRulesetBody.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneEntrypointRulesetBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneEntrypointRulesetResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneEntrypointRulesetResult.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneEntrypointRulesetResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneRulesetRuleBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneRulesetRuleBody.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneRulesetRuleBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneRulesetRuleBodyActionParameters', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneRulesetRuleBodyActionParameters.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneRulesetRuleBodyActionParameters.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneRulesetRuleBodyPosition', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneRulesetRuleBodyPosition.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneRulesetRuleBodyPosition.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UpdateZoneRulesetRuleResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UpdateZoneRulesetRuleResult.fromJson(json);
      final encoded = model.toJson();
      final again = UpdateZoneRulesetRuleResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UserApiTokensVerifyTokenResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UserApiTokensVerifyTokenResult.fromJson(json);
      final encoded = model.toJson();
      final again = UserApiTokensVerifyTokenResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('UserUserDetailsResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = UserUserDetailsResult.fromJson(json);
      final encoded = model.toJson();
      final again = UserUserDetailsResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ValidationRecord', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ValidationRecord.fromJson(json);
      final encoded = model.toJson();
      final again = ValidationRecord.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('Waitingroom', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Waitingroom.fromJson(json);
      final encoded = model.toJson();
      final again = Waitingroom.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WaitingroomAdditionalRoutesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WaitingroomAdditionalRoutesItem.fromJson(json);
      final encoded = model.toJson();
      final again = WaitingroomAdditionalRoutesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WidgetList', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WidgetList.fromJson(json);
      final encoded = model.toJson();
      final again = WidgetList.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WorkerCronTriggerGetCronTriggersResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WorkerCronTriggerGetCronTriggersResult.fromJson(json);
      final encoded = model.toJson();
      final again = WorkerCronTriggerGetCronTriggersResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WorkerCronTriggerUpdateCronTriggersResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WorkerCronTriggerUpdateCronTriggersResult.fromJson(json);
      final encoded = model.toJson();
      final again = WorkerCronTriggerUpdateCronTriggersResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WorkerScriptListWorkersItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WorkerScriptListWorkersItem.fromJson(json);
      final encoded = model.toJson();
      final again = WorkerScriptListWorkersItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('WorkerScriptListWorkersItemNamedHandlersItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = WorkerScriptListWorkersItemNamedHandlersItem.fromJson(json);
      final encoded = model.toJson();
      final again = WorkerScriptListWorkersItemNamedHandlersItem.fromJson(
        encoded,
      );
      expect(again.toJson(), encoded);
    });
    test('Zone', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Zone.fromJson(json);
      final encoded = model.toJson();
      final again = Zone.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneAccount', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneAccount.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneAccount.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneMeta', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneMeta.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneMeta.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneOwner', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneOwner.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneOwner.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZonePlan', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZonePlan.fromJson(json);
      final encoded = model.toJson();
      final again = ZonePlan.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZonePurgeBody', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZonePurgeBody.fromJson(json);
      final encoded = model.toJson();
      final again = ZonePurgeBody.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZonePurgeBodyFilesItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZonePurgeBodyFilesItem.fromJson(json);
      final encoded = model.toJson();
      final again = ZonePurgeBodyFilesItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZonePurgeResult', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZonePurgeResult.fromJson(json);
      final encoded = model.toJson();
      final again = ZonePurgeResult.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneSettingsGetAllZoneSettingsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneSettingsGetAllZoneSettingsItem.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneSettingsGetAllZoneSettingsItem.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneSettingsSingleRequest', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneSettingsSingleRequest.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneSettingsSingleRequest.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneTenant', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneTenant.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneTenant.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('ZoneTenantUnit', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = ZoneTenantUnit.fromJson(json);
      final encoded = model.toJson();
      final again = ZoneTenantUnit.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
  });
}
