// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Home';

  @override
  String get navZones => 'Zones';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Settings';

  @override
  String get navSecurity => 'Security';

  @override
  String get navDeveloper => 'Developer';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'More';

  @override
  String get securityIpAccess => 'IP access';

  @override
  String get securityPickZone =>
      'Pick a zone first — security rules are per zone.';

  @override
  String get securityNoRules => 'No rules in this phase yet';

  @override
  String get securityNewIpRule => 'New IP access rule';

  @override
  String get securityAction => 'Action';

  @override
  String get securityTarget => 'Applies to';

  @override
  String get securityValue => 'Value';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Storage';

  @override
  String get devPickAccount =>
      'Pick an account first — these live at account level.';

  @override
  String get devKvNamespaces => 'KV namespaces';

  @override
  String get devD1 => 'D1 databases';

  @override
  String get devR2 => 'R2 buckets';

  @override
  String get kvSearchHint => 'Filter keys';

  @override
  String get kvValue => 'Value';

  @override
  String get kvExpires => 'Expires';

  @override
  String get kvMoreKeys => 'More keys exist — narrow the filter';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Run';

  @override
  String get d1OneStatement => 'One statement at a time';

  @override
  String get d1NoRows => 'No rows returned';

  @override
  String get d1DestructiveWarning => 'This statement changes or removes data.';

  @override
  String get d1ConfirmTitle => 'Run a destructive statement?';

  @override
  String get d1ConfirmHint => 'Type RUN to confirm';

  @override
  String get zoneTrafficSubtitle => 'Page rules, load balancers, waiting rooms';

  @override
  String get zoneTlsSubtitle => 'Certificates, custom hostnames, DNSSEC';

  @override
  String get zoneEmailSubtitle => 'Routing rules and destination addresses';

  @override
  String get trafficPageRules => 'Page rules';

  @override
  String get trafficLoadBalancers => 'Load balancers';

  @override
  String get trafficWaitingRooms => 'Waiting rooms';

  @override
  String get tlsCertificates => 'Certificate packs';

  @override
  String get tlsCustomHostnames => 'Custom hostnames';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Routing rules';

  @override
  String get emailAddresses => 'Destination addresses';

  @override
  String get moreAlerts => 'Alerts';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tunnels';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'No connectors are running right now';

  @override
  String get ztNoPolicies => 'No policies on this application';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonAll => 'All';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonNothingHere => 'Nothing here yet';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String get commonDiagnostics => 'Copy diagnostics';

  @override
  String get commonUnlock => 'Unlock';

  @override
  String get onboardWelcomeTitle => 'Manage Cloudflare from your phone';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zones, DNS, cache and every one of the $count API endpoints. Nothing leaves your device except calls to Cloudflare — this app has no internet permission beyond that.';
  }

  @override
  String get authChooseMethod => 'How do you want to sign in?';

  @override
  String get authApiToken => 'API token';

  @override
  String get authApiTokenBlurb =>
      'Recommended. Scoped to exactly the permissions you grant, revocable at any time.';

  @override
  String get authGlobalKey => 'Global API key';

  @override
  String get authGlobalKeyBlurb =>
      'Legacy. Unrestricted access to your whole account.';

  @override
  String get authCreateToken => 'Create a token in the dashboard';

  @override
  String get authPasteToken => 'Paste your API token';

  @override
  String get authTokenHint => '40-character token from the dashboard';

  @override
  String get authVerify => 'Verify and continue';

  @override
  String get authVerifying => 'Checking the token…';

  @override
  String get authTokenValid => 'Token accepted';

  @override
  String get authEmail => 'Cloudflare account email';

  @override
  String get authGlobalKeyField => 'Global API key';

  @override
  String get authGlobalKeyWarnTitle => 'This grants full account access';

  @override
  String get authGlobalKeyWarnBody =>
      'A Global API key cannot be scoped or limited by IP. It can read and change billing, and delete the account. Use an API token unless you have a specific reason not to.';

  @override
  String get authGlobalKeyConfirm => 'Type UNRESTRICTED to continue';

  @override
  String get authProfiles => 'Profiles';

  @override
  String get authAddProfile => 'Add profile';

  @override
  String get authProfileName => 'Profile name';

  @override
  String get authSignOut => 'Remove profile';

  @override
  String get lockTitle => 'Enter your PIN';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'Wrong PIN';

  @override
  String get lockBiometric => 'Use fingerprint';

  @override
  String get lockSetPin => 'Set a PIN';

  @override
  String get lockConfirmPin => 'Repeat the PIN';

  @override
  String get lockPinTooShort => 'At least 4 digits';

  @override
  String get lockPinMismatch => 'PINs do not match';

  @override
  String get lockEnableBiometric => 'Unlock with fingerprint';

  @override
  String get permTitle => 'Permissions';

  @override
  String get permNotificationAccess => 'Notification access';

  @override
  String permMissing(String permissions) {
    return 'Your credential is missing: $permissions';
  }

  @override
  String get permFixCta => 'Create a token with this permission';

  @override
  String get zonesTitle => 'Zones';

  @override
  String get zonesSearchHint => 'Search zones';

  @override
  String get zonesEmpty => 'No zones on this account';

  @override
  String get zoneStatusActive => 'Active';

  @override
  String get zonePlan => 'Plan';

  @override
  String get zoneNameservers => 'Nameservers';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
      zero: 'No records',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Add record';

  @override
  String get dnsEditRecord => 'Edit record';

  @override
  String get dnsType => 'Type';

  @override
  String get dnsName => 'Name';

  @override
  String get dnsContent => 'Content';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Auto';

  @override
  String get dnsProxied => 'Proxied through Cloudflare';

  @override
  String get dnsPriority => 'Priority';

  @override
  String get dnsComment => 'Comment';

  @override
  String get dnsTags => 'Tags';

  @override
  String dnsDeleteConfirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get dnsExport => 'Export as BIND file';

  @override
  String get dnsSearchHint => 'Search records';

  @override
  String get cachePurgeTitle => 'Purge cache';

  @override
  String get cachePurgeEverything => 'Purge everything';

  @override
  String get cachePurgeEverythingWarn =>
      'This drops every cached file for this zone and will briefly raise origin load.';

  @override
  String get cachePurgeConfirm => 'Type PURGE to confirm';

  @override
  String get cachePurgeByUrl => 'Purge by URL';

  @override
  String get cachePurged => 'Cache purged';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Host';

  @override
  String get purgeByPrefix => 'Prefix';

  @override
  String get purgeByTag => 'Tag';

  @override
  String get purgeTargets => 'What to purge';

  @override
  String get purgeOnePerLine => 'One per line';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsRequests => 'Requests';

  @override
  String get analyticsCached => 'Cached';

  @override
  String get analyticsBandwidth => 'Bandwidth';

  @override
  String get analyticsUniques => 'Visitors';

  @override
  String get analyticsCacheRatio => 'Cache hit';

  @override
  String get analyticsThreats => 'Threats';

  @override
  String get analyticsRequestsOverTime => 'Requests over time';

  @override
  String get analyticsStatusCodes => 'Status codes';

  @override
  String get analyticsTopCountries => 'Top countries';

  @override
  String get analyticsContentTypes => 'Content types';

  @override
  String get analyticsSecurityEvents => 'Security events';

  @override
  String get analyticsNoData => 'No traffic in this period';

  @override
  String get zoneAnalyticsSubtitle => 'Traffic, cache hit ratio, threats';

  @override
  String get zoneDnsSubtitle => 'Records, proxy status, BIND export';

  @override
  String get zonePurgeSubtitle => 'By URL, host, prefix, tag — or everything';

  @override
  String get explorerTitle => 'API explorer';

  @override
  String explorerSubtitle(int count) {
    return '$count endpoints';
  }

  @override
  String get explorerSearchHint => 'Search endpoints';

  @override
  String get explorerSend => 'Send request';

  @override
  String get explorerDeprecated => 'Deprecated';

  @override
  String get explorerRequired => 'Required';

  @override
  String get explorerNoParams => 'This endpoint takes no parameters';

  @override
  String get explorerBody => 'Request body';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsDynamicColor => 'Match my wallpaper';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Off uses the app\'s own palette.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsAutoLock => 'Auto-lock';

  @override
  String get settingsAutoLockImmediate => 'Immediately';

  @override
  String get settingsAutoLockNever => 'Never';

  @override
  String get settingsLockNow => 'Lock now';

  @override
  String get settingsBlockScreenshots => 'Block screenshots';

  @override
  String get settingsBlockScreenshotsHint =>
      'Hides the app from screenshots, screen recording and the recent-apps preview.';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsPrivacyBody =>
      'Credentials are encrypted with AES-GCM using a key derived from your PIN, and are stored only on this device. They are sent to api.cloudflare.com and nowhere else. There is no telemetry.';

  @override
  String get settingsWipe => 'Erase everything';

  @override
  String get settingsWipeConfirm =>
      'This deletes every saved profile and credential from this device.';

  @override
  String get settingsAbout => 'About';

  @override
  String get errNetworkOffline => 'No internet connection';

  @override
  String get errNetworkTimeout => 'Cloudflare did not respond in time';

  @override
  String get errAuth => 'Cloudflare rejected this credential';

  @override
  String get errRateLimited => 'Rate limited — retrying shortly';

  @override
  String get errNotFound => 'Not found';

  @override
  String get errServer => 'Cloudflare returned a server error';

  @override
  String get errUnknown => 'Something went wrong';
}
