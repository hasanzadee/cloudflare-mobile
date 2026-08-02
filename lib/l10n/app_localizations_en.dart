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
  String get authOAuth => 'Sign in with Cloudflare';

  @override
  String get authOAuthBlurb =>
      'Opens the Cloudflare dashboard so you can sign in with email, Google or SSO.';

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
  String get settingsSecurity => 'Security';

  @override
  String get settingsAutoLock => 'Auto-lock';

  @override
  String get settingsAutoLockImmediate => 'Immediately';

  @override
  String get settingsAutoLockNever => 'Never';

  @override
  String get settingsBlockScreenshots => 'Block screenshots';

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
