import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Mobile'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get navZones;

  /// No description provided for @navExplorer.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get navExplorer;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get navSecurity;

  /// No description provided for @navDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get navDeveloper;

  /// No description provided for @navZeroTrust.
  ///
  /// In en, this message translates to:
  /// **'Zero Trust'**
  String get navZeroTrust;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @securityIpAccess.
  ///
  /// In en, this message translates to:
  /// **'IP access'**
  String get securityIpAccess;

  /// No description provided for @securityPickZone.
  ///
  /// In en, this message translates to:
  /// **'Pick a zone first — security rules are per zone.'**
  String get securityPickZone;

  /// No description provided for @securityNoRules.
  ///
  /// In en, this message translates to:
  /// **'No rules in this phase yet'**
  String get securityNoRules;

  /// No description provided for @securityNewIpRule.
  ///
  /// In en, this message translates to:
  /// **'New IP access rule'**
  String get securityNewIpRule;

  /// No description provided for @securityAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get securityAction;

  /// No description provided for @securityTarget.
  ///
  /// In en, this message translates to:
  /// **'Applies to'**
  String get securityTarget;

  /// No description provided for @securityValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get securityValue;

  /// No description provided for @devWorkers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get devWorkers;

  /// No description provided for @devPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get devPages;

  /// No description provided for @devStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get devStorage;

  /// No description provided for @devPickAccount.
  ///
  /// In en, this message translates to:
  /// **'Pick an account first — these live at account level.'**
  String get devPickAccount;

  /// No description provided for @devKvNamespaces.
  ///
  /// In en, this message translates to:
  /// **'KV namespaces'**
  String get devKvNamespaces;

  /// No description provided for @devD1.
  ///
  /// In en, this message translates to:
  /// **'D1 databases'**
  String get devD1;

  /// No description provided for @devR2.
  ///
  /// In en, this message translates to:
  /// **'R2 buckets'**
  String get devR2;

  /// No description provided for @ztTunnels.
  ///
  /// In en, this message translates to:
  /// **'Tunnels'**
  String get ztTunnels;

  /// No description provided for @ztAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get ztAccess;

  /// No description provided for @ztGateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get ztGateway;

  /// No description provided for @ztNoConnectors.
  ///
  /// In en, this message translates to:
  /// **'No connectors are running right now'**
  String get ztNoConnectors;

  /// No description provided for @ztNoPolicies.
  ///
  /// In en, this message translates to:
  /// **'No policies on this application'**
  String get ztNoPolicies;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get commonCopied;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get commonNothingHere;

  /// No description provided for @commonLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get commonLoadMore;

  /// No description provided for @commonDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Copy diagnostics'**
  String get commonDiagnostics;

  /// No description provided for @commonUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get commonUnlock;

  /// No description provided for @onboardWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Cloudflare from your phone'**
  String get onboardWelcomeTitle;

  /// No description provided for @onboardWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Zones, DNS, cache and every one of the {count} API endpoints. Nothing leaves your device except calls to Cloudflare — this app has no internet permission beyond that.'**
  String onboardWelcomeBody(int count);

  /// No description provided for @authChooseMethod.
  ///
  /// In en, this message translates to:
  /// **'How do you want to sign in?'**
  String get authChooseMethod;

  /// No description provided for @authApiToken.
  ///
  /// In en, this message translates to:
  /// **'API token'**
  String get authApiToken;

  /// No description provided for @authApiTokenBlurb.
  ///
  /// In en, this message translates to:
  /// **'Recommended. Scoped to exactly the permissions you grant, revocable at any time.'**
  String get authApiTokenBlurb;

  /// No description provided for @authGlobalKey.
  ///
  /// In en, this message translates to:
  /// **'Global API key'**
  String get authGlobalKey;

  /// No description provided for @authGlobalKeyBlurb.
  ///
  /// In en, this message translates to:
  /// **'Legacy. Unrestricted access to your whole account.'**
  String get authGlobalKeyBlurb;

  /// No description provided for @authOAuth.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Cloudflare'**
  String get authOAuth;

  /// No description provided for @authOAuthBlurb.
  ///
  /// In en, this message translates to:
  /// **'Opens the Cloudflare dashboard so you can sign in with email, Google or SSO.'**
  String get authOAuthBlurb;

  /// No description provided for @authOAuthNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Add an OAuth client ID in Settings first'**
  String get authOAuthNotConfigured;

  /// No description provided for @authOAuthSettings.
  ///
  /// In en, this message translates to:
  /// **'OAuth client'**
  String get authOAuthSettings;

  /// No description provided for @authOAuthClientId.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get authOAuthClientId;

  /// No description provided for @authOAuthRedirect.
  ///
  /// In en, this message translates to:
  /// **'Redirect URL'**
  String get authOAuthRedirect;

  /// No description provided for @authOAuthHelp.
  ///
  /// In en, this message translates to:
  /// **'Register a client at Manage account → OAuth clients. Token auth method must be None (PKCE); the redirect must be https, so point it at the bridge Worker in tools/oauth-callback-worker.'**
  String get authOAuthHelp;

  /// No description provided for @authCreateToken.
  ///
  /// In en, this message translates to:
  /// **'Create a token in the dashboard'**
  String get authCreateToken;

  /// No description provided for @authPasteToken.
  ///
  /// In en, this message translates to:
  /// **'Paste your API token'**
  String get authPasteToken;

  /// No description provided for @authTokenHint.
  ///
  /// In en, this message translates to:
  /// **'40-character token from the dashboard'**
  String get authTokenHint;

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get authVerify;

  /// No description provided for @authVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking the token…'**
  String get authVerifying;

  /// No description provided for @authTokenValid.
  ///
  /// In en, this message translates to:
  /// **'Token accepted'**
  String get authTokenValid;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare account email'**
  String get authEmail;

  /// No description provided for @authGlobalKeyField.
  ///
  /// In en, this message translates to:
  /// **'Global API key'**
  String get authGlobalKeyField;

  /// No description provided for @authGlobalKeyWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'This grants full account access'**
  String get authGlobalKeyWarnTitle;

  /// No description provided for @authGlobalKeyWarnBody.
  ///
  /// In en, this message translates to:
  /// **'A Global API key cannot be scoped or limited by IP. It can read and change billing, and delete the account. Use an API token unless you have a specific reason not to.'**
  String get authGlobalKeyWarnBody;

  /// No description provided for @authGlobalKeyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type UNRESTRICTED to continue'**
  String get authGlobalKeyConfirm;

  /// No description provided for @authProfiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get authProfiles;

  /// No description provided for @authAddProfile.
  ///
  /// In en, this message translates to:
  /// **'Add profile'**
  String get authAddProfile;

  /// No description provided for @authProfileName.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get authProfileName;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Remove profile'**
  String get authSignOut;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockTitle;

  /// No description provided for @lockPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get lockPin;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get lockWrongPin;

  /// No description provided for @lockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint'**
  String get lockBiometric;

  /// No description provided for @lockSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get lockSetPin;

  /// No description provided for @lockConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Repeat the PIN'**
  String get lockConfirmPin;

  /// No description provided for @lockPinTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 4 digits'**
  String get lockPinTooShort;

  /// No description provided for @lockPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get lockPinMismatch;

  /// No description provided for @lockEnableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint'**
  String get lockEnableBiometric;

  /// No description provided for @permTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permTitle;

  /// No description provided for @permNotificationAccess.
  ///
  /// In en, this message translates to:
  /// **'Notification access'**
  String get permNotificationAccess;

  /// No description provided for @permMissing.
  ///
  /// In en, this message translates to:
  /// **'Your credential is missing: {permissions}'**
  String permMissing(String permissions);

  /// No description provided for @permFixCta.
  ///
  /// In en, this message translates to:
  /// **'Create a token with this permission'**
  String get permFixCta;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get zonesTitle;

  /// No description provided for @zonesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search zones'**
  String get zonesSearchHint;

  /// No description provided for @zonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No zones on this account'**
  String get zonesEmpty;

  /// No description provided for @zoneStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get zoneStatusActive;

  /// No description provided for @zonePlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get zonePlan;

  /// No description provided for @zoneNameservers.
  ///
  /// In en, this message translates to:
  /// **'Nameservers'**
  String get zoneNameservers;

  /// No description provided for @dnsTitle.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get dnsTitle;

  /// No description provided for @dnsRecords.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No records} =1{1 record} other{{count} records}}'**
  String dnsRecords(int count);

  /// No description provided for @dnsAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get dnsAddRecord;

  /// No description provided for @dnsEditRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit record'**
  String get dnsEditRecord;

  /// No description provided for @dnsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get dnsType;

  /// No description provided for @dnsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get dnsName;

  /// No description provided for @dnsContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get dnsContent;

  /// No description provided for @dnsTtl.
  ///
  /// In en, this message translates to:
  /// **'TTL'**
  String get dnsTtl;

  /// No description provided for @dnsTtlAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get dnsTtlAuto;

  /// No description provided for @dnsProxied.
  ///
  /// In en, this message translates to:
  /// **'Proxied through Cloudflare'**
  String get dnsProxied;

  /// No description provided for @dnsPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get dnsPriority;

  /// No description provided for @dnsComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get dnsComment;

  /// No description provided for @dnsTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get dnsTags;

  /// No description provided for @dnsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String dnsDeleteConfirm(String name);

  /// No description provided for @dnsExport.
  ///
  /// In en, this message translates to:
  /// **'Export as BIND file'**
  String get dnsExport;

  /// No description provided for @dnsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search records'**
  String get dnsSearchHint;

  /// No description provided for @cachePurgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Purge cache'**
  String get cachePurgeTitle;

  /// No description provided for @cachePurgeEverything.
  ///
  /// In en, this message translates to:
  /// **'Purge everything'**
  String get cachePurgeEverything;

  /// No description provided for @cachePurgeEverythingWarn.
  ///
  /// In en, this message translates to:
  /// **'This drops every cached file for this zone and will briefly raise origin load.'**
  String get cachePurgeEverythingWarn;

  /// No description provided for @cachePurgeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type PURGE to confirm'**
  String get cachePurgeConfirm;

  /// No description provided for @cachePurgeByUrl.
  ///
  /// In en, this message translates to:
  /// **'Purge by URL'**
  String get cachePurgeByUrl;

  /// No description provided for @cachePurged.
  ///
  /// In en, this message translates to:
  /// **'Cache purged'**
  String get cachePurged;

  /// No description provided for @purgeByUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get purgeByUrl;

  /// No description provided for @purgeByHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get purgeByHost;

  /// No description provided for @purgeByPrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get purgeByPrefix;

  /// No description provided for @purgeByTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get purgeByTag;

  /// No description provided for @purgeTargets.
  ///
  /// In en, this message translates to:
  /// **'What to purge'**
  String get purgeTargets;

  /// No description provided for @purgeOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'One per line'**
  String get purgeOnePerLine;

  /// No description provided for @zoneDnsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Records, proxy status, BIND export'**
  String get zoneDnsSubtitle;

  /// No description provided for @zonePurgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'By URL, host, prefix, tag — or everything'**
  String get zonePurgeSubtitle;

  /// No description provided for @explorerTitle.
  ///
  /// In en, this message translates to:
  /// **'API explorer'**
  String get explorerTitle;

  /// No description provided for @explorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} endpoints'**
  String explorerSubtitle(int count);

  /// No description provided for @explorerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search endpoints'**
  String get explorerSearchHint;

  /// No description provided for @explorerSend.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get explorerSend;

  /// No description provided for @explorerDeprecated.
  ///
  /// In en, this message translates to:
  /// **'Deprecated'**
  String get explorerDeprecated;

  /// No description provided for @explorerRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get explorerRequired;

  /// No description provided for @explorerNoParams.
  ///
  /// In en, this message translates to:
  /// **'This endpoint takes no parameters'**
  String get explorerNoParams;

  /// No description provided for @explorerBody.
  ///
  /// In en, this message translates to:
  /// **'Request body'**
  String get explorerBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get settingsAutoLock;

  /// No description provided for @settingsAutoLockImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get settingsAutoLockImmediate;

  /// No description provided for @settingsAutoLockNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsAutoLockNever;

  /// No description provided for @settingsBlockScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots'**
  String get settingsBlockScreenshots;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Credentials are encrypted with AES-GCM using a key derived from your PIN, and are stored only on this device. They are sent to api.cloudflare.com and nowhere else. There is no telemetry.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsWipe.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get settingsWipe;

  /// No description provided for @settingsWipeConfirm.
  ///
  /// In en, this message translates to:
  /// **'This deletes every saved profile and credential from this device.'**
  String get settingsWipeConfirm;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @errNetworkOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errNetworkOffline;

  /// No description provided for @errNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare did not respond in time'**
  String get errNetworkTimeout;

  /// No description provided for @errAuth.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare rejected this credential'**
  String get errAuth;

  /// No description provided for @errRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Rate limited — retrying shortly'**
  String get errRateLimited;

  /// No description provided for @errNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errNotFound;

  /// No description provided for @errServer.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare returned a server error'**
  String get errServer;

  /// No description provided for @errUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errUnknown;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'ru':
      return LRu();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
