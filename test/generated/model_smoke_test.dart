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
    test('Organization', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = Organization.fromJson(json);
      final encoded = model.toJson();
      final again = Organization.fromJson(encoded);
      expect(again.toJson(), encoded);
    });
    test('PermissionGroupsListPermissionGroupsItem', () {
      final json = jsonDecode(r'''{}''') as Map<String, Object?>;
      final model = PermissionGroupsListPermissionGroupsItem.fromJson(json);
      final encoded = model.toJson();
      final again = PermissionGroupsListPermissionGroupsItem.fromJson(encoded);
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
