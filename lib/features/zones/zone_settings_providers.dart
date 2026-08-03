import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../scope/scope_providers.dart';

/// A zone setting the app renders as a first-class control.
///
/// Cloudflare returns 56 settings for a free zone, most of which nobody wants
/// to see on a phone. This is the curated set, in the order they matter, with
/// the allowed values written down — the API returns a bare string and the
/// spec's enums are inconsistent about which values a given plan accepts.
class ZoneSettingSpec {
  const ZoneSettingSpec({
    required this.id,
    required this.label,
    required this.description,
    this.options = const [],
    this.isToggle = false,
    this.onValue = 'on',
    this.offValue = 'off',
  });

  final String id;
  final String label;
  final String description;

  /// Allowed values for a choice setting, most-secure first.
  final List<({String value, String label})> options;

  final bool isToggle;
  final String onValue;
  final String offValue;
}

const List<({String group, List<ZoneSettingSpec> settings})> kZoneSettings = [
  (
    group: 'SSL/TLS',
    settings: [
      ZoneSettingSpec(
        id: 'ssl',
        label: 'Encryption mode',
        description:
            'Flexible leaves the hop to your origin unencrypted. Full (strict) '
            'is the only mode that actually verifies the origin certificate.',
        options: [
          (value: 'strict', label: 'Full (strict)'),
          (value: 'full', label: 'Full'),
          (value: 'flexible', label: 'Flexible'),
          (value: 'off', label: 'Off'),
        ],
      ),
      ZoneSettingSpec(
        id: 'always_use_https',
        label: 'Always use HTTPS',
        description: 'Redirects every http:// request to https://.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'automatic_https_rewrites',
        label: 'Automatic HTTPS rewrites',
        description: 'Rewrites http:// links in HTML to https:// where safe.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'min_tls_version',
        label: 'Minimum TLS version',
        description: 'Refuse handshakes below this version.',
        options: [
          (value: '1.3', label: 'TLS 1.3'),
          (value: '1.2', label: 'TLS 1.2'),
          (value: '1.1', label: 'TLS 1.1'),
          (value: '1.0', label: 'TLS 1.0'),
        ],
      ),
      ZoneSettingSpec(
        id: 'opportunistic_encryption',
        label: 'Opportunistic encryption',
        description: 'Offers HTTP/2 over TLS to clients that ask for it.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'tls_1_3',
        label: 'TLS 1.3',
        description: 'Enable the current TLS version.',
        isToggle: true,
      ),
    ],
  ),
  (
    group: 'Cache',
    settings: [
      ZoneSettingSpec(
        id: 'cache_level',
        label: 'Caching level',
        description: 'How aggressively Cloudflare treats query strings.',
        options: [
          (value: 'aggressive', label: 'Standard'),
          (value: 'basic', label: 'No query string'),
          (value: 'simplified', label: 'Ignore query string'),
        ],
      ),
      ZoneSettingSpec(
        id: 'browser_cache_ttl',
        label: 'Browser cache TTL',
        description: 'What Cloudflare tells browsers to keep.',
        options: [
          (value: '0', label: 'Respect origin'),
          (value: '1800', label: '30 minutes'),
          (value: '3600', label: '1 hour'),
          (value: '14400', label: '4 hours'),
          (value: '86400', label: '1 day'),
          (value: '604800', label: '1 week'),
        ],
      ),
      ZoneSettingSpec(
        id: 'always_online',
        label: 'Always Online',
        description: 'Serve a cached copy when the origin is unreachable.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'development_mode',
        label: 'Development mode',
        description:
            'Bypasses the cache entirely for three hours. Turns itself off.',
        isToggle: true,
      ),
    ],
  ),
  (
    group: 'Network and speed',
    settings: [
      ZoneSettingSpec(
        id: 'http3',
        label: 'HTTP/3 (QUIC)',
        description: 'Serve over QUIC to clients that support it.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'websockets',
        label: 'WebSockets',
        description: 'Allow WebSocket connections through the proxy.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'ipv6',
        label: 'IPv6 compatibility',
        description: 'Serve the zone over IPv6.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'brotli',
        label: 'Brotli',
        description: 'Compress responses with Brotli where supported.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: '0rtt',
        label: '0-RTT connection resumption',
        description: 'Faster repeat handshakes, with a replay trade-off.',
        isToggle: true,
      ),
    ],
  ),
  (
    group: 'Security',
    settings: [
      ZoneSettingSpec(
        id: 'security_level',
        label: 'Security level',
        description: 'How readily visitors are challenged.',
        options: [
          (value: 'under_attack', label: 'I am under attack'),
          (value: 'high', label: 'High'),
          (value: 'medium', label: 'Medium'),
          (value: 'low', label: 'Low'),
          (value: 'essentially_off', label: 'Essentially off'),
        ],
      ),
      ZoneSettingSpec(
        id: 'browser_check',
        label: 'Browser integrity check',
        description: 'Block requests with suspicious headers.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'email_obfuscation',
        label: 'Email obfuscation',
        description: 'Hide email addresses in HTML from scrapers.',
        isToggle: true,
      ),
      ZoneSettingSpec(
        id: 'hotlink_protection',
        label: 'Hotlink protection',
        description: 'Refuse image requests from other sites.',
        isToggle: true,
      ),
    ],
  ),
];

/// Every setting, as returned by the API, keyed by id.
final zoneSettingsProvider = FutureProvider.autoDispose
    .family<Map<String, ZoneSettingsGetAllZoneSettingsItem>, String>((
      ref,
      zoneId,
    ) async {
      final page = await ref
          .watch(cfApiProvider)
          .zones
          .getAllSettings(zoneId: zoneId, cancelToken: autoCancelToken(ref));
      // `id` is typed Object? because the spec models it as an open enum; every
      // real response carries a string.
      return {
        for (final s in page.items)
          if (s.id != null) s.id!.toString(): s,
      };
    });

class ZoneSettingsActions {
  const ZoneSettingsActions(this._ref);

  final Ref _ref;

  /// Writes one setting. The API takes `{value: …}` and echoes the new state.
  ///
  /// The value goes through `extra` rather than the generated `value` field:
  /// the spec types it as an object because a couple of settings
  /// (`security_header`) really do take one, while almost every setting takes a
  /// bare string like `"on"` or `"1.2"`. Unknown-key preservation lets us send
  /// the shape Cloudflare actually wants without hand-patching the generator.
  Future<Setting> edit({
    required String zoneId,
    required String settingId,
    required Object value,
  }) {
    return _ref
        .read(cfApiProvider)
        .zones
        .editSetting(
          zoneId: zoneId,
          settingId: settingId,
          body: ZoneSettingsSingleRequest(extra: {'value': value}),
        );
  }

  /// Purges everything. Deliberately separate from the targeted variants: the
  /// UI makes the caller type a confirmation for this one.
  Future<void> purgeEverything(String zoneId) async {
    await _ref
        .read(cfApiProvider)
        .cache
        .purge(
          zoneId: zoneId,
          body: const ZonePurgeBody(purgeEverything: true),
        );
  }

  Future<void> purgeFiles(String zoneId, List<String> urls) async {
    await _ref
        .read(cfApiProvider)
        .cache
        .purge(
          zoneId: zoneId,
          body: ZonePurgeBody(
            files: urls.map((u) => ZonePurgeBodyFilesItem(url: u)).toList(),
          ),
        );
  }

  Future<void> purgeHosts(String zoneId, List<String> hosts) async {
    await _ref
        .read(cfApiProvider)
        .cache
        .purge(
          zoneId: zoneId,
          body: ZonePurgeBody(hosts: hosts),
        );
  }

  Future<void> purgePrefixes(String zoneId, List<String> prefixes) async {
    await _ref
        .read(cfApiProvider)
        .cache
        .purge(
          zoneId: zoneId,
          body: ZonePurgeBody(prefixes: prefixes),
        );
  }

  Future<void> purgeTags(String zoneId, List<String> tags) async {
    await _ref
        .read(cfApiProvider)
        .cache
        .purge(
          zoneId: zoneId,
          body: ZonePurgeBody(tags: tags),
        );
  }
}

final zoneSettingsActionsProvider = Provider<ZoneSettingsActions>(
  ZoneSettingsActions.new,
);
