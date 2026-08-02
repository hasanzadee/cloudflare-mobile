// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import '../coerce.dart';

class Account {
  const Account({
    this.createdOn,
    this.id,
    this.managedBy,
    this.name,
    this.settings,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory Account.fromJson(Map<String, Object?> json) => Account(
    createdOn: asString(json['created_on']),
    id: asString(json['id']),
    managedBy: asModel(json['managed_by'], AccountManagedBy.fromJson),
    name: asString(json['name']),
    settings: asModel(json['settings'], AccountSettings.fromJson),
    type_: json['type'],
    extra: extraOf(json, _knownKeys),
  );

  /// Timestamp for the creation of the account
  final String? createdOn;

  /// Identifier
  final String? id;

  /// Parent container details
  final AccountManagedBy? managedBy;

  /// Account name
  final String? name;

  /// Account settings
  final AccountSettings? settings;

  /// Allowed values: `standard`, `enterprise`.
  final Object? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'created_on',
    'id',
    'managed_by',
    'name',
    'settings',
    'type',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (createdOn != null) 'created_on': createdOn!,
    if (id != null) 'id': id!,
    if (managedBy != null) 'managed_by': managedBy!.toJson(),
    if (name != null) 'name': name!,
    if (settings != null) 'settings': settings!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  Account copyWith({
    String? createdOn,
    String? id,
    AccountManagedBy? managedBy,
    String? name,
    AccountSettings? settings,
    Object? type_,
    Map<String, Object?>? extra,
  }) => Account(
    createdOn: createdOn ?? this.createdOn,
    id: id ?? this.id,
    managedBy: managedBy ?? this.managedBy,
    name: name ?? this.name,
    settings: settings ?? this.settings,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// Parent container details
class AccountManagedBy {
  const AccountManagedBy({
    this.parentOrgId,
    this.parentOrgName,
    this.extra = const <String, Object?>{},
  });

  factory AccountManagedBy.fromJson(Map<String, Object?> json) =>
      AccountManagedBy(
        parentOrgId: asString(json['parent_org_id']),
        parentOrgName: asString(json['parent_org_name']),
        extra: extraOf(json, _knownKeys),
      );

  /// ID of the parent Organization, if one exists
  final String? parentOrgId;

  /// Name of the parent Organization, if one exists
  final String? parentOrgName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'parent_org_id', 'parent_org_name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (parentOrgId != null) 'parent_org_id': parentOrgId!,
    if (parentOrgName != null) 'parent_org_name': parentOrgName!,
  };

  AccountManagedBy copyWith({
    String? parentOrgId,
    String? parentOrgName,
    Map<String, Object?>? extra,
  }) => AccountManagedBy(
    parentOrgId: parentOrgId ?? this.parentOrgId,
    parentOrgName: parentOrgName ?? this.parentOrgName,
    extra: extra ?? this.extra,
  );
}

/// Account settings
class AccountSettings {
  const AccountSettings({
    this.abuseContactEmail,
    this.enforceTwofactor,
    this.extra = const <String, Object?>{},
  });

  factory AccountSettings.fromJson(Map<String, Object?> json) =>
      AccountSettings(
        abuseContactEmail: asString(json['abuse_contact_email']),
        enforceTwofactor: asBool(json['enforce_twofactor']),
        extra: extraOf(json, _knownKeys),
      );

  /// Sets an abuse contact email to notify for abuse reports.
  final String? abuseContactEmail;

  /// Indicates whether membership in this account requires that Two-Factor
  /// Authentication is enabled
  final bool? enforceTwofactor;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'abuse_contact_email',
    'enforce_twofactor',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (abuseContactEmail != null) 'abuse_contact_email': abuseContactEmail!,
    if (enforceTwofactor != null) 'enforce_twofactor': enforceTwofactor!,
  };

  AccountSettings copyWith({
    String? abuseContactEmail,
    bool? enforceTwofactor,
    Map<String, Object?>? extra,
  }) => AccountSettings(
    abuseContactEmail: abuseContactEmail ?? this.abuseContactEmail,
    enforceTwofactor: enforceTwofactor ?? this.enforceTwofactor,
    extra: extra ?? this.extra,
  );
}

class AppPolicyResponse {
  const AppPolicyResponse({
    this.createdAt,
    this.decision,
    this.exclude,
    this.id,
    this.include,
    this.name,
    this.require,
    this.updatedAt,
    this.approvalGroups,
    this.approvalRequired,
    this.connectionRules,
    this.isolationRequired,
    this.mfaConfig,
    this.purposeJustificationPrompt,
    this.purposeJustificationRequired,
    this.sessionDuration,
    this.precedence,
    this.extra = const <String, Object?>{},
  });

  factory AppPolicyResponse.fromJson(Map<String, Object?> json) =>
      AppPolicyResponse(
        createdAt: asString(json['created_at']),
        decision: asString(json['decision']),
        exclude: asModelList(json['exclude'], Rule2.fromJson),
        id: asString(json['id']),
        include: asModelList(json['include'], Rule2.fromJson),
        name: asString(json['name']),
        require: asModelList(json['require'], Rule2.fromJson),
        updatedAt: asString(json['updated_at']),
        approvalGroups: asModelList(
          json['approval_groups'],
          ApprovalGroup.fromJson,
        ),
        approvalRequired: asBool(json['approval_required']),
        connectionRules: asModel(
          json['connection_rules'],
          ConnectionRules.fromJson,
        ),
        isolationRequired: asBool(json['isolation_required']),
        mfaConfig: asModel(json['mfa_config'], MfaConfig.fromJson),
        purposeJustificationPrompt: asString(
          json['purpose_justification_prompt'],
        ),
        purposeJustificationRequired: asBool(
          json['purpose_justification_required'],
        ),
        sessionDuration: asString(json['session_duration']),
        precedence: asInt(json['precedence']),
        extra: extraOf(json, _knownKeys),
      );

  final String? createdAt;

  /// The action Access will take if a user matches this policy. Infrastructure
  /// application policies can only use the Allow action. Allowed values: `allow`,
  /// `deny`, `non_identity`, `bypass`.
  final String? decision;

  /// Rules evaluated with a NOT logical operator. To match the policy, a user
  /// cannot meet any of the Exclude rules.
  final List<Rule2>? exclude;

  /// The UUID of the policy
  final String? id;

  /// Rules evaluated with an OR logical operator. A user needs to meet only one
  /// of the Include rules.
  final List<Rule2>? include;

  /// The name of the Access policy.
  final String? name;

  /// Rules evaluated with an AND logical operator. To match the policy, a user
  /// must meet all of the Require rules.
  final List<Rule2>? require;
  final String? updatedAt;

  /// Administrators who can approve a temporary authentication request.
  final List<ApprovalGroup>? approvalGroups;

  /// Requires the user to request access from an administrator at the start of
  /// each session.
  final bool? approvalRequired;

  /// The rules that define how users may connect to targets secured by your
  /// application.
  final ConnectionRules? connectionRules;

  /// Require this application to be served in an isolated browser for users
  /// matching this policy. 'Client Web Isolation' must be on for the account in
  /// order to use this feature.
  final bool? isolationRequired;

  /// Configures multi-factor authentication (MFA) settings.
  final MfaConfig? mfaConfig;

  /// A custom message that will appear on the purpose justification screen.
  final String? purposeJustificationPrompt;

  /// Require users to enter a justification when they log in to the application.
  final bool? purposeJustificationRequired;

  /// The amount of time that tokens issued for the application will be valid.
  /// Must be in the format `300ms` or `2h45m`. Valid time units are: ns, us (or
  /// µs), ms, s, m, h.
  final String? sessionDuration;

  /// The order of execution for this policy. Must be unique for each policy
  /// within an app.
  final int? precedence;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'created_at',
    'decision',
    'exclude',
    'id',
    'include',
    'name',
    'require',
    'updated_at',
    'approval_groups',
    'approval_required',
    'connection_rules',
    'isolation_required',
    'mfa_config',
    'purpose_justification_prompt',
    'purpose_justification_required',
    'session_duration',
    'precedence',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (createdAt != null) 'created_at': createdAt!,
    if (decision != null) 'decision': decision!,
    if (exclude != null) 'exclude': exclude!.map((e) => e.toJson()).toList(),
    if (id != null) 'id': id!,
    if (include != null) 'include': include!.map((e) => e.toJson()).toList(),
    if (name != null) 'name': name!,
    if (require != null) 'require': require!.map((e) => e.toJson()).toList(),
    if (updatedAt != null) 'updated_at': updatedAt!,
    if (approvalGroups != null)
      'approval_groups': approvalGroups!.map((e) => e.toJson()).toList(),
    if (approvalRequired != null) 'approval_required': approvalRequired!,
    if (connectionRules != null) 'connection_rules': connectionRules!.toJson(),
    if (isolationRequired != null) 'isolation_required': isolationRequired!,
    if (mfaConfig != null) 'mfa_config': mfaConfig!.toJson(),
    if (purposeJustificationPrompt != null)
      'purpose_justification_prompt': purposeJustificationPrompt!,
    if (purposeJustificationRequired != null)
      'purpose_justification_required': purposeJustificationRequired!,
    if (sessionDuration != null) 'session_duration': sessionDuration!,
    if (precedence != null) 'precedence': precedence!,
  };

  AppPolicyResponse copyWith({
    String? createdAt,
    String? decision,
    List<Rule2>? exclude,
    String? id,
    List<Rule2>? include,
    String? name,
    List<Rule2>? require,
    String? updatedAt,
    List<ApprovalGroup>? approvalGroups,
    bool? approvalRequired,
    ConnectionRules? connectionRules,
    bool? isolationRequired,
    MfaConfig? mfaConfig,
    String? purposeJustificationPrompt,
    bool? purposeJustificationRequired,
    String? sessionDuration,
    int? precedence,
    Map<String, Object?>? extra,
  }) => AppPolicyResponse(
    createdAt: createdAt ?? this.createdAt,
    decision: decision ?? this.decision,
    exclude: exclude ?? this.exclude,
    id: id ?? this.id,
    include: include ?? this.include,
    name: name ?? this.name,
    require: require ?? this.require,
    updatedAt: updatedAt ?? this.updatedAt,
    approvalGroups: approvalGroups ?? this.approvalGroups,
    approvalRequired: approvalRequired ?? this.approvalRequired,
    connectionRules: connectionRules ?? this.connectionRules,
    isolationRequired: isolationRequired ?? this.isolationRequired,
    mfaConfig: mfaConfig ?? this.mfaConfig,
    purposeJustificationPrompt:
        purposeJustificationPrompt ?? this.purposeJustificationPrompt,
    purposeJustificationRequired:
        purposeJustificationRequired ?? this.purposeJustificationRequired,
    sessionDuration: sessionDuration ?? this.sessionDuration,
    precedence: precedence ?? this.precedence,
    extra: extra ?? this.extra,
  );
}

class AppResponse {
  const AppResponse({
    this.aud,
    this.createdAt,
    this.id,
    this.updatedAt,
    this.allowAuthenticateViaWarp,
    this.allowIframe,
    this.allowedIdps,
    this.appLauncherVisible,
    this.autoRedirectToIdentity,
    this.corsHeaders,
    this.customDenyMessage,
    this.customDenyUrl,
    this.customNonIdentityDenyUrl,
    this.customPages,
    this.destinations,
    this.domain,
    this.eagerRedirectCookieSetting,
    this.enableBindingCookie,
    this.httpOnlyCookieAttribute,
    this.logoUrl,
    this.mfaConfig,
    this.name,
    this.oauthConfiguration,
    this.optionsPreflightBypass,
    this.pathCookieAttribute,
    this.readServiceTokensFromHeader,
    this.sameSiteCookieAttribute,
    this.scimConfig,
    this.selfHostedDomains,
    this.serviceAuth401Redirect,
    this.sessionDuration,
    this.skipInterstitial,
    this.tags,
    this.type_,
    this.useClientlessIsolationAppLauncherUrl,
    this.policies,
    this.saasApp,
    this.appLauncherLogoUrl,
    this.bgColor,
    this.footerLinks,
    this.headerBgColor,
    this.landingPageDesign,
    this.skipAppLauncherLoginPage,
    this.targetCriteria,
    this.extra = const <String, Object?>{},
  });

  factory AppResponse.fromJson(Map<String, Object?> json) => AppResponse(
    aud: asString(json['aud']),
    createdAt: json['created_at'],
    id: asString(json['id']),
    updatedAt: json['updated_at'],
    allowAuthenticateViaWarp: asBool(json['allow_authenticate_via_warp']),
    allowIframe: asBool(json['allow_iframe']),
    allowedIdps: asPrimitiveList<String>(json['allowed_idps'], asString),
    appLauncherVisible: asBool(json['app_launcher_visible']),
    autoRedirectToIdentity: asBool(json['auto_redirect_to_identity']),
    corsHeaders: asModel(json['cors_headers'], CorsHeaders.fromJson),
    customDenyMessage: asString(json['custom_deny_message']),
    customDenyUrl: asString(json['custom_deny_url']),
    customNonIdentityDenyUrl: asString(json['custom_non_identity_deny_url']),
    customPages: asPrimitiveList<String>(json['custom_pages'], asString),
    destinations: asModelList(
      json['destinations'],
      AppResponseDestinationsItem.fromJson,
    ),
    domain: asString(json['domain']),
    eagerRedirectCookieSetting: asBool(json['eager_redirect_cookie_setting']),
    enableBindingCookie: asBool(json['enable_binding_cookie']),
    httpOnlyCookieAttribute: asBool(json['http_only_cookie_attribute']),
    logoUrl: asString(json['logo_url']),
    mfaConfig: asModel(json['mfa_config'], MfaConfig.fromJson),
    name: asString(json['name']),
    oauthConfiguration: asModel(
      json['oauth_configuration'],
      OauthConfiguration.fromJson,
    ),
    optionsPreflightBypass: asBool(json['options_preflight_bypass']),
    pathCookieAttribute: asBool(json['path_cookie_attribute']),
    readServiceTokensFromHeader: asString(
      json['read_service_tokens_from_header'],
    ),
    sameSiteCookieAttribute: asString(json['same_site_cookie_attribute']),
    scimConfig: asModel(json['scim_config'], ScimConfig.fromJson),
    selfHostedDomains: asPrimitiveList<String>(
      json['self_hosted_domains'],
      asString,
    ),
    serviceAuth401Redirect: asBool(json['service_auth_401_redirect']),
    sessionDuration: asString(json['session_duration']),
    skipInterstitial: asBool(json['skip_interstitial']),
    tags: asPrimitiveList<String>(json['tags'], asString),
    type_: json['type'],
    useClientlessIsolationAppLauncherUrl: asBool(
      json['use_clientless_isolation_app_launcher_url'],
    ),
    policies: asModelList(json['policies'], AppPolicyResponse.fromJson),
    saasApp: asModel(json['saas_app'], AppResponseSaasApp.fromJson),
    appLauncherLogoUrl: asString(json['app_launcher_logo_url']),
    bgColor: asString(json['bg_color']),
    footerLinks: asModelList(
      json['footer_links'],
      AppResponseFooterLinksItem.fromJson,
    ),
    headerBgColor: asString(json['header_bg_color']),
    landingPageDesign: asModel(
      json['landing_page_design'],
      LandingPageDesign.fromJson,
    ),
    skipAppLauncherLoginPage: asBool(json['skip_app_launcher_login_page']),
    targetCriteria: asModelList(
      json['target_criteria'],
      TargetCriteriaSelfHostedApp.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// Audience tag.
  final String? aud;
  final Object? createdAt;

  /// UUID.
  final String? id;
  final Object? updatedAt;

  /// When set to true, users can authenticate to this application using their
  /// WARP session. When set to false this application will always require direct
  /// IdP authentication. This setting always overrides the organization setting
  /// for WARP authentication.
  final bool? allowAuthenticateViaWarp;

  /// Enables loading application content in an iFrame.
  final bool? allowIframe;

  /// The identity providers your users can select when connecting to this
  /// application. Defaults to all IdPs configured in your account.
  final List<String>? allowedIdps;

  /// Displays the application in the App Launcher.
  final bool? appLauncherVisible;

  /// When set to `true`, users skip the identity provider selection step during
  /// login. You must specify only one identity provider in allowed_idps.
  final bool? autoRedirectToIdentity;
  final CorsHeaders? corsHeaders;

  /// The custom error message shown to a user when they are denied access to the
  /// application.
  final String? customDenyMessage;

  /// The custom URL a user is redirected to when they are denied access to the
  /// application when failing identity-based rules.
  final String? customDenyUrl;

  /// The custom URL a user is redirected to when they are denied access to the
  /// application when failing non-identity rules.
  final String? customNonIdentityDenyUrl;

  /// The custom pages that will be displayed when applicable for this application
  final List<String>? customPages;

  /// List of destinations secured by Access. This supersedes
  /// `self_hosted_domains` to allow for more flexibility in defining different
  /// types of domains. If `destinations` are provided, then `self_hosted_domains`
  /// will be ignored.
  final List<AppResponseDestinationsItem>? destinations;

  /// The primary hostname and path secured by Access. This domain will be
  /// displayed if the app is visible in the App Launcher.
  final String? domain;

  /// Preemptively sets the Access session cookie on every hostname in a
  /// multi-hostname self-hosted application during the initial redirect chain,
  /// rather than setting it lazily on first visit. Defaults to true. Set to false
  /// to disable the eager redirect cookie behavior.
  final bool? eagerRedirectCookieSetting;

  /// Enables the binding cookie, which increases security against compromised
  /// authorization tokens and CSRF attacks.
  final bool? enableBindingCookie;

  /// Enables the HttpOnly cookie attribute, which increases security against XSS
  /// attacks.
  final bool? httpOnlyCookieAttribute;

  /// The image URL for the logo shown in the App Launcher dashboard.
  final String? logoUrl;

  /// Configures multi-factor authentication (MFA) settings.
  final MfaConfig? mfaConfig;

  /// The name of the application.
  final String? name;

  /// **Beta:** Optional configuration for managing an OAuth authorization flow
  /// controlled by Access. When set, Access will act as the OAuth authorization
  /// server for this application. Only compatible with OAuth clients that support
  /// [RFC 8707](https://datatracker.ietf.org/doc/html/rfc8707) (Resource
  /// Indicators for OAuth 2.0). This feature is currently in beta.
  final OauthConfiguration? oauthConfiguration;

  /// Allows options preflight requests to bypass Access authentication and go
  /// directly to the origin. Cannot turn on if cors_headers is set.
  final bool? optionsPreflightBypass;

  /// Enables cookie paths to scope an application's JWT to the application path.
  /// If disabled, the JWT will scope to the hostname by default
  final bool? pathCookieAttribute;

  /// Allows matching Access Service Tokens passed HTTP in a single header with
  /// this name. This works as an alternative to the (CF-Access-Client-Id,
  /// CF-Access-Client-Secret) pair of headers. The header value will be
  /// interpreted as a json object similar to: { "cf-access-client-id":
  /// "88bf3b6d86161464f6509f7219099e57.access.example.com",
  /// "cf-access-client-secret":
  /// "bdd31cbc4dec990953e39163fbbb194c93313ca9f0a6e420346af9d326b1d2a5" }
  final String? readServiceTokensFromHeader;

  /// Sets the SameSite cookie setting, which provides increased security against
  /// CSRF attacks.
  final String? sameSiteCookieAttribute;

  /// Configuration for provisioning to this application via SCIM. This is
  /// currently in closed beta.
  final ScimConfig? scimConfig;

  /// List of public domains that Access will secure. This field is deprecated in
  /// favor of `destinations` and will be supported until **November 21, 2025.**
  /// If `destinations` are provided, then `self_hosted_domains` will be ignored.
  final List<String>? selfHostedDomains;

  /// Returns a 401 status code when the request is blocked by a Service Auth
  /// policy.
  final bool? serviceAuth401Redirect;

  /// The amount of time that tokens issued for this application will be valid.
  /// Must be in the format `300ms` or `2h45m`. Valid time units are: ns, us (or
  /// µs), ms, s, m, h. Note: unsupported for infrastructure type applications.
  final String? sessionDuration;

  /// Enables automatic authentication through cloudflared.
  final bool? skipInterstitial;

  /// The tags you want assigned to an application. Tags are used to filter
  /// applications in the App Launcher dashboard.
  final List<String>? tags;
  final Object? type_;

  /// Determines if users can access this application via a clientless browser
  /// isolation URL. This allows users to access private domains without
  /// connecting to Gateway. The option requires Clientless Browser Isolation to
  /// be set up with policies that allow users of this application.
  final bool? useClientlessIsolationAppLauncherUrl;
  final List<AppPolicyResponse>? policies;
  final AppResponseSaasApp? saasApp;

  /// The image URL of the logo shown in the App Launcher header.
  final String? appLauncherLogoUrl;

  /// The background color of the App Launcher page.
  final String? bgColor;

  /// The links in the App Launcher footer.
  final List<AppResponseFooterLinksItem>? footerLinks;

  /// The background color of the App Launcher header.
  final String? headerBgColor;

  /// The design of the App Launcher landing page shown to users when they log in.
  final LandingPageDesign? landingPageDesign;

  /// Determines when to skip the App Launcher landing page.
  final bool? skipAppLauncherLoginPage;
  final List<TargetCriteriaSelfHostedApp>? targetCriteria;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'aud',
    'created_at',
    'id',
    'updated_at',
    'allow_authenticate_via_warp',
    'allow_iframe',
    'allowed_idps',
    'app_launcher_visible',
    'auto_redirect_to_identity',
    'cors_headers',
    'custom_deny_message',
    'custom_deny_url',
    'custom_non_identity_deny_url',
    'custom_pages',
    'destinations',
    'domain',
    'eager_redirect_cookie_setting',
    'enable_binding_cookie',
    'http_only_cookie_attribute',
    'logo_url',
    'mfa_config',
    'name',
    'oauth_configuration',
    'options_preflight_bypass',
    'path_cookie_attribute',
    'read_service_tokens_from_header',
    'same_site_cookie_attribute',
    'scim_config',
    'self_hosted_domains',
    'service_auth_401_redirect',
    'session_duration',
    'skip_interstitial',
    'tags',
    'type',
    'use_clientless_isolation_app_launcher_url',
    'policies',
    'saas_app',
    'app_launcher_logo_url',
    'bg_color',
    'footer_links',
    'header_bg_color',
    'landing_page_design',
    'skip_app_launcher_login_page',
    'target_criteria',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aud != null) 'aud': aud!,
    if (createdAt != null) 'created_at': createdAt!,
    if (id != null) 'id': id!,
    if (updatedAt != null) 'updated_at': updatedAt!,
    if (allowAuthenticateViaWarp != null)
      'allow_authenticate_via_warp': allowAuthenticateViaWarp!,
    if (allowIframe != null) 'allow_iframe': allowIframe!,
    if (allowedIdps != null) 'allowed_idps': allowedIdps!,
    if (appLauncherVisible != null) 'app_launcher_visible': appLauncherVisible!,
    if (autoRedirectToIdentity != null)
      'auto_redirect_to_identity': autoRedirectToIdentity!,
    if (corsHeaders != null) 'cors_headers': corsHeaders!.toJson(),
    if (customDenyMessage != null) 'custom_deny_message': customDenyMessage!,
    if (customDenyUrl != null) 'custom_deny_url': customDenyUrl!,
    if (customNonIdentityDenyUrl != null)
      'custom_non_identity_deny_url': customNonIdentityDenyUrl!,
    if (customPages != null) 'custom_pages': customPages!,
    if (destinations != null)
      'destinations': destinations!.map((e) => e.toJson()).toList(),
    if (domain != null) 'domain': domain!,
    if (eagerRedirectCookieSetting != null)
      'eager_redirect_cookie_setting': eagerRedirectCookieSetting!,
    if (enableBindingCookie != null)
      'enable_binding_cookie': enableBindingCookie!,
    if (httpOnlyCookieAttribute != null)
      'http_only_cookie_attribute': httpOnlyCookieAttribute!,
    if (logoUrl != null) 'logo_url': logoUrl!,
    if (mfaConfig != null) 'mfa_config': mfaConfig!.toJson(),
    if (name != null) 'name': name!,
    if (oauthConfiguration != null)
      'oauth_configuration': oauthConfiguration!.toJson(),
    if (optionsPreflightBypass != null)
      'options_preflight_bypass': optionsPreflightBypass!,
    if (pathCookieAttribute != null)
      'path_cookie_attribute': pathCookieAttribute!,
    if (readServiceTokensFromHeader != null)
      'read_service_tokens_from_header': readServiceTokensFromHeader!,
    if (sameSiteCookieAttribute != null)
      'same_site_cookie_attribute': sameSiteCookieAttribute!,
    if (scimConfig != null) 'scim_config': scimConfig!.toJson(),
    if (selfHostedDomains != null) 'self_hosted_domains': selfHostedDomains!,
    if (serviceAuth401Redirect != null)
      'service_auth_401_redirect': serviceAuth401Redirect!,
    if (sessionDuration != null) 'session_duration': sessionDuration!,
    if (skipInterstitial != null) 'skip_interstitial': skipInterstitial!,
    if (tags != null) 'tags': tags!,
    if (type_ != null) 'type': type_!,
    if (useClientlessIsolationAppLauncherUrl != null)
      'use_clientless_isolation_app_launcher_url':
          useClientlessIsolationAppLauncherUrl!,
    if (policies != null) 'policies': policies!.map((e) => e.toJson()).toList(),
    if (saasApp != null) 'saas_app': saasApp!.toJson(),
    if (appLauncherLogoUrl != null)
      'app_launcher_logo_url': appLauncherLogoUrl!,
    if (bgColor != null) 'bg_color': bgColor!,
    if (footerLinks != null)
      'footer_links': footerLinks!.map((e) => e.toJson()).toList(),
    if (headerBgColor != null) 'header_bg_color': headerBgColor!,
    if (landingPageDesign != null)
      'landing_page_design': landingPageDesign!.toJson(),
    if (skipAppLauncherLoginPage != null)
      'skip_app_launcher_login_page': skipAppLauncherLoginPage!,
    if (targetCriteria != null)
      'target_criteria': targetCriteria!.map((e) => e.toJson()).toList(),
  };

  AppResponse copyWith({
    String? aud,
    Object? createdAt,
    String? id,
    Object? updatedAt,
    bool? allowAuthenticateViaWarp,
    bool? allowIframe,
    List<String>? allowedIdps,
    bool? appLauncherVisible,
    bool? autoRedirectToIdentity,
    CorsHeaders? corsHeaders,
    String? customDenyMessage,
    String? customDenyUrl,
    String? customNonIdentityDenyUrl,
    List<String>? customPages,
    List<AppResponseDestinationsItem>? destinations,
    String? domain,
    bool? eagerRedirectCookieSetting,
    bool? enableBindingCookie,
    bool? httpOnlyCookieAttribute,
    String? logoUrl,
    MfaConfig? mfaConfig,
    String? name,
    OauthConfiguration? oauthConfiguration,
    bool? optionsPreflightBypass,
    bool? pathCookieAttribute,
    String? readServiceTokensFromHeader,
    String? sameSiteCookieAttribute,
    ScimConfig? scimConfig,
    List<String>? selfHostedDomains,
    bool? serviceAuth401Redirect,
    String? sessionDuration,
    bool? skipInterstitial,
    List<String>? tags,
    Object? type_,
    bool? useClientlessIsolationAppLauncherUrl,
    List<AppPolicyResponse>? policies,
    AppResponseSaasApp? saasApp,
    String? appLauncherLogoUrl,
    String? bgColor,
    List<AppResponseFooterLinksItem>? footerLinks,
    String? headerBgColor,
    LandingPageDesign? landingPageDesign,
    bool? skipAppLauncherLoginPage,
    List<TargetCriteriaSelfHostedApp>? targetCriteria,
    Map<String, Object?>? extra,
  }) => AppResponse(
    aud: aud ?? this.aud,
    createdAt: createdAt ?? this.createdAt,
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    allowAuthenticateViaWarp:
        allowAuthenticateViaWarp ?? this.allowAuthenticateViaWarp,
    allowIframe: allowIframe ?? this.allowIframe,
    allowedIdps: allowedIdps ?? this.allowedIdps,
    appLauncherVisible: appLauncherVisible ?? this.appLauncherVisible,
    autoRedirectToIdentity:
        autoRedirectToIdentity ?? this.autoRedirectToIdentity,
    corsHeaders: corsHeaders ?? this.corsHeaders,
    customDenyMessage: customDenyMessage ?? this.customDenyMessage,
    customDenyUrl: customDenyUrl ?? this.customDenyUrl,
    customNonIdentityDenyUrl:
        customNonIdentityDenyUrl ?? this.customNonIdentityDenyUrl,
    customPages: customPages ?? this.customPages,
    destinations: destinations ?? this.destinations,
    domain: domain ?? this.domain,
    eagerRedirectCookieSetting:
        eagerRedirectCookieSetting ?? this.eagerRedirectCookieSetting,
    enableBindingCookie: enableBindingCookie ?? this.enableBindingCookie,
    httpOnlyCookieAttribute:
        httpOnlyCookieAttribute ?? this.httpOnlyCookieAttribute,
    logoUrl: logoUrl ?? this.logoUrl,
    mfaConfig: mfaConfig ?? this.mfaConfig,
    name: name ?? this.name,
    oauthConfiguration: oauthConfiguration ?? this.oauthConfiguration,
    optionsPreflightBypass:
        optionsPreflightBypass ?? this.optionsPreflightBypass,
    pathCookieAttribute: pathCookieAttribute ?? this.pathCookieAttribute,
    readServiceTokensFromHeader:
        readServiceTokensFromHeader ?? this.readServiceTokensFromHeader,
    sameSiteCookieAttribute:
        sameSiteCookieAttribute ?? this.sameSiteCookieAttribute,
    scimConfig: scimConfig ?? this.scimConfig,
    selfHostedDomains: selfHostedDomains ?? this.selfHostedDomains,
    serviceAuth401Redirect:
        serviceAuth401Redirect ?? this.serviceAuth401Redirect,
    sessionDuration: sessionDuration ?? this.sessionDuration,
    skipInterstitial: skipInterstitial ?? this.skipInterstitial,
    tags: tags ?? this.tags,
    type_: type_ ?? this.type_,
    useClientlessIsolationAppLauncherUrl:
        useClientlessIsolationAppLauncherUrl ??
        this.useClientlessIsolationAppLauncherUrl,
    policies: policies ?? this.policies,
    saasApp: saasApp ?? this.saasApp,
    appLauncherLogoUrl: appLauncherLogoUrl ?? this.appLauncherLogoUrl,
    bgColor: bgColor ?? this.bgColor,
    footerLinks: footerLinks ?? this.footerLinks,
    headerBgColor: headerBgColor ?? this.headerBgColor,
    landingPageDesign: landingPageDesign ?? this.landingPageDesign,
    skipAppLauncherLoginPage:
        skipAppLauncherLoginPage ?? this.skipAppLauncherLoginPage,
    targetCriteria: targetCriteria ?? this.targetCriteria,
    extra: extra ?? this.extra,
  );
}

class AppResponseDestinationsItem {
  const AppResponseDestinationsItem({
    this.type_,
    this.uri,
    this.cidr,
    this.hostname,
    this.l4Protocol,
    this.portRange,
    this.vnetId,
    this.mcpServerId,
    this.workerId,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseDestinationsItem.fromJson(Map<String, Object?> json) =>
      AppResponseDestinationsItem(
        type_: asString(json['type']),
        uri: asString(json['uri']),
        cidr: asString(json['cidr']),
        hostname: asString(json['hostname']),
        l4Protocol: asString(json['l4_protocol']),
        portRange: asString(json['port_range']),
        vnetId: asString(json['vnet_id']),
        mcpServerId: asString(json['mcp_server_id']),
        workerId: asString(json['worker_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// Allowed values: `all_preview_workers`.
  final String? type_;

  /// The URI of the destination. Public destinations' URIs can include a domain
  /// and path with
  /// [wildcards](https://developers.cloudflare.com/cloudflare-one/policies/access/app-paths/).
  final String? uri;

  /// The CIDR range of the destination. Single IPs will be computed as /32.
  final String? cidr;

  /// The hostname of the destination. Matches a valid SNI served by an HTTPS
  /// origin.
  final String? hostname;

  /// The L4 protocol of the destination. When omitted, both UDP and TCP traffic
  /// will match. Allowed values: `tcp`, `udp`.
  final String? l4Protocol;

  /// The port range of the destination. Can be a single port or a range of ports.
  /// When omitted, all ports will match.
  final String? portRange;

  /// The VNET ID to match the destination. When omitted, all VNETs will match.
  final String? vnetId;

  /// The MCP server id configured in ai-controls.
  final String? mcpServerId;

  /// The ID of the Cloudflare Worker whose preview deployments to protect with
  /// Access.
  final String? workerId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'type',
    'uri',
    'cidr',
    'hostname',
    'l4_protocol',
    'port_range',
    'vnet_id',
    'mcp_server_id',
    'worker_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (type_ != null) 'type': type_!,
    if (uri != null) 'uri': uri!,
    if (cidr != null) 'cidr': cidr!,
    if (hostname != null) 'hostname': hostname!,
    if (l4Protocol != null) 'l4_protocol': l4Protocol!,
    if (portRange != null) 'port_range': portRange!,
    if (vnetId != null) 'vnet_id': vnetId!,
    if (mcpServerId != null) 'mcp_server_id': mcpServerId!,
    if (workerId != null) 'worker_id': workerId!,
  };

  AppResponseDestinationsItem copyWith({
    String? type_,
    String? uri,
    String? cidr,
    String? hostname,
    String? l4Protocol,
    String? portRange,
    String? vnetId,
    String? mcpServerId,
    String? workerId,
    Map<String, Object?>? extra,
  }) => AppResponseDestinationsItem(
    type_: type_ ?? this.type_,
    uri: uri ?? this.uri,
    cidr: cidr ?? this.cidr,
    hostname: hostname ?? this.hostname,
    l4Protocol: l4Protocol ?? this.l4Protocol,
    portRange: portRange ?? this.portRange,
    vnetId: vnetId ?? this.vnetId,
    mcpServerId: mcpServerId ?? this.mcpServerId,
    workerId: workerId ?? this.workerId,
    extra: extra ?? this.extra,
  );
}

class AppResponseFooterLinksItem {
  const AppResponseFooterLinksItem({
    this.name,
    this.url,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseFooterLinksItem.fromJson(Map<String, Object?> json) =>
      AppResponseFooterLinksItem(
        name: asString(json['name']),
        url: asString(json['url']),
        extra: extraOf(json, _knownKeys),
      );

  /// The hypertext in the footer link.
  final String? name;

  /// the hyperlink in the footer link.
  final String? url;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'name', 'url'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (name != null) 'name': name!,
    if (url != null) 'url': url!,
  };

  AppResponseFooterLinksItem copyWith({
    String? name,
    String? url,
    Map<String, Object?>? extra,
  }) => AppResponseFooterLinksItem(
    name: name ?? this.name,
    url: url ?? this.url,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasApp {
  const AppResponseSaasApp({
    this.authType,
    this.consumerServiceUrl,
    this.createdAt,
    this.customAttributes,
    this.defaultRelayState,
    this.idpEntityId,
    this.nameIdFormat,
    this.nameIdTransformJsonata,
    this.publicKey,
    this.samlAttributeTransformJsonata,
    this.spEntityId,
    this.ssoEndpoint,
    this.updatedAt,
    this.accessTokenLifetime,
    this.allowPkceWithoutClientSecret,
    this.appLauncherUrl,
    this.clientId,
    this.clientSecret,
    this.customClaims,
    this.grantTypes,
    this.groupFilterRegex,
    this.hybridAndImplicitOptions,
    this.redirectUris,
    this.refreshTokenOptions,
    this.scopes,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasApp.fromJson(Map<String, Object?> json) =>
      AppResponseSaasApp(
        authType: asString(json['auth_type']),
        consumerServiceUrl: asString(json['consumer_service_url']),
        createdAt: json['created_at'],
        customAttributes: asModelList(
          json['custom_attributes'],
          AppResponseSaasAppCustomAttributesItem.fromJson,
        ),
        defaultRelayState: asString(json['default_relay_state']),
        idpEntityId: asString(json['idp_entity_id']),
        nameIdFormat: asString(json['name_id_format']),
        nameIdTransformJsonata: asString(json['name_id_transform_jsonata']),
        publicKey: asString(json['public_key']),
        samlAttributeTransformJsonata: asString(
          json['saml_attribute_transform_jsonata'],
        ),
        spEntityId: asString(json['sp_entity_id']),
        ssoEndpoint: asString(json['sso_endpoint']),
        updatedAt: json['updated_at'],
        accessTokenLifetime: asString(json['access_token_lifetime']),
        allowPkceWithoutClientSecret: asBool(
          json['allow_pkce_without_client_secret'],
        ),
        appLauncherUrl: asString(json['app_launcher_url']),
        clientId: asString(json['client_id']),
        clientSecret: asString(json['client_secret']),
        customClaims: asModelList(
          json['custom_claims'],
          AppResponseSaasAppCustomClaimsItem.fromJson,
        ),
        grantTypes: asPrimitiveList<String>(json['grant_types'], asString),
        groupFilterRegex: asString(json['group_filter_regex']),
        hybridAndImplicitOptions: asModel(
          json['hybrid_and_implicit_options'],
          AppResponseSaasAppHybridAndImplicitOptions.fromJson,
        ),
        redirectUris: asPrimitiveList<String>(json['redirect_uris'], asString),
        refreshTokenOptions: asModel(
          json['refresh_token_options'],
          AppResponseSaasAppRefreshTokenOptions.fromJson,
        ),
        scopes: asPrimitiveList<String>(json['scopes'], asString),
        extra: extraOf(json, _knownKeys),
      );

  /// Identifier of the authentication protocol used for the saas app. Required
  /// for OIDC. Allowed values: `saml`, `oidc`.
  final String? authType;

  /// The service provider's endpoint that is responsible for receiving and
  /// parsing a SAML assertion.
  final String? consumerServiceUrl;
  final Object? createdAt;
  final List<AppResponseSaasAppCustomAttributesItem>? customAttributes;

  /// The URL that the user will be redirected to after a successful login for IDP
  /// initiated logins.
  final String? defaultRelayState;

  /// The unique identifier for your SaaS application.
  final String? idpEntityId;

  /// The format of the name identifier sent to the SaaS application. Allowed
  /// values: `id`, `email`.
  final String? nameIdFormat;

  /// A [JSONata](https://jsonata.org/) expression that transforms an
  /// application's user identities into a NameID value for its SAML assertion.
  /// This expression should evaluate to a singular string. The output of this
  /// expression can override the `name_id_format` setting.
  final String? nameIdTransformJsonata;

  /// The Access public certificate that will be used to verify your identity.
  final String? publicKey;

  /// A [JSONata] (https://jsonata.org/) expression that transforms an
  /// application's user identities into attribute assertions in the SAML
  /// response. The expression can transform id, email, name, and groups values.
  /// It can also transform fields listed in the saml_attributes or oidc_fields of
  /// the identity provider used to authenticate. The output of this expression
  /// must be a JSON object.
  final String? samlAttributeTransformJsonata;

  /// A globally unique name for an identity or service provider.
  final String? spEntityId;

  /// The endpoint where your SaaS application will send login requests.
  final String? ssoEndpoint;
  final Object? updatedAt;

  /// The lifetime of the OIDC Access Token after creation. Valid units are m,h.
  /// Must be greater than or equal to 1m and less than or equal to 24h.
  final String? accessTokenLifetime;

  /// If client secret should be required on the token endpoint when
  /// authorization_code_with_pkce grant is used.
  final bool? allowPkceWithoutClientSecret;

  /// The URL where this applications tile redirects users
  final String? appLauncherUrl;

  /// The application client id
  final String? clientId;

  /// The application client secret, only returned on POST request.
  final String? clientSecret;
  final List<AppResponseSaasAppCustomClaimsItem>? customClaims;

  /// The OIDC flows supported by this application
  final List<String>? grantTypes;

  /// A regex to filter Cloudflare groups returned in ID token and userinfo
  /// endpoint
  final String? groupFilterRegex;
  final AppResponseSaasAppHybridAndImplicitOptions? hybridAndImplicitOptions;

  /// The permitted URL's for Cloudflare to return Authorization codes and
  /// Access/ID tokens
  final List<String>? redirectUris;
  final AppResponseSaasAppRefreshTokenOptions? refreshTokenOptions;

  /// Define the user information shared with access, "offline_access" scope will
  /// be automatically enabled if refresh tokens are enabled
  final List<String>? scopes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'auth_type',
    'consumer_service_url',
    'created_at',
    'custom_attributes',
    'default_relay_state',
    'idp_entity_id',
    'name_id_format',
    'name_id_transform_jsonata',
    'public_key',
    'saml_attribute_transform_jsonata',
    'sp_entity_id',
    'sso_endpoint',
    'updated_at',
    'access_token_lifetime',
    'allow_pkce_without_client_secret',
    'app_launcher_url',
    'client_id',
    'client_secret',
    'custom_claims',
    'grant_types',
    'group_filter_regex',
    'hybrid_and_implicit_options',
    'redirect_uris',
    'refresh_token_options',
    'scopes',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (authType != null) 'auth_type': authType!,
    if (consumerServiceUrl != null) 'consumer_service_url': consumerServiceUrl!,
    if (createdAt != null) 'created_at': createdAt!,
    if (customAttributes != null)
      'custom_attributes': customAttributes!.map((e) => e.toJson()).toList(),
    if (defaultRelayState != null) 'default_relay_state': defaultRelayState!,
    if (idpEntityId != null) 'idp_entity_id': idpEntityId!,
    if (nameIdFormat != null) 'name_id_format': nameIdFormat!,
    if (nameIdTransformJsonata != null)
      'name_id_transform_jsonata': nameIdTransformJsonata!,
    if (publicKey != null) 'public_key': publicKey!,
    if (samlAttributeTransformJsonata != null)
      'saml_attribute_transform_jsonata': samlAttributeTransformJsonata!,
    if (spEntityId != null) 'sp_entity_id': spEntityId!,
    if (ssoEndpoint != null) 'sso_endpoint': ssoEndpoint!,
    if (updatedAt != null) 'updated_at': updatedAt!,
    if (accessTokenLifetime != null)
      'access_token_lifetime': accessTokenLifetime!,
    if (allowPkceWithoutClientSecret != null)
      'allow_pkce_without_client_secret': allowPkceWithoutClientSecret!,
    if (appLauncherUrl != null) 'app_launcher_url': appLauncherUrl!,
    if (clientId != null) 'client_id': clientId!,
    if (clientSecret != null) 'client_secret': clientSecret!,
    if (customClaims != null)
      'custom_claims': customClaims!.map((e) => e.toJson()).toList(),
    if (grantTypes != null) 'grant_types': grantTypes!,
    if (groupFilterRegex != null) 'group_filter_regex': groupFilterRegex!,
    if (hybridAndImplicitOptions != null)
      'hybrid_and_implicit_options': hybridAndImplicitOptions!.toJson(),
    if (redirectUris != null) 'redirect_uris': redirectUris!,
    if (refreshTokenOptions != null)
      'refresh_token_options': refreshTokenOptions!.toJson(),
    if (scopes != null) 'scopes': scopes!,
  };

  AppResponseSaasApp copyWith({
    String? authType,
    String? consumerServiceUrl,
    Object? createdAt,
    List<AppResponseSaasAppCustomAttributesItem>? customAttributes,
    String? defaultRelayState,
    String? idpEntityId,
    String? nameIdFormat,
    String? nameIdTransformJsonata,
    String? publicKey,
    String? samlAttributeTransformJsonata,
    String? spEntityId,
    String? ssoEndpoint,
    Object? updatedAt,
    String? accessTokenLifetime,
    bool? allowPkceWithoutClientSecret,
    String? appLauncherUrl,
    String? clientId,
    String? clientSecret,
    List<AppResponseSaasAppCustomClaimsItem>? customClaims,
    List<String>? grantTypes,
    String? groupFilterRegex,
    AppResponseSaasAppHybridAndImplicitOptions? hybridAndImplicitOptions,
    List<String>? redirectUris,
    AppResponseSaasAppRefreshTokenOptions? refreshTokenOptions,
    List<String>? scopes,
    Map<String, Object?>? extra,
  }) => AppResponseSaasApp(
    authType: authType ?? this.authType,
    consumerServiceUrl: consumerServiceUrl ?? this.consumerServiceUrl,
    createdAt: createdAt ?? this.createdAt,
    customAttributes: customAttributes ?? this.customAttributes,
    defaultRelayState: defaultRelayState ?? this.defaultRelayState,
    idpEntityId: idpEntityId ?? this.idpEntityId,
    nameIdFormat: nameIdFormat ?? this.nameIdFormat,
    nameIdTransformJsonata:
        nameIdTransformJsonata ?? this.nameIdTransformJsonata,
    publicKey: publicKey ?? this.publicKey,
    samlAttributeTransformJsonata:
        samlAttributeTransformJsonata ?? this.samlAttributeTransformJsonata,
    spEntityId: spEntityId ?? this.spEntityId,
    ssoEndpoint: ssoEndpoint ?? this.ssoEndpoint,
    updatedAt: updatedAt ?? this.updatedAt,
    accessTokenLifetime: accessTokenLifetime ?? this.accessTokenLifetime,
    allowPkceWithoutClientSecret:
        allowPkceWithoutClientSecret ?? this.allowPkceWithoutClientSecret,
    appLauncherUrl: appLauncherUrl ?? this.appLauncherUrl,
    clientId: clientId ?? this.clientId,
    clientSecret: clientSecret ?? this.clientSecret,
    customClaims: customClaims ?? this.customClaims,
    grantTypes: grantTypes ?? this.grantTypes,
    groupFilterRegex: groupFilterRegex ?? this.groupFilterRegex,
    hybridAndImplicitOptions:
        hybridAndImplicitOptions ?? this.hybridAndImplicitOptions,
    redirectUris: redirectUris ?? this.redirectUris,
    refreshTokenOptions: refreshTokenOptions ?? this.refreshTokenOptions,
    scopes: scopes ?? this.scopes,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppCustomAttributesItem {
  const AppResponseSaasAppCustomAttributesItem({
    this.friendlyName,
    this.name,
    this.nameFormat,
    this.required_,
    this.source,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppCustomAttributesItem.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppCustomAttributesItem(
    friendlyName: asString(json['friendly_name']),
    name: asString(json['name']),
    nameFormat: asString(json['name_format']),
    required_: asBool(json['required']),
    source: asModel(
      json['source'],
      AppResponseSaasAppCustomAttributesItemSource.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// The SAML FriendlyName of the attribute.
  final String? friendlyName;

  /// The name of the attribute.
  final String? name;

  /// A globally unique name for an identity or service provider. Allowed values:
  /// `urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified`,
  /// `urn:oasis:names:tc:SAML:2.0:attrname-format:basic`,
  /// `urn:oasis:names:tc:SAML:2.0:attrname-format:uri`.
  final String? nameFormat;

  /// If the attribute is required when building a SAML assertion.
  final bool? required_;
  final AppResponseSaasAppCustomAttributesItemSource? source;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'friendly_name',
    'name',
    'name_format',
    'required',
    'source',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (friendlyName != null) 'friendly_name': friendlyName!,
    if (name != null) 'name': name!,
    if (nameFormat != null) 'name_format': nameFormat!,
    if (required_ != null) 'required': required_!,
    if (source != null) 'source': source!.toJson(),
  };

  AppResponseSaasAppCustomAttributesItem copyWith({
    String? friendlyName,
    String? name,
    String? nameFormat,
    bool? required_,
    AppResponseSaasAppCustomAttributesItemSource? source,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppCustomAttributesItem(
    friendlyName: friendlyName ?? this.friendlyName,
    name: name ?? this.name,
    nameFormat: nameFormat ?? this.nameFormat,
    required_: required_ ?? this.required_,
    source: source ?? this.source,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppCustomAttributesItemSource {
  const AppResponseSaasAppCustomAttributesItemSource({
    this.name,
    this.nameByIdp,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppCustomAttributesItemSource.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppCustomAttributesItemSource(
    name: asString(json['name']),
    nameByIdp: asModelList(
      json['name_by_idp'],
      AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// The name of the IdP attribute.
  final String? name;

  /// A mapping from IdP ID to attribute name.
  final List<AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem>?
  nameByIdp;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'name', 'name_by_idp'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (name != null) 'name': name!,
    if (nameByIdp != null)
      'name_by_idp': nameByIdp!.map((e) => e.toJson()).toList(),
  };

  AppResponseSaasAppCustomAttributesItemSource copyWith({
    String? name,
    List<AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem>? nameByIdp,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppCustomAttributesItemSource(
    name: name ?? this.name,
    nameByIdp: nameByIdp ?? this.nameByIdp,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem {
  const AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem({
    this.idpId,
    this.sourceName,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem(
    idpId: asString(json['idp_id']),
    sourceName: asString(json['source_name']),
    extra: extraOf(json, _knownKeys),
  );

  /// The UID of the IdP.
  final String? idpId;

  /// The name of the IdP provided attribute.
  final String? sourceName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'idp_id', 'source_name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (idpId != null) 'idp_id': idpId!,
    if (sourceName != null) 'source_name': sourceName!,
  };

  AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem copyWith({
    String? idpId,
    String? sourceName,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppCustomAttributesItemSourceNameByIdpItem(
    idpId: idpId ?? this.idpId,
    sourceName: sourceName ?? this.sourceName,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppCustomClaimsItem {
  const AppResponseSaasAppCustomClaimsItem({
    this.name,
    this.required_,
    this.scope,
    this.source,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppCustomClaimsItem.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppCustomClaimsItem(
    name: asString(json['name']),
    required_: asBool(json['required']),
    scope: asString(json['scope']),
    source: asModel(
      json['source'],
      AppResponseSaasAppCustomClaimsItemSource.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// The name of the claim.
  final String? name;

  /// If the claim is required when building an OIDC token.
  final bool? required_;

  /// The scope of the claim. Allowed values: `groups`, `profile`, `email`,
  /// `openid`.
  final String? scope;
  final AppResponseSaasAppCustomClaimsItemSource? source;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'name', 'required', 'scope', 'source'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (name != null) 'name': name!,
    if (required_ != null) 'required': required_!,
    if (scope != null) 'scope': scope!,
    if (source != null) 'source': source!.toJson(),
  };

  AppResponseSaasAppCustomClaimsItem copyWith({
    String? name,
    bool? required_,
    String? scope,
    AppResponseSaasAppCustomClaimsItemSource? source,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppCustomClaimsItem(
    name: name ?? this.name,
    required_: required_ ?? this.required_,
    scope: scope ?? this.scope,
    source: source ?? this.source,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppCustomClaimsItemSource {
  const AppResponseSaasAppCustomClaimsItemSource({
    this.name,
    this.nameByIdp,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppCustomClaimsItemSource.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppCustomClaimsItemSource(
    name: asString(json['name']),
    nameByIdp: asMap(json['name_by_idp']),
    extra: extraOf(json, _knownKeys),
  );

  /// The name of the IdP claim.
  final String? name;

  /// A mapping from IdP ID to claim name.
  final Map<String, Object?>? nameByIdp;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'name', 'name_by_idp'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (name != null) 'name': name!,
    if (nameByIdp != null) 'name_by_idp': nameByIdp!,
  };

  AppResponseSaasAppCustomClaimsItemSource copyWith({
    String? name,
    Map<String, Object?>? nameByIdp,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppCustomClaimsItemSource(
    name: name ?? this.name,
    nameByIdp: nameByIdp ?? this.nameByIdp,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppHybridAndImplicitOptions {
  const AppResponseSaasAppHybridAndImplicitOptions({
    this.returnAccessTokenFromAuthorizationEndpoint,
    this.returnIdTokenFromAuthorizationEndpoint,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppHybridAndImplicitOptions.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppHybridAndImplicitOptions(
    returnAccessTokenFromAuthorizationEndpoint: asBool(
      json['return_access_token_from_authorization_endpoint'],
    ),
    returnIdTokenFromAuthorizationEndpoint: asBool(
      json['return_id_token_from_authorization_endpoint'],
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// If an Access Token should be returned from the OIDC Authorization endpoint
  final bool? returnAccessTokenFromAuthorizationEndpoint;

  /// If an ID Token should be returned from the OIDC Authorization endpoint
  final bool? returnIdTokenFromAuthorizationEndpoint;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'return_access_token_from_authorization_endpoint',
    'return_id_token_from_authorization_endpoint',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (returnAccessTokenFromAuthorizationEndpoint != null)
      'return_access_token_from_authorization_endpoint':
          returnAccessTokenFromAuthorizationEndpoint!,
    if (returnIdTokenFromAuthorizationEndpoint != null)
      'return_id_token_from_authorization_endpoint':
          returnIdTokenFromAuthorizationEndpoint!,
  };

  AppResponseSaasAppHybridAndImplicitOptions copyWith({
    bool? returnAccessTokenFromAuthorizationEndpoint,
    bool? returnIdTokenFromAuthorizationEndpoint,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppHybridAndImplicitOptions(
    returnAccessTokenFromAuthorizationEndpoint:
        returnAccessTokenFromAuthorizationEndpoint ??
        this.returnAccessTokenFromAuthorizationEndpoint,
    returnIdTokenFromAuthorizationEndpoint:
        returnIdTokenFromAuthorizationEndpoint ??
        this.returnIdTokenFromAuthorizationEndpoint,
    extra: extra ?? this.extra,
  );
}

class AppResponseSaasAppRefreshTokenOptions {
  const AppResponseSaasAppRefreshTokenOptions({
    this.lifetime,
    this.extra = const <String, Object?>{},
  });

  factory AppResponseSaasAppRefreshTokenOptions.fromJson(
    Map<String, Object?> json,
  ) => AppResponseSaasAppRefreshTokenOptions(
    lifetime: asString(json['lifetime']),
    extra: extraOf(json, _knownKeys),
  );

  /// How long a refresh token will be valid for after creation. Valid units are
  /// m,h,d. Must be longer than 1m.
  final String? lifetime;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'lifetime'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (lifetime != null) 'lifetime': lifetime!,
  };

  AppResponseSaasAppRefreshTokenOptions copyWith({
    String? lifetime,
    Map<String, Object?>? extra,
  }) => AppResponseSaasAppRefreshTokenOptions(
    lifetime: lifetime ?? this.lifetime,
    extra: extra ?? this.extra,
  );
}

/// A group of email addresses that can approve a temporary authentication
/// request.
class ApprovalGroup {
  const ApprovalGroup({
    this.approvalsNeeded,
    this.emailAddresses,
    this.emailListUuid,
    this.extra = const <String, Object?>{},
  });

  factory ApprovalGroup.fromJson(Map<String, Object?> json) => ApprovalGroup(
    approvalsNeeded: asNum(json['approvals_needed']),
    emailAddresses: asPrimitiveList<String>(json['email_addresses'], asString),
    emailListUuid: asString(json['email_list_uuid']),
    extra: extraOf(json, _knownKeys),
  );

  /// The number of approvals needed to obtain access.
  final num? approvalsNeeded;

  /// A list of emails that can approve the access request.
  final List<String>? emailAddresses;

  /// The UUID of an re-usable email list.
  final String? emailListUuid;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'approvals_needed',
    'email_addresses',
    'email_list_uuid',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (approvalsNeeded != null) 'approvals_needed': approvalsNeeded!,
    if (emailAddresses != null) 'email_addresses': emailAddresses!,
    if (emailListUuid != null) 'email_list_uuid': emailListUuid!,
  };

  ApprovalGroup copyWith({
    num? approvalsNeeded,
    List<String>? emailAddresses,
    String? emailListUuid,
    Map<String, Object?>? extra,
  }) => ApprovalGroup(
    approvalsNeeded: approvalsNeeded ?? this.approvalsNeeded,
    emailAddresses: emailAddresses ?? this.emailAddresses,
    emailListUuid: emailListUuid ?? this.emailListUuid,
    extra: extra ?? this.extra,
  );
}

/// A single query object or a batch query object
class BatchQuery {
  const BatchQuery({
    this.params,
    this.sql,
    this.batch,
    this.extra = const <String, Object?>{},
  });

  factory BatchQuery.fromJson(Map<String, Object?> json) => BatchQuery(
    params: asPrimitiveList<String>(json['params'], asString),
    sql: asString(json['sql']),
    batch: asModelList(json['batch'], SingleQuery.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  final List<String>? params;

  /// Your SQL query. Supports multiple statements, joined by semicolons, which
  /// will be executed as a batch.
  final String? sql;
  final List<SingleQuery>? batch;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'params', 'sql', 'batch'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (params != null) 'params': params!,
    if (sql != null) 'sql': sql!,
    if (batch != null) 'batch': batch!.map((e) => e.toJson()).toList(),
  };

  BatchQuery copyWith({
    List<String>? params,
    String? sql,
    List<SingleQuery>? batch,
    Map<String, Object?>? extra,
  }) => BatchQuery(
    params: params ?? this.params,
    sql: sql ?? this.sql,
    batch: batch ?? this.batch,
    extra: extra ?? this.extra,
  );
}

/// A single R2 bucket.
class Bucket {
  const Bucket({
    this.creationDate,
    this.jurisdiction,
    this.location,
    this.name,
    this.storageClass,
    this.extra = const <String, Object?>{},
  });

  factory Bucket.fromJson(Map<String, Object?> json) => Bucket(
    creationDate: asString(json['creation_date']),
    jurisdiction: asString(json['jurisdiction']),
    location: asString(json['location']),
    name: asString(json['name']),
    storageClass: asString(json['storage_class']),
    extra: extraOf(json, _knownKeys),
  );

  /// Creation timestamp.
  final String? creationDate;

  /// Jurisdiction where objects in this bucket are guaranteed to be stored.
  /// Allowed values: `default`, `eu`, `fedramp`.
  final String? jurisdiction;

  /// Location of the bucket. Allowed values: `apac`, `eeur`, `enam`, `weur`,
  /// `wnam`, `oc`.
  final String? location;

  /// Name of the bucket.
  final String? name;

  /// Storage class for newly uploaded objects, unless specified otherwise.
  /// Allowed values: `Standard`, `InfrequentAccess`.
  final String? storageClass;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'creation_date',
    'jurisdiction',
    'location',
    'name',
    'storage_class',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (creationDate != null) 'creation_date': creationDate!,
    if (jurisdiction != null) 'jurisdiction': jurisdiction!,
    if (location != null) 'location': location!,
    if (name != null) 'name': name!,
    if (storageClass != null) 'storage_class': storageClass!,
  };

  Bucket copyWith({
    String? creationDate,
    String? jurisdiction,
    String? location,
    String? name,
    String? storageClass,
    Map<String, Object?>? extra,
  }) => Bucket(
    creationDate: creationDate ?? this.creationDate,
    jurisdiction: jurisdiction ?? this.jurisdiction,
    location: location ?? this.location,
    name: name ?? this.name,
    storageClass: storageClass ?? this.storageClass,
    extra: extra ?? this.extra,
  );
}

/// Configs for the project build process.
class BuildConfig {
  const BuildConfig({
    this.buildCaching,
    this.buildCommand,
    this.destinationDir,
    this.rootDir,
    this.webAnalyticsTag,
    this.webAnalyticsToken,
    this.extra = const <String, Object?>{},
  });

  factory BuildConfig.fromJson(Map<String, Object?> json) => BuildConfig(
    buildCaching: asBool(json['build_caching']),
    buildCommand: asString(json['build_command']),
    destinationDir: asString(json['destination_dir']),
    rootDir: asString(json['root_dir']),
    webAnalyticsTag: asString(json['web_analytics_tag']),
    webAnalyticsToken: asString(json['web_analytics_token']),
    extra: extraOf(json, _knownKeys),
  );

  /// Enable build caching for the project.
  final bool? buildCaching;

  /// Command used to build project.
  final String? buildCommand;

  /// Assets output directory of the build.
  final String? destinationDir;

  /// Directory to run the command.
  final String? rootDir;

  /// The classifying tag for analytics.
  final String? webAnalyticsTag;

  /// The auth token for analytics.
  final String? webAnalyticsToken;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'build_caching',
    'build_command',
    'destination_dir',
    'root_dir',
    'web_analytics_tag',
    'web_analytics_token',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (buildCaching != null) 'build_caching': buildCaching!,
    if (buildCommand != null) 'build_command': buildCommand!,
    if (destinationDir != null) 'destination_dir': destinationDir!,
    if (rootDir != null) 'root_dir': rootDir!,
    if (webAnalyticsTag != null) 'web_analytics_tag': webAnalyticsTag!,
    if (webAnalyticsToken != null) 'web_analytics_token': webAnalyticsToken!,
  };

  BuildConfig copyWith({
    bool? buildCaching,
    String? buildCommand,
    String? destinationDir,
    String? rootDir,
    String? webAnalyticsTag,
    String? webAnalyticsToken,
    Map<String, Object?>? extra,
  }) => BuildConfig(
    buildCaching: buildCaching ?? this.buildCaching,
    buildCommand: buildCommand ?? this.buildCommand,
    destinationDir: destinationDir ?? this.destinationDir,
    rootDir: rootDir ?? this.rootDir,
    webAnalyticsTag: webAnalyticsTag ?? this.webAnalyticsTag,
    webAnalyticsToken: webAnalyticsToken ?? this.webAnalyticsToken,
    extra: extra ?? this.extra,
  );
}

/// Global CacheW configuration for the Worker. When caching is on, the platform
/// provisions a `cloudflare.app` zone for the Worker. A `type: worker` entry in
/// the `exports` map can override this value for a single entrypoint.
class CacheOptions {
  const CacheOptions({
    this.crossVersionCache,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory CacheOptions.fromJson(Map<String, Object?> json) => CacheOptions(
    crossVersionCache: asBool(json['cross_version_cache']),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether cached responses are shared across Worker version uploads. This is
  /// independent of `enabled`. It can stay true while caching is off, so the
  /// preference survives turning caching off and back on.
  final bool? crossVersionCache;

  /// Whether caching is enabled for this Worker.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'cross_version_cache', 'enabled'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (crossVersionCache != null) 'cross_version_cache': crossVersionCache!,
    if (enabled != null) 'enabled': enabled!,
  };

  CacheOptions copyWith({
    bool? crossVersionCache,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => CacheOptions(
    crossVersionCache: crossVersionCache ?? this.crossVersionCache,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

/// A Cloudflare Tunnel that connects your origin to Cloudflare's edge.
class CfdTunnel {
  const CfdTunnel({
    this.accountTag,
    this.configSrc,
    this.connections,
    this.connsActiveAt,
    this.connsInactiveAt,
    this.createdAt,
    this.deletedAt,
    this.id,
    this.metadata,
    this.name,
    this.remoteConfig,
    this.status,
    this.tunType,
    this.extra = const <String, Object?>{},
  });

  factory CfdTunnel.fromJson(Map<String, Object?> json) => CfdTunnel(
    accountTag: asString(json['account_tag']),
    configSrc: asString(json['config_src']),
    connections: asModelList(json['connections'], SchemasConnection.fromJson),
    connsActiveAt: asString(json['conns_active_at']),
    connsInactiveAt: asString(json['conns_inactive_at']),
    createdAt: asString(json['created_at']),
    deletedAt: asString(json['deleted_at']),
    id: asString(json['id']),
    metadata: asMap(json['metadata']),
    name: asString(json['name']),
    remoteConfig: asBool(json['remote_config']),
    status: asString(json['status']),
    tunType: asString(json['tun_type']),
    extra: extraOf(json, _knownKeys),
  );

  /// Cloudflare account ID
  final String? accountTag;

  /// Indicates if this is a locally or remotely configured tunnel. If `local`,
  /// manage the tunnel using a YAML file on the origin machine. If `cloudflare`,
  /// manage the tunnel on the Zero Trust dashboard. Allowed values: `local`,
  /// `cloudflare`.
  final String? configSrc;

  /// The Cloudflare Tunnel connections between your origin and Cloudflare's edge.
  final List<SchemasConnection>? connections;

  /// Timestamp of when the tunnel established at least one connection to
  /// Cloudflare's edge. If `null`, the tunnel is inactive.
  final String? connsActiveAt;

  /// Timestamp of when the tunnel became inactive (no connections to Cloudflare's
  /// edge). If `null`, the tunnel is active.
  final String? connsInactiveAt;

  /// Timestamp of when the resource was created.
  final String? createdAt;

  /// Timestamp of when the resource was deleted. If `null`, the resource has not
  /// been deleted.
  final String? deletedAt;

  /// UUID of the tunnel.
  final String? id;

  /// Metadata associated with the tunnel.
  final Map<String, Object?>? metadata;

  /// A user-friendly name for a tunnel.
  final String? name;

  /// If `true`, the tunnel can be configured remotely from the Zero Trust
  /// dashboard. If `false`, the tunnel must be configured locally on the origin
  /// machine.
  final bool? remoteConfig;

  /// The status of the tunnel. Valid values are `inactive` (tunnel has never been
  /// run), `degraded` (tunnel is active and able to serve traffic but in an
  /// unhealthy state), `healthy` (tunnel is active and able to serve traffic), or
  /// `down` (tunnel can not serve traffic as it has no connections to the
  /// Cloudflare Edge). Allowed values: `inactive`, `degraded`, `healthy`, `down`.
  final String? status;

  /// The type of tunnel. Allowed values: `cfd_tunnel`, `warp_connector`, `warp`,
  /// `magic`, `ip_sec`, `gre`, `cni`.
  final String? tunType;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'account_tag',
    'config_src',
    'connections',
    'conns_active_at',
    'conns_inactive_at',
    'created_at',
    'deleted_at',
    'id',
    'metadata',
    'name',
    'remote_config',
    'status',
    'tun_type',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (accountTag != null) 'account_tag': accountTag!,
    if (configSrc != null) 'config_src': configSrc!,
    if (connections != null)
      'connections': connections!.map((e) => e.toJson()).toList(),
    if (connsActiveAt != null) 'conns_active_at': connsActiveAt!,
    if (connsInactiveAt != null) 'conns_inactive_at': connsInactiveAt!,
    if (createdAt != null) 'created_at': createdAt!,
    if (deletedAt != null) 'deleted_at': deletedAt!,
    if (id != null) 'id': id!,
    if (metadata != null) 'metadata': metadata!,
    if (name != null) 'name': name!,
    if (remoteConfig != null) 'remote_config': remoteConfig!,
    if (status != null) 'status': status!,
    if (tunType != null) 'tun_type': tunType!,
  };

  CfdTunnel copyWith({
    String? accountTag,
    String? configSrc,
    List<SchemasConnection>? connections,
    String? connsActiveAt,
    String? connsInactiveAt,
    String? createdAt,
    String? deletedAt,
    String? id,
    Map<String, Object?>? metadata,
    String? name,
    bool? remoteConfig,
    String? status,
    String? tunType,
    Map<String, Object?>? extra,
  }) => CfdTunnel(
    accountTag: accountTag ?? this.accountTag,
    configSrc: configSrc ?? this.configSrc,
    connections: connections ?? this.connections,
    connsActiveAt: connsActiveAt ?? this.connsActiveAt,
    connsInactiveAt: connsInactiveAt ?? this.connsInactiveAt,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt ?? this.deletedAt,
    id: id ?? this.id,
    metadata: metadata ?? this.metadata,
    name: name ?? this.name,
    remoteConfig: remoteConfig ?? this.remoteConfig,
    status: status ?? this.status,
    tunType: tunType ?? this.tunType,
    extra: extra ?? this.extra,
  );
}

/// The rule configuration.
class Configuration {
  const Configuration({
    this.target,
    this.value,
    this.extra = const <String, Object?>{},
  });

  factory Configuration.fromJson(Map<String, Object?> json) => Configuration(
    target: asString(json['target']),
    value: asString(json['value']),
    extra: extraOf(json, _knownKeys),
  );

  /// The configuration target. You must set the target to `country` when
  /// specifying a country code in the rule. Allowed values: `country`.
  final String? target;

  /// The two-letter ISO-3166-1 alpha-2 code to match. For more information, refer
  /// to [IP Access rules:
  /// Parameters](https://developers.cloudflare.com/waf/tools/ip-access-rules/parameters/#country).
  final String? value;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'value'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (value != null) 'value': value!,
  };

  Configuration copyWith({
    String? target,
    String? value,
    Map<String, Object?>? extra,
  }) => Configuration(
    target: target ?? this.target,
    value: value ?? this.value,
    extra: extra ?? this.extra,
  );
}

/// The rules that define how users may connect to targets secured by your
/// application.
class ConnectionRules {
  const ConnectionRules({this.rdp, this.extra = const <String, Object?>{}});

  factory ConnectionRules.fromJson(Map<String, Object?> json) =>
      ConnectionRules(
        rdp: asModel(json['rdp'], ConnectionRulesRdp.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// The RDP-specific rules that define clipboard behavior for RDP connections.
  final ConnectionRulesRdp? rdp;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'rdp'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (rdp != null) 'rdp': rdp!.toJson(),
  };

  ConnectionRules copyWith({
    ConnectionRulesRdp? rdp,
    Map<String, Object?>? extra,
  }) => ConnectionRules(rdp: rdp ?? this.rdp, extra: extra ?? this.extra);
}

/// The RDP-specific rules that define clipboard behavior for RDP connections.
class ConnectionRulesRdp {
  const ConnectionRulesRdp({
    this.allowedClipboardLocalToRemoteFormats,
    this.allowedClipboardRemoteToLocalFormats,
    this.extra = const <String, Object?>{},
  });

  factory ConnectionRulesRdp.fromJson(Map<String, Object?> json) =>
      ConnectionRulesRdp(
        allowedClipboardLocalToRemoteFormats: asPrimitiveList<String>(
          json['allowed_clipboard_local_to_remote_formats'],
          asString,
        ),
        allowedClipboardRemoteToLocalFormats: asPrimitiveList<String>(
          json['allowed_clipboard_remote_to_local_formats'],
          asString,
        ),
        extra: extraOf(json, _knownKeys),
      );

  /// Clipboard formats allowed when copying from local machine to remote RDP
  /// session.
  final List<String>? allowedClipboardLocalToRemoteFormats;

  /// Clipboard formats allowed when copying from remote RDP session to local
  /// machine.
  final List<String>? allowedClipboardRemoteToLocalFormats;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'allowed_clipboard_local_to_remote_formats',
    'allowed_clipboard_remote_to_local_formats',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (allowedClipboardLocalToRemoteFormats != null)
      'allowed_clipboard_local_to_remote_formats':
          allowedClipboardLocalToRemoteFormats!,
    if (allowedClipboardRemoteToLocalFormats != null)
      'allowed_clipboard_remote_to_local_formats':
          allowedClipboardRemoteToLocalFormats!,
  };

  ConnectionRulesRdp copyWith({
    List<String>? allowedClipboardLocalToRemoteFormats,
    List<String>? allowedClipboardRemoteToLocalFormats,
    Map<String, Object?>? extra,
  }) => ConnectionRulesRdp(
    allowedClipboardLocalToRemoteFormats:
        allowedClipboardLocalToRemoteFormats ??
        this.allowedClipboardLocalToRemoteFormats,
    allowedClipboardRemoteToLocalFormats:
        allowedClipboardRemoteToLocalFormats ??
        this.allowedClipboardRemoteToLocalFormats,
    extra: extra ?? this.extra,
  );
}

class CorsHeaders {
  const CorsHeaders({
    this.allowAllHeaders,
    this.allowAllMethods,
    this.allowAllOrigins,
    this.allowCredentials,
    this.allowedHeaders,
    this.allowedMethods,
    this.allowedOrigins,
    this.maxAge,
    this.extra = const <String, Object?>{},
  });

  factory CorsHeaders.fromJson(Map<String, Object?> json) => CorsHeaders(
    allowAllHeaders: asBool(json['allow_all_headers']),
    allowAllMethods: asBool(json['allow_all_methods']),
    allowAllOrigins: asBool(json['allow_all_origins']),
    allowCredentials: asBool(json['allow_credentials']),
    allowedHeaders: asPrimitiveList<String>(json['allowed_headers'], asString),
    allowedMethods: asPrimitiveList<String>(json['allowed_methods'], asString),
    allowedOrigins: asPrimitiveList<String>(json['allowed_origins'], asString),
    maxAge: asNum(json['max_age']),
    extra: extraOf(json, _knownKeys),
  );

  /// Allows all HTTP request headers.
  final bool? allowAllHeaders;

  /// Allows all HTTP request methods.
  final bool? allowAllMethods;

  /// Allows all origins.
  final bool? allowAllOrigins;

  /// When set to `true`, includes credentials (cookies, authorization headers, or
  /// TLS client certificates) with requests.
  final bool? allowCredentials;

  /// Allowed HTTP request headers.
  final List<String>? allowedHeaders;

  /// Allowed HTTP request methods.
  final List<String>? allowedMethods;

  /// Allowed origins.
  final List<String>? allowedOrigins;

  /// The maximum number of seconds the results of a preflight request can be
  /// cached.
  final num? maxAge;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'allow_all_headers',
    'allow_all_methods',
    'allow_all_origins',
    'allow_credentials',
    'allowed_headers',
    'allowed_methods',
    'allowed_origins',
    'max_age',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (allowAllHeaders != null) 'allow_all_headers': allowAllHeaders!,
    if (allowAllMethods != null) 'allow_all_methods': allowAllMethods!,
    if (allowAllOrigins != null) 'allow_all_origins': allowAllOrigins!,
    if (allowCredentials != null) 'allow_credentials': allowCredentials!,
    if (allowedHeaders != null) 'allowed_headers': allowedHeaders!,
    if (allowedMethods != null) 'allowed_methods': allowedMethods!,
    if (allowedOrigins != null) 'allowed_origins': allowedOrigins!,
    if (maxAge != null) 'max_age': maxAge!,
  };

  CorsHeaders copyWith({
    bool? allowAllHeaders,
    bool? allowAllMethods,
    bool? allowAllOrigins,
    bool? allowCredentials,
    List<String>? allowedHeaders,
    List<String>? allowedMethods,
    List<String>? allowedOrigins,
    num? maxAge,
    Map<String, Object?>? extra,
  }) => CorsHeaders(
    allowAllHeaders: allowAllHeaders ?? this.allowAllHeaders,
    allowAllMethods: allowAllMethods ?? this.allowAllMethods,
    allowAllOrigins: allowAllOrigins ?? this.allowAllOrigins,
    allowCredentials: allowCredentials ?? this.allowCredentials,
    allowedHeaders: allowedHeaders ?? this.allowedHeaders,
    allowedMethods: allowedMethods ?? this.allowedMethods,
    allowedOrigins: allowedOrigins ?? this.allowedOrigins,
    maxAge: maxAge ?? this.maxAge,
    extra: extra ?? this.extra,
  );
}

class CreateZoneRulesetRuleBody {
  const CreateZoneRulesetRuleBody({
    this.action,
    this.actionParameters,
    this.categories,
    this.description,
    this.enabled,
    this.exposedCredentialCheck,
    this.expression,
    this.id,
    this.lastUpdated,
    this.logging,
    this.ratelimit,
    this.ref,
    this.version,
    this.position,
    this.extra = const <String, Object?>{},
  });

  factory CreateZoneRulesetRuleBody.fromJson(Map<String, Object?> json) =>
      CreateZoneRulesetRuleBody(
        action: json['action'],
        actionParameters: asModel(
          json['action_parameters'],
          CreateZoneRulesetRuleBodyActionParameters.fromJson,
        ),
        categories: asPrimitiveList<String>(json['categories'], asString),
        description: json['description'],
        enabled: json['enabled'],
        exposedCredentialCheck: asModel(
          json['exposed_credential_check'],
          RuleExposedCredentialCheck.fromJson,
        ),
        expression: asString(json['expression']),
        id: asString(json['id']),
        lastUpdated: asString(json['last_updated']),
        logging: asModel(json['logging'], RuleLogging.fromJson),
        ratelimit: asModel(json['ratelimit'], RuleRatelimit.fromJson),
        ref: asString(json['ref']),
        version: asString(json['version']),
        position: asModel(
          json['position'],
          CreateZoneRulesetRuleBodyPosition.fromJson,
        ),
        extra: extraOf(json, _knownKeys),
      );

  /// Allowed values: `transform_response_html`.
  final Object? action;
  final CreateZoneRulesetRuleBodyActionParameters? actionParameters;

  /// The categories of the rule.
  final List<String>? categories;
  final Object? description;
  final Object? enabled;

  /// Configuration for exposed credential checking.
  final RuleExposedCredentialCheck? exposedCredentialCheck;

  /// The expression defining which traffic will match the rule.
  final String? expression;

  /// The unique ID of the rule.
  final String? id;

  /// The timestamp of when the rule was last modified.
  final String? lastUpdated;

  /// An object configuring the rule's logging behavior.
  final RuleLogging? logging;

  /// An object configuring the rule's rate limit behavior.
  final RuleRatelimit? ratelimit;

  /// The reference of the rule (the rule's ID by default).
  final String? ref;

  /// The version of the rule.
  final String? version;
  final CreateZoneRulesetRuleBodyPosition? position;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'action',
    'action_parameters',
    'categories',
    'description',
    'enabled',
    'exposed_credential_check',
    'expression',
    'id',
    'last_updated',
    'logging',
    'ratelimit',
    'ref',
    'version',
    'position',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (action != null) 'action': action!,
    if (actionParameters != null)
      'action_parameters': actionParameters!.toJson(),
    if (categories != null) 'categories': categories!,
    if (description != null) 'description': description!,
    if (enabled != null) 'enabled': enabled!,
    if (exposedCredentialCheck != null)
      'exposed_credential_check': exposedCredentialCheck!.toJson(),
    if (expression != null) 'expression': expression!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (logging != null) 'logging': logging!.toJson(),
    if (ratelimit != null) 'ratelimit': ratelimit!.toJson(),
    if (ref != null) 'ref': ref!,
    if (version != null) 'version': version!,
    if (position != null) 'position': position!.toJson(),
  };

  CreateZoneRulesetRuleBody copyWith({
    Object? action,
    CreateZoneRulesetRuleBodyActionParameters? actionParameters,
    List<String>? categories,
    Object? description,
    Object? enabled,
    RuleExposedCredentialCheck? exposedCredentialCheck,
    String? expression,
    String? id,
    String? lastUpdated,
    RuleLogging? logging,
    RuleRatelimit? ratelimit,
    String? ref,
    String? version,
    CreateZoneRulesetRuleBodyPosition? position,
    Map<String, Object?>? extra,
  }) => CreateZoneRulesetRuleBody(
    action: action ?? this.action,
    actionParameters: actionParameters ?? this.actionParameters,
    categories: categories ?? this.categories,
    description: description ?? this.description,
    enabled: enabled ?? this.enabled,
    exposedCredentialCheck:
        exposedCredentialCheck ?? this.exposedCredentialCheck,
    expression: expression ?? this.expression,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    logging: logging ?? this.logging,
    ratelimit: ratelimit ?? this.ratelimit,
    ref: ref ?? this.ref,
    version: version ?? this.version,
    position: position ?? this.position,
    extra: extra ?? this.extra,
  );
}

class CreateZoneRulesetRuleBodyActionParameters {
  const CreateZoneRulesetRuleBodyActionParameters({
    this.linkMaze,
    this.extra = const <String, Object?>{},
  });

  factory CreateZoneRulesetRuleBodyActionParameters.fromJson(
    Map<String, Object?> json,
  ) => CreateZoneRulesetRuleBodyActionParameters(
    linkMaze: asMap(json['link_maze']),
    extra: extraOf(json, _knownKeys),
  );

  /// Enables the link maze transformation on the response.
  final Map<String, Object?>? linkMaze;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'link_maze'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (linkMaze != null) 'link_maze': linkMaze!,
  };

  CreateZoneRulesetRuleBodyActionParameters copyWith({
    Map<String, Object?>? linkMaze,
    Map<String, Object?>? extra,
  }) => CreateZoneRulesetRuleBodyActionParameters(
    linkMaze: linkMaze ?? this.linkMaze,
    extra: extra ?? this.extra,
  );
}

class CreateZoneRulesetRuleBodyPosition {
  const CreateZoneRulesetRuleBodyPosition({
    this.before,
    this.after,
    this.index,
    this.extra = const <String, Object?>{},
  });

  factory CreateZoneRulesetRuleBodyPosition.fromJson(
    Map<String, Object?> json,
  ) => CreateZoneRulesetRuleBodyPosition(
    before: asString(json['before']),
    after: asString(json['after']),
    index: asInt(json['index']),
    extra: extraOf(json, _knownKeys),
  );

  /// The ID of another rule to place the rule before. An empty value causes the
  /// rule to be placed at the top.
  final String? before;

  /// The ID of another rule to place the rule after. An empty value causes the
  /// rule to be placed at the bottom.
  final String? after;

  /// An index at which to place the rule, where index 1 is the first rule.
  final int? index;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'before', 'after', 'index'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (before != null) 'before': before!,
    if (after != null) 'after': after!,
    if (index != null) 'index': index!,
  };

  CreateZoneRulesetRuleBodyPosition copyWith({
    String? before,
    String? after,
    int? index,
    Map<String, Object?>? extra,
  }) => CreateZoneRulesetRuleBodyPosition(
    before: before ?? this.before,
    after: after ?? this.after,
    index: index ?? this.index,
    extra: extra ?? this.extra,
  );
}

class CreateZoneRulesetRuleResult {
  const CreateZoneRulesetRuleResult({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.rules,
    this.extra = const <String, Object?>{},
  });

  factory CreateZoneRulesetRuleResult.fromJson(Map<String, Object?> json) =>
      CreateZoneRulesetRuleResult(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        rules: asModelList(json['rules'], ResponseRule.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// The list of rules in the ruleset.
  final List<ResponseRule>? rules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
    'rules',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
    if (rules != null) 'rules': rules!.map((e) => e.toJson()).toList(),
  };

  CreateZoneRulesetRuleResult copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    List<ResponseRule>? rules,
    Map<String, Object?>? extra,
  }) => CreateZoneRulesetRuleResult(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    rules: rules ?? this.rules,
    extra: extra ?? this.extra,
  );
}

class DatabaseResponse {
  const DatabaseResponse({
    this.createdAt,
    this.jurisdiction,
    this.name,
    this.uuid,
    this.version,
    this.extra = const <String, Object?>{},
  });

  factory DatabaseResponse.fromJson(Map<String, Object?> json) =>
      DatabaseResponse(
        createdAt: asString(json['created_at']),
        jurisdiction: asString(json['jurisdiction']),
        name: asString(json['name']),
        uuid: asString(json['uuid']),
        version: asString(json['version']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specifies the timestamp the resource was created as an ISO8601 string.
  final String? createdAt;

  /// Specify the location to restrict the D1 database to run and store data. If
  /// this option is present, the location hint is ignored. Allowed values: `eu`,
  /// `fedramp`.
  final String? jurisdiction;

  /// D1 database name.
  final String? name;

  /// D1 database identifier (UUID).
  final String? uuid;
  final String? version;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'created_at',
    'jurisdiction',
    'name',
    'uuid',
    'version',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (createdAt != null) 'created_at': createdAt!,
    if (jurisdiction != null) 'jurisdiction': jurisdiction!,
    if (name != null) 'name': name!,
    if (uuid != null) 'uuid': uuid!,
    if (version != null) 'version': version!,
  };

  DatabaseResponse copyWith({
    String? createdAt,
    String? jurisdiction,
    String? name,
    String? uuid,
    String? version,
    Map<String, Object?>? extra,
  }) => DatabaseResponse(
    createdAt: createdAt ?? this.createdAt,
    jurisdiction: jurisdiction ?? this.jurisdiction,
    name: name ?? this.name,
    uuid: uuid ?? this.uuid,
    version: version ?? this.version,
    extra: extra ?? this.extra,
  );
}

class DeleteZoneRulesetRuleResult {
  const DeleteZoneRulesetRuleResult({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.rules,
    this.extra = const <String, Object?>{},
  });

  factory DeleteZoneRulesetRuleResult.fromJson(Map<String, Object?> json) =>
      DeleteZoneRulesetRuleResult(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        rules: asModelList(json['rules'], ResponseRule.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// The list of rules in the ruleset.
  final List<ResponseRule>? rules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
    'rules',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
    if (rules != null) 'rules': rules!.map((e) => e.toJson()).toList(),
  };

  DeleteZoneRulesetRuleResult copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    List<ResponseRule>? rules,
    Map<String, Object?>? extra,
  }) => DeleteZoneRulesetRuleResult(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    rules: rules ?? this.rules,
    extra: extra ?? this.extra,
  );
}

class Deployment {
  const Deployment({
    this.aliases,
    this.buildConfig,
    this.createdOn,
    this.deploymentTrigger,
    this.envVars,
    this.environment,
    this.id,
    this.isSkipped,
    this.latestStage,
    this.modifiedOn,
    this.projectId,
    this.projectName,
    this.shortId,
    this.skipReason,
    this.source,
    this.stages,
    this.url,
    this.usesFunctions,
    this.extra = const <String, Object?>{},
  });

  factory Deployment.fromJson(Map<String, Object?> json) => Deployment(
    aliases: asPrimitiveList<String>(json['aliases'], asString),
    buildConfig: asModel(json['build_config'], BuildConfig.fromJson),
    createdOn: asString(json['created_on']),
    deploymentTrigger: asModel(
      json['deployment_trigger'],
      DeploymentDeploymentTrigger.fromJson,
    ),
    envVars: asMap(json['env_vars']),
    environment: asString(json['environment']),
    id: asString(json['id']),
    isSkipped: asBool(json['is_skipped']),
    latestStage: asModel(json['latest_stage'], Stage.fromJson),
    modifiedOn: asString(json['modified_on']),
    projectId: asString(json['project_id']),
    projectName: asString(json['project_name']),
    shortId: asString(json['short_id']),
    skipReason: asString(json['skip_reason']),
    source: asModel(json['source'], Source.fromJson),
    stages: asModelList(json['stages'], Stage.fromJson),
    url: asString(json['url']),
    usesFunctions: asBool(json['uses_functions']),
    extra: extraOf(json, _knownKeys),
  );

  /// A list of alias URLs pointing to this deployment.
  final List<String>? aliases;

  /// Configs for the project build process.
  final BuildConfig? buildConfig;

  /// When the deployment was created.
  final String? createdOn;

  /// Info about what caused the deployment.
  final DeploymentDeploymentTrigger? deploymentTrigger;

  /// Environment variables used for builds and Pages Functions.
  final Map<String, Object?>? envVars;

  /// Type of deploy. Allowed values: `preview`, `production`.
  final String? environment;

  /// Id of the deployment.
  final String? id;

  /// If the deployment has been skipped.
  final bool? isSkipped;

  /// The status of the deployment.
  final Stage? latestStage;

  /// When the deployment was last modified.
  final String? modifiedOn;

  /// Id of the project.
  final String? projectId;

  /// Name of the project.
  final String? projectName;

  /// Short Id (8 character) of the deployment.
  final String? shortId;

  /// Why the deployment was skipped. Allowed values: `commit_message`,
  /// `preview_deployments_disabled`, `production_deployments_disabled`,
  /// `path_config`, `branch_config`, `pages_to_workers_conversion`.
  final String? skipReason;

  /// Configs for the project source control.
  final Source? source;

  /// List of past stages.
  final List<Stage>? stages;

  /// The live URL to view this deployment.
  final String? url;

  /// Whether the deployment uses functions.
  final bool? usesFunctions;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'aliases',
    'build_config',
    'created_on',
    'deployment_trigger',
    'env_vars',
    'environment',
    'id',
    'is_skipped',
    'latest_stage',
    'modified_on',
    'project_id',
    'project_name',
    'short_id',
    'skip_reason',
    'source',
    'stages',
    'url',
    'uses_functions',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aliases != null) 'aliases': aliases!,
    if (buildConfig != null) 'build_config': buildConfig!.toJson(),
    if (createdOn != null) 'created_on': createdOn!,
    if (deploymentTrigger != null)
      'deployment_trigger': deploymentTrigger!.toJson(),
    if (envVars != null) 'env_vars': envVars!,
    if (environment != null) 'environment': environment!,
    if (id != null) 'id': id!,
    if (isSkipped != null) 'is_skipped': isSkipped!,
    if (latestStage != null) 'latest_stage': latestStage!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (projectId != null) 'project_id': projectId!,
    if (projectName != null) 'project_name': projectName!,
    if (shortId != null) 'short_id': shortId!,
    if (skipReason != null) 'skip_reason': skipReason!,
    if (source != null) 'source': source!.toJson(),
    if (stages != null) 'stages': stages!.map((e) => e.toJson()).toList(),
    if (url != null) 'url': url!,
    if (usesFunctions != null) 'uses_functions': usesFunctions!,
  };

  Deployment copyWith({
    List<String>? aliases,
    BuildConfig? buildConfig,
    String? createdOn,
    DeploymentDeploymentTrigger? deploymentTrigger,
    Map<String, Object?>? envVars,
    String? environment,
    String? id,
    bool? isSkipped,
    Stage? latestStage,
    String? modifiedOn,
    String? projectId,
    String? projectName,
    String? shortId,
    String? skipReason,
    Source? source,
    List<Stage>? stages,
    String? url,
    bool? usesFunctions,
    Map<String, Object?>? extra,
  }) => Deployment(
    aliases: aliases ?? this.aliases,
    buildConfig: buildConfig ?? this.buildConfig,
    createdOn: createdOn ?? this.createdOn,
    deploymentTrigger: deploymentTrigger ?? this.deploymentTrigger,
    envVars: envVars ?? this.envVars,
    environment: environment ?? this.environment,
    id: id ?? this.id,
    isSkipped: isSkipped ?? this.isSkipped,
    latestStage: latestStage ?? this.latestStage,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    shortId: shortId ?? this.shortId,
    skipReason: skipReason ?? this.skipReason,
    source: source ?? this.source,
    stages: stages ?? this.stages,
    url: url ?? this.url,
    usesFunctions: usesFunctions ?? this.usesFunctions,
    extra: extra ?? this.extra,
  );
}

/// Info about what caused the deployment.
class DeploymentDeploymentTrigger {
  const DeploymentDeploymentTrigger({
    this.metadata,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory DeploymentDeploymentTrigger.fromJson(Map<String, Object?> json) =>
      DeploymentDeploymentTrigger(
        metadata: asModel(
          json['metadata'],
          DeploymentDeploymentTriggerMetadata.fromJson,
        ),
        type_: asString(json['type']),
        extra: extraOf(json, _knownKeys),
      );

  /// Additional info about the trigger.
  final DeploymentDeploymentTriggerMetadata? metadata;

  /// What caused the deployment. Allowed values: `github:push`, `ad_hoc`,
  /// `deploy_hook`.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'metadata', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (metadata != null) 'metadata': metadata!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  DeploymentDeploymentTrigger copyWith({
    DeploymentDeploymentTriggerMetadata? metadata,
    String? type_,
    Map<String, Object?>? extra,
  }) => DeploymentDeploymentTrigger(
    metadata: metadata ?? this.metadata,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// Additional info about the trigger.
class DeploymentDeploymentTriggerMetadata {
  const DeploymentDeploymentTriggerMetadata({
    this.branch,
    this.commitDirty,
    this.commitHash,
    this.commitMessage,
    this.extra = const <String, Object?>{},
  });

  factory DeploymentDeploymentTriggerMetadata.fromJson(
    Map<String, Object?> json,
  ) => DeploymentDeploymentTriggerMetadata(
    branch: asString(json['branch']),
    commitDirty: asBool(json['commit_dirty']),
    commitHash: asString(json['commit_hash']),
    commitMessage: asString(json['commit_message']),
    extra: extraOf(json, _knownKeys),
  );

  /// Where the trigger happened.
  final String? branch;

  /// Whether the deployment trigger commit was dirty.
  final bool? commitDirty;

  /// Hash of the deployment trigger commit.
  final String? commitHash;

  /// Message of the deployment trigger commit.
  final String? commitMessage;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'branch',
    'commit_dirty',
    'commit_hash',
    'commit_message',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (branch != null) 'branch': branch!,
    if (commitDirty != null) 'commit_dirty': commitDirty!,
    if (commitHash != null) 'commit_hash': commitHash!,
    if (commitMessage != null) 'commit_message': commitMessage!,
  };

  DeploymentDeploymentTriggerMetadata copyWith({
    String? branch,
    bool? commitDirty,
    String? commitHash,
    String? commitMessage,
    Map<String, Object?>? extra,
  }) => DeploymentDeploymentTriggerMetadata(
    branch: branch ?? this.branch,
    commitDirty: commitDirty ?? this.commitDirty,
    commitHash: commitHash ?? this.commitHash,
    commitMessage: commitMessage ?? this.commitMessage,
    extra: extra ?? this.extra,
  );
}

class DnsRecordPatch {
  const DnsRecordPatch({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPatch.fromJson(Map<String, Object?> json) => DnsRecordPatch(
    comment: asString(json['comment']),
    name: asString(json['name']),
    proxied: asBool(json['proxied']),
    settings: asModel(json['settings'], Settings.fromJson),
    tags: asPrimitiveList<String>(json['tags'], asString),
    ttl: asNum(json['ttl']),
    content: asString(json['content']),
    privateRouting: asBool(json['private_routing']),
    type_: asString(json['type']),
    priority: asNum(json['priority']),
    data: asModel(json['data'], DnsRecordPatchData.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordPatchData? data;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
  };

  DnsRecordPatch copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordPatchData? data,
    Map<String, Object?>? extra,
  }) => DnsRecordPatch(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordPatchData {
  const DnsRecordPatchData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPatchData.fromJson(Map<String, Object?> json) =>
      DnsRecordPatchData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordPatchData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordPatchData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

class DnsRecordPost {
  const DnsRecordPost({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPost.fromJson(Map<String, Object?> json) => DnsRecordPost(
    comment: asString(json['comment']),
    name: asString(json['name']),
    proxied: asBool(json['proxied']),
    settings: asModel(json['settings'], Settings.fromJson),
    tags: asPrimitiveList<String>(json['tags'], asString),
    ttl: asNum(json['ttl']),
    content: asString(json['content']),
    privateRouting: asBool(json['private_routing']),
    type_: asString(json['type']),
    priority: asNum(json['priority']),
    data: asModel(json['data'], DnsRecordPostData.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordPostData? data;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
  };

  DnsRecordPost copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordPostData? data,
    Map<String, Object?>? extra,
  }) => DnsRecordPost(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordPostData {
  const DnsRecordPostData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordPostData.fromJson(Map<String, Object?> json) =>
      DnsRecordPostData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordPostData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordPostData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

class DnsRecordResponse {
  const DnsRecordResponse({
    this.comment,
    this.name,
    this.proxied,
    this.settings,
    this.tags,
    this.ttl,
    this.content,
    this.privateRouting,
    this.type_,
    this.priority,
    this.data,
    this.commentModifiedOn,
    this.createdOn,
    this.id,
    this.meta,
    this.modifiedOn,
    this.proxiable,
    this.tagsModifiedOn,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordResponse.fromJson(Map<String, Object?> json) =>
      DnsRecordResponse(
        comment: asString(json['comment']),
        name: asString(json['name']),
        proxied: asBool(json['proxied']),
        settings: asModel(json['settings'], Settings.fromJson),
        tags: asPrimitiveList<String>(json['tags'], asString),
        ttl: asNum(json['ttl']),
        content: asString(json['content']),
        privateRouting: asBool(json['private_routing']),
        type_: asString(json['type']),
        priority: asNum(json['priority']),
        data: asModel(json['data'], DnsRecordResponseData.fromJson),
        commentModifiedOn: asString(json['comment_modified_on']),
        createdOn: asString(json['created_on']),
        id: asString(json['id']),
        meta: asModel(json['meta'], DnsRecordResponseMeta.fromJson),
        modifiedOn: asString(json['modified_on']),
        proxiable: asBool(json['proxiable']),
        tagsModifiedOn: asString(json['tags_modified_on']),
        extra: extraOf(json, _knownKeys),
      );

  /// Comments or notes about the DNS record. This field has no effect on DNS
  /// responses.
  final String? comment;

  /// Complete DNS record name, including the zone name, in Punycode.
  final String? name;

  /// Whether the record is receiving the performance and security benefits of
  /// Cloudflare.
  final bool? proxied;

  /// Settings for the DNS record.
  final Settings? settings;

  /// Custom tags for the DNS record. This field has no effect on DNS responses.
  final List<String>? tags;

  /// Time To Live (TTL) of the DNS record in seconds. Setting to 1 means
  /// 'automatic'. Value must be between 60 and 86400, with the minimum reduced to
  /// 30 for Enterprise zones.
  final num? ttl;

  /// Formatted URI content. See 'data' to set URI properties.
  final String? content;

  /// Enables private network routing to the origin.
  final bool? privateRouting;

  /// Record type. Allowed values: `URI`.
  final String? type_;

  /// Required for MX and URI records; ignored for other record types (but may
  /// still be returned by the API). Records with lower priorities are preferred.
  /// This field is to be deprecated in favor of the priority field within the
  /// data map.
  final num? priority;

  /// Components of a URI record.
  final DnsRecordResponseData? data;

  /// When the record comment was last modified. Omitted if there is no comment.
  final String? commentModifiedOn;

  /// When the record was created.
  final String? createdOn;

  /// Identifier.
  final String? id;

  /// Extra Cloudflare-specific metadata about the record.
  final DnsRecordResponseMeta? meta;

  /// When the record was last modified.
  final String? modifiedOn;

  /// Whether the record can be proxied by Cloudflare or not.
  final bool? proxiable;

  /// When the record tags were last modified. Omitted if there are no tags.
  final String? tagsModifiedOn;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'comment',
    'name',
    'proxied',
    'settings',
    'tags',
    'ttl',
    'content',
    'private_routing',
    'type',
    'priority',
    'data',
    'comment_modified_on',
    'created_on',
    'id',
    'meta',
    'modified_on',
    'proxiable',
    'tags_modified_on',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (comment != null) 'comment': comment!,
    if (name != null) 'name': name!,
    if (proxied != null) 'proxied': proxied!,
    if (settings != null) 'settings': settings!.toJson(),
    if (tags != null) 'tags': tags!,
    if (ttl != null) 'ttl': ttl!,
    if (content != null) 'content': content!,
    if (privateRouting != null) 'private_routing': privateRouting!,
    if (type_ != null) 'type': type_!,
    if (priority != null) 'priority': priority!,
    if (data != null) 'data': data!.toJson(),
    if (commentModifiedOn != null) 'comment_modified_on': commentModifiedOn!,
    if (createdOn != null) 'created_on': createdOn!,
    if (id != null) 'id': id!,
    if (meta != null) 'meta': meta!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (proxiable != null) 'proxiable': proxiable!,
    if (tagsModifiedOn != null) 'tags_modified_on': tagsModifiedOn!,
  };

  DnsRecordResponse copyWith({
    String? comment,
    String? name,
    bool? proxied,
    Settings? settings,
    List<String>? tags,
    num? ttl,
    String? content,
    bool? privateRouting,
    String? type_,
    num? priority,
    DnsRecordResponseData? data,
    String? commentModifiedOn,
    String? createdOn,
    String? id,
    DnsRecordResponseMeta? meta,
    String? modifiedOn,
    bool? proxiable,
    String? tagsModifiedOn,
    Map<String, Object?>? extra,
  }) => DnsRecordResponse(
    comment: comment ?? this.comment,
    name: name ?? this.name,
    proxied: proxied ?? this.proxied,
    settings: settings ?? this.settings,
    tags: tags ?? this.tags,
    ttl: ttl ?? this.ttl,
    content: content ?? this.content,
    privateRouting: privateRouting ?? this.privateRouting,
    type_: type_ ?? this.type_,
    priority: priority ?? this.priority,
    data: data ?? this.data,
    commentModifiedOn: commentModifiedOn ?? this.commentModifiedOn,
    createdOn: createdOn ?? this.createdOn,
    id: id ?? this.id,
    meta: meta ?? this.meta,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    proxiable: proxiable ?? this.proxiable,
    tagsModifiedOn: tagsModifiedOn ?? this.tagsModifiedOn,
    extra: extra ?? this.extra,
  );
}

/// Components of a URI record.
class DnsRecordResponseData {
  const DnsRecordResponseData({
    this.target,
    this.weight,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordResponseData.fromJson(Map<String, Object?> json) =>
      DnsRecordResponseData(
        target: asString(json['target']),
        weight: asNum(json['weight']),
        extra: extraOf(json, _knownKeys),
      );

  /// The record content.
  final String? target;

  /// The record weight.
  final num? weight;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'target', 'weight'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (target != null) 'target': target!,
    if (weight != null) 'weight': weight!,
  };

  DnsRecordResponseData copyWith({
    String? target,
    num? weight,
    Map<String, Object?>? extra,
  }) => DnsRecordResponseData(
    target: target ?? this.target,
    weight: weight ?? this.weight,
    extra: extra ?? this.extra,
  );
}

/// Extra Cloudflare-specific metadata about the record.
class DnsRecordResponseMeta {
  const DnsRecordResponseMeta({
    this.deadGlue,
    this.isGlue,
    this.shadowedBy,
    this.shadowedRecordsCount,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordResponseMeta.fromJson(Map<String, Object?> json) =>
      DnsRecordResponseMeta(
        deadGlue: asBool(json['dead_glue']),
        isGlue: asBool(json['is_glue']),
        shadowedBy: asPrimitiveList<String>(json['shadowed_by'], asString),
        shadowedRecordsCount: asInt(json['shadowed_records_count']),
        extra: extraOf(json, _knownKeys),
      );

  /// Whether this glue record is not served because a shallower NS delegation
  /// takes precedence over the deeper delegation that needs it. Present only when
  /// true; reachable glue carries only `is_glue`. See [Unreachable glue
  /// records](https://developers.cloudflare.com/dns/manage-dns-records/reference/shadowed-records#unreachable-glue-records).
  final bool? deadGlue;

  /// Whether this A or AAAA record is glue for a subdomain NS delegation. See
  /// [Glue
  /// records](https://developers.cloudflare.com/dns/manage-dns-records/reference/shadowed-records#glue-records).
  final bool? isGlue;

  /// IDs of the NS records that shadow this record. See [Shadowed
  /// records](https://developers.cloudflare.com/dns/manage-dns-records/reference/shadowed-records).
  final List<String>? shadowedBy;

  /// Number of records shadowed by this NS delegation. See [Shadowed
  /// records](https://developers.cloudflare.com/dns/manage-dns-records/reference/shadowed-records).
  final int? shadowedRecordsCount;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'dead_glue',
    'is_glue',
    'shadowed_by',
    'shadowed_records_count',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (deadGlue != null) 'dead_glue': deadGlue!,
    if (isGlue != null) 'is_glue': isGlue!,
    if (shadowedBy != null) 'shadowed_by': shadowedBy!,
    if (shadowedRecordsCount != null)
      'shadowed_records_count': shadowedRecordsCount!,
  };

  DnsRecordResponseMeta copyWith({
    bool? deadGlue,
    bool? isGlue,
    List<String>? shadowedBy,
    int? shadowedRecordsCount,
    Map<String, Object?>? extra,
  }) => DnsRecordResponseMeta(
    deadGlue: deadGlue ?? this.deadGlue,
    isGlue: isGlue ?? this.isGlue,
    shadowedBy: shadowedBy ?? this.shadowedBy,
    shadowedRecordsCount: shadowedRecordsCount ?? this.shadowedRecordsCount,
    extra: extra ?? this.extra,
  );
}

class DnsRecordsForAZoneImportDnsRecordsResult {
  const DnsRecordsForAZoneImportDnsRecordsResult({
    this.recsAdded,
    this.totalRecordsParsed,
    this.extra = const <String, Object?>{},
  });

  factory DnsRecordsForAZoneImportDnsRecordsResult.fromJson(
    Map<String, Object?> json,
  ) => DnsRecordsForAZoneImportDnsRecordsResult(
    recsAdded: asNum(json['recs_added']),
    totalRecordsParsed: asNum(json['total_records_parsed']),
    extra: extraOf(json, _knownKeys),
  );

  /// Number of DNS records added.
  final num? recsAdded;

  /// Total number of DNS records parsed.
  final num? totalRecordsParsed;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'recs_added', 'total_records_parsed'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (recsAdded != null) 'recs_added': recsAdded!,
    if (totalRecordsParsed != null) 'total_records_parsed': totalRecordsParsed!,
  };

  DnsRecordsForAZoneImportDnsRecordsResult copyWith({
    num? recsAdded,
    num? totalRecordsParsed,
    Map<String, Object?>? extra,
  }) => DnsRecordsForAZoneImportDnsRecordsResult(
    recsAdded: recsAdded ?? this.recsAdded,
    totalRecordsParsed: totalRecordsParsed ?? this.totalRecordsParsed,
    extra: extra ?? this.extra,
  );
}

class DnsResolverSettingsV4 {
  const DnsResolverSettingsV4({
    this.ip,
    this.port,
    this.routeThroughPrivateNetwork,
    this.vnetId,
    this.extra = const <String, Object?>{},
  });

  factory DnsResolverSettingsV4.fromJson(Map<String, Object?> json) =>
      DnsResolverSettingsV4(
        ip: asString(json['ip']),
        port: asInt(json['port']),
        routeThroughPrivateNetwork: asBool(
          json['route_through_private_network'],
        ),
        vnetId: asString(json['vnet_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify the IPv4 address of the upstream resolver.
  final String? ip;

  /// Specify a port number to use for the upstream resolver. Defaults to 53 if
  /// unspecified.
  final int? port;

  /// Indicate whether to connect to this resolver over a private network. Must
  /// set when vnet_id set.
  final bool? routeThroughPrivateNetwork;

  /// Specify an optional virtual network for this resolver. Uses default virtual
  /// network id if omitted.
  final String? vnetId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'ip',
    'port',
    'route_through_private_network',
    'vnet_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ip != null) 'ip': ip!,
    if (port != null) 'port': port!,
    if (routeThroughPrivateNetwork != null)
      'route_through_private_network': routeThroughPrivateNetwork!,
    if (vnetId != null) 'vnet_id': vnetId!,
  };

  DnsResolverSettingsV4 copyWith({
    String? ip,
    int? port,
    bool? routeThroughPrivateNetwork,
    String? vnetId,
    Map<String, Object?>? extra,
  }) => DnsResolverSettingsV4(
    ip: ip ?? this.ip,
    port: port ?? this.port,
    routeThroughPrivateNetwork:
        routeThroughPrivateNetwork ?? this.routeThroughPrivateNetwork,
    vnetId: vnetId ?? this.vnetId,
    extra: extra ?? this.extra,
  );
}

class DnsResolverSettingsV6 {
  const DnsResolverSettingsV6({
    this.ip,
    this.port,
    this.routeThroughPrivateNetwork,
    this.vnetId,
    this.extra = const <String, Object?>{},
  });

  factory DnsResolverSettingsV6.fromJson(Map<String, Object?> json) =>
      DnsResolverSettingsV6(
        ip: asString(json['ip']),
        port: asInt(json['port']),
        routeThroughPrivateNetwork: asBool(
          json['route_through_private_network'],
        ),
        vnetId: asString(json['vnet_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify the IPv6 address of the upstream resolver.
  final String? ip;

  /// Specify a port number to use for the upstream resolver. Defaults to 53 if
  /// unspecified.
  final int? port;

  /// Indicate whether to connect to this resolver over a private network. Must
  /// set when vnet_id set.
  final bool? routeThroughPrivateNetwork;

  /// Specify an optional virtual network for this resolver. Uses default virtual
  /// network id if omitted.
  final String? vnetId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'ip',
    'port',
    'route_through_private_network',
    'vnet_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ip != null) 'ip': ip!,
    if (port != null) 'port': port!,
    if (routeThroughPrivateNetwork != null)
      'route_through_private_network': routeThroughPrivateNetwork!,
    if (vnetId != null) 'vnet_id': vnetId!,
  };

  DnsResolverSettingsV6 copyWith({
    String? ip,
    int? port,
    bool? routeThroughPrivateNetwork,
    String? vnetId,
    Map<String, Object?>? extra,
  }) => DnsResolverSettingsV6(
    ip: ip ?? this.ip,
    port: port ?? this.port,
    routeThroughPrivateNetwork:
        routeThroughPrivateNetwork ?? this.routeThroughPrivateNetwork,
    vnetId: vnetId ?? this.vnetId,
    extra: extra ?? this.extra,
  );
}

/// Defines the expiration time stamp and default duration of a DNS policy.
/// Takes precedence over the policy's `schedule` configuration, if any. This
/// does not apply to HTTP or network policies. Settable only for `dns` rules.
class Expiration {
  const Expiration({
    this.duration,
    this.expired,
    this.expiresAt,
    this.extra = const <String, Object?>{},
  });

  factory Expiration.fromJson(Map<String, Object?> json) => Expiration(
    duration: asInt(json['duration']),
    expired: asBool(json['expired']),
    expiresAt: json['expires_at'],
    extra: extraOf(json, _knownKeys),
  );

  /// Defines the default duration a policy active in minutes. Must set in order
  /// to use the `reset_expiration` endpoint on this rule.
  final int? duration;

  /// Indicates whether the policy is expired.
  final bool? expired;
  final Object? expiresAt;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'duration', 'expired', 'expires_at'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (duration != null) 'duration': duration!,
    if (expired != null) 'expired': expired!,
    if (expiresAt != null) 'expires_at': expiresAt!,
  };

  Expiration copyWith({
    int? duration,
    bool? expired,
    Object? expiresAt,
    Map<String, Object?>? extra,
  }) => Expiration(
    duration: duration ?? this.duration,
    expired: expired ?? this.expired,
    expiresAt: expiresAt ?? this.expiresAt,
    extra: extra ?? this.extra,
  );
}

/// A non-blocking reconciliation info entry. Emitted for stale tombstones (a
/// no-op on this deploy) and for tombstones applied with the source class still
/// in code (the supported zero-downtime rollout pattern).
class ExportsReconciliationInfo {
  const ExportsReconciliationInfo({
    this.class_,
    this.message,
    this.namespaceId,
    this.referencingScripts,
    this.scenario,
    this.extra = const <String, Object?>{},
  });

  factory ExportsReconciliationInfo.fromJson(Map<String, Object?> json) =>
      ExportsReconciliationInfo(
        class_: asString(json['class']),
        message: asString(json['message']),
        namespaceId: asString(json['namespace_id']),
        referencingScripts: asPrimitiveList<String>(
          json['referencing_scripts'],
          asString,
        ),
        scenario: asString(json['scenario']),
        extra: extraOf(json, _knownKeys),
      );

  /// The class name the info entry is about.
  final String? class_;

  /// Human-readable explanation.
  final String? message;

  /// The provisioned namespace the entry relates to, when applicable.
  final String? namespaceId;

  /// Other Workers in the account that still bind to the affected class.
  /// Advisory: while non-empty the tombstone is not yet safe to remove — redeploy
  /// these Workers with bindings re-pointed first.
  final List<String>? referencingScripts;

  /// Stable, machine-readable tag identifying which reconciliation scenario
  /// produced an error, warning, or info entry. Clients may branch on this value
  /// instead of parsing `message`. Allowed values: `code_class_not_in_exports`,
  /// `provisioned_class_missing_from_config`, `config_export_not_in_code`,
  /// `config_references_nonexistent_class`, `orphaned_provisioned_namespace`,
  /// `storage_type_mismatch`, `free_tier_requires_sqlite`, `invalid_export`,
  /// `tombstone_delete_class_still_in_code`,
  /// `tombstone_delete_blocked_by_external_bindings`,
  /// `tombstone_renamed_to_occupied`, `transferred_pending_not_found`,
  /// `transferred_target_missing`, `transferred_target_mismatch`,
  /// `phase_one_transfer_source_missing`,
  /// `phase_one_transfer_source_namespace_missing`,
  /// `phase_one_transfer_target_class_provisioned`,
  /// `phase_one_transfer_after_commit_mismatch`, `phase_one_transfer_duplicate`,
  /// `phase_one_transfer_target_in_dispatch_namespace`,
  /// `phase_one_transfer_source_in_dispatch_namespace`,
  /// `transferred_source_in_dispatch_namespace`,
  /// `transferred_target_in_dispatch_namespace`,
  /// `container_undeclared_reference`, `container_class_not_durable_object`,
  /// `container_wiring_inconsistent`, `container_multiple_durable_objects`,
  /// `transfer_container_parity_mismatch`,
  /// `transfer_container_parity_mismatch_on_commit`,
  /// `tombstone_class_still_in_code`, `stale_tombstone`,
  /// `transfer_receive_already_applied`, `transfer_receive_cleanup_complete`.
  final String? scenario;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'class',
    'message',
    'namespace_id',
    'referencing_scripts',
    'scenario',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (class_ != null) 'class': class_!,
    if (message != null) 'message': message!,
    if (namespaceId != null) 'namespace_id': namespaceId!,
    if (referencingScripts != null) 'referencing_scripts': referencingScripts!,
    if (scenario != null) 'scenario': scenario!,
  };

  ExportsReconciliationInfo copyWith({
    String? class_,
    String? message,
    String? namespaceId,
    List<String>? referencingScripts,
    String? scenario,
    Map<String, Object?>? extra,
  }) => ExportsReconciliationInfo(
    class_: class_ ?? this.class_,
    message: message ?? this.message,
    namespaceId: namespaceId ?? this.namespaceId,
    referencingScripts: referencingScripts ?? this.referencingScripts,
    scenario: scenario ?? this.scenario,
    extra: extra ?? this.extra,
  );
}

/// A single applied `renamed` tombstone.
class ExportsReconciliationRename {
  const ExportsReconciliationRename({
    this.from,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory ExportsReconciliationRename.fromJson(Map<String, Object?> json) =>
      ExportsReconciliationRename(
        from: asString(json['from']),
        to: asString(json['to']),
        extra: extraOf(json, _knownKeys),
      );

  /// The original (source) class name.
  final String? from;

  /// The new class name (`renamed_to`).
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'from', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (from != null) 'from': from!,
    if (to != null) 'to': to!,
  };

  ExportsReconciliationRename copyWith({
    String? from,
    String? to,
    Map<String, Object?>? extra,
  }) => ExportsReconciliationRename(
    from: from ?? this.from,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

/// A single committed `transferred` tombstone (phase-2 commit).
class ExportsReconciliationTransfer {
  const ExportsReconciliationTransfer({
    this.class_,
    this.phase,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory ExportsReconciliationTransfer.fromJson(Map<String, Object?> json) =>
      ExportsReconciliationTransfer(
        class_: asString(json['class']),
        phase: asString(json['phase']),
        to: asString(json['to']),
        extra: extraOf(json, _knownKeys),
      );

  /// The source class name that was transferred.
  final String? class_;

  /// The transfer phase. Currently always `committed`. Allowed values:
  /// `committed`.
  final String? phase;

  /// The destination script that now owns the namespace.
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'class', 'phase', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (class_ != null) 'class': class_!,
    if (phase != null) 'phase': phase!,
    if (to != null) 'to': to!,
  };

  ExportsReconciliationTransfer copyWith({
    String? class_,
    String? phase,
    String? to,
    Map<String, Object?>? extra,
  }) => ExportsReconciliationTransfer(
    class_: class_ ?? this.class_,
    phase: phase ?? this.phase,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

/// A single phase-1 transfer hint recorded on the target side (a live
/// `expecting-transfer` entry).
class ExportsReconciliationTransferPending {
  const ExportsReconciliationTransferPending({
    this.class_,
    this.from,
    this.extra = const <String, Object?>{},
  });

  factory ExportsReconciliationTransferPending.fromJson(
    Map<String, Object?> json,
  ) => ExportsReconciliationTransferPending(
    class_: asString(json['class']),
    from: asString(json['from']),
    extra: extraOf(json, _knownKeys),
  );

  /// The target-side class name awaiting transfer.
  final String? class_;

  /// The source script the namespace will be transferred from.
  final String? from;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'class', 'from'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (class_ != null) 'class': class_!,
    if (from != null) 'from': from!,
  };

  ExportsReconciliationTransferPending copyWith({
    String? class_,
    String? from,
    Map<String, Object?>? extra,
  }) => ExportsReconciliationTransferPending(
    class_: class_ ?? this.class_,
    from: from ?? this.from,
    extra: extra ?? this.extra,
  );
}

/// A non-blocking reconciliation warning. Reserved: no scenario populates this
/// array today (`code_class_not_in_exports` is surfaced as info and
/// `provisioned_class_missing_from_config` is a hard error). Clients should
/// still surface any entries that appear.
class ExportsReconciliationWarning {
  const ExportsReconciliationWarning({
    this.class_,
    this.message,
    this.namespaceId,
    this.scenario,
    this.extra = const <String, Object?>{},
  });

  factory ExportsReconciliationWarning.fromJson(Map<String, Object?> json) =>
      ExportsReconciliationWarning(
        class_: asString(json['class']),
        message: asString(json['message']),
        namespaceId: asString(json['namespace_id']),
        scenario: asString(json['scenario']),
        extra: extraOf(json, _knownKeys),
      );

  /// The class name the warning is about.
  final String? class_;

  /// Human-readable explanation of the warning.
  final String? message;

  /// The provisioned namespace the warning relates to, when applicable.
  final String? namespaceId;

  /// Stable, machine-readable tag identifying which reconciliation scenario
  /// produced an error, warning, or info entry. Clients may branch on this value
  /// instead of parsing `message`. Allowed values: `code_class_not_in_exports`,
  /// `provisioned_class_missing_from_config`, `config_export_not_in_code`,
  /// `config_references_nonexistent_class`, `orphaned_provisioned_namespace`,
  /// `storage_type_mismatch`, `free_tier_requires_sqlite`, `invalid_export`,
  /// `tombstone_delete_class_still_in_code`,
  /// `tombstone_delete_blocked_by_external_bindings`,
  /// `tombstone_renamed_to_occupied`, `transferred_pending_not_found`,
  /// `transferred_target_missing`, `transferred_target_mismatch`,
  /// `phase_one_transfer_source_missing`,
  /// `phase_one_transfer_source_namespace_missing`,
  /// `phase_one_transfer_target_class_provisioned`,
  /// `phase_one_transfer_after_commit_mismatch`, `phase_one_transfer_duplicate`,
  /// `phase_one_transfer_target_in_dispatch_namespace`,
  /// `phase_one_transfer_source_in_dispatch_namespace`,
  /// `transferred_source_in_dispatch_namespace`,
  /// `transferred_target_in_dispatch_namespace`,
  /// `container_undeclared_reference`, `container_class_not_durable_object`,
  /// `container_wiring_inconsistent`, `container_multiple_durable_objects`,
  /// `transfer_container_parity_mismatch`,
  /// `transfer_container_parity_mismatch_on_commit`,
  /// `tombstone_class_still_in_code`, `stale_tombstone`,
  /// `transfer_receive_already_applied`, `transfer_receive_cleanup_complete`.
  final String? scenario;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'class',
    'message',
    'namespace_id',
    'scenario',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (class_ != null) 'class': class_!,
    if (message != null) 'message': message!,
    if (namespaceId != null) 'namespace_id': namespaceId!,
    if (scenario != null) 'scenario': scenario!,
  };

  ExportsReconciliationWarning copyWith({
    String? class_,
    String? message,
    String? namespaceId,
    String? scenario,
    Map<String, Object?>? extra,
  }) => ExportsReconciliationWarning(
    class_: class_ ?? this.class_,
    message: message ?? this.message,
    namespaceId: namespaceId ?? this.namespaceId,
    scenario: scenario ?? this.scenario,
    extra: extra ?? this.extra,
  );
}

class GetZoneEntrypointRulesetResult {
  const GetZoneEntrypointRulesetResult({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.rules,
    this.extra = const <String, Object?>{},
  });

  factory GetZoneEntrypointRulesetResult.fromJson(Map<String, Object?> json) =>
      GetZoneEntrypointRulesetResult(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        rules: asModelList(json['rules'], ResponseRule.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// The list of rules in the ruleset.
  final List<ResponseRule>? rules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
    'rules',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
    if (rules != null) 'rules': rules!.map((e) => e.toJson()).toList(),
  };

  GetZoneEntrypointRulesetResult copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    List<ResponseRule>? rules,
    Map<String, Object?>? extra,
  }) => GetZoneEntrypointRulesetResult(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    rules: rules ?? this.rules,
    extra: extra ?? this.extra,
  );
}

class GetZoneRulesetResult {
  const GetZoneRulesetResult({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.rules,
    this.extra = const <String, Object?>{},
  });

  factory GetZoneRulesetResult.fromJson(Map<String, Object?> json) =>
      GetZoneRulesetResult(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        rules: asModelList(json['rules'], ResponseRule.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// The list of rules in the ruleset.
  final List<ResponseRule>? rules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
    'rules',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
    if (rules != null) 'rules': rules!.map((e) => e.toJson()).toList(),
  };

  GetZoneRulesetResult copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    List<ResponseRule>? rules,
    Map<String, Object?>? extra,
  }) => GetZoneRulesetResult(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    rules: rules ?? this.rules,
    extra: extra ?? this.extra,
  );
}

class IpAccessRulesForAZoneCreateAnIpAccessRuleBody {
  const IpAccessRulesForAZoneCreateAnIpAccessRuleBody({
    this.configuration,
    this.mode,
    this.notes,
    this.extra = const <String, Object?>{},
  });

  factory IpAccessRulesForAZoneCreateAnIpAccessRuleBody.fromJson(
    Map<String, Object?> json,
  ) => IpAccessRulesForAZoneCreateAnIpAccessRuleBody(
    configuration: asModel(json['configuration'], Configuration.fromJson),
    mode: asString(json['mode']),
    notes: json['notes'],
    extra: extraOf(json, _knownKeys),
  );

  /// The rule configuration.
  final Configuration? configuration;

  /// The action to apply to a matched request. Allowed values: `block`,
  /// `challenge`, `whitelist`, `js_challenge`, `managed_challenge`.
  final String? mode;
  final Object? notes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'configuration', 'mode', 'notes'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (configuration != null) 'configuration': configuration!.toJson(),
    if (mode != null) 'mode': mode!,
    if (notes != null) 'notes': notes!,
  };

  IpAccessRulesForAZoneCreateAnIpAccessRuleBody copyWith({
    Configuration? configuration,
    String? mode,
    Object? notes,
    Map<String, Object?>? extra,
  }) => IpAccessRulesForAZoneCreateAnIpAccessRuleBody(
    configuration: configuration ?? this.configuration,
    mode: mode ?? this.mode,
    notes: notes ?? this.notes,
    extra: extra ?? this.extra,
  );
}

class IpAccessRulesForAZoneDeleteAnIpAccessRuleBody {
  const IpAccessRulesForAZoneDeleteAnIpAccessRuleBody({
    this.cascade,
    this.extra = const <String, Object?>{},
  });

  factory IpAccessRulesForAZoneDeleteAnIpAccessRuleBody.fromJson(
    Map<String, Object?> json,
  ) => IpAccessRulesForAZoneDeleteAnIpAccessRuleBody(
    cascade: asString(json['cascade']),
    extra: extraOf(json, _knownKeys),
  );

  /// The level to attempt to delete similar rules defined for other zones with
  /// the same owner. The default value is `none`, which will only delete the
  /// current rule. Using `basic` will delete rules that match the same action
  /// (mode) and configuration, while using `aggressive` will delete rules that
  /// match the same configuration. Allowed values: `none`, `basic`, `aggressive`.
  final String? cascade;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'cascade'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cascade != null) 'cascade': cascade!,
  };

  IpAccessRulesForAZoneDeleteAnIpAccessRuleBody copyWith({
    String? cascade,
    Map<String, Object?>? extra,
  }) => IpAccessRulesForAZoneDeleteAnIpAccessRuleBody(
    cascade: cascade ?? this.cascade,
    extra: extra ?? this.extra,
  );
}

class IpAccessRulesForAZoneDeleteAnIpAccessRuleResult {
  const IpAccessRulesForAZoneDeleteAnIpAccessRuleResult({
    this.id,
    this.extra = const <String, Object?>{},
  });

  factory IpAccessRulesForAZoneDeleteAnIpAccessRuleResult.fromJson(
    Map<String, Object?> json,
  ) => IpAccessRulesForAZoneDeleteAnIpAccessRuleResult(
    id: asString(json['id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The unique identifier of the IP Access rule.
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  IpAccessRulesForAZoneDeleteAnIpAccessRuleResult copyWith({
    String? id,
    Map<String, Object?>? extra,
  }) => IpAccessRulesForAZoneDeleteAnIpAccessRuleResult(
    id: id ?? this.id,
    extra: extra ?? this.extra,
  );
}

/// The design of the App Launcher landing page shown to users when they log in.
class LandingPageDesign {
  const LandingPageDesign({
    this.buttonColor,
    this.buttonTextColor,
    this.imageUrl,
    this.message,
    this.title,
    this.extra = const <String, Object?>{},
  });

  factory LandingPageDesign.fromJson(Map<String, Object?> json) =>
      LandingPageDesign(
        buttonColor: asString(json['button_color']),
        buttonTextColor: asString(json['button_text_color']),
        imageUrl: asString(json['image_url']),
        message: asString(json['message']),
        title: asString(json['title']),
        extra: extraOf(json, _knownKeys),
      );

  /// The background color of the log in button on the landing page.
  final String? buttonColor;

  /// The color of the text in the log in button on the landing page.
  final String? buttonTextColor;

  /// The URL of the image shown on the landing page.
  final String? imageUrl;

  /// The message shown on the landing page.
  final String? message;

  /// The title shown on the landing page.
  final String? title;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'button_color',
    'button_text_color',
    'image_url',
    'message',
    'title',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (buttonColor != null) 'button_color': buttonColor!,
    if (buttonTextColor != null) 'button_text_color': buttonTextColor!,
    if (imageUrl != null) 'image_url': imageUrl!,
    if (message != null) 'message': message!,
    if (title != null) 'title': title!,
  };

  LandingPageDesign copyWith({
    String? buttonColor,
    String? buttonTextColor,
    String? imageUrl,
    String? message,
    String? title,
    Map<String, Object?>? extra,
  }) => LandingPageDesign(
    buttonColor: buttonColor ?? this.buttonColor,
    buttonTextColor: buttonTextColor ?? this.buttonTextColor,
    imageUrl: imageUrl ?? this.imageUrl,
    message: message ?? this.message,
    title: title ?? this.title,
    extra: extra ?? this.extra,
  );
}

/// Limits to apply for this Worker.
class Limits {
  const Limits({
    this.cpuMs,
    this.subrequests,
    this.extra = const <String, Object?>{},
  });

  factory Limits.fromJson(Map<String, Object?> json) => Limits(
    cpuMs: asInt(json['cpu_ms']),
    subrequests: asInt(json['subrequests']),
    extra: extraOf(json, _knownKeys),
  );

  /// The amount of CPU time this Worker can use in milliseconds.
  final int? cpuMs;

  /// The number of subrequests this Worker can make per request.
  final int? subrequests;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'cpu_ms', 'subrequests'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cpuMs != null) 'cpu_ms': cpuMs!,
    if (subrequests != null) 'subrequests': subrequests!,
  };

  Limits copyWith({
    int? cpuMs,
    int? subrequests,
    Map<String, Object?>? extra,
  }) => Limits(
    cpuMs: cpuMs ?? this.cpuMs,
    subrequests: subrequests ?? this.subrequests,
    extra: extra ?? this.extra,
  );
}

class ListZoneRulesetsItem {
  const ListZoneRulesetsItem({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.extra = const <String, Object?>{},
  });

  factory ListZoneRulesetsItem.fromJson(Map<String, Object?> json) =>
      ListZoneRulesetsItem(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
  };

  ListZoneRulesetsItem copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    Map<String, Object?>? extra,
  }) => ListZoneRulesetsItem(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    extra: extra ?? this.extra,
  );
}

/// Configures multi-factor authentication (MFA) settings.
class MfaConfig {
  const MfaConfig({
    this.allowedAuthenticators,
    this.mfaDisabled,
    this.sessionDuration,
    this.extra = const <String, Object?>{},
  });

  factory MfaConfig.fromJson(Map<String, Object?> json) => MfaConfig(
    allowedAuthenticators: asPrimitiveList<String>(
      json['allowed_authenticators'],
      asString,
    ),
    mfaDisabled: asBool(json['mfa_disabled']),
    sessionDuration: asString(json['session_duration']),
    extra: extraOf(json, _knownKeys),
  );

  /// Lists the MFA methods that users can authenticate with.
  final List<String>? allowedAuthenticators;

  /// Indicates whether to disable MFA for this resource. This option is available
  /// at the application and policy level.
  final bool? mfaDisabled;

  /// Defines the duration of an MFA session. Must be in minutes (m) or hours (h).
  /// Minimum: 0m. Maximum: 720h (30 days). Examples:`5m` or `24h`.
  final String? sessionDuration;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'allowed_authenticators',
    'mfa_disabled',
    'session_duration',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (allowedAuthenticators != null)
      'allowed_authenticators': allowedAuthenticators!,
    if (mfaDisabled != null) 'mfa_disabled': mfaDisabled!,
    if (sessionDuration != null) 'session_duration': sessionDuration!,
  };

  MfaConfig copyWith({
    List<String>? allowedAuthenticators,
    bool? mfaDisabled,
    String? sessionDuration,
    Map<String, Object?>? extra,
  }) => MfaConfig(
    allowedAuthenticators: allowedAuthenticators ?? this.allowedAuthenticators,
    mfaDisabled: mfaDisabled ?? this.mfaDisabled,
    sessionDuration: sessionDuration ?? this.sessionDuration,
    extra: extra ?? this.extra,
  );
}

class MigrationStep {
  const MigrationStep({
    this.deletedClasses,
    this.newClasses,
    this.newSqliteClasses,
    this.renamedClasses,
    this.transferredClasses,
    this.extra = const <String, Object?>{},
  });

  factory MigrationStep.fromJson(Map<String, Object?> json) => MigrationStep(
    deletedClasses: asPrimitiveList<String>(json['deleted_classes'], asString),
    newClasses: asPrimitiveList<String>(json['new_classes'], asString),
    newSqliteClasses: asPrimitiveList<String>(
      json['new_sqlite_classes'],
      asString,
    ),
    renamedClasses: asModelList(
      json['renamed_classes'],
      MigrationStepRenamedClassesItem.fromJson,
    ),
    transferredClasses: asModelList(
      json['transferred_classes'],
      MigrationStepTransferredClassesItem.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// A list of classes to delete Durable Object namespaces from.
  final List<String>? deletedClasses;

  /// A list of classes to create Durable Object namespaces from.
  final List<String>? newClasses;

  /// A list of classes to create Durable Object namespaces with SQLite from.
  final List<String>? newSqliteClasses;

  /// A list of classes with Durable Object namespaces that were renamed.
  final List<MigrationStepRenamedClassesItem>? renamedClasses;

  /// A list of transfers for Durable Object namespaces from a different Worker
  /// and class to a class defined in this Worker.
  final List<MigrationStepTransferredClassesItem>? transferredClasses;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'deleted_classes',
    'new_classes',
    'new_sqlite_classes',
    'renamed_classes',
    'transferred_classes',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (deletedClasses != null) 'deleted_classes': deletedClasses!,
    if (newClasses != null) 'new_classes': newClasses!,
    if (newSqliteClasses != null) 'new_sqlite_classes': newSqliteClasses!,
    if (renamedClasses != null)
      'renamed_classes': renamedClasses!.map((e) => e.toJson()).toList(),
    if (transferredClasses != null)
      'transferred_classes': transferredClasses!
          .map((e) => e.toJson())
          .toList(),
  };

  MigrationStep copyWith({
    List<String>? deletedClasses,
    List<String>? newClasses,
    List<String>? newSqliteClasses,
    List<MigrationStepRenamedClassesItem>? renamedClasses,
    List<MigrationStepTransferredClassesItem>? transferredClasses,
    Map<String, Object?>? extra,
  }) => MigrationStep(
    deletedClasses: deletedClasses ?? this.deletedClasses,
    newClasses: newClasses ?? this.newClasses,
    newSqliteClasses: newSqliteClasses ?? this.newSqliteClasses,
    renamedClasses: renamedClasses ?? this.renamedClasses,
    transferredClasses: transferredClasses ?? this.transferredClasses,
    extra: extra ?? this.extra,
  );
}

class MigrationStepRenamedClassesItem {
  const MigrationStepRenamedClassesItem({
    this.from,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory MigrationStepRenamedClassesItem.fromJson(Map<String, Object?> json) =>
      MigrationStepRenamedClassesItem(
        from: asString(json['from']),
        to: asString(json['to']),
        extra: extraOf(json, _knownKeys),
      );

  final String? from;
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'from', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (from != null) 'from': from!,
    if (to != null) 'to': to!,
  };

  MigrationStepRenamedClassesItem copyWith({
    String? from,
    String? to,
    Map<String, Object?>? extra,
  }) => MigrationStepRenamedClassesItem(
    from: from ?? this.from,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

class MigrationStepTransferredClassesItem {
  const MigrationStepTransferredClassesItem({
    this.from,
    this.fromScript,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory MigrationStepTransferredClassesItem.fromJson(
    Map<String, Object?> json,
  ) => MigrationStepTransferredClassesItem(
    from: asString(json['from']),
    fromScript: asString(json['from_script']),
    to: asString(json['to']),
    extra: extraOf(json, _knownKeys),
  );

  final String? from;
  final String? fromScript;
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'from', 'from_script', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (from != null) 'from': from!,
    if (fromScript != null) 'from_script': fromScript!,
    if (to != null) 'to': to!,
  };

  MigrationStepTransferredClassesItem copyWith({
    String? from,
    String? fromScript,
    String? to,
    Map<String, Object?>? extra,
  }) => MigrationStepTransferredClassesItem(
    from: from ?? this.from,
    fromScript: fromScript ?? this.fromScript,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

class Namespace {
  const Namespace({
    this.id,
    this.supportsUrlEncoding,
    this.title,
    this.extra = const <String, Object?>{},
  });

  factory Namespace.fromJson(Map<String, Object?> json) => Namespace(
    id: asString(json['id']),
    supportsUrlEncoding: asBool(json['supports_url_encoding']),
    title: asString(json['title']),
    extra: extraOf(json, _knownKeys),
  );

  /// Namespace identifier tag.
  final String? id;

  /// True if keys written on the URL will be URL-decoded before storing. For
  /// example, if set to "true", a key written on the URL as "%3F" will be stored
  /// as "?".
  final bool? supportsUrlEncoding;

  /// A human-readable string name for a Namespace.
  final String? title;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'id',
    'supports_url_encoding',
    'title',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (supportsUrlEncoding != null)
      'supports_url_encoding': supportsUrlEncoding!,
    if (title != null) 'title': title!,
  };

  Namespace copyWith({
    String? id,
    bool? supportsUrlEncoding,
    String? title,
    Map<String, Object?>? extra,
  }) => Namespace(
    id: id ?? this.id,
    supportsUrlEncoding: supportsUrlEncoding ?? this.supportsUrlEncoding,
    title: title ?? this.title,
    extra: extra ?? this.extra,
  );
}

/// **Beta:** Optional configuration for managing an OAuth authorization flow
/// controlled by Access. When set, Access will act as the OAuth authorization
/// server for this application. Only compatible with OAuth clients that support
/// [RFC 8707](https://datatracker.ietf.org/doc/html/rfc8707) (Resource
/// Indicators for OAuth 2.0). This feature is currently in beta.
class OauthConfiguration {
  const OauthConfiguration({
    this.dynamicClientRegistration,
    this.enabled,
    this.grant,
    this.extra = const <String, Object?>{},
  });

  factory OauthConfiguration.fromJson(Map<String, Object?> json) =>
      OauthConfiguration(
        dynamicClientRegistration: asModel(
          json['dynamic_client_registration'],
          OauthConfigurationDynamicClientRegistration.fromJson,
        ),
        enabled: asBool(json['enabled']),
        grant: asModel(json['grant'], OauthConfigurationGrant.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// Settings for OAuth dynamic client registration.
  final OauthConfigurationDynamicClientRegistration? dynamicClientRegistration;

  /// Whether the OAuth configuration is enabled for this application. When set to
  /// `false`, Access will not handle OAuth for this application. Defaults to
  /// `true` if omitted.
  final bool? enabled;

  /// Settings for OAuth grant behavior.
  final OauthConfigurationGrant? grant;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'dynamic_client_registration',
    'enabled',
    'grant',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (dynamicClientRegistration != null)
      'dynamic_client_registration': dynamicClientRegistration!.toJson(),
    if (enabled != null) 'enabled': enabled!,
    if (grant != null) 'grant': grant!.toJson(),
  };

  OauthConfiguration copyWith({
    OauthConfigurationDynamicClientRegistration? dynamicClientRegistration,
    bool? enabled,
    OauthConfigurationGrant? grant,
    Map<String, Object?>? extra,
  }) => OauthConfiguration(
    dynamicClientRegistration:
        dynamicClientRegistration ?? this.dynamicClientRegistration,
    enabled: enabled ?? this.enabled,
    grant: grant ?? this.grant,
    extra: extra ?? this.extra,
  );
}

/// Settings for OAuth dynamic client registration.
class OauthConfigurationDynamicClientRegistration {
  const OauthConfigurationDynamicClientRegistration({
    this.allowAnyOnLocalhost,
    this.allowAnyOnLoopback,
    this.allowedUris,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory OauthConfigurationDynamicClientRegistration.fromJson(
    Map<String, Object?> json,
  ) => OauthConfigurationDynamicClientRegistration(
    allowAnyOnLocalhost: asBool(json['allow_any_on_localhost']),
    allowAnyOnLoopback: asBool(json['allow_any_on_loopback']),
    allowedUris: asPrimitiveList<String>(json['allowed_uris'], asString),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Allows any client with redirect URIs on localhost.
  final bool? allowAnyOnLocalhost;

  /// Allows any client with redirect URIs on 127.0.0.1.
  final bool? allowAnyOnLoopback;

  /// The URIs that are allowed as redirect URIs for dynamically registered
  /// clients. HTTP and HTTPS paths may end in `/*` to match all sub-paths.
  /// Custom-scheme URIs must be explicitly configured and match exactly.
  final List<String>? allowedUris;

  /// Whether dynamic client registration is enabled.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'allow_any_on_localhost',
    'allow_any_on_loopback',
    'allowed_uris',
    'enabled',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (allowAnyOnLocalhost != null)
      'allow_any_on_localhost': allowAnyOnLocalhost!,
    if (allowAnyOnLoopback != null)
      'allow_any_on_loopback': allowAnyOnLoopback!,
    if (allowedUris != null) 'allowed_uris': allowedUris!,
    if (enabled != null) 'enabled': enabled!,
  };

  OauthConfigurationDynamicClientRegistration copyWith({
    bool? allowAnyOnLocalhost,
    bool? allowAnyOnLoopback,
    List<String>? allowedUris,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => OauthConfigurationDynamicClientRegistration(
    allowAnyOnLocalhost: allowAnyOnLocalhost ?? this.allowAnyOnLocalhost,
    allowAnyOnLoopback: allowAnyOnLoopback ?? this.allowAnyOnLoopback,
    allowedUris: allowedUris ?? this.allowedUris,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

/// Settings for OAuth grant behavior.
class OauthConfigurationGrant {
  const OauthConfigurationGrant({
    this.accessTokenLifetime,
    this.sessionDuration,
    this.extra = const <String, Object?>{},
  });

  factory OauthConfigurationGrant.fromJson(Map<String, Object?> json) =>
      OauthConfigurationGrant(
        accessTokenLifetime: asString(json['access_token_lifetime']),
        sessionDuration: asString(json['session_duration']),
        extra: extraOf(json, _knownKeys),
      );

  /// The lifetime of the access token. Must be in the format `300ms` or `2h45m`.
  /// Valid time units are ns, us (or µs), ms, s, m, h.
  final String? accessTokenLifetime;

  /// The duration of the OAuth session. Must be in the format `300ms` or `2h45m`.
  /// Valid time units are ns, us (or µs), ms, s, m, h.
  final String? sessionDuration;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'access_token_lifetime',
    'session_duration',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (accessTokenLifetime != null)
      'access_token_lifetime': accessTokenLifetime!,
    if (sessionDuration != null) 'session_duration': sessionDuration!,
  };

  OauthConfigurationGrant copyWith({
    String? accessTokenLifetime,
    String? sessionDuration,
    Map<String, Object?>? extra,
  }) => OauthConfigurationGrant(
    accessTokenLifetime: accessTokenLifetime ?? this.accessTokenLifetime,
    sessionDuration: sessionDuration ?? this.sessionDuration,
    extra: extra ?? this.extra,
  );
}

/// Observability settings for the Worker.
class Observability {
  const Observability({
    this.enabled,
    this.headSamplingRate,
    this.logs,
    this.traces,
    this.extra = const <String, Object?>{},
  });

  factory Observability.fromJson(Map<String, Object?> json) => Observability(
    enabled: asBool(json['enabled']),
    headSamplingRate: asNum(json['head_sampling_rate']),
    logs: asModel(json['logs'], ObservabilityLogs.fromJson),
    traces: asModel(json['traces'], ObservabilityTraces.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether observability is enabled for the Worker.
  final bool? enabled;

  /// The sampling rate for incoming requests. From 0 to 1 (1 = 100%, 0.1 = 10%).
  /// Default is 1.
  final num? headSamplingRate;

  /// Log settings for the Worker.
  final ObservabilityLogs? logs;

  /// Trace settings for the Worker.
  final ObservabilityTraces? traces;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'head_sampling_rate',
    'logs',
    'traces',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (headSamplingRate != null) 'head_sampling_rate': headSamplingRate!,
    if (logs != null) 'logs': logs!.toJson(),
    if (traces != null) 'traces': traces!.toJson(),
  };

  Observability copyWith({
    bool? enabled,
    num? headSamplingRate,
    ObservabilityLogs? logs,
    ObservabilityTraces? traces,
    Map<String, Object?>? extra,
  }) => Observability(
    enabled: enabled ?? this.enabled,
    headSamplingRate: headSamplingRate ?? this.headSamplingRate,
    logs: logs ?? this.logs,
    traces: traces ?? this.traces,
    extra: extra ?? this.extra,
  );
}

/// Log settings for the Worker.
class ObservabilityLogs {
  const ObservabilityLogs({
    this.destinations,
    this.enabled,
    this.headSamplingRate,
    this.invocationLogs,
    this.persist,
    this.extra = const <String, Object?>{},
  });

  factory ObservabilityLogs.fromJson(Map<String, Object?> json) =>
      ObservabilityLogs(
        destinations: asPrimitiveList<String>(json['destinations'], asString),
        enabled: asBool(json['enabled']),
        headSamplingRate: asNum(json['head_sampling_rate']),
        invocationLogs: asBool(json['invocation_logs']),
        persist: asBool(json['persist']),
        extra: extraOf(json, _knownKeys),
      );

  /// A list of destinations where logs will be exported to.
  final List<String>? destinations;

  /// Whether logs are enabled for the Worker.
  final bool? enabled;

  /// The sampling rate for logs. From 0 to 1 (1 = 100%, 0.1 = 10%). Default is 1.
  final num? headSamplingRate;

  /// Whether [invocation
  /// logs](https://developers.cloudflare.com/workers/observability/logs/workers-logs/#invocation-logs)
  /// are enabled for the Worker.
  final bool? invocationLogs;

  /// Whether log persistence is enabled for the Worker.
  final bool? persist;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'destinations',
    'enabled',
    'head_sampling_rate',
    'invocation_logs',
    'persist',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (destinations != null) 'destinations': destinations!,
    if (enabled != null) 'enabled': enabled!,
    if (headSamplingRate != null) 'head_sampling_rate': headSamplingRate!,
    if (invocationLogs != null) 'invocation_logs': invocationLogs!,
    if (persist != null) 'persist': persist!,
  };

  ObservabilityLogs copyWith({
    List<String>? destinations,
    bool? enabled,
    num? headSamplingRate,
    bool? invocationLogs,
    bool? persist,
    Map<String, Object?>? extra,
  }) => ObservabilityLogs(
    destinations: destinations ?? this.destinations,
    enabled: enabled ?? this.enabled,
    headSamplingRate: headSamplingRate ?? this.headSamplingRate,
    invocationLogs: invocationLogs ?? this.invocationLogs,
    persist: persist ?? this.persist,
    extra: extra ?? this.extra,
  );
}

/// Trace settings for the Worker.
class ObservabilityTraces {
  const ObservabilityTraces({
    this.destinations,
    this.enabled,
    this.headSamplingRate,
    this.persist,
    this.propagationPolicy,
    this.extra = const <String, Object?>{},
  });

  factory ObservabilityTraces.fromJson(Map<String, Object?> json) =>
      ObservabilityTraces(
        destinations: asPrimitiveList<String>(json['destinations'], asString),
        enabled: asBool(json['enabled']),
        headSamplingRate: asNum(json['head_sampling_rate']),
        persist: asBool(json['persist']),
        propagationPolicy: asString(json['propagation_policy']),
        extra: extraOf(json, _knownKeys),
      );

  /// A list of destinations where traces will be exported to.
  final List<String>? destinations;

  /// Whether traces are enabled for the Worker.
  final bool? enabled;

  /// The sampling rate for traces. From 0 to 1 (1 = 100%, 0.1 = 10%). Default is
  /// 1.
  final num? headSamplingRate;

  /// Whether trace persistence is enabled for the Worker.
  final bool? persist;

  /// Controls how inbound trace context (traceparent/tracestate) headers on
  /// incoming requests are handled. "authenticated" (default) honors inbound
  /// trace context only when accompanied by a valid trace auth token. "accept"
  /// unconditionally accepts inbound trace context. Requires the trace
  /// propagation feature to be enabled. Allowed values: `authenticated`,
  /// `accept`.
  final String? propagationPolicy;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'destinations',
    'enabled',
    'head_sampling_rate',
    'persist',
    'propagation_policy',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (destinations != null) 'destinations': destinations!,
    if (enabled != null) 'enabled': enabled!,
    if (headSamplingRate != null) 'head_sampling_rate': headSamplingRate!,
    if (persist != null) 'persist': persist!,
    if (propagationPolicy != null) 'propagation_policy': propagationPolicy!,
  };

  ObservabilityTraces copyWith({
    List<String>? destinations,
    bool? enabled,
    num? headSamplingRate,
    bool? persist,
    String? propagationPolicy,
    Map<String, Object?>? extra,
  }) => ObservabilityTraces(
    destinations: destinations ?? this.destinations,
    enabled: enabled ?? this.enabled,
    headSamplingRate: headSamplingRate ?? this.headSamplingRate,
    persist: persist ?? this.persist,
    propagationPolicy: propagationPolicy ?? this.propagationPolicy,
    extra: extra ?? this.extra,
  );
}

class Organization {
  const Organization({
    this.id,
    this.name,
    this.permissions,
    this.roles,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory Organization.fromJson(Map<String, Object?> json) => Organization(
    id: asString(json['id']),
    name: asString(json['name']),
    permissions: asPrimitiveList<String>(json['permissions'], asString),
    roles: asPrimitiveList<String>(json['roles'], asString),
    status: asString(json['status']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Organization name.
  final String? name;

  /// Access permissions for this User.
  final List<String>? permissions;

  /// List of roles that a user has within an organization.
  final List<String>? roles;

  /// Whether the user is a member of the organization or has an invitation
  /// pending. Allowed values: `member`, `invited`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'id',
    'name',
    'permissions',
    'roles',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (permissions != null) 'permissions': permissions!,
    if (roles != null) 'roles': roles!,
    if (status != null) 'status': status!,
  };

  Organization copyWith({
    String? id,
    String? name,
    List<String>? permissions,
    List<String>? roles,
    String? status,
    Map<String, Object?>? extra,
  }) => Organization(
    id: id ?? this.id,
    name: name ?? this.name,
    permissions: permissions ?? this.permissions,
    roles: roles ?? this.roles,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

class PermissionGroupsListPermissionGroupsItem {
  const PermissionGroupsListPermissionGroupsItem({
    this.category,
    this.id,
    this.name,
    this.scopes,
    this.extra = const <String, Object?>{},
  });

  factory PermissionGroupsListPermissionGroupsItem.fromJson(
    Map<String, Object?> json,
  ) => PermissionGroupsListPermissionGroupsItem(
    category: asString(json['category']),
    id: asString(json['id']),
    name: asString(json['name']),
    scopes: asPrimitiveList<String>(json['scopes'], asString),
    extra: extraOf(json, _knownKeys),
  );

  /// Product category that this permission group belongs to. Allowed values:
  /// `developer_platform`, `ai_and_machine_learning`, `dns_and_zones`,
  /// `app_security`, `rules_and_configuration`, `cloudflare_one_and_zero_trust`,
  /// `analytics_and_logs`, `network_services`, `media`, `email_and_messaging`,
  /// `cache_and_performance`, `account_and_billing`, `other`.
  final String? category;

  /// Public ID.
  final String? id;

  /// Permission Group Name
  final String? name;

  /// Resources to which the Permission Group is scoped
  final List<String>? scopes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'category', 'id', 'name', 'scopes'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (category != null) 'category': category!,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (scopes != null) 'scopes': scopes!,
  };

  PermissionGroupsListPermissionGroupsItem copyWith({
    String? category,
    String? id,
    String? name,
    List<String>? scopes,
    Map<String, Object?>? extra,
  }) => PermissionGroupsListPermissionGroupsItem(
    category: category ?? this.category,
    id: id ?? this.id,
    name: name ?? this.name,
    scopes: scopes ?? this.scopes,
    extra: extra ?? this.extra,
  );
}

/// Configuration for [Smart
/// Placement](https://developers.cloudflare.com/workers/configuration/smart-placement).
/// Specify mode='smart' for Smart Placement, or one of region/hostname/host.
class PlacementInfo {
  const PlacementInfo({
    this.mode,
    this.region,
    this.hostname,
    this.host,
    this.target,
    this.lastAnalyzedAt,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory PlacementInfo.fromJson(Map<String, Object?> json) => PlacementInfo(
    mode: asString(json['mode']),
    region: asString(json['region']),
    hostname: asString(json['hostname']),
    host: asString(json['host']),
    target: asModelList(json['target'], PlacementTarget.fromJson),
    lastAnalyzedAt: asString(json['last_analyzed_at']),
    status: asString(json['status']),
    extra: extraOf(json, _knownKeys),
  );

  /// Targeted placement mode. Allowed values: `targeted`.
  final String? mode;

  /// Cloud region for targeted placement in format 'provider:region'.
  final String? region;

  /// HTTP hostname for targeted placement.
  final String? hostname;

  /// TCP host and port for targeted placement.
  final String? host;

  /// Array of placement targets (currently limited to single target).
  final List<PlacementTarget>? target;

  /// The last time the script was analyzed for [Smart
  /// Placement](https://developers.cloudflare.com/workers/configuration/smart-placement).
  final String? lastAnalyzedAt;

  /// Status of [Smart
  /// Placement](https://developers.cloudflare.com/workers/configuration/smart-placement).
  /// Allowed values: `SUCCESS`, `UNSUPPORTED_APPLICATION`,
  /// `INSUFFICIENT_INVOCATIONS`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'mode',
    'region',
    'hostname',
    'host',
    'target',
    'last_analyzed_at',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (mode != null) 'mode': mode!,
    if (region != null) 'region': region!,
    if (hostname != null) 'hostname': hostname!,
    if (host != null) 'host': host!,
    if (target != null) 'target': target!.map((e) => e.toJson()).toList(),
    if (lastAnalyzedAt != null) 'last_analyzed_at': lastAnalyzedAt!,
    if (status != null) 'status': status!,
  };

  PlacementInfo copyWith({
    String? mode,
    String? region,
    String? hostname,
    String? host,
    List<PlacementTarget>? target,
    String? lastAnalyzedAt,
    String? status,
    Map<String, Object?>? extra,
  }) => PlacementInfo(
    mode: mode ?? this.mode,
    region: region ?? this.region,
    hostname: hostname ?? this.hostname,
    host: host ?? this.host,
    target: target ?? this.target,
    lastAnalyzedAt: lastAnalyzedAt ?? this.lastAnalyzedAt,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

/// A target to run your Worker near.
class PlacementTarget {
  const PlacementTarget({
    this.region,
    this.hostname,
    this.host,
    this.extra = const <String, Object?>{},
  });

  factory PlacementTarget.fromJson(Map<String, Object?> json) =>
      PlacementTarget(
        region: asString(json['region']),
        hostname: asString(json['hostname']),
        host: asString(json['host']),
        extra: extraOf(json, _knownKeys),
      );

  /// Cloud region in format 'provider:region'.
  final String? region;

  /// HTTP hostname for targeted placement.
  final String? hostname;

  /// TCP host:port for targeted placement.
  final String? host;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'region', 'hostname', 'host'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (region != null) 'region': region!,
    if (hostname != null) 'hostname': hostname!,
    if (host != null) 'host': host!,
  };

  PlacementTarget copyWith({
    String? region,
    String? hostname,
    String? host,
    Map<String, Object?>? extra,
  }) => PlacementTarget(
    region: region ?? this.region,
    hostname: hostname ?? this.hostname,
    host: host ?? this.host,
    extra: extra ?? this.extra,
  );
}

class Project {
  const Project({
    this.buildConfig,
    this.canonicalDeployment,
    this.createdOn,
    this.deploymentConfigs,
    this.domains,
    this.framework,
    this.frameworkVersion,
    this.id,
    this.latestDeployment,
    this.name,
    this.previewScriptName,
    this.productionBranch,
    this.productionScriptName,
    this.source,
    this.subdomain,
    this.usesFunctions,
    this.extra = const <String, Object?>{},
  });

  factory Project.fromJson(Map<String, Object?> json) => Project(
    buildConfig: asModel(json['build_config'], BuildConfig.fromJson),
    canonicalDeployment: asModel(
      json['canonical_deployment'],
      ProjectCanonicalDeployment.fromJson,
    ),
    createdOn: asString(json['created_on']),
    deploymentConfigs: asModel(
      json['deployment_configs'],
      ProjectDeploymentConfigs.fromJson,
    ),
    domains: asPrimitiveList<String>(json['domains'], asString),
    framework: asString(json['framework']),
    frameworkVersion: asString(json['framework_version']),
    id: asString(json['id']),
    latestDeployment: asModel(
      json['latest_deployment'],
      ProjectLatestDeployment.fromJson,
    ),
    name: asString(json['name']),
    previewScriptName: asString(json['preview_script_name']),
    productionBranch: asString(json['production_branch']),
    productionScriptName: asString(json['production_script_name']),
    source: asModel(json['source'], Source.fromJson),
    subdomain: asString(json['subdomain']),
    usesFunctions: asBool(json['uses_functions']),
    extra: extraOf(json, _knownKeys),
  );

  /// Configs for the project build process.
  final BuildConfig? buildConfig;
  final ProjectCanonicalDeployment? canonicalDeployment;

  /// When the project was created.
  final String? createdOn;

  /// Configs for deployments in a project.
  final ProjectDeploymentConfigs? deploymentConfigs;

  /// A list of associated custom domains for the project.
  final List<String>? domains;

  /// Framework the project is using.
  final String? framework;

  /// Version of the framework the project is using.
  final String? frameworkVersion;

  /// ID of the project.
  final String? id;
  final ProjectLatestDeployment? latestDeployment;

  /// Name of the project.
  final String? name;

  /// Name of the preview script.
  final String? previewScriptName;

  /// Production branch of the project. Used to identify production deployments.
  final String? productionBranch;

  /// Name of the production script.
  final String? productionScriptName;

  /// Configs for the project source control.
  final Source? source;

  /// The Cloudflare subdomain associated with the project.
  final String? subdomain;

  /// Whether the project uses functions.
  final bool? usesFunctions;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'build_config',
    'canonical_deployment',
    'created_on',
    'deployment_configs',
    'domains',
    'framework',
    'framework_version',
    'id',
    'latest_deployment',
    'name',
    'preview_script_name',
    'production_branch',
    'production_script_name',
    'source',
    'subdomain',
    'uses_functions',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (buildConfig != null) 'build_config': buildConfig!.toJson(),
    if (canonicalDeployment != null)
      'canonical_deployment': canonicalDeployment!.toJson(),
    if (createdOn != null) 'created_on': createdOn!,
    if (deploymentConfigs != null)
      'deployment_configs': deploymentConfigs!.toJson(),
    if (domains != null) 'domains': domains!,
    if (framework != null) 'framework': framework!,
    if (frameworkVersion != null) 'framework_version': frameworkVersion!,
    if (id != null) 'id': id!,
    if (latestDeployment != null)
      'latest_deployment': latestDeployment!.toJson(),
    if (name != null) 'name': name!,
    if (previewScriptName != null) 'preview_script_name': previewScriptName!,
    if (productionBranch != null) 'production_branch': productionBranch!,
    if (productionScriptName != null)
      'production_script_name': productionScriptName!,
    if (source != null) 'source': source!.toJson(),
    if (subdomain != null) 'subdomain': subdomain!,
    if (usesFunctions != null) 'uses_functions': usesFunctions!,
  };

  Project copyWith({
    BuildConfig? buildConfig,
    ProjectCanonicalDeployment? canonicalDeployment,
    String? createdOn,
    ProjectDeploymentConfigs? deploymentConfigs,
    List<String>? domains,
    String? framework,
    String? frameworkVersion,
    String? id,
    ProjectLatestDeployment? latestDeployment,
    String? name,
    String? previewScriptName,
    String? productionBranch,
    String? productionScriptName,
    Source? source,
    String? subdomain,
    bool? usesFunctions,
    Map<String, Object?>? extra,
  }) => Project(
    buildConfig: buildConfig ?? this.buildConfig,
    canonicalDeployment: canonicalDeployment ?? this.canonicalDeployment,
    createdOn: createdOn ?? this.createdOn,
    deploymentConfigs: deploymentConfigs ?? this.deploymentConfigs,
    domains: domains ?? this.domains,
    framework: framework ?? this.framework,
    frameworkVersion: frameworkVersion ?? this.frameworkVersion,
    id: id ?? this.id,
    latestDeployment: latestDeployment ?? this.latestDeployment,
    name: name ?? this.name,
    previewScriptName: previewScriptName ?? this.previewScriptName,
    productionBranch: productionBranch ?? this.productionBranch,
    productionScriptName: productionScriptName ?? this.productionScriptName,
    source: source ?? this.source,
    subdomain: subdomain ?? this.subdomain,
    usesFunctions: usesFunctions ?? this.usesFunctions,
    extra: extra ?? this.extra,
  );
}

class ProjectCanonicalDeployment {
  const ProjectCanonicalDeployment({
    this.aliases,
    this.buildConfig,
    this.createdOn,
    this.deploymentTrigger,
    this.envVars,
    this.environment,
    this.id,
    this.isSkipped,
    this.latestStage,
    this.modifiedOn,
    this.projectId,
    this.projectName,
    this.shortId,
    this.skipReason,
    this.source,
    this.stages,
    this.url,
    this.usesFunctions,
    this.extra = const <String, Object?>{},
  });

  factory ProjectCanonicalDeployment.fromJson(Map<String, Object?> json) =>
      ProjectCanonicalDeployment(
        aliases: asPrimitiveList<String>(json['aliases'], asString),
        buildConfig: asModel(json['build_config'], BuildConfig.fromJson),
        createdOn: asString(json['created_on']),
        deploymentTrigger: asModel(
          json['deployment_trigger'],
          ProjectCanonicalDeploymentDeploymentTrigger.fromJson,
        ),
        envVars: asMap(json['env_vars']),
        environment: asString(json['environment']),
        id: asString(json['id']),
        isSkipped: asBool(json['is_skipped']),
        latestStage: asModel(json['latest_stage'], Stage.fromJson),
        modifiedOn: asString(json['modified_on']),
        projectId: asString(json['project_id']),
        projectName: asString(json['project_name']),
        shortId: asString(json['short_id']),
        skipReason: asString(json['skip_reason']),
        source: asModel(json['source'], Source.fromJson),
        stages: asModelList(json['stages'], Stage.fromJson),
        url: asString(json['url']),
        usesFunctions: asBool(json['uses_functions']),
        extra: extraOf(json, _knownKeys),
      );

  /// A list of alias URLs pointing to this deployment.
  final List<String>? aliases;

  /// Configs for the project build process.
  final BuildConfig? buildConfig;

  /// When the deployment was created.
  final String? createdOn;

  /// Info about what caused the deployment.
  final ProjectCanonicalDeploymentDeploymentTrigger? deploymentTrigger;

  /// Environment variables used for builds and Pages Functions.
  final Map<String, Object?>? envVars;

  /// Type of deploy. Allowed values: `preview`, `production`.
  final String? environment;

  /// Id of the deployment.
  final String? id;

  /// If the deployment has been skipped.
  final bool? isSkipped;

  /// The status of the deployment.
  final Stage? latestStage;

  /// When the deployment was last modified.
  final String? modifiedOn;

  /// Id of the project.
  final String? projectId;

  /// Name of the project.
  final String? projectName;

  /// Short Id (8 character) of the deployment.
  final String? shortId;

  /// Why the deployment was skipped. Allowed values: `commit_message`,
  /// `preview_deployments_disabled`, `production_deployments_disabled`,
  /// `path_config`, `branch_config`, `pages_to_workers_conversion`.
  final String? skipReason;

  /// Configs for the project source control.
  final Source? source;

  /// List of past stages.
  final List<Stage>? stages;

  /// The live URL to view this deployment.
  final String? url;

  /// Whether the deployment uses functions.
  final bool? usesFunctions;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'aliases',
    'build_config',
    'created_on',
    'deployment_trigger',
    'env_vars',
    'environment',
    'id',
    'is_skipped',
    'latest_stage',
    'modified_on',
    'project_id',
    'project_name',
    'short_id',
    'skip_reason',
    'source',
    'stages',
    'url',
    'uses_functions',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aliases != null) 'aliases': aliases!,
    if (buildConfig != null) 'build_config': buildConfig!.toJson(),
    if (createdOn != null) 'created_on': createdOn!,
    if (deploymentTrigger != null)
      'deployment_trigger': deploymentTrigger!.toJson(),
    if (envVars != null) 'env_vars': envVars!,
    if (environment != null) 'environment': environment!,
    if (id != null) 'id': id!,
    if (isSkipped != null) 'is_skipped': isSkipped!,
    if (latestStage != null) 'latest_stage': latestStage!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (projectId != null) 'project_id': projectId!,
    if (projectName != null) 'project_name': projectName!,
    if (shortId != null) 'short_id': shortId!,
    if (skipReason != null) 'skip_reason': skipReason!,
    if (source != null) 'source': source!.toJson(),
    if (stages != null) 'stages': stages!.map((e) => e.toJson()).toList(),
    if (url != null) 'url': url!,
    if (usesFunctions != null) 'uses_functions': usesFunctions!,
  };

  ProjectCanonicalDeployment copyWith({
    List<String>? aliases,
    BuildConfig? buildConfig,
    String? createdOn,
    ProjectCanonicalDeploymentDeploymentTrigger? deploymentTrigger,
    Map<String, Object?>? envVars,
    String? environment,
    String? id,
    bool? isSkipped,
    Stage? latestStage,
    String? modifiedOn,
    String? projectId,
    String? projectName,
    String? shortId,
    String? skipReason,
    Source? source,
    List<Stage>? stages,
    String? url,
    bool? usesFunctions,
    Map<String, Object?>? extra,
  }) => ProjectCanonicalDeployment(
    aliases: aliases ?? this.aliases,
    buildConfig: buildConfig ?? this.buildConfig,
    createdOn: createdOn ?? this.createdOn,
    deploymentTrigger: deploymentTrigger ?? this.deploymentTrigger,
    envVars: envVars ?? this.envVars,
    environment: environment ?? this.environment,
    id: id ?? this.id,
    isSkipped: isSkipped ?? this.isSkipped,
    latestStage: latestStage ?? this.latestStage,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    shortId: shortId ?? this.shortId,
    skipReason: skipReason ?? this.skipReason,
    source: source ?? this.source,
    stages: stages ?? this.stages,
    url: url ?? this.url,
    usesFunctions: usesFunctions ?? this.usesFunctions,
    extra: extra ?? this.extra,
  );
}

/// Info about what caused the deployment.
class ProjectCanonicalDeploymentDeploymentTrigger {
  const ProjectCanonicalDeploymentDeploymentTrigger({
    this.metadata,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory ProjectCanonicalDeploymentDeploymentTrigger.fromJson(
    Map<String, Object?> json,
  ) => ProjectCanonicalDeploymentDeploymentTrigger(
    metadata: asModel(
      json['metadata'],
      ProjectCanonicalDeploymentDeploymentTriggerMetadata.fromJson,
    ),
    type_: asString(json['type']),
    extra: extraOf(json, _knownKeys),
  );

  /// Additional info about the trigger.
  final ProjectCanonicalDeploymentDeploymentTriggerMetadata? metadata;

  /// What caused the deployment. Allowed values: `github:push`, `ad_hoc`,
  /// `deploy_hook`.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'metadata', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (metadata != null) 'metadata': metadata!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  ProjectCanonicalDeploymentDeploymentTrigger copyWith({
    ProjectCanonicalDeploymentDeploymentTriggerMetadata? metadata,
    String? type_,
    Map<String, Object?>? extra,
  }) => ProjectCanonicalDeploymentDeploymentTrigger(
    metadata: metadata ?? this.metadata,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// Additional info about the trigger.
class ProjectCanonicalDeploymentDeploymentTriggerMetadata {
  const ProjectCanonicalDeploymentDeploymentTriggerMetadata({
    this.branch,
    this.commitDirty,
    this.commitHash,
    this.commitMessage,
    this.extra = const <String, Object?>{},
  });

  factory ProjectCanonicalDeploymentDeploymentTriggerMetadata.fromJson(
    Map<String, Object?> json,
  ) => ProjectCanonicalDeploymentDeploymentTriggerMetadata(
    branch: asString(json['branch']),
    commitDirty: asBool(json['commit_dirty']),
    commitHash: asString(json['commit_hash']),
    commitMessage: asString(json['commit_message']),
    extra: extraOf(json, _knownKeys),
  );

  /// Where the trigger happened.
  final String? branch;

  /// Whether the deployment trigger commit was dirty.
  final bool? commitDirty;

  /// Hash of the deployment trigger commit.
  final String? commitHash;

  /// Message of the deployment trigger commit.
  final String? commitMessage;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'branch',
    'commit_dirty',
    'commit_hash',
    'commit_message',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (branch != null) 'branch': branch!,
    if (commitDirty != null) 'commit_dirty': commitDirty!,
    if (commitHash != null) 'commit_hash': commitHash!,
    if (commitMessage != null) 'commit_message': commitMessage!,
  };

  ProjectCanonicalDeploymentDeploymentTriggerMetadata copyWith({
    String? branch,
    bool? commitDirty,
    String? commitHash,
    String? commitMessage,
    Map<String, Object?>? extra,
  }) => ProjectCanonicalDeploymentDeploymentTriggerMetadata(
    branch: branch ?? this.branch,
    commitDirty: commitDirty ?? this.commitDirty,
    commitHash: commitHash ?? this.commitHash,
    commitMessage: commitMessage ?? this.commitMessage,
    extra: extra ?? this.extra,
  );
}

/// Configs for deployments in a project.
class ProjectDeploymentConfigs {
  const ProjectDeploymentConfigs({
    this.preview,
    this.production,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigs.fromJson(Map<String, Object?> json) =>
      ProjectDeploymentConfigs(
        preview: asModel(
          json['preview'],
          ProjectDeploymentConfigsPreview.fromJson,
        ),
        production: asModel(
          json['production'],
          ProjectDeploymentConfigsProduction.fromJson,
        ),
        extra: extraOf(json, _knownKeys),
      );

  /// Configs for preview deploys.
  final ProjectDeploymentConfigsPreview? preview;

  /// Configs for production deploys.
  final ProjectDeploymentConfigsProduction? production;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'preview', 'production'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (preview != null) 'preview': preview!.toJson(),
    if (production != null) 'production': production!.toJson(),
  };

  ProjectDeploymentConfigs copyWith({
    ProjectDeploymentConfigsPreview? preview,
    ProjectDeploymentConfigsProduction? production,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigs(
    preview: preview ?? this.preview,
    production: production ?? this.production,
    extra: extra ?? this.extra,
  );
}

/// Configs for preview deploys.
class ProjectDeploymentConfigsPreview {
  const ProjectDeploymentConfigsPreview({
    this.aiBindings,
    this.alwaysUseLatestCompatibilityDate,
    this.analyticsEngineDatasets,
    this.browsers,
    this.buildImageMajorVersion,
    this.compatibilityDate,
    this.compatibilityFlags,
    this.d1Databases,
    this.durableObjectNamespaces,
    this.envVars,
    this.failOpen,
    this.hyperdriveBindings,
    this.kvNamespaces,
    this.limits,
    this.mtlsCertificates,
    this.placement,
    this.queueProducers,
    this.r2Buckets,
    this.services,
    this.usageModel,
    this.vectorizeBindings,
    this.wranglerConfigHash,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsPreview.fromJson(Map<String, Object?> json) =>
      ProjectDeploymentConfigsPreview(
        aiBindings: asMap(json['ai_bindings']),
        alwaysUseLatestCompatibilityDate: asBool(
          json['always_use_latest_compatibility_date'],
        ),
        analyticsEngineDatasets: asMap(json['analytics_engine_datasets']),
        browsers: asMap(json['browsers']),
        buildImageMajorVersion: asInt(json['build_image_major_version']),
        compatibilityDate: asString(json['compatibility_date']),
        compatibilityFlags: asPrimitiveList<String>(
          json['compatibility_flags'],
          asString,
        ),
        d1Databases: asMap(json['d1_databases']),
        durableObjectNamespaces: asMap(json['durable_object_namespaces']),
        envVars: asMap(json['env_vars']),
        failOpen: asBool(json['fail_open']),
        hyperdriveBindings: asMap(json['hyperdrive_bindings']),
        kvNamespaces: asMap(json['kv_namespaces']),
        limits: asModel(
          json['limits'],
          ProjectDeploymentConfigsPreviewLimits.fromJson,
        ),
        mtlsCertificates: asMap(json['mtls_certificates']),
        placement: asModel(
          json['placement'],
          ProjectDeploymentConfigsPreviewPlacement.fromJson,
        ),
        queueProducers: asMap(json['queue_producers']),
        r2Buckets: asMap(json['r2_buckets']),
        services: asMap(json['services']),
        usageModel: asString(json['usage_model']),
        vectorizeBindings: asMap(json['vectorize_bindings']),
        wranglerConfigHash: asString(json['wrangler_config_hash']),
        extra: extraOf(json, _knownKeys),
      );

  /// Constellation bindings used for Pages Functions.
  final Map<String, Object?>? aiBindings;

  /// Whether to always use the latest compatibility date for Pages Functions.
  final bool? alwaysUseLatestCompatibilityDate;

  /// Analytics Engine bindings used for Pages Functions.
  final Map<String, Object?>? analyticsEngineDatasets;

  /// Browser bindings used for Pages Functions.
  final Map<String, Object?>? browsers;

  /// The major version of the build image to use for Pages Functions.
  final int? buildImageMajorVersion;

  /// Compatibility date used for Pages Functions.
  final String? compatibilityDate;

  /// Compatibility flags used for Pages Functions.
  final List<String>? compatibilityFlags;

  /// D1 databases used for Pages Functions.
  final Map<String, Object?>? d1Databases;

  /// Durable Object namespaces used for Pages Functions.
  final Map<String, Object?>? durableObjectNamespaces;

  /// Environment variables used for builds and Pages Functions.
  final Map<String, Object?>? envVars;

  /// Whether to fail open when the deployment config cannot be applied.
  final bool? failOpen;

  /// Hyperdrive bindings used for Pages Functions.
  final Map<String, Object?>? hyperdriveBindings;

  /// KV namespaces used for Pages Functions.
  final Map<String, Object?>? kvNamespaces;

  /// Limits for Pages Functions.
  final ProjectDeploymentConfigsPreviewLimits? limits;

  /// mTLS bindings used for Pages Functions.
  final Map<String, Object?>? mtlsCertificates;

  /// Placement setting used for Pages Functions.
  final ProjectDeploymentConfigsPreviewPlacement? placement;

  /// Queue Producer bindings used for Pages Functions.
  final Map<String, Object?>? queueProducers;

  /// R2 buckets used for Pages Functions.
  final Map<String, Object?>? r2Buckets;

  /// Services used for Pages Functions.
  final Map<String, Object?>? services;

  /// The usage model for Pages Functions. Allowed values: `standard`, `bundled`,
  /// `unbound`.
  final String? usageModel;

  /// Vectorize bindings used for Pages Functions.
  final Map<String, Object?>? vectorizeBindings;

  /// Hash of the Wrangler configuration used for the deployment.
  final String? wranglerConfigHash;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'ai_bindings',
    'always_use_latest_compatibility_date',
    'analytics_engine_datasets',
    'browsers',
    'build_image_major_version',
    'compatibility_date',
    'compatibility_flags',
    'd1_databases',
    'durable_object_namespaces',
    'env_vars',
    'fail_open',
    'hyperdrive_bindings',
    'kv_namespaces',
    'limits',
    'mtls_certificates',
    'placement',
    'queue_producers',
    'r2_buckets',
    'services',
    'usage_model',
    'vectorize_bindings',
    'wrangler_config_hash',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aiBindings != null) 'ai_bindings': aiBindings!,
    if (alwaysUseLatestCompatibilityDate != null)
      'always_use_latest_compatibility_date': alwaysUseLatestCompatibilityDate!,
    if (analyticsEngineDatasets != null)
      'analytics_engine_datasets': analyticsEngineDatasets!,
    if (browsers != null) 'browsers': browsers!,
    if (buildImageMajorVersion != null)
      'build_image_major_version': buildImageMajorVersion!,
    if (compatibilityDate != null) 'compatibility_date': compatibilityDate!,
    if (compatibilityFlags != null) 'compatibility_flags': compatibilityFlags!,
    if (d1Databases != null) 'd1_databases': d1Databases!,
    if (durableObjectNamespaces != null)
      'durable_object_namespaces': durableObjectNamespaces!,
    if (envVars != null) 'env_vars': envVars!,
    if (failOpen != null) 'fail_open': failOpen!,
    if (hyperdriveBindings != null) 'hyperdrive_bindings': hyperdriveBindings!,
    if (kvNamespaces != null) 'kv_namespaces': kvNamespaces!,
    if (limits != null) 'limits': limits!.toJson(),
    if (mtlsCertificates != null) 'mtls_certificates': mtlsCertificates!,
    if (placement != null) 'placement': placement!.toJson(),
    if (queueProducers != null) 'queue_producers': queueProducers!,
    if (r2Buckets != null) 'r2_buckets': r2Buckets!,
    if (services != null) 'services': services!,
    if (usageModel != null) 'usage_model': usageModel!,
    if (vectorizeBindings != null) 'vectorize_bindings': vectorizeBindings!,
    if (wranglerConfigHash != null) 'wrangler_config_hash': wranglerConfigHash!,
  };

  ProjectDeploymentConfigsPreview copyWith({
    Map<String, Object?>? aiBindings,
    bool? alwaysUseLatestCompatibilityDate,
    Map<String, Object?>? analyticsEngineDatasets,
    Map<String, Object?>? browsers,
    int? buildImageMajorVersion,
    String? compatibilityDate,
    List<String>? compatibilityFlags,
    Map<String, Object?>? d1Databases,
    Map<String, Object?>? durableObjectNamespaces,
    Map<String, Object?>? envVars,
    bool? failOpen,
    Map<String, Object?>? hyperdriveBindings,
    Map<String, Object?>? kvNamespaces,
    ProjectDeploymentConfigsPreviewLimits? limits,
    Map<String, Object?>? mtlsCertificates,
    ProjectDeploymentConfigsPreviewPlacement? placement,
    Map<String, Object?>? queueProducers,
    Map<String, Object?>? r2Buckets,
    Map<String, Object?>? services,
    String? usageModel,
    Map<String, Object?>? vectorizeBindings,
    String? wranglerConfigHash,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsPreview(
    aiBindings: aiBindings ?? this.aiBindings,
    alwaysUseLatestCompatibilityDate:
        alwaysUseLatestCompatibilityDate ??
        this.alwaysUseLatestCompatibilityDate,
    analyticsEngineDatasets:
        analyticsEngineDatasets ?? this.analyticsEngineDatasets,
    browsers: browsers ?? this.browsers,
    buildImageMajorVersion:
        buildImageMajorVersion ?? this.buildImageMajorVersion,
    compatibilityDate: compatibilityDate ?? this.compatibilityDate,
    compatibilityFlags: compatibilityFlags ?? this.compatibilityFlags,
    d1Databases: d1Databases ?? this.d1Databases,
    durableObjectNamespaces:
        durableObjectNamespaces ?? this.durableObjectNamespaces,
    envVars: envVars ?? this.envVars,
    failOpen: failOpen ?? this.failOpen,
    hyperdriveBindings: hyperdriveBindings ?? this.hyperdriveBindings,
    kvNamespaces: kvNamespaces ?? this.kvNamespaces,
    limits: limits ?? this.limits,
    mtlsCertificates: mtlsCertificates ?? this.mtlsCertificates,
    placement: placement ?? this.placement,
    queueProducers: queueProducers ?? this.queueProducers,
    r2Buckets: r2Buckets ?? this.r2Buckets,
    services: services ?? this.services,
    usageModel: usageModel ?? this.usageModel,
    vectorizeBindings: vectorizeBindings ?? this.vectorizeBindings,
    wranglerConfigHash: wranglerConfigHash ?? this.wranglerConfigHash,
    extra: extra ?? this.extra,
  );
}

/// Limits for Pages Functions.
class ProjectDeploymentConfigsPreviewLimits {
  const ProjectDeploymentConfigsPreviewLimits({
    this.cpuMs,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsPreviewLimits.fromJson(
    Map<String, Object?> json,
  ) => ProjectDeploymentConfigsPreviewLimits(
    cpuMs: asInt(json['cpu_ms']),
    extra: extraOf(json, _knownKeys),
  );

  /// CPU time limit in milliseconds.
  final int? cpuMs;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'cpu_ms'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cpuMs != null) 'cpu_ms': cpuMs!,
  };

  ProjectDeploymentConfigsPreviewLimits copyWith({
    int? cpuMs,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsPreviewLimits(
    cpuMs: cpuMs ?? this.cpuMs,
    extra: extra ?? this.extra,
  );
}

/// Placement setting used for Pages Functions.
class ProjectDeploymentConfigsPreviewPlacement {
  const ProjectDeploymentConfigsPreviewPlacement({
    this.mode,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsPreviewPlacement.fromJson(
    Map<String, Object?> json,
  ) => ProjectDeploymentConfigsPreviewPlacement(
    mode: asString(json['mode']),
    extra: extraOf(json, _knownKeys),
  );

  /// Placement mode.
  final String? mode;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'mode'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (mode != null) 'mode': mode!,
  };

  ProjectDeploymentConfigsPreviewPlacement copyWith({
    String? mode,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsPreviewPlacement(
    mode: mode ?? this.mode,
    extra: extra ?? this.extra,
  );
}

/// Configs for production deploys.
class ProjectDeploymentConfigsProduction {
  const ProjectDeploymentConfigsProduction({
    this.aiBindings,
    this.alwaysUseLatestCompatibilityDate,
    this.analyticsEngineDatasets,
    this.browsers,
    this.buildImageMajorVersion,
    this.compatibilityDate,
    this.compatibilityFlags,
    this.d1Databases,
    this.durableObjectNamespaces,
    this.envVars,
    this.failOpen,
    this.hyperdriveBindings,
    this.kvNamespaces,
    this.limits,
    this.mtlsCertificates,
    this.placement,
    this.queueProducers,
    this.r2Buckets,
    this.services,
    this.usageModel,
    this.vectorizeBindings,
    this.wranglerConfigHash,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsProduction.fromJson(
    Map<String, Object?> json,
  ) => ProjectDeploymentConfigsProduction(
    aiBindings: asMap(json['ai_bindings']),
    alwaysUseLatestCompatibilityDate: asBool(
      json['always_use_latest_compatibility_date'],
    ),
    analyticsEngineDatasets: asMap(json['analytics_engine_datasets']),
    browsers: asMap(json['browsers']),
    buildImageMajorVersion: asInt(json['build_image_major_version']),
    compatibilityDate: asString(json['compatibility_date']),
    compatibilityFlags: asPrimitiveList<String>(
      json['compatibility_flags'],
      asString,
    ),
    d1Databases: asMap(json['d1_databases']),
    durableObjectNamespaces: asMap(json['durable_object_namespaces']),
    envVars: asMap(json['env_vars']),
    failOpen: asBool(json['fail_open']),
    hyperdriveBindings: asMap(json['hyperdrive_bindings']),
    kvNamespaces: asMap(json['kv_namespaces']),
    limits: asModel(
      json['limits'],
      ProjectDeploymentConfigsProductionLimits.fromJson,
    ),
    mtlsCertificates: asMap(json['mtls_certificates']),
    placement: asModel(
      json['placement'],
      ProjectDeploymentConfigsProductionPlacement.fromJson,
    ),
    queueProducers: asMap(json['queue_producers']),
    r2Buckets: asMap(json['r2_buckets']),
    services: asMap(json['services']),
    usageModel: asString(json['usage_model']),
    vectorizeBindings: asMap(json['vectorize_bindings']),
    wranglerConfigHash: asString(json['wrangler_config_hash']),
    extra: extraOf(json, _knownKeys),
  );

  /// Constellation bindings used for Pages Functions.
  final Map<String, Object?>? aiBindings;

  /// Whether to always use the latest compatibility date for Pages Functions.
  final bool? alwaysUseLatestCompatibilityDate;

  /// Analytics Engine bindings used for Pages Functions.
  final Map<String, Object?>? analyticsEngineDatasets;

  /// Browser bindings used for Pages Functions.
  final Map<String, Object?>? browsers;

  /// The major version of the build image to use for Pages Functions.
  final int? buildImageMajorVersion;

  /// Compatibility date used for Pages Functions.
  final String? compatibilityDate;

  /// Compatibility flags used for Pages Functions.
  final List<String>? compatibilityFlags;

  /// D1 databases used for Pages Functions.
  final Map<String, Object?>? d1Databases;

  /// Durable Object namespaces used for Pages Functions.
  final Map<String, Object?>? durableObjectNamespaces;

  /// Environment variables used for builds and Pages Functions.
  final Map<String, Object?>? envVars;

  /// Whether to fail open when the deployment config cannot be applied.
  final bool? failOpen;

  /// Hyperdrive bindings used for Pages Functions.
  final Map<String, Object?>? hyperdriveBindings;

  /// KV namespaces used for Pages Functions.
  final Map<String, Object?>? kvNamespaces;

  /// Limits for Pages Functions.
  final ProjectDeploymentConfigsProductionLimits? limits;

  /// mTLS bindings used for Pages Functions.
  final Map<String, Object?>? mtlsCertificates;

  /// Placement setting used for Pages Functions.
  final ProjectDeploymentConfigsProductionPlacement? placement;

  /// Queue Producer bindings used for Pages Functions.
  final Map<String, Object?>? queueProducers;

  /// R2 buckets used for Pages Functions.
  final Map<String, Object?>? r2Buckets;

  /// Services used for Pages Functions.
  final Map<String, Object?>? services;

  /// The usage model for Pages Functions. Allowed values: `standard`, `bundled`,
  /// `unbound`.
  final String? usageModel;

  /// Vectorize bindings used for Pages Functions.
  final Map<String, Object?>? vectorizeBindings;

  /// Hash of the Wrangler configuration used for the deployment.
  final String? wranglerConfigHash;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'ai_bindings',
    'always_use_latest_compatibility_date',
    'analytics_engine_datasets',
    'browsers',
    'build_image_major_version',
    'compatibility_date',
    'compatibility_flags',
    'd1_databases',
    'durable_object_namespaces',
    'env_vars',
    'fail_open',
    'hyperdrive_bindings',
    'kv_namespaces',
    'limits',
    'mtls_certificates',
    'placement',
    'queue_producers',
    'r2_buckets',
    'services',
    'usage_model',
    'vectorize_bindings',
    'wrangler_config_hash',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aiBindings != null) 'ai_bindings': aiBindings!,
    if (alwaysUseLatestCompatibilityDate != null)
      'always_use_latest_compatibility_date': alwaysUseLatestCompatibilityDate!,
    if (analyticsEngineDatasets != null)
      'analytics_engine_datasets': analyticsEngineDatasets!,
    if (browsers != null) 'browsers': browsers!,
    if (buildImageMajorVersion != null)
      'build_image_major_version': buildImageMajorVersion!,
    if (compatibilityDate != null) 'compatibility_date': compatibilityDate!,
    if (compatibilityFlags != null) 'compatibility_flags': compatibilityFlags!,
    if (d1Databases != null) 'd1_databases': d1Databases!,
    if (durableObjectNamespaces != null)
      'durable_object_namespaces': durableObjectNamespaces!,
    if (envVars != null) 'env_vars': envVars!,
    if (failOpen != null) 'fail_open': failOpen!,
    if (hyperdriveBindings != null) 'hyperdrive_bindings': hyperdriveBindings!,
    if (kvNamespaces != null) 'kv_namespaces': kvNamespaces!,
    if (limits != null) 'limits': limits!.toJson(),
    if (mtlsCertificates != null) 'mtls_certificates': mtlsCertificates!,
    if (placement != null) 'placement': placement!.toJson(),
    if (queueProducers != null) 'queue_producers': queueProducers!,
    if (r2Buckets != null) 'r2_buckets': r2Buckets!,
    if (services != null) 'services': services!,
    if (usageModel != null) 'usage_model': usageModel!,
    if (vectorizeBindings != null) 'vectorize_bindings': vectorizeBindings!,
    if (wranglerConfigHash != null) 'wrangler_config_hash': wranglerConfigHash!,
  };

  ProjectDeploymentConfigsProduction copyWith({
    Map<String, Object?>? aiBindings,
    bool? alwaysUseLatestCompatibilityDate,
    Map<String, Object?>? analyticsEngineDatasets,
    Map<String, Object?>? browsers,
    int? buildImageMajorVersion,
    String? compatibilityDate,
    List<String>? compatibilityFlags,
    Map<String, Object?>? d1Databases,
    Map<String, Object?>? durableObjectNamespaces,
    Map<String, Object?>? envVars,
    bool? failOpen,
    Map<String, Object?>? hyperdriveBindings,
    Map<String, Object?>? kvNamespaces,
    ProjectDeploymentConfigsProductionLimits? limits,
    Map<String, Object?>? mtlsCertificates,
    ProjectDeploymentConfigsProductionPlacement? placement,
    Map<String, Object?>? queueProducers,
    Map<String, Object?>? r2Buckets,
    Map<String, Object?>? services,
    String? usageModel,
    Map<String, Object?>? vectorizeBindings,
    String? wranglerConfigHash,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsProduction(
    aiBindings: aiBindings ?? this.aiBindings,
    alwaysUseLatestCompatibilityDate:
        alwaysUseLatestCompatibilityDate ??
        this.alwaysUseLatestCompatibilityDate,
    analyticsEngineDatasets:
        analyticsEngineDatasets ?? this.analyticsEngineDatasets,
    browsers: browsers ?? this.browsers,
    buildImageMajorVersion:
        buildImageMajorVersion ?? this.buildImageMajorVersion,
    compatibilityDate: compatibilityDate ?? this.compatibilityDate,
    compatibilityFlags: compatibilityFlags ?? this.compatibilityFlags,
    d1Databases: d1Databases ?? this.d1Databases,
    durableObjectNamespaces:
        durableObjectNamespaces ?? this.durableObjectNamespaces,
    envVars: envVars ?? this.envVars,
    failOpen: failOpen ?? this.failOpen,
    hyperdriveBindings: hyperdriveBindings ?? this.hyperdriveBindings,
    kvNamespaces: kvNamespaces ?? this.kvNamespaces,
    limits: limits ?? this.limits,
    mtlsCertificates: mtlsCertificates ?? this.mtlsCertificates,
    placement: placement ?? this.placement,
    queueProducers: queueProducers ?? this.queueProducers,
    r2Buckets: r2Buckets ?? this.r2Buckets,
    services: services ?? this.services,
    usageModel: usageModel ?? this.usageModel,
    vectorizeBindings: vectorizeBindings ?? this.vectorizeBindings,
    wranglerConfigHash: wranglerConfigHash ?? this.wranglerConfigHash,
    extra: extra ?? this.extra,
  );
}

/// Limits for Pages Functions.
class ProjectDeploymentConfigsProductionLimits {
  const ProjectDeploymentConfigsProductionLimits({
    this.cpuMs,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsProductionLimits.fromJson(
    Map<String, Object?> json,
  ) => ProjectDeploymentConfigsProductionLimits(
    cpuMs: asInt(json['cpu_ms']),
    extra: extraOf(json, _knownKeys),
  );

  /// CPU time limit in milliseconds.
  final int? cpuMs;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'cpu_ms'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cpuMs != null) 'cpu_ms': cpuMs!,
  };

  ProjectDeploymentConfigsProductionLimits copyWith({
    int? cpuMs,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsProductionLimits(
    cpuMs: cpuMs ?? this.cpuMs,
    extra: extra ?? this.extra,
  );
}

/// Placement setting used for Pages Functions.
class ProjectDeploymentConfigsProductionPlacement {
  const ProjectDeploymentConfigsProductionPlacement({
    this.mode,
    this.extra = const <String, Object?>{},
  });

  factory ProjectDeploymentConfigsProductionPlacement.fromJson(
    Map<String, Object?> json,
  ) => ProjectDeploymentConfigsProductionPlacement(
    mode: asString(json['mode']),
    extra: extraOf(json, _knownKeys),
  );

  /// Placement mode.
  final String? mode;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'mode'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (mode != null) 'mode': mode!,
  };

  ProjectDeploymentConfigsProductionPlacement copyWith({
    String? mode,
    Map<String, Object?>? extra,
  }) => ProjectDeploymentConfigsProductionPlacement(
    mode: mode ?? this.mode,
    extra: extra ?? this.extra,
  );
}

class ProjectLatestDeployment {
  const ProjectLatestDeployment({
    this.aliases,
    this.buildConfig,
    this.createdOn,
    this.deploymentTrigger,
    this.envVars,
    this.environment,
    this.id,
    this.isSkipped,
    this.latestStage,
    this.modifiedOn,
    this.projectId,
    this.projectName,
    this.shortId,
    this.skipReason,
    this.source,
    this.stages,
    this.url,
    this.usesFunctions,
    this.extra = const <String, Object?>{},
  });

  factory ProjectLatestDeployment.fromJson(Map<String, Object?> json) =>
      ProjectLatestDeployment(
        aliases: asPrimitiveList<String>(json['aliases'], asString),
        buildConfig: asModel(json['build_config'], BuildConfig.fromJson),
        createdOn: asString(json['created_on']),
        deploymentTrigger: asModel(
          json['deployment_trigger'],
          ProjectLatestDeploymentDeploymentTrigger.fromJson,
        ),
        envVars: asMap(json['env_vars']),
        environment: asString(json['environment']),
        id: asString(json['id']),
        isSkipped: asBool(json['is_skipped']),
        latestStage: asModel(json['latest_stage'], Stage.fromJson),
        modifiedOn: asString(json['modified_on']),
        projectId: asString(json['project_id']),
        projectName: asString(json['project_name']),
        shortId: asString(json['short_id']),
        skipReason: asString(json['skip_reason']),
        source: asModel(json['source'], Source.fromJson),
        stages: asModelList(json['stages'], Stage.fromJson),
        url: asString(json['url']),
        usesFunctions: asBool(json['uses_functions']),
        extra: extraOf(json, _knownKeys),
      );

  /// A list of alias URLs pointing to this deployment.
  final List<String>? aliases;

  /// Configs for the project build process.
  final BuildConfig? buildConfig;

  /// When the deployment was created.
  final String? createdOn;

  /// Info about what caused the deployment.
  final ProjectLatestDeploymentDeploymentTrigger? deploymentTrigger;

  /// Environment variables used for builds and Pages Functions.
  final Map<String, Object?>? envVars;

  /// Type of deploy. Allowed values: `preview`, `production`.
  final String? environment;

  /// Id of the deployment.
  final String? id;

  /// If the deployment has been skipped.
  final bool? isSkipped;

  /// The status of the deployment.
  final Stage? latestStage;

  /// When the deployment was last modified.
  final String? modifiedOn;

  /// Id of the project.
  final String? projectId;

  /// Name of the project.
  final String? projectName;

  /// Short Id (8 character) of the deployment.
  final String? shortId;

  /// Why the deployment was skipped. Allowed values: `commit_message`,
  /// `preview_deployments_disabled`, `production_deployments_disabled`,
  /// `path_config`, `branch_config`, `pages_to_workers_conversion`.
  final String? skipReason;

  /// Configs for the project source control.
  final Source? source;

  /// List of past stages.
  final List<Stage>? stages;

  /// The live URL to view this deployment.
  final String? url;

  /// Whether the deployment uses functions.
  final bool? usesFunctions;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'aliases',
    'build_config',
    'created_on',
    'deployment_trigger',
    'env_vars',
    'environment',
    'id',
    'is_skipped',
    'latest_stage',
    'modified_on',
    'project_id',
    'project_name',
    'short_id',
    'skip_reason',
    'source',
    'stages',
    'url',
    'uses_functions',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (aliases != null) 'aliases': aliases!,
    if (buildConfig != null) 'build_config': buildConfig!.toJson(),
    if (createdOn != null) 'created_on': createdOn!,
    if (deploymentTrigger != null)
      'deployment_trigger': deploymentTrigger!.toJson(),
    if (envVars != null) 'env_vars': envVars!,
    if (environment != null) 'environment': environment!,
    if (id != null) 'id': id!,
    if (isSkipped != null) 'is_skipped': isSkipped!,
    if (latestStage != null) 'latest_stage': latestStage!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (projectId != null) 'project_id': projectId!,
    if (projectName != null) 'project_name': projectName!,
    if (shortId != null) 'short_id': shortId!,
    if (skipReason != null) 'skip_reason': skipReason!,
    if (source != null) 'source': source!.toJson(),
    if (stages != null) 'stages': stages!.map((e) => e.toJson()).toList(),
    if (url != null) 'url': url!,
    if (usesFunctions != null) 'uses_functions': usesFunctions!,
  };

  ProjectLatestDeployment copyWith({
    List<String>? aliases,
    BuildConfig? buildConfig,
    String? createdOn,
    ProjectLatestDeploymentDeploymentTrigger? deploymentTrigger,
    Map<String, Object?>? envVars,
    String? environment,
    String? id,
    bool? isSkipped,
    Stage? latestStage,
    String? modifiedOn,
    String? projectId,
    String? projectName,
    String? shortId,
    String? skipReason,
    Source? source,
    List<Stage>? stages,
    String? url,
    bool? usesFunctions,
    Map<String, Object?>? extra,
  }) => ProjectLatestDeployment(
    aliases: aliases ?? this.aliases,
    buildConfig: buildConfig ?? this.buildConfig,
    createdOn: createdOn ?? this.createdOn,
    deploymentTrigger: deploymentTrigger ?? this.deploymentTrigger,
    envVars: envVars ?? this.envVars,
    environment: environment ?? this.environment,
    id: id ?? this.id,
    isSkipped: isSkipped ?? this.isSkipped,
    latestStage: latestStage ?? this.latestStage,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    shortId: shortId ?? this.shortId,
    skipReason: skipReason ?? this.skipReason,
    source: source ?? this.source,
    stages: stages ?? this.stages,
    url: url ?? this.url,
    usesFunctions: usesFunctions ?? this.usesFunctions,
    extra: extra ?? this.extra,
  );
}

/// Info about what caused the deployment.
class ProjectLatestDeploymentDeploymentTrigger {
  const ProjectLatestDeploymentDeploymentTrigger({
    this.metadata,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory ProjectLatestDeploymentDeploymentTrigger.fromJson(
    Map<String, Object?> json,
  ) => ProjectLatestDeploymentDeploymentTrigger(
    metadata: asModel(
      json['metadata'],
      ProjectLatestDeploymentDeploymentTriggerMetadata.fromJson,
    ),
    type_: asString(json['type']),
    extra: extraOf(json, _knownKeys),
  );

  /// Additional info about the trigger.
  final ProjectLatestDeploymentDeploymentTriggerMetadata? metadata;

  /// What caused the deployment. Allowed values: `github:push`, `ad_hoc`,
  /// `deploy_hook`.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'metadata', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (metadata != null) 'metadata': metadata!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  ProjectLatestDeploymentDeploymentTrigger copyWith({
    ProjectLatestDeploymentDeploymentTriggerMetadata? metadata,
    String? type_,
    Map<String, Object?>? extra,
  }) => ProjectLatestDeploymentDeploymentTrigger(
    metadata: metadata ?? this.metadata,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// Additional info about the trigger.
class ProjectLatestDeploymentDeploymentTriggerMetadata {
  const ProjectLatestDeploymentDeploymentTriggerMetadata({
    this.branch,
    this.commitDirty,
    this.commitHash,
    this.commitMessage,
    this.extra = const <String, Object?>{},
  });

  factory ProjectLatestDeploymentDeploymentTriggerMetadata.fromJson(
    Map<String, Object?> json,
  ) => ProjectLatestDeploymentDeploymentTriggerMetadata(
    branch: asString(json['branch']),
    commitDirty: asBool(json['commit_dirty']),
    commitHash: asString(json['commit_hash']),
    commitMessage: asString(json['commit_message']),
    extra: extraOf(json, _knownKeys),
  );

  /// Where the trigger happened.
  final String? branch;

  /// Whether the deployment trigger commit was dirty.
  final bool? commitDirty;

  /// Hash of the deployment trigger commit.
  final String? commitHash;

  /// Message of the deployment trigger commit.
  final String? commitMessage;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'branch',
    'commit_dirty',
    'commit_hash',
    'commit_message',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (branch != null) 'branch': branch!,
    if (commitDirty != null) 'commit_dirty': commitDirty!,
    if (commitHash != null) 'commit_hash': commitHash!,
    if (commitMessage != null) 'commit_message': commitMessage!,
  };

  ProjectLatestDeploymentDeploymentTriggerMetadata copyWith({
    String? branch,
    bool? commitDirty,
    String? commitHash,
    String? commitMessage,
    Map<String, Object?>? extra,
  }) => ProjectLatestDeploymentDeploymentTriggerMetadata(
    branch: branch ?? this.branch,
    commitDirty: commitDirty ?? this.commitDirty,
    commitHash: commitHash ?? this.commitHash,
    commitMessage: commitMessage ?? this.commitMessage,
    extra: extra ?? this.extra,
  );
}

class QueryMeta {
  const QueryMeta({
    this.changedDb,
    this.changes,
    this.duration,
    this.lastRowId,
    this.rowsRead,
    this.rowsWritten,
    this.servedByColo,
    this.servedByPrimary,
    this.servedByRegion,
    this.sizeAfter,
    this.timings,
    this.extra = const <String, Object?>{},
  });

  factory QueryMeta.fromJson(Map<String, Object?> json) => QueryMeta(
    changedDb: asBool(json['changed_db']),
    changes: asNum(json['changes']),
    duration: asNum(json['duration']),
    lastRowId: asNum(json['last_row_id']),
    rowsRead: asNum(json['rows_read']),
    rowsWritten: asNum(json['rows_written']),
    servedByColo: asString(json['served_by_colo']),
    servedByPrimary: asBool(json['served_by_primary']),
    servedByRegion: asString(json['served_by_region']),
    sizeAfter: asNum(json['size_after']),
    timings: asModel(json['timings'], QueryMetaTimings.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Denotes if the database has been altered in some way, like deleting rows.
  final bool? changedDb;

  /// Rough indication of how many rows were modified by the query, as provided by
  /// SQLite's `sqlite3_total_changes()`.
  final num? changes;

  /// The duration of the SQL query execution inside the database. Does not
  /// include any network communication.
  final num? duration;

  /// The row ID of the last inserted row in a table with an `INTEGER PRIMARY KEY`
  /// as provided by SQLite. Tables created with `WITHOUT ROWID` do not populate
  /// this.
  final num? lastRowId;

  /// Number of rows read during the SQL query execution, including indices (not
  /// all rows are necessarily returned).
  final num? rowsRead;

  /// Number of rows written during the SQL query execution, including indices.
  final num? rowsWritten;

  /// The three letters airport code of the colo that handled the query.
  final String? servedByColo;

  /// Denotes if the query has been handled by the database primary instance.
  final bool? servedByPrimary;

  /// Region location hint of the database instance that handled the query.
  /// Allowed values: `WNAM`, `ENAM`, `WEUR`, `EEUR`, `APAC`, `OC`.
  final String? servedByRegion;

  /// Size of the database after the query committed, in bytes.
  final num? sizeAfter;

  /// Various durations for the query.
  final QueryMetaTimings? timings;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'changed_db',
    'changes',
    'duration',
    'last_row_id',
    'rows_read',
    'rows_written',
    'served_by_colo',
    'served_by_primary',
    'served_by_region',
    'size_after',
    'timings',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (changedDb != null) 'changed_db': changedDb!,
    if (changes != null) 'changes': changes!,
    if (duration != null) 'duration': duration!,
    if (lastRowId != null) 'last_row_id': lastRowId!,
    if (rowsRead != null) 'rows_read': rowsRead!,
    if (rowsWritten != null) 'rows_written': rowsWritten!,
    if (servedByColo != null) 'served_by_colo': servedByColo!,
    if (servedByPrimary != null) 'served_by_primary': servedByPrimary!,
    if (servedByRegion != null) 'served_by_region': servedByRegion!,
    if (sizeAfter != null) 'size_after': sizeAfter!,
    if (timings != null) 'timings': timings!.toJson(),
  };

  QueryMeta copyWith({
    bool? changedDb,
    num? changes,
    num? duration,
    num? lastRowId,
    num? rowsRead,
    num? rowsWritten,
    String? servedByColo,
    bool? servedByPrimary,
    String? servedByRegion,
    num? sizeAfter,
    QueryMetaTimings? timings,
    Map<String, Object?>? extra,
  }) => QueryMeta(
    changedDb: changedDb ?? this.changedDb,
    changes: changes ?? this.changes,
    duration: duration ?? this.duration,
    lastRowId: lastRowId ?? this.lastRowId,
    rowsRead: rowsRead ?? this.rowsRead,
    rowsWritten: rowsWritten ?? this.rowsWritten,
    servedByColo: servedByColo ?? this.servedByColo,
    servedByPrimary: servedByPrimary ?? this.servedByPrimary,
    servedByRegion: servedByRegion ?? this.servedByRegion,
    sizeAfter: sizeAfter ?? this.sizeAfter,
    timings: timings ?? this.timings,
    extra: extra ?? this.extra,
  );
}

/// Various durations for the query.
class QueryMetaTimings {
  const QueryMetaTimings({
    this.sqlDurationMs,
    this.extra = const <String, Object?>{},
  });

  factory QueryMetaTimings.fromJson(Map<String, Object?> json) =>
      QueryMetaTimings(
        sqlDurationMs: asNum(json['sql_duration_ms']),
        extra: extraOf(json, _knownKeys),
      );

  /// The duration of the SQL query execution inside the database. Does not
  /// include any network communication.
  final num? sqlDurationMs;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'sql_duration_ms'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (sqlDurationMs != null) 'sql_duration_ms': sqlDurationMs!,
  };

  QueryMetaTimings copyWith({
    num? sqlDurationMs,
    Map<String, Object?>? extra,
  }) => QueryMetaTimings(
    sqlDurationMs: sqlDurationMs ?? this.sqlDurationMs,
    extra: extra ?? this.extra,
  );
}

class QueryResultResponse {
  const QueryResultResponse({
    this.meta,
    this.results,
    this.success,
    this.extra = const <String, Object?>{},
  });

  factory QueryResultResponse.fromJson(Map<String, Object?> json) =>
      QueryResultResponse(
        meta: asModel(json['meta'], QueryMeta.fromJson),
        results: asObjectList(json['results']),
        success: asBool(json['success']),
        extra: extraOf(json, _knownKeys),
      );

  final QueryMeta? meta;
  final List<Object?>? results;
  final bool? success;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'meta', 'results', 'success'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (meta != null) 'meta': meta!.toJson(),
    if (results != null) 'results': results!,
    if (success != null) 'success': success!,
  };

  QueryResultResponse copyWith({
    QueryMeta? meta,
    List<Object?>? results,
    bool? success,
    Map<String, Object?>? extra,
  }) => QueryResultResponse(
    meta: meta ?? this.meta,
    results: results ?? this.results,
    success: success ?? this.success,
    extra: extra ?? this.extra,
  );
}

class R2ListBucketsResult {
  const R2ListBucketsResult({
    this.buckets,
    this.extra = const <String, Object?>{},
  });

  factory R2ListBucketsResult.fromJson(Map<String, Object?> json) =>
      R2ListBucketsResult(
        buckets: asModelList(json['buckets'], Bucket.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  final List<Bucket>? buckets;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'buckets'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (buckets != null) 'buckets': buckets!.map((e) => e.toJson()).toList(),
  };

  R2ListBucketsResult copyWith({
    List<Bucket>? buckets,
    Map<String, Object?>? extra,
  }) => R2ListBucketsResult(
    buckets: buckets ?? this.buckets,
    extra: extra ?? this.extra,
  );
}

class ResponseRule {
  const ResponseRule({
    this.action,
    this.actionParameters,
    this.categories,
    this.description,
    this.enabled,
    this.exposedCredentialCheck,
    this.expression,
    this.id,
    this.lastUpdated,
    this.logging,
    this.ratelimit,
    this.ref,
    this.version,
    this.extra = const <String, Object?>{},
  });

  factory ResponseRule.fromJson(Map<String, Object?> json) => ResponseRule(
    action: json['action'],
    actionParameters: asModel(
      json['action_parameters'],
      ResponseRuleActionParameters.fromJson,
    ),
    categories: asPrimitiveList<String>(json['categories'], asString),
    description: json['description'],
    enabled: json['enabled'],
    exposedCredentialCheck: asModel(
      json['exposed_credential_check'],
      RuleExposedCredentialCheck.fromJson,
    ),
    expression: asString(json['expression']),
    id: asString(json['id']),
    lastUpdated: asString(json['last_updated']),
    logging: asModel(json['logging'], RuleLogging.fromJson),
    ratelimit: asModel(json['ratelimit'], RuleRatelimit.fromJson),
    ref: asString(json['ref']),
    version: asString(json['version']),
    extra: extraOf(json, _knownKeys),
  );

  /// Allowed values: `transform_response_html`.
  final Object? action;
  final ResponseRuleActionParameters? actionParameters;

  /// The categories of the rule.
  final List<String>? categories;
  final Object? description;
  final Object? enabled;

  /// Configuration for exposed credential checking.
  final RuleExposedCredentialCheck? exposedCredentialCheck;

  /// The expression defining which traffic will match the rule.
  final String? expression;

  /// The unique ID of the rule.
  final String? id;

  /// The timestamp of when the rule was last modified.
  final String? lastUpdated;

  /// An object configuring the rule's logging behavior.
  final RuleLogging? logging;

  /// An object configuring the rule's rate limit behavior.
  final RuleRatelimit? ratelimit;

  /// The reference of the rule (the rule's ID by default).
  final String? ref;

  /// The version of the rule.
  final String? version;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'action',
    'action_parameters',
    'categories',
    'description',
    'enabled',
    'exposed_credential_check',
    'expression',
    'id',
    'last_updated',
    'logging',
    'ratelimit',
    'ref',
    'version',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (action != null) 'action': action!,
    if (actionParameters != null)
      'action_parameters': actionParameters!.toJson(),
    if (categories != null) 'categories': categories!,
    if (description != null) 'description': description!,
    if (enabled != null) 'enabled': enabled!,
    if (exposedCredentialCheck != null)
      'exposed_credential_check': exposedCredentialCheck!.toJson(),
    if (expression != null) 'expression': expression!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (logging != null) 'logging': logging!.toJson(),
    if (ratelimit != null) 'ratelimit': ratelimit!.toJson(),
    if (ref != null) 'ref': ref!,
    if (version != null) 'version': version!,
  };

  ResponseRule copyWith({
    Object? action,
    ResponseRuleActionParameters? actionParameters,
    List<String>? categories,
    Object? description,
    Object? enabled,
    RuleExposedCredentialCheck? exposedCredentialCheck,
    String? expression,
    String? id,
    String? lastUpdated,
    RuleLogging? logging,
    RuleRatelimit? ratelimit,
    String? ref,
    String? version,
    Map<String, Object?>? extra,
  }) => ResponseRule(
    action: action ?? this.action,
    actionParameters: actionParameters ?? this.actionParameters,
    categories: categories ?? this.categories,
    description: description ?? this.description,
    enabled: enabled ?? this.enabled,
    exposedCredentialCheck:
        exposedCredentialCheck ?? this.exposedCredentialCheck,
    expression: expression ?? this.expression,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    logging: logging ?? this.logging,
    ratelimit: ratelimit ?? this.ratelimit,
    ref: ref ?? this.ref,
    version: version ?? this.version,
    extra: extra ?? this.extra,
  );
}

class ResponseRuleActionParameters {
  const ResponseRuleActionParameters({
    this.linkMaze,
    this.extra = const <String, Object?>{},
  });

  factory ResponseRuleActionParameters.fromJson(Map<String, Object?> json) =>
      ResponseRuleActionParameters(
        linkMaze: asMap(json['link_maze']),
        extra: extraOf(json, _knownKeys),
      );

  /// Enables the link maze transformation on the response.
  final Map<String, Object?>? linkMaze;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'link_maze'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (linkMaze != null) 'link_maze': linkMaze!,
  };

  ResponseRuleActionParameters copyWith({
    Map<String, Object?>? linkMaze,
    Map<String, Object?>? extra,
  }) => ResponseRuleActionParameters(
    linkMaze: linkMaze ?? this.linkMaze,
    extra: extra ?? this.extra,
  );
}

class Route {
  const Route({
    this.id,
    this.pattern,
    this.script,
    this.extra = const <String, Object?>{},
  });

  factory Route.fromJson(Map<String, Object?> json) => Route(
    id: json['id'],
    pattern: asString(json['pattern']),
    script: asString(json['script']),
    extra: extraOf(json, _knownKeys),
  );

  final Object? id;

  /// Pattern to match incoming requests against. [Learn
  /// more](https://developers.cloudflare.com/workers/configuration/routing/routes/#matching-behavior).
  final String? pattern;

  /// Name of the script to run if the route matches.
  final String? script;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'pattern', 'script'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (pattern != null) 'pattern': pattern!,
    if (script != null) 'script': script!,
  };

  Route copyWith({
    Object? id,
    String? pattern,
    String? script,
    Map<String, Object?>? extra,
  }) => Route(
    id: id ?? this.id,
    pattern: pattern ?? this.pattern,
    script: script ?? this.script,
    extra: extra ?? this.extra,
  );
}

class Rule {
  const Rule({
    this.allowedModes,
    this.configuration,
    this.createdOn,
    this.id,
    this.mode,
    this.modifiedOn,
    this.notes,
    this.extra = const <String, Object?>{},
  });

  factory Rule.fromJson(Map<String, Object?> json) => Rule(
    allowedModes: asPrimitiveList<String>(json['allowed_modes'], asString),
    configuration: asModel(json['configuration'], Configuration.fromJson),
    createdOn: asString(json['created_on']),
    id: asString(json['id']),
    mode: asString(json['mode']),
    modifiedOn: asString(json['modified_on']),
    notes: asString(json['notes']),
    extra: extraOf(json, _knownKeys),
  );

  /// The available actions that a rule can apply to a matched request.
  final List<String>? allowedModes;

  /// The rule configuration.
  final Configuration? configuration;

  /// The timestamp of when the rule was created.
  final String? createdOn;

  /// The unique identifier of the IP Access rule.
  final String? id;

  /// The action to apply to a matched request. Allowed values: `block`,
  /// `challenge`, `whitelist`, `js_challenge`, `managed_challenge`.
  final String? mode;

  /// The timestamp of when the rule was last modified.
  final String? modifiedOn;

  /// An informative summary of the rule, typically used as a reminder or
  /// explanation.
  final String? notes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'allowed_modes',
    'configuration',
    'created_on',
    'id',
    'mode',
    'modified_on',
    'notes',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (allowedModes != null) 'allowed_modes': allowedModes!,
    if (configuration != null) 'configuration': configuration!.toJson(),
    if (createdOn != null) 'created_on': createdOn!,
    if (id != null) 'id': id!,
    if (mode != null) 'mode': mode!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (notes != null) 'notes': notes!,
  };

  Rule copyWith({
    List<String>? allowedModes,
    Configuration? configuration,
    String? createdOn,
    String? id,
    String? mode,
    String? modifiedOn,
    String? notes,
    Map<String, Object?>? extra,
  }) => Rule(
    allowedModes: allowedModes ?? this.allowedModes,
    configuration: configuration ?? this.configuration,
    createdOn: createdOn ?? this.createdOn,
    id: id ?? this.id,
    mode: mode ?? this.mode,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    notes: notes ?? this.notes,
    extra: extra ?? this.extra,
  );
}

class Rule2 {
  const Rule2({
    this.group,
    this.anyValidServiceToken,
    this.authContext,
    this.authMethod,
    this.azureAd,
    this.certificate,
    this.commonName,
    this.geo,
    this.devicePosture,
    this.emailDomain,
    this.emailList,
    this.email,
    this.everyone,
    this.externalEvaluation,
    this.githubOrganization,
    this.gsuite,
    this.loginMethod,
    this.ipList,
    this.ip,
    this.okta,
    this.saml,
    this.oidc,
    this.serviceToken,
    this.linkedAppToken,
    this.userRiskScore,
    this.cloudflareAccountMember,
    this.extra = const <String, Object?>{},
  });

  factory Rule2.fromJson(Map<String, Object?> json) => Rule2(
    group: asModel(json['group'], Rule2Group.fromJson),
    anyValidServiceToken: asMap(json['any_valid_service_token']),
    authContext: asModel(json['auth_context'], Rule2AuthContext.fromJson),
    authMethod: asModel(json['auth_method'], Rule2AuthMethod.fromJson),
    azureAd: asModel(json['azureAD'], Rule2AzureAd.fromJson),
    certificate: asMap(json['certificate']),
    commonName: asModel(json['common_name'], Rule2CommonName.fromJson),
    geo: asModel(json['geo'], Rule2Geo.fromJson),
    devicePosture: asModel(json['device_posture'], Rule2DevicePosture.fromJson),
    emailDomain: asModel(json['email_domain'], Rule2EmailDomain.fromJson),
    emailList: asModel(json['email_list'], Rule2EmailList.fromJson),
    email: asModel(json['email'], Rule2Email.fromJson),
    everyone: asMap(json['everyone']),
    externalEvaluation: asModel(
      json['external_evaluation'],
      Rule2ExternalEvaluation.fromJson,
    ),
    githubOrganization: asModel(
      json['github-organization'],
      Rule2GithubOrganization.fromJson,
    ),
    gsuite: asModel(json['gsuite'], Rule2Gsuite.fromJson),
    loginMethod: asModel(json['login_method'], Rule2LoginMethod.fromJson),
    ipList: asModel(json['ip_list'], Rule2IpList.fromJson),
    ip: asModel(json['ip'], Rule2Ip.fromJson),
    okta: asModel(json['okta'], Rule2Okta.fromJson),
    saml: asModel(json['saml'], Rule2Saml.fromJson),
    oidc: asModel(json['oidc'], Rule2Oidc.fromJson),
    serviceToken: asModel(json['service_token'], Rule2ServiceToken.fromJson),
    linkedAppToken: asModel(
      json['linked_app_token'],
      Rule2LinkedAppToken.fromJson,
    ),
    userRiskScore: asModel(
      json['user_risk_score'],
      Rule2UserRiskScore.fromJson,
    ),
    cloudflareAccountMember: asModel(
      json['cloudflare_account_member'],
      Rule2CloudflareAccountMember.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  final Rule2Group? group;

  /// An empty object which matches on all service tokens.
  final Map<String, Object?>? anyValidServiceToken;
  final Rule2AuthContext? authContext;
  final Rule2AuthMethod? authMethod;
  final Rule2AzureAd? azureAd;
  final Map<String, Object?>? certificate;
  final Rule2CommonName? commonName;
  final Rule2Geo? geo;
  final Rule2DevicePosture? devicePosture;
  final Rule2EmailDomain? emailDomain;
  final Rule2EmailList? emailList;
  final Rule2Email? email;

  /// An empty object which matches on all users.
  final Map<String, Object?>? everyone;
  final Rule2ExternalEvaluation? externalEvaluation;
  final Rule2GithubOrganization? githubOrganization;
  final Rule2Gsuite? gsuite;
  final Rule2LoginMethod? loginMethod;
  final Rule2IpList? ipList;
  final Rule2Ip? ip;
  final Rule2Okta? okta;
  final Rule2Saml? saml;
  final Rule2Oidc? oidc;
  final Rule2ServiceToken? serviceToken;
  final Rule2LinkedAppToken? linkedAppToken;
  final Rule2UserRiskScore? userRiskScore;
  final Rule2CloudflareAccountMember? cloudflareAccountMember;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'group',
    'any_valid_service_token',
    'auth_context',
    'auth_method',
    'azureAD',
    'certificate',
    'common_name',
    'geo',
    'device_posture',
    'email_domain',
    'email_list',
    'email',
    'everyone',
    'external_evaluation',
    'github-organization',
    'gsuite',
    'login_method',
    'ip_list',
    'ip',
    'okta',
    'saml',
    'oidc',
    'service_token',
    'linked_app_token',
    'user_risk_score',
    'cloudflare_account_member',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (group != null) 'group': group!.toJson(),
    if (anyValidServiceToken != null)
      'any_valid_service_token': anyValidServiceToken!,
    if (authContext != null) 'auth_context': authContext!.toJson(),
    if (authMethod != null) 'auth_method': authMethod!.toJson(),
    if (azureAd != null) 'azureAD': azureAd!.toJson(),
    if (certificate != null) 'certificate': certificate!,
    if (commonName != null) 'common_name': commonName!.toJson(),
    if (geo != null) 'geo': geo!.toJson(),
    if (devicePosture != null) 'device_posture': devicePosture!.toJson(),
    if (emailDomain != null) 'email_domain': emailDomain!.toJson(),
    if (emailList != null) 'email_list': emailList!.toJson(),
    if (email != null) 'email': email!.toJson(),
    if (everyone != null) 'everyone': everyone!,
    if (externalEvaluation != null)
      'external_evaluation': externalEvaluation!.toJson(),
    if (githubOrganization != null)
      'github-organization': githubOrganization!.toJson(),
    if (gsuite != null) 'gsuite': gsuite!.toJson(),
    if (loginMethod != null) 'login_method': loginMethod!.toJson(),
    if (ipList != null) 'ip_list': ipList!.toJson(),
    if (ip != null) 'ip': ip!.toJson(),
    if (okta != null) 'okta': okta!.toJson(),
    if (saml != null) 'saml': saml!.toJson(),
    if (oidc != null) 'oidc': oidc!.toJson(),
    if (serviceToken != null) 'service_token': serviceToken!.toJson(),
    if (linkedAppToken != null) 'linked_app_token': linkedAppToken!.toJson(),
    if (userRiskScore != null) 'user_risk_score': userRiskScore!.toJson(),
    if (cloudflareAccountMember != null)
      'cloudflare_account_member': cloudflareAccountMember!.toJson(),
  };

  Rule2 copyWith({
    Rule2Group? group,
    Map<String, Object?>? anyValidServiceToken,
    Rule2AuthContext? authContext,
    Rule2AuthMethod? authMethod,
    Rule2AzureAd? azureAd,
    Map<String, Object?>? certificate,
    Rule2CommonName? commonName,
    Rule2Geo? geo,
    Rule2DevicePosture? devicePosture,
    Rule2EmailDomain? emailDomain,
    Rule2EmailList? emailList,
    Rule2Email? email,
    Map<String, Object?>? everyone,
    Rule2ExternalEvaluation? externalEvaluation,
    Rule2GithubOrganization? githubOrganization,
    Rule2Gsuite? gsuite,
    Rule2LoginMethod? loginMethod,
    Rule2IpList? ipList,
    Rule2Ip? ip,
    Rule2Okta? okta,
    Rule2Saml? saml,
    Rule2Oidc? oidc,
    Rule2ServiceToken? serviceToken,
    Rule2LinkedAppToken? linkedAppToken,
    Rule2UserRiskScore? userRiskScore,
    Rule2CloudflareAccountMember? cloudflareAccountMember,
    Map<String, Object?>? extra,
  }) => Rule2(
    group: group ?? this.group,
    anyValidServiceToken: anyValidServiceToken ?? this.anyValidServiceToken,
    authContext: authContext ?? this.authContext,
    authMethod: authMethod ?? this.authMethod,
    azureAd: azureAd ?? this.azureAd,
    certificate: certificate ?? this.certificate,
    commonName: commonName ?? this.commonName,
    geo: geo ?? this.geo,
    devicePosture: devicePosture ?? this.devicePosture,
    emailDomain: emailDomain ?? this.emailDomain,
    emailList: emailList ?? this.emailList,
    email: email ?? this.email,
    everyone: everyone ?? this.everyone,
    externalEvaluation: externalEvaluation ?? this.externalEvaluation,
    githubOrganization: githubOrganization ?? this.githubOrganization,
    gsuite: gsuite ?? this.gsuite,
    loginMethod: loginMethod ?? this.loginMethod,
    ipList: ipList ?? this.ipList,
    ip: ip ?? this.ip,
    okta: okta ?? this.okta,
    saml: saml ?? this.saml,
    oidc: oidc ?? this.oidc,
    serviceToken: serviceToken ?? this.serviceToken,
    linkedAppToken: linkedAppToken ?? this.linkedAppToken,
    userRiskScore: userRiskScore ?? this.userRiskScore,
    cloudflareAccountMember:
        cloudflareAccountMember ?? this.cloudflareAccountMember,
    extra: extra ?? this.extra,
  );
}

class Rule2AuthContext {
  const Rule2AuthContext({
    this.acId,
    this.id,
    this.identityProviderId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2AuthContext.fromJson(Map<String, Object?> json) =>
      Rule2AuthContext(
        acId: asString(json['ac_id']),
        id: asString(json['id']),
        identityProviderId: asString(json['identity_provider_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ACID of an Authentication context.
  final String? acId;

  /// The ID of an Authentication context.
  final String? id;

  /// The ID of your Azure identity provider.
  final String? identityProviderId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ac_id', 'id', 'identity_provider_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (acId != null) 'ac_id': acId!,
    if (id != null) 'id': id!,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
  };

  Rule2AuthContext copyWith({
    String? acId,
    String? id,
    String? identityProviderId,
    Map<String, Object?>? extra,
  }) => Rule2AuthContext(
    acId: acId ?? this.acId,
    id: id ?? this.id,
    identityProviderId: identityProviderId ?? this.identityProviderId,
    extra: extra ?? this.extra,
  );
}

class Rule2AuthMethod {
  const Rule2AuthMethod({
    this.authMethod,
    this.extra = const <String, Object?>{},
  });

  factory Rule2AuthMethod.fromJson(Map<String, Object?> json) =>
      Rule2AuthMethod(
        authMethod: asString(json['auth_method']),
        extra: extraOf(json, _knownKeys),
      );

  /// The type of authentication method
  /// https://datatracker.ietf.org/doc/html/rfc8176#section-2.
  final String? authMethod;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'auth_method'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (authMethod != null) 'auth_method': authMethod!,
  };

  Rule2AuthMethod copyWith({String? authMethod, Map<String, Object?>? extra}) =>
      Rule2AuthMethod(
        authMethod: authMethod ?? this.authMethod,
        extra: extra ?? this.extra,
      );
}

class Rule2AzureAd {
  const Rule2AzureAd({
    this.id,
    this.identityProviderId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2AzureAd.fromJson(Map<String, Object?> json) => Rule2AzureAd(
    id: asString(json['id']),
    identityProviderId: asString(json['identity_provider_id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The ID of an Azure group.
  final String? id;

  /// The ID of your Azure identity provider.
  final String? identityProviderId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'identity_provider_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
  };

  Rule2AzureAd copyWith({
    String? id,
    String? identityProviderId,
    Map<String, Object?>? extra,
  }) => Rule2AzureAd(
    id: id ?? this.id,
    identityProviderId: identityProviderId ?? this.identityProviderId,
    extra: extra ?? this.extra,
  );
}

class Rule2CloudflareAccountMember {
  const Rule2CloudflareAccountMember({
    this.accountId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2CloudflareAccountMember.fromJson(Map<String, Object?> json) =>
      Rule2CloudflareAccountMember(
        accountId: asString(json['account_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// Identifier.
  final String? accountId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'account_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (accountId != null) 'account_id': accountId!,
  };

  Rule2CloudflareAccountMember copyWith({
    String? accountId,
    Map<String, Object?>? extra,
  }) => Rule2CloudflareAccountMember(
    accountId: accountId ?? this.accountId,
    extra: extra ?? this.extra,
  );
}

class Rule2CommonName {
  const Rule2CommonName({
    this.commonName,
    this.extra = const <String, Object?>{},
  });

  factory Rule2CommonName.fromJson(Map<String, Object?> json) =>
      Rule2CommonName(
        commonName: asString(json['common_name']),
        extra: extraOf(json, _knownKeys),
      );

  /// The common name to match.
  final String? commonName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'common_name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (commonName != null) 'common_name': commonName!,
  };

  Rule2CommonName copyWith({String? commonName, Map<String, Object?>? extra}) =>
      Rule2CommonName(
        commonName: commonName ?? this.commonName,
        extra: extra ?? this.extra,
      );
}

class Rule2DevicePosture {
  const Rule2DevicePosture({
    this.integrationUid,
    this.extra = const <String, Object?>{},
  });

  factory Rule2DevicePosture.fromJson(Map<String, Object?> json) =>
      Rule2DevicePosture(
        integrationUid: asString(json['integration_uid']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ID of a device posture integration.
  final String? integrationUid;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'integration_uid'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (integrationUid != null) 'integration_uid': integrationUid!,
  };

  Rule2DevicePosture copyWith({
    String? integrationUid,
    Map<String, Object?>? extra,
  }) => Rule2DevicePosture(
    integrationUid: integrationUid ?? this.integrationUid,
    extra: extra ?? this.extra,
  );
}

class Rule2Email {
  const Rule2Email({this.email, this.extra = const <String, Object?>{}});

  factory Rule2Email.fromJson(Map<String, Object?> json) => Rule2Email(
    email: asString(json['email']),
    extra: extraOf(json, _knownKeys),
  );

  /// The email of the user.
  final String? email;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'email'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (email != null) 'email': email!,
  };

  Rule2Email copyWith({String? email, Map<String, Object?>? extra}) =>
      Rule2Email(email: email ?? this.email, extra: extra ?? this.extra);
}

class Rule2EmailDomain {
  const Rule2EmailDomain({this.domain, this.extra = const <String, Object?>{}});

  factory Rule2EmailDomain.fromJson(Map<String, Object?> json) =>
      Rule2EmailDomain(
        domain: asString(json['domain']),
        extra: extraOf(json, _knownKeys),
      );

  /// The email domain to match.
  final String? domain;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'domain'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (domain != null) 'domain': domain!,
  };

  Rule2EmailDomain copyWith({String? domain, Map<String, Object?>? extra}) =>
      Rule2EmailDomain(
        domain: domain ?? this.domain,
        extra: extra ?? this.extra,
      );
}

class Rule2EmailList {
  const Rule2EmailList({this.id, this.extra = const <String, Object?>{}});

  factory Rule2EmailList.fromJson(Map<String, Object?> json) => Rule2EmailList(
    id: asString(json['id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The ID of a previously created email list.
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  Rule2EmailList copyWith({String? id, Map<String, Object?>? extra}) =>
      Rule2EmailList(id: id ?? this.id, extra: extra ?? this.extra);
}

class Rule2ExternalEvaluation {
  const Rule2ExternalEvaluation({
    this.evaluateUrl,
    this.keysUrl,
    this.extra = const <String, Object?>{},
  });

  factory Rule2ExternalEvaluation.fromJson(Map<String, Object?> json) =>
      Rule2ExternalEvaluation(
        evaluateUrl: asString(json['evaluate_url']),
        keysUrl: asString(json['keys_url']),
        extra: extraOf(json, _knownKeys),
      );

  /// The API endpoint containing your business logic.
  final String? evaluateUrl;

  /// The API endpoint containing the key that Access uses to verify that the
  /// response came from your API.
  final String? keysUrl;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'evaluate_url', 'keys_url'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (evaluateUrl != null) 'evaluate_url': evaluateUrl!,
    if (keysUrl != null) 'keys_url': keysUrl!,
  };

  Rule2ExternalEvaluation copyWith({
    String? evaluateUrl,
    String? keysUrl,
    Map<String, Object?>? extra,
  }) => Rule2ExternalEvaluation(
    evaluateUrl: evaluateUrl ?? this.evaluateUrl,
    keysUrl: keysUrl ?? this.keysUrl,
    extra: extra ?? this.extra,
  );
}

class Rule2Geo {
  const Rule2Geo({this.countryCode, this.extra = const <String, Object?>{}});

  factory Rule2Geo.fromJson(Map<String, Object?> json) => Rule2Geo(
    countryCode: asString(json['country_code']),
    extra: extraOf(json, _knownKeys),
  );

  /// The country code that should be matched.
  final String? countryCode;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'country_code'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (countryCode != null) 'country_code': countryCode!,
  };

  Rule2Geo copyWith({String? countryCode, Map<String, Object?>? extra}) =>
      Rule2Geo(
        countryCode: countryCode ?? this.countryCode,
        extra: extra ?? this.extra,
      );
}

class Rule2GithubOrganization {
  const Rule2GithubOrganization({
    this.identityProviderId,
    this.name,
    this.team,
    this.extra = const <String, Object?>{},
  });

  factory Rule2GithubOrganization.fromJson(Map<String, Object?> json) =>
      Rule2GithubOrganization(
        identityProviderId: asString(json['identity_provider_id']),
        name: asString(json['name']),
        team: asString(json['team']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ID of your Github identity provider.
  final String? identityProviderId;

  /// The name of the organization.
  final String? name;

  /// The name of the team
  final String? team;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'identity_provider_id',
    'name',
    'team',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
    if (name != null) 'name': name!,
    if (team != null) 'team': team!,
  };

  Rule2GithubOrganization copyWith({
    String? identityProviderId,
    String? name,
    String? team,
    Map<String, Object?>? extra,
  }) => Rule2GithubOrganization(
    identityProviderId: identityProviderId ?? this.identityProviderId,
    name: name ?? this.name,
    team: team ?? this.team,
    extra: extra ?? this.extra,
  );
}

class Rule2Group {
  const Rule2Group({this.id, this.extra = const <String, Object?>{}});

  factory Rule2Group.fromJson(Map<String, Object?> json) =>
      Rule2Group(id: asString(json['id']), extra: extraOf(json, _knownKeys));

  /// The ID of a previously created Access group.
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  Rule2Group copyWith({String? id, Map<String, Object?>? extra}) =>
      Rule2Group(id: id ?? this.id, extra: extra ?? this.extra);
}

class Rule2Gsuite {
  const Rule2Gsuite({
    this.email,
    this.identityProviderId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2Gsuite.fromJson(Map<String, Object?> json) => Rule2Gsuite(
    email: asString(json['email']),
    identityProviderId: asString(json['identity_provider_id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The email of the Google Workspace group.
  final String? email;

  /// The ID of your Google Workspace identity provider.
  final String? identityProviderId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'email', 'identity_provider_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (email != null) 'email': email!,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
  };

  Rule2Gsuite copyWith({
    String? email,
    String? identityProviderId,
    Map<String, Object?>? extra,
  }) => Rule2Gsuite(
    email: email ?? this.email,
    identityProviderId: identityProviderId ?? this.identityProviderId,
    extra: extra ?? this.extra,
  );
}

class Rule2Ip {
  const Rule2Ip({this.ip, this.extra = const <String, Object?>{}});

  factory Rule2Ip.fromJson(Map<String, Object?> json) =>
      Rule2Ip(ip: asString(json['ip']), extra: extraOf(json, _knownKeys));

  /// An IPv4 or IPv6 CIDR block.
  final String? ip;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ip'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ip != null) 'ip': ip!,
  };

  Rule2Ip copyWith({String? ip, Map<String, Object?>? extra}) =>
      Rule2Ip(ip: ip ?? this.ip, extra: extra ?? this.extra);
}

class Rule2IpList {
  const Rule2IpList({this.id, this.extra = const <String, Object?>{}});

  factory Rule2IpList.fromJson(Map<String, Object?> json) =>
      Rule2IpList(id: asString(json['id']), extra: extraOf(json, _knownKeys));

  /// The ID of a previously created IP list.
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  Rule2IpList copyWith({String? id, Map<String, Object?>? extra}) =>
      Rule2IpList(id: id ?? this.id, extra: extra ?? this.extra);
}

class Rule2LinkedAppToken {
  const Rule2LinkedAppToken({
    this.appUid,
    this.extra = const <String, Object?>{},
  });

  factory Rule2LinkedAppToken.fromJson(Map<String, Object?> json) =>
      Rule2LinkedAppToken(
        appUid: asString(json['app_uid']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ID of an Access OIDC SaaS application
  final String? appUid;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'app_uid'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (appUid != null) 'app_uid': appUid!,
  };

  Rule2LinkedAppToken copyWith({String? appUid, Map<String, Object?>? extra}) =>
      Rule2LinkedAppToken(
        appUid: appUid ?? this.appUid,
        extra: extra ?? this.extra,
      );
}

class Rule2LoginMethod {
  const Rule2LoginMethod({this.id, this.extra = const <String, Object?>{}});

  factory Rule2LoginMethod.fromJson(Map<String, Object?> json) =>
      Rule2LoginMethod(
        id: asString(json['id']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ID of an identity provider.
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  Rule2LoginMethod copyWith({String? id, Map<String, Object?>? extra}) =>
      Rule2LoginMethod(id: id ?? this.id, extra: extra ?? this.extra);
}

class Rule2Oidc {
  const Rule2Oidc({
    this.claimName,
    this.claimValue,
    this.identityProviderId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2Oidc.fromJson(Map<String, Object?> json) => Rule2Oidc(
    claimName: asString(json['claim_name']),
    claimValue: asString(json['claim_value']),
    identityProviderId: asString(json['identity_provider_id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The name of the OIDC claim.
  final String? claimName;

  /// The OIDC claim value to look for.
  final String? claimValue;

  /// The ID of your OIDC identity provider.
  final String? identityProviderId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'claim_name',
    'claim_value',
    'identity_provider_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (claimName != null) 'claim_name': claimName!,
    if (claimValue != null) 'claim_value': claimValue!,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
  };

  Rule2Oidc copyWith({
    String? claimName,
    String? claimValue,
    String? identityProviderId,
    Map<String, Object?>? extra,
  }) => Rule2Oidc(
    claimName: claimName ?? this.claimName,
    claimValue: claimValue ?? this.claimValue,
    identityProviderId: identityProviderId ?? this.identityProviderId,
    extra: extra ?? this.extra,
  );
}

class Rule2Okta {
  const Rule2Okta({
    this.identityProviderId,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory Rule2Okta.fromJson(Map<String, Object?> json) => Rule2Okta(
    identityProviderId: asString(json['identity_provider_id']),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// The ID of your Okta identity provider.
  final String? identityProviderId;

  /// The name of the Okta group.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'identity_provider_id', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
    if (name != null) 'name': name!,
  };

  Rule2Okta copyWith({
    String? identityProviderId,
    String? name,
    Map<String, Object?>? extra,
  }) => Rule2Okta(
    identityProviderId: identityProviderId ?? this.identityProviderId,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

class Rule2Saml {
  const Rule2Saml({
    this.attributeName,
    this.attributeValue,
    this.identityProviderId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2Saml.fromJson(Map<String, Object?> json) => Rule2Saml(
    attributeName: asString(json['attribute_name']),
    attributeValue: asString(json['attribute_value']),
    identityProviderId: asString(json['identity_provider_id']),
    extra: extraOf(json, _knownKeys),
  );

  /// The name of the SAML attribute.
  final String? attributeName;

  /// The SAML attribute value to look for.
  final String? attributeValue;

  /// The ID of your SAML identity provider.
  final String? identityProviderId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'attribute_name',
    'attribute_value',
    'identity_provider_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (attributeName != null) 'attribute_name': attributeName!,
    if (attributeValue != null) 'attribute_value': attributeValue!,
    if (identityProviderId != null) 'identity_provider_id': identityProviderId!,
  };

  Rule2Saml copyWith({
    String? attributeName,
    String? attributeValue,
    String? identityProviderId,
    Map<String, Object?>? extra,
  }) => Rule2Saml(
    attributeName: attributeName ?? this.attributeName,
    attributeValue: attributeValue ?? this.attributeValue,
    identityProviderId: identityProviderId ?? this.identityProviderId,
    extra: extra ?? this.extra,
  );
}

class Rule2ServiceToken {
  const Rule2ServiceToken({
    this.tokenId,
    this.extra = const <String, Object?>{},
  });

  factory Rule2ServiceToken.fromJson(Map<String, Object?> json) =>
      Rule2ServiceToken(
        tokenId: asString(json['token_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// The ID of a Service Token.
  final String? tokenId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'token_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (tokenId != null) 'token_id': tokenId!,
  };

  Rule2ServiceToken copyWith({String? tokenId, Map<String, Object?>? extra}) =>
      Rule2ServiceToken(
        tokenId: tokenId ?? this.tokenId,
        extra: extra ?? this.extra,
      );
}

class Rule2UserRiskScore {
  const Rule2UserRiskScore({
    this.userRiskScore,
    this.extra = const <String, Object?>{},
  });

  factory Rule2UserRiskScore.fromJson(Map<String, Object?> json) =>
      Rule2UserRiskScore(
        userRiskScore: asPrimitiveList<String>(
          json['user_risk_score'],
          asString,
        ),
        extra: extraOf(json, _knownKeys),
      );

  /// A list of risk score levels to match. Values can be low, medium, high, or
  /// unscored.
  final List<String>? userRiskScore;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'user_risk_score'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (userRiskScore != null) 'user_risk_score': userRiskScore!,
  };

  Rule2UserRiskScore copyWith({
    List<String>? userRiskScore,
    Map<String, Object?>? extra,
  }) => Rule2UserRiskScore(
    userRiskScore: userRiskScore ?? this.userRiskScore,
    extra: extra ?? this.extra,
  );
}

/// Configuration for exposed credential checking.
class RuleExposedCredentialCheck {
  const RuleExposedCredentialCheck({
    this.passwordExpression,
    this.usernameExpression,
    this.extra = const <String, Object?>{},
  });

  factory RuleExposedCredentialCheck.fromJson(Map<String, Object?> json) =>
      RuleExposedCredentialCheck(
        passwordExpression: asString(json['password_expression']),
        usernameExpression: asString(json['username_expression']),
        extra: extraOf(json, _knownKeys),
      );

  /// An expression that selects the password used in the credentials check.
  final String? passwordExpression;

  /// An expression that selects the user ID used in the credentials check.
  final String? usernameExpression;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'password_expression',
    'username_expression',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (passwordExpression != null) 'password_expression': passwordExpression!,
    if (usernameExpression != null) 'username_expression': usernameExpression!,
  };

  RuleExposedCredentialCheck copyWith({
    String? passwordExpression,
    String? usernameExpression,
    Map<String, Object?>? extra,
  }) => RuleExposedCredentialCheck(
    passwordExpression: passwordExpression ?? this.passwordExpression,
    usernameExpression: usernameExpression ?? this.usernameExpression,
    extra: extra ?? this.extra,
  );
}

/// An object configuring the rule's logging behavior.
class RuleLogging {
  const RuleLogging({this.enabled, this.extra = const <String, Object?>{}});

  factory RuleLogging.fromJson(Map<String, Object?> json) => RuleLogging(
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether to generate a log when the rule matches.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'enabled'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
  };

  RuleLogging copyWith({bool? enabled, Map<String, Object?>? extra}) =>
      RuleLogging(enabled: enabled ?? this.enabled, extra: extra ?? this.extra);
}

/// An object configuring the rule's rate limit behavior.
class RuleRatelimit {
  const RuleRatelimit({
    this.characteristics,
    this.countingExpression,
    this.mitigationTimeout,
    this.period,
    this.requestsPerPeriod,
    this.requestsToOrigin,
    this.scorePerPeriod,
    this.scoreResponseHeaderName,
    this.extra = const <String, Object?>{},
  });

  factory RuleRatelimit.fromJson(Map<String, Object?> json) => RuleRatelimit(
    characteristics: asPrimitiveList<String>(json['characteristics'], asString),
    countingExpression: asString(json['counting_expression']),
    mitigationTimeout: asInt(json['mitigation_timeout']),
    period: asInt(json['period']),
    requestsPerPeriod: asInt(json['requests_per_period']),
    requestsToOrigin: asBool(json['requests_to_origin']),
    scorePerPeriod: asInt(json['score_per_period']),
    scoreResponseHeaderName: asString(json['score_response_header_name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Characteristics of the request on which the rate limit counter will be
  /// incremented.
  final List<String>? characteristics;

  /// An expression that defines when the rate limit counter should be
  /// incremented. It defaults to the same as the rule's expression.
  final String? countingExpression;

  /// Period of time in seconds after which the action will be disabled following
  /// its first execution.
  final int? mitigationTimeout;

  /// Period in seconds over which the counter is being incremented.
  final int? period;

  /// The threshold of requests per period after which the action will be executed
  /// for the first time.
  final int? requestsPerPeriod;

  /// Whether counting is only performed when an origin is reached.
  final bool? requestsToOrigin;

  /// The score threshold per period for which the action will be executed the
  /// first time.
  final int? scorePerPeriod;

  /// A response header name provided by the origin, which contains the score to
  /// increment rate limit counter with.
  final String? scoreResponseHeaderName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'characteristics',
    'counting_expression',
    'mitigation_timeout',
    'period',
    'requests_per_period',
    'requests_to_origin',
    'score_per_period',
    'score_response_header_name',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (characteristics != null) 'characteristics': characteristics!,
    if (countingExpression != null) 'counting_expression': countingExpression!,
    if (mitigationTimeout != null) 'mitigation_timeout': mitigationTimeout!,
    if (period != null) 'period': period!,
    if (requestsPerPeriod != null) 'requests_per_period': requestsPerPeriod!,
    if (requestsToOrigin != null) 'requests_to_origin': requestsToOrigin!,
    if (scorePerPeriod != null) 'score_per_period': scorePerPeriod!,
    if (scoreResponseHeaderName != null)
      'score_response_header_name': scoreResponseHeaderName!,
  };

  RuleRatelimit copyWith({
    List<String>? characteristics,
    String? countingExpression,
    int? mitigationTimeout,
    int? period,
    int? requestsPerPeriod,
    bool? requestsToOrigin,
    int? scorePerPeriod,
    String? scoreResponseHeaderName,
    Map<String, Object?>? extra,
  }) => RuleRatelimit(
    characteristics: characteristics ?? this.characteristics,
    countingExpression: countingExpression ?? this.countingExpression,
    mitigationTimeout: mitigationTimeout ?? this.mitigationTimeout,
    period: period ?? this.period,
    requestsPerPeriod: requestsPerPeriod ?? this.requestsPerPeriod,
    requestsToOrigin: requestsToOrigin ?? this.requestsToOrigin,
    scorePerPeriod: scorePerPeriod ?? this.scorePerPeriod,
    scoreResponseHeaderName:
        scoreResponseHeaderName ?? this.scoreResponseHeaderName,
    extra: extra ?? this.extra,
  );
}

/// Defines settings for this rule. Settings apply only to specific rule types
/// and must use compatible selectors. If Terraform detects drift, confirm the
/// setting supports your rule type and check whether the API modifies the
/// value. Use API-returned values in your configuration to prevent drift.
class RuleSettings {
  const RuleSettings({
    this.addHeaders,
    this.allowChildBypass,
    this.auditSsh,
    this.bisoAdminControls,
    this.blockPage,
    this.blockPageEnabled,
    this.blockReason,
    this.bypassParentRule,
    this.checkSession,
    this.deleteHeaders,
    this.dnsResolvers,
    this.egress,
    this.forensicCopy,
    this.ignoreCnameCategoryMatches,
    this.insecureDisableDnssecValidation,
    this.ipCategories,
    this.ipIndicatorFeeds,
    this.l4override,
    this.notificationSettings,
    this.overrideHost,
    this.overrideIps,
    this.payloadLog,
    this.quarantine,
    this.redirect,
    this.resolveDnsInternally,
    this.resolveDnsThroughCloudflare,
    this.setHeaders,
    this.untrustedCert,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettings.fromJson(Map<String, Object?> json) => RuleSettings(
    addHeaders: asMap(json['add_headers']),
    allowChildBypass: asBool(json['allow_child_bypass']),
    auditSsh: asModel(json['audit_ssh'], RuleSettingsAuditSsh.fromJson),
    bisoAdminControls: asModel(
      json['biso_admin_controls'],
      RuleSettingsBisoAdminControls.fromJson,
    ),
    blockPage: asModel(json['block_page'], RuleSettingsBlockPage.fromJson),
    blockPageEnabled: asBool(json['block_page_enabled']),
    blockReason: asString(json['block_reason']),
    bypassParentRule: asBool(json['bypass_parent_rule']),
    checkSession: asModel(
      json['check_session'],
      RuleSettingsCheckSession.fromJson,
    ),
    deleteHeaders: asPrimitiveList<String>(json['delete_headers'], asString),
    dnsResolvers: asModel(
      json['dns_resolvers'],
      RuleSettingsDnsResolvers.fromJson,
    ),
    egress: asModel(json['egress'], RuleSettingsEgress.fromJson),
    forensicCopy: asModel(
      json['forensic_copy'],
      RuleSettingsForensicCopy.fromJson,
    ),
    ignoreCnameCategoryMatches: asBool(json['ignore_cname_category_matches']),
    insecureDisableDnssecValidation: asBool(
      json['insecure_disable_dnssec_validation'],
    ),
    ipCategories: asBool(json['ip_categories']),
    ipIndicatorFeeds: asBool(json['ip_indicator_feeds']),
    l4override: asModel(json['l4override'], RuleSettingsL4override.fromJson),
    notificationSettings: asModel(
      json['notification_settings'],
      RuleSettingsNotificationSettings.fromJson,
    ),
    overrideHost: asString(json['override_host']),
    overrideIps: asPrimitiveList<String>(json['override_ips'], asString),
    payloadLog: asModel(json['payload_log'], RuleSettingsPayloadLog.fromJson),
    quarantine: asModel(json['quarantine'], RuleSettingsQuarantine.fromJson),
    redirect: asModel(json['redirect'], RuleSettingsRedirect.fromJson),
    resolveDnsInternally: asModel(
      json['resolve_dns_internally'],
      RuleSettingsResolveDnsInternally.fromJson,
    ),
    resolveDnsThroughCloudflare: asBool(json['resolve_dns_through_cloudflare']),
    setHeaders: asMap(json['set_headers']),
    untrustedCert: asModel(
      json['untrusted_cert'],
      RuleSettingsUntrustedCert.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// Add custom headers to allowed requests as key-value pairs. Use header names
  /// as keys that map to arrays of header values. Header values may contain
  /// `@{selector.name}` variable references that are interpolated at the edge.
  /// Use `@@{` to escape a literal `@{`. A maximum of 20 header operations (add +
  /// set + delete) is allowed per policy. Each header name may not exceed 256
  /// bytes and each header value may not exceed 4 KB. Settable only for `http`
  /// rules with the action set to `allow`.
  final Map<String, Object?>? addHeaders;

  /// Set to enable MSP children to bypass this rule. Only parent MSP accounts can
  /// set this. this rule. Settable for all types of rules.
  final bool? allowChildBypass;

  /// Define the settings for the Audit SSH action. Settable only for `l4` rules
  /// with `audit_ssh` action.
  final RuleSettingsAuditSsh? auditSsh;

  /// Configure browser isolation behavior. Settable only for `http` rules with
  /// the action set to `isolate`.
  final RuleSettingsBisoAdminControls? bisoAdminControls;

  /// Configure custom block page settings. If missing or null, use the account
  /// settings. Settable only for `http` rules with the action set to `block`.
  final RuleSettingsBlockPage? blockPage;

  /// Enable the custom block page. Settable only for `dns` rules with action
  /// `block`.
  final bool? blockPageEnabled;

  /// Explain why the rule blocks the request. The custom block page shows this
  /// text (if enabled). Settable only for `dns`, `l4`, and `http` rules when the
  /// action set to `block`.
  final String? blockReason;

  /// Set to enable MSP accounts to bypass their parent's rules. Only MSP child
  /// accounts can set this. Settable for all types of rules.
  final bool? bypassParentRule;

  /// Configure session check behavior. Settable only for `l4` and `http` rules
  /// with the action set to `allow`.
  final RuleSettingsCheckSession? checkSession;

  /// Remove headers from allowed requests by name. A maximum of 20 header
  /// operations (add + set + delete) is allowed per policy. Each header name may
  /// not exceed 256 bytes. Settable only for `http` rules with the action set to
  /// `allow`.
  final List<String>? deleteHeaders;

  /// Configure custom resolvers to route queries that match the resolver policy.
  /// Unused with 'resolve_dns_through_cloudflare' or 'resolve_dns_internally'
  /// settings. DNS queries get routed to the address closest to their origin.
  /// Only valid when a rule's action set to 'resolve'. Settable only for
  /// `dns_resolver` rules.
  final RuleSettingsDnsResolvers? dnsResolvers;

  /// Configure how Gateway Proxy traffic egresses. You can enable this setting
  /// for rules with Egress actions and filters, or omit it to indicate local
  /// egress via WARP IPs. Settable only for `egress` rules.
  final RuleSettingsEgress? egress;

  /// Configure whether a copy of the HTTP request will be sent to storage when
  /// the rule matches.
  final RuleSettingsForensicCopy? forensicCopy;

  /// Ignore category matches at CNAME domains in a response. When off, evaluate
  /// categories in this rule against all CNAME domain categories in the response.
  /// Settable only for `dns` and `dns_resolver` rules.
  final bool? ignoreCnameCategoryMatches;

  /// Specify whether to disable DNSSEC validation (for Allow actions) [INSECURE].
  /// Settable only for `dns` rules.
  final bool? insecureDisableDnssecValidation;

  /// Enable IPs in DNS resolver category blocks. The system blocks only domain
  /// name categories unless you enable this setting. Settable only for `dns` and
  /// `dns_resolver` rules.
  final bool? ipCategories;

  /// Indicates whether to include IPs in DNS resolver indicator feed blocks.
  /// Default, indicator feeds block only domain names. Settable only for `dns`
  /// and `dns_resolver` rules.
  final bool? ipIndicatorFeeds;

  /// Send matching traffic to the supplied destination IP address and port.
  /// Settable only for `l4` rules with the action set to `l4_override`.
  final RuleSettingsL4override? l4override;

  /// Configure a notification to display on the user's device when this rule
  /// matched. Settable for all types of rules with the action set to `block`.
  final RuleSettingsNotificationSettings? notificationSettings;

  /// Defines a hostname for override, for the matching DNS queries. Settable only
  /// for `dns` rules with the action set to `override`.
  final String? overrideHost;

  /// Defines a an IP or set of IPs for overriding matched DNS queries. Settable
  /// only for `dns` rules with the action set to `override`.
  final List<String>? overrideIps;

  /// Configure DLP payload logging. Settable only for `http` rules.
  final RuleSettingsPayloadLog? payloadLog;

  /// Configure settings that apply to quarantine rules. Settable only for `http`
  /// rules.
  final RuleSettingsQuarantine? quarantine;

  /// Apply settings to redirect rules. Settable only for `http` rules with the
  /// action set to `redirect`.
  final RuleSettingsRedirect? redirect;

  /// Configure to forward the query to the internal DNS service, passing the
  /// specified 'view_id' as input. Not used when 'dns_resolvers' is specified or
  /// 'resolve_dns_through_cloudflare' is set. Only valid when a rule's action set
  /// to 'resolve'. Settable only for `dns_resolver` rules.
  final RuleSettingsResolveDnsInternally? resolveDnsInternally;

  /// Enable to send queries that match the policy to Cloudflare's default 1.1.1.1
  /// DNS resolver. Cannot set when 'dns_resolvers' specified or
  /// 'resolve_dns_internally' is set. Only valid when a rule's action set to
  /// 'resolve'. Settable only for `dns_resolver` rules.
  final bool? resolveDnsThroughCloudflare;

  /// Replace existing headers on allowed requests with the specified key-value
  /// pairs. If a header does not exist, it is added. Header values may contain
  /// `@{selector.name}` variable references that are interpolated at the edge.
  /// Use `@@{` to escape a literal `@{`. A maximum of 20 header operations (add +
  /// set + delete) is allowed per policy. Each header name may not exceed 256
  /// bytes and each header value may not exceed 4 KB. Settable only for `http`
  /// rules with the action set to `allow`.
  final Map<String, Object?>? setHeaders;

  /// Configure behavior when an upstream certificate is invalid or an SSL error
  /// occurs. Settable only for `http` rules with the action set to `allow`.
  final RuleSettingsUntrustedCert? untrustedCert;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'add_headers',
    'allow_child_bypass',
    'audit_ssh',
    'biso_admin_controls',
    'block_page',
    'block_page_enabled',
    'block_reason',
    'bypass_parent_rule',
    'check_session',
    'delete_headers',
    'dns_resolvers',
    'egress',
    'forensic_copy',
    'ignore_cname_category_matches',
    'insecure_disable_dnssec_validation',
    'ip_categories',
    'ip_indicator_feeds',
    'l4override',
    'notification_settings',
    'override_host',
    'override_ips',
    'payload_log',
    'quarantine',
    'redirect',
    'resolve_dns_internally',
    'resolve_dns_through_cloudflare',
    'set_headers',
    'untrusted_cert',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (addHeaders != null) 'add_headers': addHeaders!,
    if (allowChildBypass != null) 'allow_child_bypass': allowChildBypass!,
    if (auditSsh != null) 'audit_ssh': auditSsh!.toJson(),
    if (bisoAdminControls != null)
      'biso_admin_controls': bisoAdminControls!.toJson(),
    if (blockPage != null) 'block_page': blockPage!.toJson(),
    if (blockPageEnabled != null) 'block_page_enabled': blockPageEnabled!,
    if (blockReason != null) 'block_reason': blockReason!,
    if (bypassParentRule != null) 'bypass_parent_rule': bypassParentRule!,
    if (checkSession != null) 'check_session': checkSession!.toJson(),
    if (deleteHeaders != null) 'delete_headers': deleteHeaders!,
    if (dnsResolvers != null) 'dns_resolvers': dnsResolvers!.toJson(),
    if (egress != null) 'egress': egress!.toJson(),
    if (forensicCopy != null) 'forensic_copy': forensicCopy!.toJson(),
    if (ignoreCnameCategoryMatches != null)
      'ignore_cname_category_matches': ignoreCnameCategoryMatches!,
    if (insecureDisableDnssecValidation != null)
      'insecure_disable_dnssec_validation': insecureDisableDnssecValidation!,
    if (ipCategories != null) 'ip_categories': ipCategories!,
    if (ipIndicatorFeeds != null) 'ip_indicator_feeds': ipIndicatorFeeds!,
    if (l4override != null) 'l4override': l4override!.toJson(),
    if (notificationSettings != null)
      'notification_settings': notificationSettings!.toJson(),
    if (overrideHost != null) 'override_host': overrideHost!,
    if (overrideIps != null) 'override_ips': overrideIps!,
    if (payloadLog != null) 'payload_log': payloadLog!.toJson(),
    if (quarantine != null) 'quarantine': quarantine!.toJson(),
    if (redirect != null) 'redirect': redirect!.toJson(),
    if (resolveDnsInternally != null)
      'resolve_dns_internally': resolveDnsInternally!.toJson(),
    if (resolveDnsThroughCloudflare != null)
      'resolve_dns_through_cloudflare': resolveDnsThroughCloudflare!,
    if (setHeaders != null) 'set_headers': setHeaders!,
    if (untrustedCert != null) 'untrusted_cert': untrustedCert!.toJson(),
  };

  RuleSettings copyWith({
    Map<String, Object?>? addHeaders,
    bool? allowChildBypass,
    RuleSettingsAuditSsh? auditSsh,
    RuleSettingsBisoAdminControls? bisoAdminControls,
    RuleSettingsBlockPage? blockPage,
    bool? blockPageEnabled,
    String? blockReason,
    bool? bypassParentRule,
    RuleSettingsCheckSession? checkSession,
    List<String>? deleteHeaders,
    RuleSettingsDnsResolvers? dnsResolvers,
    RuleSettingsEgress? egress,
    RuleSettingsForensicCopy? forensicCopy,
    bool? ignoreCnameCategoryMatches,
    bool? insecureDisableDnssecValidation,
    bool? ipCategories,
    bool? ipIndicatorFeeds,
    RuleSettingsL4override? l4override,
    RuleSettingsNotificationSettings? notificationSettings,
    String? overrideHost,
    List<String>? overrideIps,
    RuleSettingsPayloadLog? payloadLog,
    RuleSettingsQuarantine? quarantine,
    RuleSettingsRedirect? redirect,
    RuleSettingsResolveDnsInternally? resolveDnsInternally,
    bool? resolveDnsThroughCloudflare,
    Map<String, Object?>? setHeaders,
    RuleSettingsUntrustedCert? untrustedCert,
    Map<String, Object?>? extra,
  }) => RuleSettings(
    addHeaders: addHeaders ?? this.addHeaders,
    allowChildBypass: allowChildBypass ?? this.allowChildBypass,
    auditSsh: auditSsh ?? this.auditSsh,
    bisoAdminControls: bisoAdminControls ?? this.bisoAdminControls,
    blockPage: blockPage ?? this.blockPage,
    blockPageEnabled: blockPageEnabled ?? this.blockPageEnabled,
    blockReason: blockReason ?? this.blockReason,
    bypassParentRule: bypassParentRule ?? this.bypassParentRule,
    checkSession: checkSession ?? this.checkSession,
    deleteHeaders: deleteHeaders ?? this.deleteHeaders,
    dnsResolvers: dnsResolvers ?? this.dnsResolvers,
    egress: egress ?? this.egress,
    forensicCopy: forensicCopy ?? this.forensicCopy,
    ignoreCnameCategoryMatches:
        ignoreCnameCategoryMatches ?? this.ignoreCnameCategoryMatches,
    insecureDisableDnssecValidation:
        insecureDisableDnssecValidation ?? this.insecureDisableDnssecValidation,
    ipCategories: ipCategories ?? this.ipCategories,
    ipIndicatorFeeds: ipIndicatorFeeds ?? this.ipIndicatorFeeds,
    l4override: l4override ?? this.l4override,
    notificationSettings: notificationSettings ?? this.notificationSettings,
    overrideHost: overrideHost ?? this.overrideHost,
    overrideIps: overrideIps ?? this.overrideIps,
    payloadLog: payloadLog ?? this.payloadLog,
    quarantine: quarantine ?? this.quarantine,
    redirect: redirect ?? this.redirect,
    resolveDnsInternally: resolveDnsInternally ?? this.resolveDnsInternally,
    resolveDnsThroughCloudflare:
        resolveDnsThroughCloudflare ?? this.resolveDnsThroughCloudflare,
    setHeaders: setHeaders ?? this.setHeaders,
    untrustedCert: untrustedCert ?? this.untrustedCert,
    extra: extra ?? this.extra,
  );
}

/// Define the settings for the Audit SSH action. Settable only for `l4` rules
/// with `audit_ssh` action.
class RuleSettingsAuditSsh {
  const RuleSettingsAuditSsh({
    this.commandLogging,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsAuditSsh.fromJson(Map<String, Object?> json) =>
      RuleSettingsAuditSsh(
        commandLogging: asBool(json['command_logging']),
        extra: extraOf(json, _knownKeys),
      );

  /// Enable SSH command logging.
  final bool? commandLogging;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'command_logging'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (commandLogging != null) 'command_logging': commandLogging!,
  };

  RuleSettingsAuditSsh copyWith({
    bool? commandLogging,
    Map<String, Object?>? extra,
  }) => RuleSettingsAuditSsh(
    commandLogging: commandLogging ?? this.commandLogging,
    extra: extra ?? this.extra,
  );
}

/// Configure browser isolation behavior. Settable only for `http` rules with
/// the action set to `isolate`.
class RuleSettingsBisoAdminControls {
  const RuleSettingsBisoAdminControls({
    this.copy,
    this.dcp,
    this.dd,
    this.dk,
    this.download,
    this.dp,
    this.du,
    this.keyboard,
    this.paste,
    this.printing,
    this.upload,
    this.version,
    this.wmId,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsBisoAdminControls.fromJson(Map<String, Object?> json) =>
      RuleSettingsBisoAdminControls(
        copy: asString(json['copy']),
        dcp: asBool(json['dcp']),
        dd: asBool(json['dd']),
        dk: asBool(json['dk']),
        download: asString(json['download']),
        dp: asBool(json['dp']),
        du: asBool(json['du']),
        keyboard: asString(json['keyboard']),
        paste: asString(json['paste']),
        printing: asString(json['printing']),
        upload: asString(json['upload']),
        version: asString(json['version']),
        wmId: asString(json['wm_id']),
        extra: extraOf(json, _knownKeys),
      );

  /// Configure copy behavior. If set to remote_only, users cannot copy isolated
  /// content from the remote browser to the local clipboard. If this field is
  /// absent, copying remains enabled. Applies only when version == "v2". Allowed
  /// values: `enabled`, `disabled`, `remote_only`.
  final String? copy;

  /// Set to false to enable copy-pasting. Only applies when `version == "v1"`.
  final bool? dcp;

  /// Set to false to enable downloading. Only applies when `version == "v1"`.
  final bool? dd;

  /// Set to false to enable keyboard usage. Only applies when `version == "v1"`.
  final bool? dk;

  /// Configure download behavior. When set to remote_only, users can view
  /// downloads but cannot save them. If this field is absent, downloading remains
  /// enabled. Applies only when version == "v2". Allowed values: `enabled`,
  /// `disabled`, `remote_only`.
  final String? download;

  /// Set to false to enable printing. Only applies when `version == "v1"`.
  final bool? dp;

  /// Set to false to enable uploading. Only applies when `version == "v1"`.
  final bool? du;

  /// Configure keyboard usage behavior. If this field is absent, keyboard usage
  /// remains enabled. Applies only when version == "v2". Allowed values:
  /// `enabled`, `disabled`.
  final String? keyboard;

  /// Configure paste behavior. If set to remote_only, users cannot paste content
  /// from the local clipboard into isolated pages. If this field is absent,
  /// pasting remains enabled. Applies only when version == "v2". Allowed values:
  /// `enabled`, `disabled`, `remote_only`.
  final String? paste;

  /// Configure print behavior. Default, Printing is enabled. Applies only when
  /// version == "v2". Allowed values: `enabled`, `disabled`.
  final String? printing;

  /// Configure upload behavior. If this field is absent, uploading remains
  /// enabled. Applies only when version == "v2". Allowed values: `enabled`,
  /// `disabled`.
  final String? upload;

  /// Indicate which version of the browser isolation controls should apply.
  /// Allowed values: `v1`, `v2`.
  final String? version;

  /// Specify the watermark ID (UUID) to apply to the isolated browser session.
  /// When present, enables watermark rendering in the isolated browser.
  final String? wmId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'copy',
    'dcp',
    'dd',
    'dk',
    'download',
    'dp',
    'du',
    'keyboard',
    'paste',
    'printing',
    'upload',
    'version',
    'wm_id',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (copy != null) 'copy': copy!,
    if (dcp != null) 'dcp': dcp!,
    if (dd != null) 'dd': dd!,
    if (dk != null) 'dk': dk!,
    if (download != null) 'download': download!,
    if (dp != null) 'dp': dp!,
    if (du != null) 'du': du!,
    if (keyboard != null) 'keyboard': keyboard!,
    if (paste != null) 'paste': paste!,
    if (printing != null) 'printing': printing!,
    if (upload != null) 'upload': upload!,
    if (version != null) 'version': version!,
    if (wmId != null) 'wm_id': wmId!,
  };

  RuleSettingsBisoAdminControls copyWith({
    String? copy,
    bool? dcp,
    bool? dd,
    bool? dk,
    String? download,
    bool? dp,
    bool? du,
    String? keyboard,
    String? paste,
    String? printing,
    String? upload,
    String? version,
    String? wmId,
    Map<String, Object?>? extra,
  }) => RuleSettingsBisoAdminControls(
    copy: copy ?? this.copy,
    dcp: dcp ?? this.dcp,
    dd: dd ?? this.dd,
    dk: dk ?? this.dk,
    download: download ?? this.download,
    dp: dp ?? this.dp,
    du: du ?? this.du,
    keyboard: keyboard ?? this.keyboard,
    paste: paste ?? this.paste,
    printing: printing ?? this.printing,
    upload: upload ?? this.upload,
    version: version ?? this.version,
    wmId: wmId ?? this.wmId,
    extra: extra ?? this.extra,
  );
}

/// Configure custom block page settings. If missing or null, use the account
/// settings. Settable only for `http` rules with the action set to `block`.
class RuleSettingsBlockPage {
  const RuleSettingsBlockPage({
    this.includeContext,
    this.targetUri,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsBlockPage.fromJson(Map<String, Object?> json) =>
      RuleSettingsBlockPage(
        includeContext: asBool(json['include_context']),
        targetUri: asString(json['target_uri']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify whether to pass the context information as query parameters.
  final bool? includeContext;

  /// Specify the URI to which the user is redirected.
  final String? targetUri;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'include_context', 'target_uri'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (includeContext != null) 'include_context': includeContext!,
    if (targetUri != null) 'target_uri': targetUri!,
  };

  RuleSettingsBlockPage copyWith({
    bool? includeContext,
    String? targetUri,
    Map<String, Object?>? extra,
  }) => RuleSettingsBlockPage(
    includeContext: includeContext ?? this.includeContext,
    targetUri: targetUri ?? this.targetUri,
    extra: extra ?? this.extra,
  );
}

/// Configure session check behavior. Settable only for `l4` and `http` rules
/// with the action set to `allow`.
class RuleSettingsCheckSession {
  const RuleSettingsCheckSession({
    this.duration,
    this.enforce,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsCheckSession.fromJson(Map<String, Object?> json) =>
      RuleSettingsCheckSession(
        duration: asString(json['duration']),
        enforce: asBool(json['enforce']),
        extra: extraOf(json, _knownKeys),
      );

  /// Sets the required session freshness threshold. The API returns a normalized
  /// version of this value.
  final String? duration;

  /// Enable session enforcement.
  final bool? enforce;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'duration', 'enforce'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (duration != null) 'duration': duration!,
    if (enforce != null) 'enforce': enforce!,
  };

  RuleSettingsCheckSession copyWith({
    String? duration,
    bool? enforce,
    Map<String, Object?>? extra,
  }) => RuleSettingsCheckSession(
    duration: duration ?? this.duration,
    enforce: enforce ?? this.enforce,
    extra: extra ?? this.extra,
  );
}

/// Configure custom resolvers to route queries that match the resolver policy.
/// Unused with 'resolve_dns_through_cloudflare' or 'resolve_dns_internally'
/// settings. DNS queries get routed to the address closest to their origin.
/// Only valid when a rule's action set to 'resolve'. Settable only for
/// `dns_resolver` rules.
class RuleSettingsDnsResolvers {
  const RuleSettingsDnsResolvers({
    this.ipv4,
    this.ipv6,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsDnsResolvers.fromJson(Map<String, Object?> json) =>
      RuleSettingsDnsResolvers(
        ipv4: asModelList(json['ipv4'], DnsResolverSettingsV4.fromJson),
        ipv6: asModelList(json['ipv6'], DnsResolverSettingsV6.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  final List<DnsResolverSettingsV4>? ipv4;
  final List<DnsResolverSettingsV6>? ipv6;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ipv4', 'ipv6'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ipv4 != null) 'ipv4': ipv4!.map((e) => e.toJson()).toList(),
    if (ipv6 != null) 'ipv6': ipv6!.map((e) => e.toJson()).toList(),
  };

  RuleSettingsDnsResolvers copyWith({
    List<DnsResolverSettingsV4>? ipv4,
    List<DnsResolverSettingsV6>? ipv6,
    Map<String, Object?>? extra,
  }) => RuleSettingsDnsResolvers(
    ipv4: ipv4 ?? this.ipv4,
    ipv6: ipv6 ?? this.ipv6,
    extra: extra ?? this.extra,
  );
}

/// Configure how Gateway Proxy traffic egresses. You can enable this setting
/// for rules with Egress actions and filters, or omit it to indicate local
/// egress via WARP IPs. Settable only for `egress` rules.
class RuleSettingsEgress {
  const RuleSettingsEgress({
    this.ipv4,
    this.ipv4Fallback,
    this.ipv6,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsEgress.fromJson(Map<String, Object?> json) =>
      RuleSettingsEgress(
        ipv4: asString(json['ipv4']),
        ipv4Fallback: asString(json['ipv4_fallback']),
        ipv6: asString(json['ipv6']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify the IPv4 address to use for egress.
  final String? ipv4;

  /// Specify the fallback IPv4 address to use for egress when the primary IPv4
  /// fails. Set '0.0.0.0' to indicate local egress via WARP IPs.
  final String? ipv4Fallback;

  /// Specify the IPv6 range to use for egress.
  final String? ipv6;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ipv4', 'ipv4_fallback', 'ipv6'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ipv4 != null) 'ipv4': ipv4!,
    if (ipv4Fallback != null) 'ipv4_fallback': ipv4Fallback!,
    if (ipv6 != null) 'ipv6': ipv6!,
  };

  RuleSettingsEgress copyWith({
    String? ipv4,
    String? ipv4Fallback,
    String? ipv6,
    Map<String, Object?>? extra,
  }) => RuleSettingsEgress(
    ipv4: ipv4 ?? this.ipv4,
    ipv4Fallback: ipv4Fallback ?? this.ipv4Fallback,
    ipv6: ipv6 ?? this.ipv6,
    extra: extra ?? this.extra,
  );
}

/// Configure whether a copy of the HTTP request will be sent to storage when
/// the rule matches.
class RuleSettingsForensicCopy {
  const RuleSettingsForensicCopy({
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsForensicCopy.fromJson(Map<String, Object?> json) =>
      RuleSettingsForensicCopy(
        enabled: asBool(json['enabled']),
        extra: extraOf(json, _knownKeys),
      );

  /// Enable sending the copy to storage.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'enabled'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
  };

  RuleSettingsForensicCopy copyWith({
    bool? enabled,
    Map<String, Object?>? extra,
  }) => RuleSettingsForensicCopy(
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

/// Send matching traffic to the supplied destination IP address and port.
/// Settable only for `l4` rules with the action set to `l4_override`.
class RuleSettingsL4override {
  const RuleSettingsL4override({
    this.ip,
    this.port,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsL4override.fromJson(Map<String, Object?> json) =>
      RuleSettingsL4override(
        ip: asString(json['ip']),
        port: asInt(json['port']),
        extra: extraOf(json, _knownKeys),
      );

  /// Defines the IPv4 or IPv6 address.
  final String? ip;

  /// Defines a port number to use for TCP/UDP overrides.
  final int? port;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ip', 'port'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ip != null) 'ip': ip!,
    if (port != null) 'port': port!,
  };

  RuleSettingsL4override copyWith({
    String? ip,
    int? port,
    Map<String, Object?>? extra,
  }) => RuleSettingsL4override(
    ip: ip ?? this.ip,
    port: port ?? this.port,
    extra: extra ?? this.extra,
  );
}

/// Configure a notification to display on the user's device when this rule
/// matched. Settable for all types of rules with the action set to `block`.
class RuleSettingsNotificationSettings {
  const RuleSettingsNotificationSettings({
    this.enabled,
    this.includeContext,
    this.msg,
    this.supportUrl,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsNotificationSettings.fromJson(
    Map<String, Object?> json,
  ) => RuleSettingsNotificationSettings(
    enabled: asBool(json['enabled']),
    includeContext: asBool(json['include_context']),
    msg: asString(json['msg']),
    supportUrl: asString(json['support_url']),
    extra: extraOf(json, _knownKeys),
  );

  /// Enable notification.
  final bool? enabled;

  /// Indicates whether to pass the context information as query parameters.
  final bool? includeContext;

  /// Customize the message shown in the notification.
  final String? msg;

  /// Defines an optional URL to direct users to additional information. If unset,
  /// the notification opens a block page.
  final String? supportUrl;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'include_context',
    'msg',
    'support_url',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (includeContext != null) 'include_context': includeContext!,
    if (msg != null) 'msg': msg!,
    if (supportUrl != null) 'support_url': supportUrl!,
  };

  RuleSettingsNotificationSettings copyWith({
    bool? enabled,
    bool? includeContext,
    String? msg,
    String? supportUrl,
    Map<String, Object?>? extra,
  }) => RuleSettingsNotificationSettings(
    enabled: enabled ?? this.enabled,
    includeContext: includeContext ?? this.includeContext,
    msg: msg ?? this.msg,
    supportUrl: supportUrl ?? this.supportUrl,
    extra: extra ?? this.extra,
  );
}

/// Configure DLP payload logging. Settable only for `http` rules.
class RuleSettingsPayloadLog {
  const RuleSettingsPayloadLog({
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsPayloadLog.fromJson(Map<String, Object?> json) =>
      RuleSettingsPayloadLog(
        enabled: asBool(json['enabled']),
        extra: extraOf(json, _knownKeys),
      );

  /// Enable DLP payload logging for this rule.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'enabled'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
  };

  RuleSettingsPayloadLog copyWith({
    bool? enabled,
    Map<String, Object?>? extra,
  }) => RuleSettingsPayloadLog(
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

/// Configure settings that apply to quarantine rules. Settable only for `http`
/// rules.
class RuleSettingsQuarantine {
  const RuleSettingsQuarantine({
    this.fileTypes,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsQuarantine.fromJson(Map<String, Object?> json) =>
      RuleSettingsQuarantine(
        fileTypes: asPrimitiveList<String>(json['file_types'], asString),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify the types of files to sandbox.
  final List<String>? fileTypes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'file_types'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (fileTypes != null) 'file_types': fileTypes!,
  };

  RuleSettingsQuarantine copyWith({
    List<String>? fileTypes,
    Map<String, Object?>? extra,
  }) => RuleSettingsQuarantine(
    fileTypes: fileTypes ?? this.fileTypes,
    extra: extra ?? this.extra,
  );
}

/// Apply settings to redirect rules. Settable only for `http` rules with the
/// action set to `redirect`.
class RuleSettingsRedirect {
  const RuleSettingsRedirect({
    this.includeContext,
    this.preservePathAndQuery,
    this.targetUri,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsRedirect.fromJson(Map<String, Object?> json) =>
      RuleSettingsRedirect(
        includeContext: asBool(json['include_context']),
        preservePathAndQuery: asBool(json['preserve_path_and_query']),
        targetUri: asString(json['target_uri']),
        extra: extraOf(json, _knownKeys),
      );

  /// Specify whether to pass the context information as query parameters.
  final bool? includeContext;

  /// Specify whether to append the path and query parameters from the original
  /// request to target_uri.
  final bool? preservePathAndQuery;

  /// Specify the URI to which the user is redirected.
  final String? targetUri;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'include_context',
    'preserve_path_and_query',
    'target_uri',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (includeContext != null) 'include_context': includeContext!,
    if (preservePathAndQuery != null)
      'preserve_path_and_query': preservePathAndQuery!,
    if (targetUri != null) 'target_uri': targetUri!,
  };

  RuleSettingsRedirect copyWith({
    bool? includeContext,
    bool? preservePathAndQuery,
    String? targetUri,
    Map<String, Object?>? extra,
  }) => RuleSettingsRedirect(
    includeContext: includeContext ?? this.includeContext,
    preservePathAndQuery: preservePathAndQuery ?? this.preservePathAndQuery,
    targetUri: targetUri ?? this.targetUri,
    extra: extra ?? this.extra,
  );
}

/// Configure to forward the query to the internal DNS service, passing the
/// specified 'view_id' as input. Not used when 'dns_resolvers' is specified or
/// 'resolve_dns_through_cloudflare' is set. Only valid when a rule's action set
/// to 'resolve'. Settable only for `dns_resolver` rules.
class RuleSettingsResolveDnsInternally {
  const RuleSettingsResolveDnsInternally({
    this.fallback,
    this.viewId,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsResolveDnsInternally.fromJson(
    Map<String, Object?> json,
  ) => RuleSettingsResolveDnsInternally(
    fallback: asString(json['fallback']),
    viewId: asString(json['view_id']),
    extra: extraOf(json, _knownKeys),
  );

  /// Specify the fallback behavior to apply when the internal DNS response code
  /// differs from 'NOERROR' or when the response data contains only CNAME records
  /// for 'A' or 'AAAA' queries. Allowed values: `none`, `public_dns`.
  final String? fallback;

  /// Specify the internal DNS view identifier to pass to the internal DNS
  /// service.
  final String? viewId;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'fallback', 'view_id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (fallback != null) 'fallback': fallback!,
    if (viewId != null) 'view_id': viewId!,
  };

  RuleSettingsResolveDnsInternally copyWith({
    String? fallback,
    String? viewId,
    Map<String, Object?>? extra,
  }) => RuleSettingsResolveDnsInternally(
    fallback: fallback ?? this.fallback,
    viewId: viewId ?? this.viewId,
    extra: extra ?? this.extra,
  );
}

/// Configure behavior when an upstream certificate is invalid or an SSL error
/// occurs. Settable only for `http` rules with the action set to `allow`.
class RuleSettingsUntrustedCert {
  const RuleSettingsUntrustedCert({
    this.action,
    this.extra = const <String, Object?>{},
  });

  factory RuleSettingsUntrustedCert.fromJson(Map<String, Object?> json) =>
      RuleSettingsUntrustedCert(
        action: asString(json['action']),
        extra: extraOf(json, _knownKeys),
      );

  /// Defines the action performed when an untrusted certificate seen. The default
  /// action an error with HTTP code 526. Allowed values: `pass_through`, `block`,
  /// `error`.
  final String? action;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'action'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (action != null) 'action': action!,
  };

  RuleSettingsUntrustedCert copyWith({
    String? action,
    Map<String, Object?>? extra,
  }) => RuleSettingsUntrustedCert(
    action: action ?? this.action,
    extra: extra ?? this.extra,
  );
}

class Rules {
  const Rules({
    this.action,
    this.createdAt,
    this.deletedAt,
    this.description,
    this.devicePosture,
    this.enabled,
    this.expiration,
    this.filters,
    this.id,
    this.identity,
    this.name,
    this.precedence,
    this.readOnly,
    this.ruleSettings,
    this.schedule,
    this.sharable,
    this.sourceAccount,
    this.traffic,
    this.updatedAt,
    this.version,
    this.warningStatus,
    this.extra = const <String, Object?>{},
  });

  factory Rules.fromJson(Map<String, Object?> json) => Rules(
    action: asString(json['action']),
    createdAt: asString(json['created_at']),
    deletedAt: asString(json['deleted_at']),
    description: asString(json['description']),
    devicePosture: asString(json['device_posture']),
    enabled: asBool(json['enabled']),
    expiration: asModel(json['expiration'], Expiration.fromJson),
    filters: asPrimitiveList<String>(json['filters'], asString),
    id: asString(json['id']),
    identity: asString(json['identity']),
    name: asString(json['name']),
    precedence: asInt(json['precedence']),
    readOnly: asBool(json['read_only']),
    ruleSettings: asModel(json['rule_settings'], RuleSettings.fromJson),
    schedule: asModel(json['schedule'], Schedule2.fromJson),
    sharable: asBool(json['sharable']),
    sourceAccount: asString(json['source_account']),
    traffic: asString(json['traffic']),
    updatedAt: asString(json['updated_at']),
    version: asInt(json['version']),
    warningStatus: asString(json['warning_status']),
    extra: extraOf(json, _knownKeys),
  );

  /// Specify the action to perform when the associated traffic, identity, and
  /// device posture expressions either absent or evaluate to `true`. Allowed
  /// values: `on`, `off`, `allow`, `block`, `scan`, `noscan`, `safesearch`,
  /// `ytrestricted`, `isolate`, `noisolate`, `override`, `l4_override`, `egress`,
  /// `resolve`, `quarantine`, `redirect`.
  final String? action;
  final String? createdAt;

  /// Indicate the date of deletion, if any.
  final String? deletedAt;

  /// Specify the rule description.
  final String? description;

  /// Specify the wirefilter expression used for device posture check. The API
  /// automatically formats and sanitizes expressions before storing them. To
  /// prevent Terraform state drift, use the formatted expression returned in the
  /// API response.
  final String? devicePosture;

  /// Specify whether the rule is enabled.
  final bool? enabled;

  /// Defines the expiration time stamp and default duration of a DNS policy.
  /// Takes precedence over the policy's `schedule` configuration, if any. This
  /// does not apply to HTTP or network policies. Settable only for `dns` rules.
  final Expiration? expiration;

  /// Specify the protocol or layer to evaluate the traffic, identity, and device
  /// posture expressions. Can only contain a single value.
  final List<String>? filters;

  /// Identify the API resource with a UUID.
  final String? id;

  /// Specify the wirefilter expression used for identity matching. The API
  /// automatically formats and sanitizes expressions before storing them. To
  /// prevent Terraform state drift, use the formatted expression returned in the
  /// API response.
  final String? identity;

  /// Specify the rule name.
  final String? name;

  /// Set the order of your rules. Lower values indicate higher precedence. At
  /// each processing phase, evaluate applicable rules in ascending order of this
  /// value. Refer to [Order of
  /// enforcement](http://developers.cloudflare.com/learning-paths/secure-internet-traffic/understand-policies/order-of-enforcement/#manage-precedence-with-terraform)
  /// to manage precedence via Terraform.
  final int? precedence;

  /// Indicate that this rule is shared via the Orgs API and read only.
  final bool? readOnly;

  /// Defines settings for this rule. Settings apply only to specific rule types
  /// and must use compatible selectors. If Terraform detects drift, confirm the
  /// setting supports your rule type and check whether the API modifies the
  /// value. Use API-returned values in your configuration to prevent drift.
  final RuleSettings? ruleSettings;

  /// Defines the schedule for activating DNS policies. Settable only for `dns`
  /// and `dns_resolver` rules.
  final Schedule2? schedule;

  /// Indicate that this rule is sharable via the Orgs API.
  final bool? sharable;

  /// Provide the account tag of the account that created the rule.
  final String? sourceAccount;

  /// Specify the wirefilter expression used for traffic matching. The API
  /// automatically formats and sanitizes expressions before storing them. To
  /// prevent Terraform state drift, use the formatted expression returned in the
  /// API response.
  final String? traffic;
  final String? updatedAt;

  /// Indicate the version number of the rule(read-only).
  final int? version;

  /// Indicate a warning for a misconfigured rule, if any.
  final String? warningStatus;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'action',
    'created_at',
    'deleted_at',
    'description',
    'device_posture',
    'enabled',
    'expiration',
    'filters',
    'id',
    'identity',
    'name',
    'precedence',
    'read_only',
    'rule_settings',
    'schedule',
    'sharable',
    'source_account',
    'traffic',
    'updated_at',
    'version',
    'warning_status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (action != null) 'action': action!,
    if (createdAt != null) 'created_at': createdAt!,
    if (deletedAt != null) 'deleted_at': deletedAt!,
    if (description != null) 'description': description!,
    if (devicePosture != null) 'device_posture': devicePosture!,
    if (enabled != null) 'enabled': enabled!,
    if (expiration != null) 'expiration': expiration!.toJson(),
    if (filters != null) 'filters': filters!,
    if (id != null) 'id': id!,
    if (identity != null) 'identity': identity!,
    if (name != null) 'name': name!,
    if (precedence != null) 'precedence': precedence!,
    if (readOnly != null) 'read_only': readOnly!,
    if (ruleSettings != null) 'rule_settings': ruleSettings!.toJson(),
    if (schedule != null) 'schedule': schedule!.toJson(),
    if (sharable != null) 'sharable': sharable!,
    if (sourceAccount != null) 'source_account': sourceAccount!,
    if (traffic != null) 'traffic': traffic!,
    if (updatedAt != null) 'updated_at': updatedAt!,
    if (version != null) 'version': version!,
    if (warningStatus != null) 'warning_status': warningStatus!,
  };

  Rules copyWith({
    String? action,
    String? createdAt,
    String? deletedAt,
    String? description,
    String? devicePosture,
    bool? enabled,
    Expiration? expiration,
    List<String>? filters,
    String? id,
    String? identity,
    String? name,
    int? precedence,
    bool? readOnly,
    RuleSettings? ruleSettings,
    Schedule2? schedule,
    bool? sharable,
    String? sourceAccount,
    String? traffic,
    String? updatedAt,
    int? version,
    String? warningStatus,
    Map<String, Object?>? extra,
  }) => Rules(
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt ?? this.deletedAt,
    description: description ?? this.description,
    devicePosture: devicePosture ?? this.devicePosture,
    enabled: enabled ?? this.enabled,
    expiration: expiration ?? this.expiration,
    filters: filters ?? this.filters,
    id: id ?? this.id,
    identity: identity ?? this.identity,
    name: name ?? this.name,
    precedence: precedence ?? this.precedence,
    readOnly: readOnly ?? this.readOnly,
    ruleSettings: ruleSettings ?? this.ruleSettings,
    schedule: schedule ?? this.schedule,
    sharable: sharable ?? this.sharable,
    sourceAccount: sourceAccount ?? this.sourceAccount,
    traffic: traffic ?? this.traffic,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    warningStatus: warningStatus ?? this.warningStatus,
    extra: extra ?? this.extra,
  );
}

class Schedule {
  const Schedule({
    this.createdOn,
    this.cron,
    this.modifiedOn,
    this.extra = const <String, Object?>{},
  });

  factory Schedule.fromJson(Map<String, Object?> json) => Schedule(
    createdOn: asString(json['created_on']),
    cron: asString(json['cron']),
    modifiedOn: asString(json['modified_on']),
    extra: extraOf(json, _knownKeys),
  );

  final String? createdOn;
  final String? cron;
  final String? modifiedOn;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'created_on', 'cron', 'modified_on'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (createdOn != null) 'created_on': createdOn!,
    if (cron != null) 'cron': cron!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
  };

  Schedule copyWith({
    String? createdOn,
    String? cron,
    String? modifiedOn,
    Map<String, Object?>? extra,
  }) => Schedule(
    createdOn: createdOn ?? this.createdOn,
    cron: cron ?? this.cron,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    extra: extra ?? this.extra,
  );
}

/// Defines the schedule for activating DNS policies. Settable only for `dns`
/// and `dns_resolver` rules.
class Schedule2 {
  const Schedule2({
    this.fri,
    this.mon,
    this.sat,
    this.sun,
    this.thu,
    this.timeZone,
    this.tue,
    this.wed,
    this.extra = const <String, Object?>{},
  });

  factory Schedule2.fromJson(Map<String, Object?> json) => Schedule2(
    fri: asString(json['fri']),
    mon: asString(json['mon']),
    sat: asString(json['sat']),
    sun: asString(json['sun']),
    thu: asString(json['thu']),
    timeZone: asString(json['time_zone']),
    tue: asString(json['tue']),
    wed: asString(json['wed']),
    extra: extraOf(json, _knownKeys),
  );

  /// Specify the time intervals when the rule is active on Fridays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Fridays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? fri;

  /// Specify the time intervals when the rule is active on Mondays, in the
  /// increasing order from 00:00-24:00(capped at maximum of 6 time splits). If
  /// this parameter omitted, the rule is deactivated on Mondays. API returns a
  /// formatted version of this string, which may cause Terraform drift if a
  /// unformatted value is used.
  final String? mon;

  /// Specify the time intervals when the rule is active on Saturdays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Saturdays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? sat;

  /// Specify the time intervals when the rule is active on Sundays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Sundays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? sun;

  /// Specify the time intervals when the rule is active on Thursdays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Thursdays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? thu;

  /// Specify the time zone for rule evaluation. When a [valid time zone city
  /// name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) is
  /// provided, Gateway always uses the current time for that time zone. When this
  /// parameter is omitted, Gateway uses the time zone determined from the user's
  /// IP address. Colo time zone is used when the user's IP address does not
  /// resolve to a location.
  final String? timeZone;

  /// Specify the time intervals when the rule is active on Tuesdays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Tuesdays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? tue;

  /// Specify the time intervals when the rule is active on Wednesdays, in the
  /// increasing order from 00:00-24:00. If this parameter omitted, the rule is
  /// deactivated on Wednesdays. API returns a formatted version of this string,
  /// which may cause Terraform drift if a unformatted value is used.
  final String? wed;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'fri',
    'mon',
    'sat',
    'sun',
    'thu',
    'time_zone',
    'tue',
    'wed',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (fri != null) 'fri': fri!,
    if (mon != null) 'mon': mon!,
    if (sat != null) 'sat': sat!,
    if (sun != null) 'sun': sun!,
    if (thu != null) 'thu': thu!,
    if (timeZone != null) 'time_zone': timeZone!,
    if (tue != null) 'tue': tue!,
    if (wed != null) 'wed': wed!,
  };

  Schedule2 copyWith({
    String? fri,
    String? mon,
    String? sat,
    String? sun,
    String? thu,
    String? timeZone,
    String? tue,
    String? wed,
    Map<String, Object?>? extra,
  }) => Schedule2(
    fri: fri ?? this.fri,
    mon: mon ?? this.mon,
    sat: sat ?? this.sat,
    sun: sun ?? this.sun,
    thu: thu ?? this.thu,
    timeZone: timeZone ?? this.timeZone,
    tue: tue ?? this.tue,
    wed: wed ?? this.wed,
    extra: extra ?? this.extra,
  );
}

class SchemasConnection {
  const SchemasConnection({
    this.clientId,
    this.clientVersion,
    this.coloName,
    this.id,
    this.isPendingReconnect,
    this.openedAt,
    this.originIp,
    this.uuid,
    this.extra = const <String, Object?>{},
  });

  factory SchemasConnection.fromJson(Map<String, Object?> json) =>
      SchemasConnection(
        clientId: asString(json['client_id']),
        clientVersion: asString(json['client_version']),
        coloName: asString(json['colo_name']),
        id: asString(json['id']),
        isPendingReconnect: asBool(json['is_pending_reconnect']),
        openedAt: asString(json['opened_at']),
        originIp: json['origin_ip'],
        uuid: asString(json['uuid']),
        extra: extraOf(json, _knownKeys),
      );

  /// UUID of the Cloudflare Tunnel connector.
  final String? clientId;

  /// The cloudflared version used to establish this connection.
  final String? clientVersion;

  /// The Cloudflare data center used for this connection.
  final String? coloName;

  /// UUID of the Cloudflare Tunnel connection.
  final String? id;

  /// Cloudflare continues to track connections for several minutes after they
  /// disconnect. This is an optimization to improve latency and reliability of
  /// reconnecting. If `true`, the connection has disconnected but is still being
  /// tracked. If `false`, the connection is actively serving traffic.
  final bool? isPendingReconnect;

  /// Timestamp of when the connection was established.
  final String? openedAt;

  /// The public IP address of the host running cloudflared.
  final Object? originIp;

  /// UUID of the Cloudflare Tunnel connection.
  final String? uuid;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'client_id',
    'client_version',
    'colo_name',
    'id',
    'is_pending_reconnect',
    'opened_at',
    'origin_ip',
    'uuid',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (clientId != null) 'client_id': clientId!,
    if (clientVersion != null) 'client_version': clientVersion!,
    if (coloName != null) 'colo_name': coloName!,
    if (id != null) 'id': id!,
    if (isPendingReconnect != null) 'is_pending_reconnect': isPendingReconnect!,
    if (openedAt != null) 'opened_at': openedAt!,
    if (originIp != null) 'origin_ip': originIp!,
    if (uuid != null) 'uuid': uuid!,
  };

  SchemasConnection copyWith({
    String? clientId,
    String? clientVersion,
    String? coloName,
    String? id,
    bool? isPendingReconnect,
    String? openedAt,
    Object? originIp,
    String? uuid,
    Map<String, Object?>? extra,
  }) => SchemasConnection(
    clientId: clientId ?? this.clientId,
    clientVersion: clientVersion ?? this.clientVersion,
    coloName: coloName ?? this.coloName,
    id: id ?? this.id,
    isPendingReconnect: isPendingReconnect ?? this.isPendingReconnect,
    openedAt: openedAt ?? this.openedAt,
    originIp: originIp ?? this.originIp,
    uuid: uuid ?? this.uuid,
    extra: extra ?? this.extra,
  );
}

/// Configuration for provisioning to this application via SCIM. This is
/// currently in closed beta.
class ScimConfig {
  const ScimConfig({
    this.authentication,
    this.deactivateOnDelete,
    this.enabled,
    this.idpUid,
    this.mappings,
    this.remoteUri,
    this.extra = const <String, Object?>{},
  });

  factory ScimConfig.fromJson(Map<String, Object?> json) => ScimConfig(
    authentication: asModel(
      json['authentication'],
      ScimConfigAuthentication.fromJson,
    ),
    deactivateOnDelete: asBool(json['deactivate_on_delete']),
    enabled: asBool(json['enabled']),
    idpUid: asString(json['idp_uid']),
    mappings: asModelList(json['mappings'], ScimConfigMapping.fromJson),
    remoteUri: asString(json['remote_uri']),
    extra: extraOf(json, _knownKeys),
  );

  final ScimConfigAuthentication? authentication;

  /// If false, propagates DELETE requests to the target application for SCIM
  /// resources. If true, sets 'active' to false on the SCIM resource. Note: Some
  /// targets do not support DELETE operations.
  final bool? deactivateOnDelete;

  /// Whether SCIM provisioning is turned on for this application.
  final bool? enabled;

  /// The UID of the IdP to use as the source for SCIM resources to provision to
  /// this application.
  final String? idpUid;

  /// A list of mappings to apply to SCIM resources before provisioning them in
  /// this application. These can transform or filter the resources to be
  /// provisioned.
  final List<ScimConfigMapping>? mappings;

  /// The base URI for the application's SCIM-compatible API.
  final String? remoteUri;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'authentication',
    'deactivate_on_delete',
    'enabled',
    'idp_uid',
    'mappings',
    'remote_uri',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (authentication != null) 'authentication': authentication!.toJson(),
    if (deactivateOnDelete != null) 'deactivate_on_delete': deactivateOnDelete!,
    if (enabled != null) 'enabled': enabled!,
    if (idpUid != null) 'idp_uid': idpUid!,
    if (mappings != null) 'mappings': mappings!.map((e) => e.toJson()).toList(),
    if (remoteUri != null) 'remote_uri': remoteUri!,
  };

  ScimConfig copyWith({
    ScimConfigAuthentication? authentication,
    bool? deactivateOnDelete,
    bool? enabled,
    String? idpUid,
    List<ScimConfigMapping>? mappings,
    String? remoteUri,
    Map<String, Object?>? extra,
  }) => ScimConfig(
    authentication: authentication ?? this.authentication,
    deactivateOnDelete: deactivateOnDelete ?? this.deactivateOnDelete,
    enabled: enabled ?? this.enabled,
    idpUid: idpUid ?? this.idpUid,
    mappings: mappings ?? this.mappings,
    remoteUri: remoteUri ?? this.remoteUri,
    extra: extra ?? this.extra,
  );
}

class ScimConfigAuthentication {
  const ScimConfigAuthentication({
    this.password,
    this.scheme,
    this.user,
    this.token,
    this.authorizationUrl,
    this.clientId,
    this.clientSecret,
    this.scopes,
    this.tokenUrl,
    this.extra = const <String, Object?>{},
  });

  factory ScimConfigAuthentication.fromJson(Map<String, Object?> json) =>
      ScimConfigAuthentication(
        password: asString(json['password']),
        scheme: asString(json['scheme']),
        user: asString(json['user']),
        token: asString(json['token']),
        authorizationUrl: asString(json['authorization_url']),
        clientId: asString(json['client_id']),
        clientSecret: asString(json['client_secret']),
        scopes: asPrimitiveList<String>(json['scopes'], asString),
        tokenUrl: asString(json['token_url']),
        extra: extraOf(json, _knownKeys),
      );

  /// Password used to authenticate with the remote SCIM service.
  final String? password;

  /// The authentication scheme to use when making SCIM requests to this
  /// application. Allowed values: `access_service_token`.
  final String? scheme;

  /// User name used to authenticate with the remote SCIM service.
  final String? user;

  /// Token used to authenticate with the remote SCIM service.
  final String? token;

  /// URL used to generate the auth code used during token generation.
  final String? authorizationUrl;

  /// Client ID of the Access service token used to authenticate with the remote
  /// service.
  final String? clientId;

  /// Client secret of the Access service token used to authenticate with the
  /// remote service.
  final String? clientSecret;

  /// The authorization scopes to request when generating the token used to
  /// authenticate with the remove SCIM service.
  final List<String>? scopes;

  /// URL used to generate the token used to authenticate with the remote SCIM
  /// service.
  final String? tokenUrl;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'password',
    'scheme',
    'user',
    'token',
    'authorization_url',
    'client_id',
    'client_secret',
    'scopes',
    'token_url',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (password != null) 'password': password!,
    if (scheme != null) 'scheme': scheme!,
    if (user != null) 'user': user!,
    if (token != null) 'token': token!,
    if (authorizationUrl != null) 'authorization_url': authorizationUrl!,
    if (clientId != null) 'client_id': clientId!,
    if (clientSecret != null) 'client_secret': clientSecret!,
    if (scopes != null) 'scopes': scopes!,
    if (tokenUrl != null) 'token_url': tokenUrl!,
  };

  ScimConfigAuthentication copyWith({
    String? password,
    String? scheme,
    String? user,
    String? token,
    String? authorizationUrl,
    String? clientId,
    String? clientSecret,
    List<String>? scopes,
    String? tokenUrl,
    Map<String, Object?>? extra,
  }) => ScimConfigAuthentication(
    password: password ?? this.password,
    scheme: scheme ?? this.scheme,
    user: user ?? this.user,
    token: token ?? this.token,
    authorizationUrl: authorizationUrl ?? this.authorizationUrl,
    clientId: clientId ?? this.clientId,
    clientSecret: clientSecret ?? this.clientSecret,
    scopes: scopes ?? this.scopes,
    tokenUrl: tokenUrl ?? this.tokenUrl,
    extra: extra ?? this.extra,
  );
}

/// Transformations and filters applied to resources before they are provisioned
/// in the remote SCIM service.
class ScimConfigMapping {
  const ScimConfigMapping({
    this.enabled,
    this.filter,
    this.operations,
    this.schema,
    this.strictness,
    this.transformJsonata,
    this.extra = const <String, Object?>{},
  });

  factory ScimConfigMapping.fromJson(Map<String, Object?> json) =>
      ScimConfigMapping(
        enabled: asBool(json['enabled']),
        filter: asString(json['filter']),
        operations: asModel(
          json['operations'],
          ScimConfigMappingOperations.fromJson,
        ),
        schema: asString(json['schema']),
        strictness: asString(json['strictness']),
        transformJsonata: asString(json['transform_jsonata']),
        extra: extraOf(json, _knownKeys),
      );

  /// Whether or not this mapping is enabled.
  final bool? enabled;

  /// A [SCIM filter
  /// expression](https://datatracker.ietf.org/doc/html/rfc7644#section-3.4.2.2)
  /// that matches resources that should be provisioned to this application.
  final String? filter;

  /// Whether or not this mapping applies to creates, updates, or deletes.
  final ScimConfigMappingOperations? operations;

  /// Which SCIM resource type this mapping applies to.
  final String? schema;

  /// The level of adherence to outbound resource schemas when provisioning to
  /// this mapping. ‘Strict’ removes unknown values, while ‘passthrough’ passes
  /// unknown values to the target. Allowed values: `strict`, `passthrough`.
  final String? strictness;

  /// A [JSONata](https://jsonata.org/) expression that transforms the resource
  /// before provisioning it in the application.
  final String? transformJsonata;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'filter',
    'operations',
    'schema',
    'strictness',
    'transform_jsonata',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (filter != null) 'filter': filter!,
    if (operations != null) 'operations': operations!.toJson(),
    if (schema != null) 'schema': schema!,
    if (strictness != null) 'strictness': strictness!,
    if (transformJsonata != null) 'transform_jsonata': transformJsonata!,
  };

  ScimConfigMapping copyWith({
    bool? enabled,
    String? filter,
    ScimConfigMappingOperations? operations,
    String? schema,
    String? strictness,
    String? transformJsonata,
    Map<String, Object?>? extra,
  }) => ScimConfigMapping(
    enabled: enabled ?? this.enabled,
    filter: filter ?? this.filter,
    operations: operations ?? this.operations,
    schema: schema ?? this.schema,
    strictness: strictness ?? this.strictness,
    transformJsonata: transformJsonata ?? this.transformJsonata,
    extra: extra ?? this.extra,
  );
}

/// Whether or not this mapping applies to creates, updates, or deletes.
class ScimConfigMappingOperations {
  const ScimConfigMappingOperations({
    this.create,
    this.delete,
    this.update,
    this.extra = const <String, Object?>{},
  });

  factory ScimConfigMappingOperations.fromJson(Map<String, Object?> json) =>
      ScimConfigMappingOperations(
        create: asBool(json['create']),
        delete: asBool(json['delete']),
        update: asBool(json['update']),
        extra: extraOf(json, _knownKeys),
      );

  /// Whether or not this mapping applies to create (POST) operations.
  final bool? create;

  /// Whether or not this mapping applies to DELETE operations.
  final bool? delete;

  /// Whether or not this mapping applies to update (PATCH/PUT) operations.
  final bool? update;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'create', 'delete', 'update'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (create != null) 'create': create!,
    if (delete != null) 'delete': delete!,
    if (update != null) 'update': update!,
  };

  ScimConfigMappingOperations copyWith({
    bool? create,
    bool? delete,
    bool? update,
    Map<String, Object?>? extra,
  }) => ScimConfigMappingOperations(
    create: create ?? this.create,
    delete: delete ?? this.delete,
    update: update ?? this.update,
    extra: extra ?? this.extra,
  );
}

class ScriptAndVersionSettingsItem {
  const ScriptAndVersionSettingsItem({
    this.annotations,
    this.bindings,
    this.cacheOptions,
    this.compatibilityDate,
    this.compatibilityFlags,
    this.exports,
    this.exportsReconciliation,
    this.limits,
    this.logpush,
    this.migrations,
    this.observability,
    this.placement,
    this.tags,
    this.tailConsumers,
    this.usageModel,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItem.fromJson(Map<String, Object?> json) =>
      ScriptAndVersionSettingsItem(
        annotations: asModel(
          json['annotations'],
          ScriptAndVersionSettingsItemAnnotations.fromJson,
        ),
        bindings: json['bindings'],
        cacheOptions: asModel(json['cache_options'], CacheOptions.fromJson),
        compatibilityDate: json['compatibility_date'],
        compatibilityFlags: json['compatibility_flags'],
        exports: asMap(json['exports']),
        exportsReconciliation: asModel(
          json['exports_reconciliation'],
          ScriptAndVersionSettingsItemExportsReconciliation.fromJson,
        ),
        limits: asModel(json['limits'], Limits.fromJson),
        logpush: asBool(json['logpush']),
        migrations: asModel(
          json['migrations'],
          ScriptAndVersionSettingsItemMigrations.fromJson,
        ),
        observability: asModel(json['observability'], Observability.fromJson),
        placement: asModel(
          json['placement'],
          ScriptAndVersionSettingsItemPlacement.fromJson,
        ),
        tags: json['tags'],
        tailConsumers: json['tail_consumers'],
        usageModel: asString(json['usage_model']),
        extra: extraOf(json, _knownKeys),
      );

  /// Annotations for the Worker version. Annotations are not inherited across
  /// settings updates; omitting this field means the new version will have no
  /// annotations.
  final ScriptAndVersionSettingsItemAnnotations? annotations;
  final Object? bindings;

  /// Global CacheW configuration for the Worker. When caching is on, the platform
  /// provisions a `cloudflare.app` zone for the Worker. A `type: worker` entry in
  /// the `exports` map can override this value for a single entrypoint.
  final CacheOptions? cacheOptions;
  final Object? compatibilityDate;
  final Object? compatibilityFlags;

  /// Declarative exports for the Worker. Worker entrypoint entries (`type:
  /// worker`) carry cache configuration for that entrypoint.
  final Map<String, Object?>? exports;

  /// Summary of the declarative exports reconciliation that ran on this upload.
  /// Populated only when the uploaded metadata included an `exports` block.
  /// Durable Object entries drive reconciliation; `type: worker` entries do not
  /// contribute to this summary.
  final ScriptAndVersionSettingsItemExportsReconciliation?
  exportsReconciliation;

  /// Limits to apply for this Worker.
  final Limits? limits;

  /// Whether Logpush is turned on for the Worker.
  final bool? logpush;

  /// Migrations to apply for Durable Objects associated with this Worker.
  final ScriptAndVersionSettingsItemMigrations? migrations;

  /// Observability settings for the Worker.
  final Observability? observability;
  final ScriptAndVersionSettingsItemPlacement? placement;
  final Object? tags;
  final Object? tailConsumers;

  /// Usage model for the Worker invocations. Allowed values: `standard`,
  /// `bundled`, `unbound`.
  final String? usageModel;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'annotations',
    'bindings',
    'cache_options',
    'compatibility_date',
    'compatibility_flags',
    'exports',
    'exports_reconciliation',
    'limits',
    'logpush',
    'migrations',
    'observability',
    'placement',
    'tags',
    'tail_consumers',
    'usage_model',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (annotations != null) 'annotations': annotations!.toJson(),
    if (bindings != null) 'bindings': bindings!,
    if (cacheOptions != null) 'cache_options': cacheOptions!.toJson(),
    if (compatibilityDate != null) 'compatibility_date': compatibilityDate!,
    if (compatibilityFlags != null) 'compatibility_flags': compatibilityFlags!,
    if (exports != null) 'exports': exports!,
    if (exportsReconciliation != null)
      'exports_reconciliation': exportsReconciliation!.toJson(),
    if (limits != null) 'limits': limits!.toJson(),
    if (logpush != null) 'logpush': logpush!,
    if (migrations != null) 'migrations': migrations!.toJson(),
    if (observability != null) 'observability': observability!.toJson(),
    if (placement != null) 'placement': placement!.toJson(),
    if (tags != null) 'tags': tags!,
    if (tailConsumers != null) 'tail_consumers': tailConsumers!,
    if (usageModel != null) 'usage_model': usageModel!,
  };

  ScriptAndVersionSettingsItem copyWith({
    ScriptAndVersionSettingsItemAnnotations? annotations,
    Object? bindings,
    CacheOptions? cacheOptions,
    Object? compatibilityDate,
    Object? compatibilityFlags,
    Map<String, Object?>? exports,
    ScriptAndVersionSettingsItemExportsReconciliation? exportsReconciliation,
    Limits? limits,
    bool? logpush,
    ScriptAndVersionSettingsItemMigrations? migrations,
    Observability? observability,
    ScriptAndVersionSettingsItemPlacement? placement,
    Object? tags,
    Object? tailConsumers,
    String? usageModel,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItem(
    annotations: annotations ?? this.annotations,
    bindings: bindings ?? this.bindings,
    cacheOptions: cacheOptions ?? this.cacheOptions,
    compatibilityDate: compatibilityDate ?? this.compatibilityDate,
    compatibilityFlags: compatibilityFlags ?? this.compatibilityFlags,
    exports: exports ?? this.exports,
    exportsReconciliation: exportsReconciliation ?? this.exportsReconciliation,
    limits: limits ?? this.limits,
    logpush: logpush ?? this.logpush,
    migrations: migrations ?? this.migrations,
    observability: observability ?? this.observability,
    placement: placement ?? this.placement,
    tags: tags ?? this.tags,
    tailConsumers: tailConsumers ?? this.tailConsumers,
    usageModel: usageModel ?? this.usageModel,
    extra: extra ?? this.extra,
  );
}

/// Annotations for the Worker version. Annotations are not inherited across
/// settings updates; omitting this field means the new version will have no
/// annotations.
class ScriptAndVersionSettingsItemAnnotations {
  const ScriptAndVersionSettingsItemAnnotations({
    this.workersMessage,
    this.workersTag,
    this.workersTriggeredBy,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemAnnotations.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemAnnotations(
    workersMessage: asString(json['workers/message']),
    workersTag: asString(json['workers/tag']),
    workersTriggeredBy: asString(json['workers/triggered_by']),
    extra: extraOf(json, _knownKeys),
  );

  /// Human-readable message about the version. Truncated to 1000 bytes if longer.
  final String? workersMessage;

  /// User-provided identifier for the version. Maximum 100 bytes.
  final String? workersTag;

  /// Operation that triggered the creation of the version. This is read-only and
  /// set by the server.
  final String? workersTriggeredBy;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'workers/message',
    'workers/tag',
    'workers/triggered_by',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (workersMessage != null) 'workers/message': workersMessage!,
    if (workersTag != null) 'workers/tag': workersTag!,
    if (workersTriggeredBy != null) 'workers/triggered_by': workersTriggeredBy!,
  };

  ScriptAndVersionSettingsItemAnnotations copyWith({
    String? workersMessage,
    String? workersTag,
    String? workersTriggeredBy,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemAnnotations(
    workersMessage: workersMessage ?? this.workersMessage,
    workersTag: workersTag ?? this.workersTag,
    workersTriggeredBy: workersTriggeredBy ?? this.workersTriggeredBy,
    extra: extra ?? this.extra,
  );
}

/// Summary of the declarative exports reconciliation that ran on this upload.
/// Populated only when the uploaded metadata included an `exports` block.
/// Durable Object entries drive reconciliation; `type: worker` entries do not
/// contribute to this summary.
class ScriptAndVersionSettingsItemExportsReconciliation {
  const ScriptAndVersionSettingsItemExportsReconciliation({
    this.created,
    this.deleted,
    this.info,
    this.removableEntries,
    this.renamed,
    this.transferPending,
    this.transferred,
    this.updated,
    this.warnings,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemExportsReconciliation.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemExportsReconciliation(
    created: asPrimitiveList<String>(json['created'], asString),
    deleted: asPrimitiveList<String>(json['deleted'], asString),
    info: asModelList(json['info'], ExportsReconciliationInfo.fromJson),
    removableEntries: asPrimitiveList<String>(
      json['removable_entries'],
      asString,
    ),
    renamed: asModelList(json['renamed'], ExportsReconciliationRename.fromJson),
    transferPending: asModelList(
      json['transfer_pending'],
      ExportsReconciliationTransferPending.fromJson,
    ),
    transferred: asModelList(
      json['transferred'],
      ExportsReconciliationTransfer.fromJson,
    ),
    updated: asPrimitiveList<String>(json['updated'], asString),
    warnings: asModelList(
      json['warnings'],
      ExportsReconciliationWarning.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// Class names for which a new namespace was provisioned.
  final List<String>? created;

  /// Class names whose namespace was deleted by a `deleted` tombstone.
  final List<String>? deleted;

  /// Non-blocking info entries (stale tombstones, tombstone applied with class
  /// still in code). See `exports_reconciliation_info`.
  final List<ExportsReconciliationInfo>? info;

  /// Source class names whose tombstone entry is now stale and safe to delete
  /// from `exports` (no remaining referencing scripts).
  final List<String>? removableEntries;

  /// Applied `renamed` tombstones.
  final List<ExportsReconciliationRename>? renamed;

  /// Phase-1 transfer hints recorded on the target side.
  final List<ExportsReconciliationTransferPending>? transferPending;

  /// Committed `transferred` tombstones (phase-2).
  final List<ExportsReconciliationTransfer>? transferred;

  /// Class names whose provisioned namespace was mutated in place.
  final List<String>? updated;

  /// Non-blocking warnings. See `exports_reconciliation_warning`.
  final List<ExportsReconciliationWarning>? warnings;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'created',
    'deleted',
    'info',
    'removable_entries',
    'renamed',
    'transfer_pending',
    'transferred',
    'updated',
    'warnings',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (created != null) 'created': created!,
    if (deleted != null) 'deleted': deleted!,
    if (info != null) 'info': info!.map((e) => e.toJson()).toList(),
    if (removableEntries != null) 'removable_entries': removableEntries!,
    if (renamed != null) 'renamed': renamed!.map((e) => e.toJson()).toList(),
    if (transferPending != null)
      'transfer_pending': transferPending!.map((e) => e.toJson()).toList(),
    if (transferred != null)
      'transferred': transferred!.map((e) => e.toJson()).toList(),
    if (updated != null) 'updated': updated!,
    if (warnings != null) 'warnings': warnings!.map((e) => e.toJson()).toList(),
  };

  ScriptAndVersionSettingsItemExportsReconciliation copyWith({
    List<String>? created,
    List<String>? deleted,
    List<ExportsReconciliationInfo>? info,
    List<String>? removableEntries,
    List<ExportsReconciliationRename>? renamed,
    List<ExportsReconciliationTransferPending>? transferPending,
    List<ExportsReconciliationTransfer>? transferred,
    List<String>? updated,
    List<ExportsReconciliationWarning>? warnings,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemExportsReconciliation(
    created: created ?? this.created,
    deleted: deleted ?? this.deleted,
    info: info ?? this.info,
    removableEntries: removableEntries ?? this.removableEntries,
    renamed: renamed ?? this.renamed,
    transferPending: transferPending ?? this.transferPending,
    transferred: transferred ?? this.transferred,
    updated: updated ?? this.updated,
    warnings: warnings ?? this.warnings,
    extra: extra ?? this.extra,
  );
}

/// Migrations to apply for Durable Objects associated with this Worker.
class ScriptAndVersionSettingsItemMigrations {
  const ScriptAndVersionSettingsItemMigrations({
    this.newTag,
    this.oldTag,
    this.deletedClasses,
    this.newClasses,
    this.newSqliteClasses,
    this.renamedClasses,
    this.transferredClasses,
    this.steps,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemMigrations.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemMigrations(
    newTag: asString(json['new_tag']),
    oldTag: asString(json['old_tag']),
    deletedClasses: asPrimitiveList<String>(json['deleted_classes'], asString),
    newClasses: asPrimitiveList<String>(json['new_classes'], asString),
    newSqliteClasses: asPrimitiveList<String>(
      json['new_sqlite_classes'],
      asString,
    ),
    renamedClasses: asModelList(
      json['renamed_classes'],
      ScriptAndVersionSettingsItemMigrationsRenamedClassesItem.fromJson,
    ),
    transferredClasses: asModelList(
      json['transferred_classes'],
      ScriptAndVersionSettingsItemMigrationsTransferredClassesItem.fromJson,
    ),
    steps: asModelList(json['steps'], MigrationStep.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Tag to set as the latest migration tag.
  final String? newTag;

  /// Tag used to verify against the latest migration tag for this Worker. If they
  /// don't match, the upload is rejected.
  final String? oldTag;

  /// A list of classes to delete Durable Object namespaces from.
  final List<String>? deletedClasses;

  /// A list of classes to create Durable Object namespaces from.
  final List<String>? newClasses;

  /// A list of classes to create Durable Object namespaces with SQLite from.
  final List<String>? newSqliteClasses;

  /// A list of classes with Durable Object namespaces that were renamed.
  final List<ScriptAndVersionSettingsItemMigrationsRenamedClassesItem>?
  renamedClasses;

  /// A list of transfers for Durable Object namespaces from a different Worker
  /// and class to a class defined in this Worker.
  final List<ScriptAndVersionSettingsItemMigrationsTransferredClassesItem>?
  transferredClasses;

  /// Migrations to apply in order.
  final List<MigrationStep>? steps;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'new_tag',
    'old_tag',
    'deleted_classes',
    'new_classes',
    'new_sqlite_classes',
    'renamed_classes',
    'transferred_classes',
    'steps',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (newTag != null) 'new_tag': newTag!,
    if (oldTag != null) 'old_tag': oldTag!,
    if (deletedClasses != null) 'deleted_classes': deletedClasses!,
    if (newClasses != null) 'new_classes': newClasses!,
    if (newSqliteClasses != null) 'new_sqlite_classes': newSqliteClasses!,
    if (renamedClasses != null)
      'renamed_classes': renamedClasses!.map((e) => e.toJson()).toList(),
    if (transferredClasses != null)
      'transferred_classes': transferredClasses!
          .map((e) => e.toJson())
          .toList(),
    if (steps != null) 'steps': steps!.map((e) => e.toJson()).toList(),
  };

  ScriptAndVersionSettingsItemMigrations copyWith({
    String? newTag,
    String? oldTag,
    List<String>? deletedClasses,
    List<String>? newClasses,
    List<String>? newSqliteClasses,
    List<ScriptAndVersionSettingsItemMigrationsRenamedClassesItem>?
    renamedClasses,
    List<ScriptAndVersionSettingsItemMigrationsTransferredClassesItem>?
    transferredClasses,
    List<MigrationStep>? steps,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemMigrations(
    newTag: newTag ?? this.newTag,
    oldTag: oldTag ?? this.oldTag,
    deletedClasses: deletedClasses ?? this.deletedClasses,
    newClasses: newClasses ?? this.newClasses,
    newSqliteClasses: newSqliteClasses ?? this.newSqliteClasses,
    renamedClasses: renamedClasses ?? this.renamedClasses,
    transferredClasses: transferredClasses ?? this.transferredClasses,
    steps: steps ?? this.steps,
    extra: extra ?? this.extra,
  );
}

class ScriptAndVersionSettingsItemMigrationsRenamedClassesItem {
  const ScriptAndVersionSettingsItemMigrationsRenamedClassesItem({
    this.from,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemMigrationsRenamedClassesItem.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemMigrationsRenamedClassesItem(
    from: asString(json['from']),
    to: asString(json['to']),
    extra: extraOf(json, _knownKeys),
  );

  final String? from;
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'from', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (from != null) 'from': from!,
    if (to != null) 'to': to!,
  };

  ScriptAndVersionSettingsItemMigrationsRenamedClassesItem copyWith({
    String? from,
    String? to,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemMigrationsRenamedClassesItem(
    from: from ?? this.from,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

class ScriptAndVersionSettingsItemMigrationsTransferredClassesItem {
  const ScriptAndVersionSettingsItemMigrationsTransferredClassesItem({
    this.from,
    this.fromScript,
    this.to,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemMigrationsTransferredClassesItem.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemMigrationsTransferredClassesItem(
    from: asString(json['from']),
    fromScript: asString(json['from_script']),
    to: asString(json['to']),
    extra: extraOf(json, _knownKeys),
  );

  final String? from;
  final String? fromScript;
  final String? to;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'from', 'from_script', 'to'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (from != null) 'from': from!,
    if (fromScript != null) 'from_script': fromScript!,
    if (to != null) 'to': to!,
  };

  ScriptAndVersionSettingsItemMigrationsTransferredClassesItem copyWith({
    String? from,
    String? fromScript,
    String? to,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemMigrationsTransferredClassesItem(
    from: from ?? this.from,
    fromScript: fromScript ?? this.fromScript,
    to: to ?? this.to,
    extra: extra ?? this.extra,
  );
}

class ScriptAndVersionSettingsItemPlacement {
  const ScriptAndVersionSettingsItemPlacement({
    this.mode,
    this.region,
    this.hostname,
    this.host,
    this.target,
    this.extra = const <String, Object?>{},
  });

  factory ScriptAndVersionSettingsItemPlacement.fromJson(
    Map<String, Object?> json,
  ) => ScriptAndVersionSettingsItemPlacement(
    mode: asString(json['mode']),
    region: asString(json['region']),
    hostname: asString(json['hostname']),
    host: asString(json['host']),
    target: asModelList(json['target'], PlacementTarget.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// Targeted placement mode. Allowed values: `targeted`.
  final String? mode;

  /// Cloud region for targeted placement in format 'provider:region'.
  final String? region;

  /// HTTP hostname for targeted placement.
  final String? hostname;

  /// TCP host and port for targeted placement.
  final String? host;

  /// Array of placement targets (currently limited to single target).
  final List<PlacementTarget>? target;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'mode',
    'region',
    'hostname',
    'host',
    'target',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (mode != null) 'mode': mode!,
    if (region != null) 'region': region!,
    if (hostname != null) 'hostname': hostname!,
    if (host != null) 'host': host!,
    if (target != null) 'target': target!.map((e) => e.toJson()).toList(),
  };

  ScriptAndVersionSettingsItemPlacement copyWith({
    String? mode,
    String? region,
    String? hostname,
    String? host,
    List<PlacementTarget>? target,
    Map<String, Object?>? extra,
  }) => ScriptAndVersionSettingsItemPlacement(
    mode: mode ?? this.mode,
    region: region ?? this.region,
    hostname: hostname ?? this.hostname,
    host: host ?? this.host,
    target: target ?? this.target,
    extra: extra ?? this.extra,
  );
}

class Setting {
  const Setting({
    this.editable,
    this.id,
    this.modifiedOn,
    this.value,
    this.timeRemaining,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory Setting.fromJson(Map<String, Object?> json) => Setting(
    editable: asBool(json['editable']),
    id: json['id'],
    modifiedOn: asString(json['modified_on']),
    value: asString(json['value']),
    timeRemaining: asNum(json['time_remaining']),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not this setting can be modified for this zone (based on your
  /// Cloudflare plan level). Allowed values: `true`, `false`.
  final bool? editable;

  /// ID of the zone setting. Allowed values: `websockets`.
  final Object? id;

  /// last time this setting was modified.
  final String? modifiedOn;

  /// Value of the zone setting. Allowed values: `off`, `on`.
  final String? value;

  /// Value of the zone setting. Notes: The interval (in seconds) from when
  /// development mode expires (positive integer) or last expired (negative
  /// integer) for the domain. If development mode has never been enabled, this
  /// value is false.
  final num? timeRemaining;

  /// ssl-recommender enrollment setting.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'editable',
    'id',
    'modified_on',
    'value',
    'time_remaining',
    'enabled',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (editable != null) 'editable': editable!,
    if (id != null) 'id': id!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (value != null) 'value': value!,
    if (timeRemaining != null) 'time_remaining': timeRemaining!,
    if (enabled != null) 'enabled': enabled!,
  };

  Setting copyWith({
    bool? editable,
    Object? id,
    String? modifiedOn,
    String? value,
    num? timeRemaining,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => Setting(
    editable: editable ?? this.editable,
    id: id ?? this.id,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    value: value ?? this.value,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

class SettingValue {
  const SettingValue({
    this.enabled,
    this.poolId,
    this.cacheByDeviceType,
    this.cf,
    this.hostnames,
    this.wordpress,
    this.wpPlugin,
    this.strictTransportSecurity,
    this.extra = const <String, Object?>{},
  });

  factory SettingValue.fromJson(Map<String, Object?> json) => SettingValue(
    enabled: asBool(json['enabled']),
    poolId: asString(json['pool_id']),
    cacheByDeviceType: asBool(json['cache_by_device_type']),
    cf: asBool(json['cf']),
    hostnames: asPrimitiveList<String>(json['hostnames'], asString),
    wordpress: asBool(json['wordpress']),
    wpPlugin: asBool(json['wp_plugin']),
    strictTransportSecurity: asModel(
      json['strict_transport_security'],
      SettingValueStrictTransportSecurity.fromJson,
    ),
    extra: extraOf(json, _knownKeys),
  );

  /// Indicates whether or not Automatic Platform Optimization is enabled.
  final bool? enabled;

  /// Egress pool id which refers to a grouping of dedicated egress IPs through
  /// which Cloudflare will connect to origin.
  final String? poolId;

  /// Indicates whether or not [cache by device
  /// type](https://developers.cloudflare.com/automatic-platform-optimization/reference/cache-device-type/)
  /// is enabled.
  final bool? cacheByDeviceType;

  /// Indicates whether or not Cloudflare proxy is enabled.
  final bool? cf;

  /// An array of hostnames where Automatic Platform Optimization for WordPress is
  /// activated.
  final List<String>? hostnames;

  /// Indicates whether or not site is powered by WordPress.
  final bool? wordpress;

  /// Indicates whether or not [Cloudflare for WordPress
  /// plugin](https://wordpress.org/plugins/cloudflare/) is installed.
  final bool? wpPlugin;

  /// Strict Transport Security.
  final SettingValueStrictTransportSecurity? strictTransportSecurity;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'pool_id',
    'cache_by_device_type',
    'cf',
    'hostnames',
    'wordpress',
    'wp_plugin',
    'strict_transport_security',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (poolId != null) 'pool_id': poolId!,
    if (cacheByDeviceType != null) 'cache_by_device_type': cacheByDeviceType!,
    if (cf != null) 'cf': cf!,
    if (hostnames != null) 'hostnames': hostnames!,
    if (wordpress != null) 'wordpress': wordpress!,
    if (wpPlugin != null) 'wp_plugin': wpPlugin!,
    if (strictTransportSecurity != null)
      'strict_transport_security': strictTransportSecurity!.toJson(),
  };

  SettingValue copyWith({
    bool? enabled,
    String? poolId,
    bool? cacheByDeviceType,
    bool? cf,
    List<String>? hostnames,
    bool? wordpress,
    bool? wpPlugin,
    SettingValueStrictTransportSecurity? strictTransportSecurity,
    Map<String, Object?>? extra,
  }) => SettingValue(
    enabled: enabled ?? this.enabled,
    poolId: poolId ?? this.poolId,
    cacheByDeviceType: cacheByDeviceType ?? this.cacheByDeviceType,
    cf: cf ?? this.cf,
    hostnames: hostnames ?? this.hostnames,
    wordpress: wordpress ?? this.wordpress,
    wpPlugin: wpPlugin ?? this.wpPlugin,
    strictTransportSecurity:
        strictTransportSecurity ?? this.strictTransportSecurity,
    extra: extra ?? this.extra,
  );
}

/// Strict Transport Security.
class SettingValueStrictTransportSecurity {
  const SettingValueStrictTransportSecurity({
    this.enabled,
    this.includeSubdomains,
    this.maxAge,
    this.nosniff,
    this.preload,
    this.extra = const <String, Object?>{},
  });

  factory SettingValueStrictTransportSecurity.fromJson(
    Map<String, Object?> json,
  ) => SettingValueStrictTransportSecurity(
    enabled: asBool(json['enabled']),
    includeSubdomains: asBool(json['include_subdomains']),
    maxAge: asNum(json['max_age']),
    nosniff: asBool(json['nosniff']),
    preload: asBool(json['preload']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not strict transport security is enabled.
  final bool? enabled;

  /// Include all subdomains for strict transport security.
  final bool? includeSubdomains;

  /// Max age in seconds of the strict transport security.
  final num? maxAge;

  /// Whether or not to include 'X-Content-Type-Options: nosniff' header.
  final bool? nosniff;

  /// Enable automatic preload of the HSTS configuration.
  final bool? preload;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'enabled',
    'include_subdomains',
    'max_age',
    'nosniff',
    'preload',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (includeSubdomains != null) 'include_subdomains': includeSubdomains!,
    if (maxAge != null) 'max_age': maxAge!,
    if (nosniff != null) 'nosniff': nosniff!,
    if (preload != null) 'preload': preload!,
  };

  SettingValueStrictTransportSecurity copyWith({
    bool? enabled,
    bool? includeSubdomains,
    num? maxAge,
    bool? nosniff,
    bool? preload,
    Map<String, Object?>? extra,
  }) => SettingValueStrictTransportSecurity(
    enabled: enabled ?? this.enabled,
    includeSubdomains: includeSubdomains ?? this.includeSubdomains,
    maxAge: maxAge ?? this.maxAge,
    nosniff: nosniff ?? this.nosniff,
    preload: preload ?? this.preload,
    extra: extra ?? this.extra,
  );
}

/// Settings for the DNS record.
class Settings {
  const Settings({
    this.ipv4Only,
    this.ipv6Only,
    this.extra = const <String, Object?>{},
  });

  factory Settings.fromJson(Map<String, Object?> json) => Settings(
    ipv4Only: asBool(json['ipv4_only']),
    ipv6Only: asBool(json['ipv6_only']),
    extra: extraOf(json, _knownKeys),
  );

  /// When enabled, only A records will be generated, and AAAA records will not be
  /// created. This setting is intended for exceptional cases. Note that this
  /// option only applies to proxied records and it has no effect on whether
  /// Cloudflare communicates with the origin using IPv4 or IPv6.
  final bool? ipv4Only;

  /// When enabled, only AAAA records will be generated, and A records will not be
  /// created. This setting is intended for exceptional cases. Note that this
  /// option only applies to proxied records and it has no effect on whether
  /// Cloudflare communicates with the origin using IPv4 or IPv6.
  final bool? ipv6Only;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'ipv4_only', 'ipv6_only'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (ipv4Only != null) 'ipv4_only': ipv4Only!,
    if (ipv6Only != null) 'ipv6_only': ipv6Only!,
  };

  Settings copyWith({
    bool? ipv4Only,
    bool? ipv6Only,
    Map<String, Object?>? extra,
  }) => Settings(
    ipv4Only: ipv4Only ?? this.ipv4Only,
    ipv6Only: ipv6Only ?? this.ipv6Only,
    extra: extra ?? this.extra,
  );
}

/// A single query with or without parameters
class SingleQuery {
  const SingleQuery({
    this.params,
    this.sql,
    this.extra = const <String, Object?>{},
  });

  factory SingleQuery.fromJson(Map<String, Object?> json) => SingleQuery(
    params: asPrimitiveList<String>(json['params'], asString),
    sql: asString(json['sql']),
    extra: extraOf(json, _knownKeys),
  );

  final List<String>? params;

  /// Your SQL query. Supports multiple statements, joined by semicolons, which
  /// will be executed as a batch.
  final String? sql;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'params', 'sql'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (params != null) 'params': params!,
    if (sql != null) 'sql': sql!,
  };

  SingleQuery copyWith({
    List<String>? params,
    String? sql,
    Map<String, Object?>? extra,
  }) => SingleQuery(
    params: params ?? this.params,
    sql: sql ?? this.sql,
    extra: extra ?? this.extra,
  );
}

/// Configs for the project source control.
class Source {
  const Source({
    this.config,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory Source.fromJson(Map<String, Object?> json) => Source(
    config: asModel(json['config'], SourceConfig.fromJson),
    type_: asString(json['type']),
    extra: extraOf(json, _knownKeys),
  );

  final SourceConfig? config;

  /// The source control management provider. Allowed values: `github`, `gitlab`.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'config', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (config != null) 'config': config!.toJson(),
    if (type_ != null) 'type': type_!,
  };

  Source copyWith({
    SourceConfig? config,
    String? type_,
    Map<String, Object?>? extra,
  }) => Source(
    config: config ?? this.config,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

class SourceConfig {
  const SourceConfig({
    this.deploymentsEnabled,
    this.owner,
    this.ownerId,
    this.pathExcludes,
    this.pathIncludes,
    this.prCommentsEnabled,
    this.previewBranchExcludes,
    this.previewBranchIncludes,
    this.previewDeploymentSetting,
    this.productionBranch,
    this.productionDeploymentsEnabled,
    this.repoId,
    this.repoName,
    this.extra = const <String, Object?>{},
  });

  factory SourceConfig.fromJson(Map<String, Object?> json) => SourceConfig(
    deploymentsEnabled: asBool(json['deployments_enabled']),
    owner: asString(json['owner']),
    ownerId: asString(json['owner_id']),
    pathExcludes: asPrimitiveList<String>(json['path_excludes'], asString),
    pathIncludes: asPrimitiveList<String>(json['path_includes'], asString),
    prCommentsEnabled: asBool(json['pr_comments_enabled']),
    previewBranchExcludes: asPrimitiveList<String>(
      json['preview_branch_excludes'],
      asString,
    ),
    previewBranchIncludes: asPrimitiveList<String>(
      json['preview_branch_includes'],
      asString,
    ),
    previewDeploymentSetting: asString(json['preview_deployment_setting']),
    productionBranch: asString(json['production_branch']),
    productionDeploymentsEnabled: asBool(
      json['production_deployments_enabled'],
    ),
    repoId: asString(json['repo_id']),
    repoName: asString(json['repo_name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether to enable automatic deployments when pushing to the source
  /// repository. When disabled, no deployments (production or preview) will be
  /// triggered automatically.
  final bool? deploymentsEnabled;

  /// The owner of the repository.
  final String? owner;

  /// The owner ID of the repository.
  final String? ownerId;

  /// A list of paths that should be excluded from triggering a preview
  /// deployment. Wildcard syntax (`*`) is supported.
  final List<String>? pathExcludes;

  /// A list of paths that should be watched to trigger a preview deployment.
  /// Wildcard syntax (`*`) is supported.
  final List<String>? pathIncludes;

  /// Whether to enable PR comments.
  final bool? prCommentsEnabled;

  /// A list of branches that should not trigger a preview deployment. Wildcard
  /// syntax (`*`) is supported. Must be used with `preview_deployment_setting`
  /// set to `custom`.
  final List<String>? previewBranchExcludes;

  /// A list of branches that should trigger a preview deployment. Wildcard syntax
  /// (`*`) is supported. Must be used with `preview_deployment_setting` set to
  /// `custom`.
  final List<String>? previewBranchIncludes;

  /// Controls whether commits to preview branches trigger a preview deployment.
  /// Allowed values: `all`, `none`, `custom`.
  final String? previewDeploymentSetting;

  /// The production branch of the repository.
  final String? productionBranch;

  /// Whether to trigger a production deployment on commits to the production
  /// branch.
  final bool? productionDeploymentsEnabled;

  /// The ID of the repository.
  final String? repoId;

  /// The name of the repository.
  final String? repoName;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'deployments_enabled',
    'owner',
    'owner_id',
    'path_excludes',
    'path_includes',
    'pr_comments_enabled',
    'preview_branch_excludes',
    'preview_branch_includes',
    'preview_deployment_setting',
    'production_branch',
    'production_deployments_enabled',
    'repo_id',
    'repo_name',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (deploymentsEnabled != null) 'deployments_enabled': deploymentsEnabled!,
    if (owner != null) 'owner': owner!,
    if (ownerId != null) 'owner_id': ownerId!,
    if (pathExcludes != null) 'path_excludes': pathExcludes!,
    if (pathIncludes != null) 'path_includes': pathIncludes!,
    if (prCommentsEnabled != null) 'pr_comments_enabled': prCommentsEnabled!,
    if (previewBranchExcludes != null)
      'preview_branch_excludes': previewBranchExcludes!,
    if (previewBranchIncludes != null)
      'preview_branch_includes': previewBranchIncludes!,
    if (previewDeploymentSetting != null)
      'preview_deployment_setting': previewDeploymentSetting!,
    if (productionBranch != null) 'production_branch': productionBranch!,
    if (productionDeploymentsEnabled != null)
      'production_deployments_enabled': productionDeploymentsEnabled!,
    if (repoId != null) 'repo_id': repoId!,
    if (repoName != null) 'repo_name': repoName!,
  };

  SourceConfig copyWith({
    bool? deploymentsEnabled,
    String? owner,
    String? ownerId,
    List<String>? pathExcludes,
    List<String>? pathIncludes,
    bool? prCommentsEnabled,
    List<String>? previewBranchExcludes,
    List<String>? previewBranchIncludes,
    String? previewDeploymentSetting,
    String? productionBranch,
    bool? productionDeploymentsEnabled,
    String? repoId,
    String? repoName,
    Map<String, Object?>? extra,
  }) => SourceConfig(
    deploymentsEnabled: deploymentsEnabled ?? this.deploymentsEnabled,
    owner: owner ?? this.owner,
    ownerId: ownerId ?? this.ownerId,
    pathExcludes: pathExcludes ?? this.pathExcludes,
    pathIncludes: pathIncludes ?? this.pathIncludes,
    prCommentsEnabled: prCommentsEnabled ?? this.prCommentsEnabled,
    previewBranchExcludes: previewBranchExcludes ?? this.previewBranchExcludes,
    previewBranchIncludes: previewBranchIncludes ?? this.previewBranchIncludes,
    previewDeploymentSetting:
        previewDeploymentSetting ?? this.previewDeploymentSetting,
    productionBranch: productionBranch ?? this.productionBranch,
    productionDeploymentsEnabled:
        productionDeploymentsEnabled ?? this.productionDeploymentsEnabled,
    repoId: repoId ?? this.repoId,
    repoName: repoName ?? this.repoName,
    extra: extra ?? this.extra,
  );
}

/// The status of the deployment.
class Stage {
  const Stage({
    this.endedOn,
    this.name,
    this.startedOn,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory Stage.fromJson(Map<String, Object?> json) => Stage(
    endedOn: asString(json['ended_on']),
    name: asString(json['name']),
    startedOn: asString(json['started_on']),
    status: asString(json['status']),
    extra: extraOf(json, _knownKeys),
  );

  /// When the stage ended.
  final String? endedOn;

  /// The current build stage. Allowed values: `queued`, `initialize`,
  /// `clone_repo`, `build`, `deploy`.
  final String? name;

  /// When the stage started.
  final String? startedOn;

  /// State of the current stage. Allowed values: `success`, `idle`, `active`,
  /// `failure`, `canceled`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'ended_on',
    'name',
    'started_on',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (endedOn != null) 'ended_on': endedOn!,
    if (name != null) 'name': name!,
    if (startedOn != null) 'started_on': startedOn!,
    if (status != null) 'status': status!,
  };

  Stage copyWith({
    String? endedOn,
    String? name,
    String? startedOn,
    String? status,
    Map<String, Object?>? extra,
  }) => Stage(
    endedOn: endedOn ?? this.endedOn,
    name: name ?? this.name,
    startedOn: startedOn ?? this.startedOn,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

/// A reference to a script that will consume logs from the attached Worker.
class TailConsumersScript {
  const TailConsumersScript({
    this.environment,
    this.namespace,
    this.service,
    this.extra = const <String, Object?>{},
  });

  factory TailConsumersScript.fromJson(Map<String, Object?> json) =>
      TailConsumersScript(
        environment: asString(json['environment']),
        namespace: asString(json['namespace']),
        service: asString(json['service']),
        extra: extraOf(json, _knownKeys),
      );

  /// Optional environment if the Worker utilizes one.
  final String? environment;

  /// Optional dispatch namespace the script belongs to.
  final String? namespace;

  /// Name of Worker that is to be the consumer.
  final String? service;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'environment', 'namespace', 'service'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (environment != null) 'environment': environment!,
    if (namespace != null) 'namespace': namespace!,
    if (service != null) 'service': service!,
  };

  TailConsumersScript copyWith({
    String? environment,
    String? namespace,
    String? service,
    Map<String, Object?>? extra,
  }) => TailConsumersScript(
    environment: environment ?? this.environment,
    namespace: namespace ?? this.namespace,
    service: service ?? this.service,
    extra: extra ?? this.extra,
  );
}

class TargetCriteriaSelfHostedApp {
  const TargetCriteriaSelfHostedApp({
    this.port,
    this.targetAttributes,
    this.protocol,
    this.extra = const <String, Object?>{},
  });

  factory TargetCriteriaSelfHostedApp.fromJson(Map<String, Object?> json) =>
      TargetCriteriaSelfHostedApp(
        port: asInt(json['port']),
        targetAttributes: asMap(json['target_attributes']),
        protocol: asString(json['protocol']),
        extra: extraOf(json, _knownKeys),
      );

  /// The port that the targets use for the chosen communication protocol. A port
  /// cannot be assigned to multiple protocols.
  final int? port;

  /// Contains a map of target attribute keys to target attribute values.
  final Map<String, Object?>? targetAttributes;

  /// The communication protocol your application secures. Allowed values: `RDP`.
  final String? protocol;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'port',
    'target_attributes',
    'protocol',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (port != null) 'port': port!,
    if (targetAttributes != null) 'target_attributes': targetAttributes!,
    if (protocol != null) 'protocol': protocol!,
  };

  TargetCriteriaSelfHostedApp copyWith({
    int? port,
    Map<String, Object?>? targetAttributes,
    String? protocol,
    Map<String, Object?>? extra,
  }) => TargetCriteriaSelfHostedApp(
    port: port ?? this.port,
    targetAttributes: targetAttributes ?? this.targetAttributes,
    protocol: protocol ?? this.protocol,
    extra: extra ?? this.extra,
  );
}

/// A client (typically cloudflared) that maintains connections to a Cloudflare
/// data center.
class TunnelClient {
  const TunnelClient({
    this.arch,
    this.configVersion,
    this.conns,
    this.features,
    this.id,
    this.runAt,
    this.version,
    this.extra = const <String, Object?>{},
  });

  factory TunnelClient.fromJson(Map<String, Object?> json) => TunnelClient(
    arch: asString(json['arch']),
    configVersion: asInt(json['config_version']),
    conns: asModelList(json['conns'], SchemasConnection.fromJson),
    features: asPrimitiveList<String>(json['features'], asString),
    id: asString(json['id']),
    runAt: asString(json['run_at']),
    version: asString(json['version']),
    extra: extraOf(json, _knownKeys),
  );

  /// The cloudflared OS architecture used to establish this connection.
  final String? arch;

  /// The version of the remote tunnel configuration. Used internally to sync
  /// cloudflared with the Zero Trust dashboard.
  final int? configVersion;

  /// The Cloudflare Tunnel connections between your origin and Cloudflare's edge.
  final List<SchemasConnection>? conns;

  /// Features enabled for the Cloudflare Tunnel.
  final List<String>? features;

  /// UUID of the Cloudflare Tunnel connection.
  final String? id;

  /// Timestamp of when the tunnel connection was started.
  final String? runAt;

  /// The cloudflared version used to establish this connection.
  final String? version;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'arch',
    'config_version',
    'conns',
    'features',
    'id',
    'run_at',
    'version',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (arch != null) 'arch': arch!,
    if (configVersion != null) 'config_version': configVersion!,
    if (conns != null) 'conns': conns!.map((e) => e.toJson()).toList(),
    if (features != null) 'features': features!,
    if (id != null) 'id': id!,
    if (runAt != null) 'run_at': runAt!,
    if (version != null) 'version': version!,
  };

  TunnelClient copyWith({
    String? arch,
    int? configVersion,
    List<SchemasConnection>? conns,
    List<String>? features,
    String? id,
    String? runAt,
    String? version,
    Map<String, Object?>? extra,
  }) => TunnelClient(
    arch: arch ?? this.arch,
    configVersion: configVersion ?? this.configVersion,
    conns: conns ?? this.conns,
    features: features ?? this.features,
    id: id ?? this.id,
    runAt: runAt ?? this.runAt,
    version: version ?? this.version,
    extra: extra ?? this.extra,
  );
}

class UpdateZoneRulesetRuleBody {
  const UpdateZoneRulesetRuleBody({
    this.action,
    this.actionParameters,
    this.categories,
    this.description,
    this.enabled,
    this.exposedCredentialCheck,
    this.expression,
    this.id,
    this.lastUpdated,
    this.logging,
    this.ratelimit,
    this.ref,
    this.version,
    this.position,
    this.extra = const <String, Object?>{},
  });

  factory UpdateZoneRulesetRuleBody.fromJson(Map<String, Object?> json) =>
      UpdateZoneRulesetRuleBody(
        action: json['action'],
        actionParameters: asModel(
          json['action_parameters'],
          UpdateZoneRulesetRuleBodyActionParameters.fromJson,
        ),
        categories: asPrimitiveList<String>(json['categories'], asString),
        description: json['description'],
        enabled: json['enabled'],
        exposedCredentialCheck: asModel(
          json['exposed_credential_check'],
          RuleExposedCredentialCheck.fromJson,
        ),
        expression: asString(json['expression']),
        id: asString(json['id']),
        lastUpdated: asString(json['last_updated']),
        logging: asModel(json['logging'], RuleLogging.fromJson),
        ratelimit: asModel(json['ratelimit'], RuleRatelimit.fromJson),
        ref: asString(json['ref']),
        version: asString(json['version']),
        position: asModel(
          json['position'],
          UpdateZoneRulesetRuleBodyPosition.fromJson,
        ),
        extra: extraOf(json, _knownKeys),
      );

  /// Allowed values: `transform_response_html`.
  final Object? action;
  final UpdateZoneRulesetRuleBodyActionParameters? actionParameters;

  /// The categories of the rule.
  final List<String>? categories;
  final Object? description;
  final Object? enabled;

  /// Configuration for exposed credential checking.
  final RuleExposedCredentialCheck? exposedCredentialCheck;

  /// The expression defining which traffic will match the rule.
  final String? expression;

  /// The unique ID of the rule.
  final String? id;

  /// The timestamp of when the rule was last modified.
  final String? lastUpdated;

  /// An object configuring the rule's logging behavior.
  final RuleLogging? logging;

  /// An object configuring the rule's rate limit behavior.
  final RuleRatelimit? ratelimit;

  /// The reference of the rule (the rule's ID by default).
  final String? ref;

  /// The version of the rule.
  final String? version;
  final UpdateZoneRulesetRuleBodyPosition? position;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'action',
    'action_parameters',
    'categories',
    'description',
    'enabled',
    'exposed_credential_check',
    'expression',
    'id',
    'last_updated',
    'logging',
    'ratelimit',
    'ref',
    'version',
    'position',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (action != null) 'action': action!,
    if (actionParameters != null)
      'action_parameters': actionParameters!.toJson(),
    if (categories != null) 'categories': categories!,
    if (description != null) 'description': description!,
    if (enabled != null) 'enabled': enabled!,
    if (exposedCredentialCheck != null)
      'exposed_credential_check': exposedCredentialCheck!.toJson(),
    if (expression != null) 'expression': expression!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (logging != null) 'logging': logging!.toJson(),
    if (ratelimit != null) 'ratelimit': ratelimit!.toJson(),
    if (ref != null) 'ref': ref!,
    if (version != null) 'version': version!,
    if (position != null) 'position': position!.toJson(),
  };

  UpdateZoneRulesetRuleBody copyWith({
    Object? action,
    UpdateZoneRulesetRuleBodyActionParameters? actionParameters,
    List<String>? categories,
    Object? description,
    Object? enabled,
    RuleExposedCredentialCheck? exposedCredentialCheck,
    String? expression,
    String? id,
    String? lastUpdated,
    RuleLogging? logging,
    RuleRatelimit? ratelimit,
    String? ref,
    String? version,
    UpdateZoneRulesetRuleBodyPosition? position,
    Map<String, Object?>? extra,
  }) => UpdateZoneRulesetRuleBody(
    action: action ?? this.action,
    actionParameters: actionParameters ?? this.actionParameters,
    categories: categories ?? this.categories,
    description: description ?? this.description,
    enabled: enabled ?? this.enabled,
    exposedCredentialCheck:
        exposedCredentialCheck ?? this.exposedCredentialCheck,
    expression: expression ?? this.expression,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    logging: logging ?? this.logging,
    ratelimit: ratelimit ?? this.ratelimit,
    ref: ref ?? this.ref,
    version: version ?? this.version,
    position: position ?? this.position,
    extra: extra ?? this.extra,
  );
}

class UpdateZoneRulesetRuleBodyActionParameters {
  const UpdateZoneRulesetRuleBodyActionParameters({
    this.linkMaze,
    this.extra = const <String, Object?>{},
  });

  factory UpdateZoneRulesetRuleBodyActionParameters.fromJson(
    Map<String, Object?> json,
  ) => UpdateZoneRulesetRuleBodyActionParameters(
    linkMaze: asMap(json['link_maze']),
    extra: extraOf(json, _knownKeys),
  );

  /// Enables the link maze transformation on the response.
  final Map<String, Object?>? linkMaze;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'link_maze'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (linkMaze != null) 'link_maze': linkMaze!,
  };

  UpdateZoneRulesetRuleBodyActionParameters copyWith({
    Map<String, Object?>? linkMaze,
    Map<String, Object?>? extra,
  }) => UpdateZoneRulesetRuleBodyActionParameters(
    linkMaze: linkMaze ?? this.linkMaze,
    extra: extra ?? this.extra,
  );
}

class UpdateZoneRulesetRuleBodyPosition {
  const UpdateZoneRulesetRuleBodyPosition({
    this.before,
    this.after,
    this.index,
    this.extra = const <String, Object?>{},
  });

  factory UpdateZoneRulesetRuleBodyPosition.fromJson(
    Map<String, Object?> json,
  ) => UpdateZoneRulesetRuleBodyPosition(
    before: asString(json['before']),
    after: asString(json['after']),
    index: asInt(json['index']),
    extra: extraOf(json, _knownKeys),
  );

  /// The ID of another rule to place the rule before. An empty value causes the
  /// rule to be placed at the top.
  final String? before;

  /// The ID of another rule to place the rule after. An empty value causes the
  /// rule to be placed at the bottom.
  final String? after;

  /// An index at which to place the rule, where index 1 is the first rule.
  final int? index;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'before', 'after', 'index'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (before != null) 'before': before!,
    if (after != null) 'after': after!,
    if (index != null) 'index': index!,
  };

  UpdateZoneRulesetRuleBodyPosition copyWith({
    String? before,
    String? after,
    int? index,
    Map<String, Object?>? extra,
  }) => UpdateZoneRulesetRuleBodyPosition(
    before: before ?? this.before,
    after: after ?? this.after,
    index: index ?? this.index,
    extra: extra ?? this.extra,
  );
}

class UpdateZoneRulesetRuleResult {
  const UpdateZoneRulesetRuleResult({
    this.description,
    this.id,
    this.lastUpdated,
    this.name,
    this.version,
    this.kind,
    this.phase,
    this.rules,
    this.extra = const <String, Object?>{},
  });

  factory UpdateZoneRulesetRuleResult.fromJson(Map<String, Object?> json) =>
      UpdateZoneRulesetRuleResult(
        description: asString(json['description']),
        id: json['id'],
        lastUpdated: asString(json['last_updated']),
        name: asString(json['name']),
        version: json['version'],
        kind: asString(json['kind']),
        phase: asString(json['phase']),
        rules: asModelList(json['rules'], ResponseRule.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// An informative description of the ruleset.
  final String? description;
  final Object? id;

  /// The timestamp of when the ruleset was last modified.
  final String? lastUpdated;

  /// The human-readable name of the ruleset.
  final String? name;
  final Object? version;

  /// The kind of the ruleset. Allowed values: `managed`, `custom`, `root`,
  /// `zone`.
  final String? kind;

  /// The phase of the ruleset. Allowed values: `ddos_l4`, `ddos_l7`,
  /// `http_config_settings`, `http_custom_errors`, `http_log_custom_fields`,
  /// `http_ratelimit`, `http_request_cache_settings`,
  /// `http_request_dynamic_redirect`, `http_request_firewall_custom`,
  /// `http_request_firewall_managed`, `http_request_late_transform`,
  /// `http_request_origin`, `http_request_redirect`, `http_request_sanitize`,
  /// `http_request_sbfm`, `http_request_transform`,
  /// `http_response_cache_settings`, `http_response_compression`,
  /// `http_response_firewall_managed`, `http_response_headers_transform`,
  /// `magic_transit`, `magic_transit_ids_managed`, `magic_transit_managed`,
  /// `magic_transit_ratelimit`.
  final String? phase;

  /// The list of rules in the ruleset.
  final List<ResponseRule>? rules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'description',
    'id',
    'last_updated',
    'name',
    'version',
    'kind',
    'phase',
    'rules',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (description != null) 'description': description!,
    if (id != null) 'id': id!,
    if (lastUpdated != null) 'last_updated': lastUpdated!,
    if (name != null) 'name': name!,
    if (version != null) 'version': version!,
    if (kind != null) 'kind': kind!,
    if (phase != null) 'phase': phase!,
    if (rules != null) 'rules': rules!.map((e) => e.toJson()).toList(),
  };

  UpdateZoneRulesetRuleResult copyWith({
    String? description,
    Object? id,
    String? lastUpdated,
    String? name,
    Object? version,
    String? kind,
    String? phase,
    List<ResponseRule>? rules,
    Map<String, Object?>? extra,
  }) => UpdateZoneRulesetRuleResult(
    description: description ?? this.description,
    id: id ?? this.id,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    phase: phase ?? this.phase,
    rules: rules ?? this.rules,
    extra: extra ?? this.extra,
  );
}

class UserApiTokensVerifyTokenResult {
  const UserApiTokensVerifyTokenResult({
    this.expiresOn,
    this.id,
    this.notBefore,
    this.status,
    this.extra = const <String, Object?>{},
  });

  factory UserApiTokensVerifyTokenResult.fromJson(Map<String, Object?> json) =>
      UserApiTokensVerifyTokenResult(
        expiresOn: asString(json['expires_on']),
        id: asString(json['id']),
        notBefore: asString(json['not_before']),
        status: asString(json['status']),
        extra: extraOf(json, _knownKeys),
      );

  /// The expiration time on or after which the JWT MUST NOT be accepted for
  /// processing.
  final String? expiresOn;

  /// Token identifier tag.
  final String? id;

  /// The time before which the token MUST NOT be accepted for processing.
  final String? notBefore;

  /// Status of the token. Allowed values: `active`, `disabled`, `expired`.
  final String? status;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'expires_on',
    'id',
    'not_before',
    'status',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (expiresOn != null) 'expires_on': expiresOn!,
    if (id != null) 'id': id!,
    if (notBefore != null) 'not_before': notBefore!,
    if (status != null) 'status': status!,
  };

  UserApiTokensVerifyTokenResult copyWith({
    String? expiresOn,
    String? id,
    String? notBefore,
    String? status,
    Map<String, Object?>? extra,
  }) => UserApiTokensVerifyTokenResult(
    expiresOn: expiresOn ?? this.expiresOn,
    id: id ?? this.id,
    notBefore: notBefore ?? this.notBefore,
    status: status ?? this.status,
    extra: extra ?? this.extra,
  );
}

class UserUserDetailsResult {
  const UserUserDetailsResult({
    this.betas,
    this.country,
    this.email,
    this.firstName,
    this.hasBusinessZones,
    this.hasEnterpriseZones,
    this.hasProZones,
    this.id,
    this.lastName,
    this.organizations,
    this.suspended,
    this.telephone,
    this.twoFactorAuthenticationEnabled,
    this.twoFactorAuthenticationLocked,
    this.zipcode,
    this.extra = const <String, Object?>{},
  });

  factory UserUserDetailsResult.fromJson(Map<String, Object?> json) =>
      UserUserDetailsResult(
        betas: asPrimitiveList<String>(json['betas'], asString),
        country: asString(json['country']),
        email: asString(json['email']),
        firstName: asString(json['first_name']),
        hasBusinessZones: asBool(json['has_business_zones']),
        hasEnterpriseZones: asBool(json['has_enterprise_zones']),
        hasProZones: asBool(json['has_pro_zones']),
        id: asString(json['id']),
        lastName: asString(json['last_name']),
        organizations: asModelList(
          json['organizations'],
          Organization.fromJson,
        ),
        suspended: asBool(json['suspended']),
        telephone: asString(json['telephone']),
        twoFactorAuthenticationEnabled: asBool(
          json['two_factor_authentication_enabled'],
        ),
        twoFactorAuthenticationLocked: asBool(
          json['two_factor_authentication_locked'],
        ),
        zipcode: asString(json['zipcode']),
        extra: extraOf(json, _knownKeys),
      );

  /// Lists the betas that the user is participating in.
  final List<String>? betas;

  /// The country in which the user lives.
  final String? country;

  /// Current email address of the user.
  final String? email;

  /// User's first name
  final String? firstName;

  /// Indicates whether user has any business zones
  final bool? hasBusinessZones;

  /// Indicates whether user has any enterprise zones
  final bool? hasEnterpriseZones;

  /// Indicates whether user has any pro zones
  final bool? hasProZones;

  /// Identifier of the user.
  final String? id;

  /// User's last name
  final String? lastName;
  final List<Organization>? organizations;

  /// Indicates whether user has been suspended
  final bool? suspended;

  /// User's telephone number
  final String? telephone;

  /// Indicates whether two-factor authentication is enabled for the user account.
  /// Does not apply to API authentication.
  final bool? twoFactorAuthenticationEnabled;

  /// Indicates whether two-factor authentication is required by one of the
  /// accounts that the user is a member of.
  final bool? twoFactorAuthenticationLocked;

  /// The zipcode or postal code where the user lives.
  final String? zipcode;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'betas',
    'country',
    'email',
    'first_name',
    'has_business_zones',
    'has_enterprise_zones',
    'has_pro_zones',
    'id',
    'last_name',
    'organizations',
    'suspended',
    'telephone',
    'two_factor_authentication_enabled',
    'two_factor_authentication_locked',
    'zipcode',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (betas != null) 'betas': betas!,
    if (country != null) 'country': country!,
    if (email != null) 'email': email!,
    if (firstName != null) 'first_name': firstName!,
    if (hasBusinessZones != null) 'has_business_zones': hasBusinessZones!,
    if (hasEnterpriseZones != null) 'has_enterprise_zones': hasEnterpriseZones!,
    if (hasProZones != null) 'has_pro_zones': hasProZones!,
    if (id != null) 'id': id!,
    if (lastName != null) 'last_name': lastName!,
    if (organizations != null)
      'organizations': organizations!.map((e) => e.toJson()).toList(),
    if (suspended != null) 'suspended': suspended!,
    if (telephone != null) 'telephone': telephone!,
    if (twoFactorAuthenticationEnabled != null)
      'two_factor_authentication_enabled': twoFactorAuthenticationEnabled!,
    if (twoFactorAuthenticationLocked != null)
      'two_factor_authentication_locked': twoFactorAuthenticationLocked!,
    if (zipcode != null) 'zipcode': zipcode!,
  };

  UserUserDetailsResult copyWith({
    List<String>? betas,
    String? country,
    String? email,
    String? firstName,
    bool? hasBusinessZones,
    bool? hasEnterpriseZones,
    bool? hasProZones,
    String? id,
    String? lastName,
    List<Organization>? organizations,
    bool? suspended,
    String? telephone,
    bool? twoFactorAuthenticationEnabled,
    bool? twoFactorAuthenticationLocked,
    String? zipcode,
    Map<String, Object?>? extra,
  }) => UserUserDetailsResult(
    betas: betas ?? this.betas,
    country: country ?? this.country,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    hasBusinessZones: hasBusinessZones ?? this.hasBusinessZones,
    hasEnterpriseZones: hasEnterpriseZones ?? this.hasEnterpriseZones,
    hasProZones: hasProZones ?? this.hasProZones,
    id: id ?? this.id,
    lastName: lastName ?? this.lastName,
    organizations: organizations ?? this.organizations,
    suspended: suspended ?? this.suspended,
    telephone: telephone ?? this.telephone,
    twoFactorAuthenticationEnabled:
        twoFactorAuthenticationEnabled ?? this.twoFactorAuthenticationEnabled,
    twoFactorAuthenticationLocked:
        twoFactorAuthenticationLocked ?? this.twoFactorAuthenticationLocked,
    zipcode: zipcode ?? this.zipcode,
    extra: extra ?? this.extra,
  );
}

class WorkerCronTriggerGetCronTriggersResult {
  const WorkerCronTriggerGetCronTriggersResult({
    this.schedules,
    this.extra = const <String, Object?>{},
  });

  factory WorkerCronTriggerGetCronTriggersResult.fromJson(
    Map<String, Object?> json,
  ) => WorkerCronTriggerGetCronTriggersResult(
    schedules: asModelList(json['schedules'], Schedule.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  final List<Schedule>? schedules;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'schedules'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (schedules != null)
      'schedules': schedules!.map((e) => e.toJson()).toList(),
  };

  WorkerCronTriggerGetCronTriggersResult copyWith({
    List<Schedule>? schedules,
    Map<String, Object?>? extra,
  }) => WorkerCronTriggerGetCronTriggersResult(
    schedules: schedules ?? this.schedules,
    extra: extra ?? this.extra,
  );
}

class WorkerScriptListWorkersItem {
  const WorkerScriptListWorkersItem({
    this.cacheOptions,
    this.compatibilityDate,
    this.compatibilityFlags,
    this.createdOn,
    this.etag,
    this.exports,
    this.handlers,
    this.hasAssets,
    this.hasModules,
    this.id,
    this.lastDeployedFrom,
    this.logpush,
    this.migrationTag,
    this.modifiedOn,
    this.namedHandlers,
    this.observability,
    this.placement,
    this.placementMode,
    this.placementStatus,
    this.tag,
    this.tags,
    this.tailConsumers,
    this.usageModel,
    this.routes,
    this.extra = const <String, Object?>{},
  });

  factory WorkerScriptListWorkersItem.fromJson(Map<String, Object?> json) =>
      WorkerScriptListWorkersItem(
        cacheOptions: asModel(json['cache_options'], CacheOptions.fromJson),
        compatibilityDate: asString(json['compatibility_date']),
        compatibilityFlags: asPrimitiveList<String>(
          json['compatibility_flags'],
          asString,
        ),
        createdOn: asString(json['created_on']),
        etag: asString(json['etag']),
        exports: asMap(json['exports']),
        handlers: asPrimitiveList<String>(json['handlers'], asString),
        hasAssets: asBool(json['has_assets']),
        hasModules: asBool(json['has_modules']),
        id: asString(json['id']),
        lastDeployedFrom: asString(json['last_deployed_from']),
        logpush: asBool(json['logpush']),
        migrationTag: asString(json['migration_tag']),
        modifiedOn: asString(json['modified_on']),
        namedHandlers: asModelList(
          json['named_handlers'],
          WorkerScriptListWorkersItemNamedHandlersItem.fromJson,
        ),
        observability: asModel(json['observability'], Observability.fromJson),
        placement: asModel(json['placement'], PlacementInfo.fromJson),
        placementMode: json['placement_mode'],
        placementStatus: json['placement_status'],
        tag: asString(json['tag']),
        tags: asPrimitiveList<String>(json['tags'], asString),
        tailConsumers: asModelList(
          json['tail_consumers'],
          TailConsumersScript.fromJson,
        ),
        usageModel: asString(json['usage_model']),
        routes: asModelList(json['routes'], Route.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// Global CacheW configuration for the Worker. When caching is on, the platform
  /// provisions a `cloudflare.app` zone for the Worker. A `type: worker` entry in
  /// the `exports` map can override this value for a single entrypoint.
  final CacheOptions? cacheOptions;

  /// Date indicating targeted support in the Workers runtime. Backwards
  /// incompatible fixes to the runtime following this date will not affect this
  /// Worker.
  final String? compatibilityDate;

  /// Flags that enable or disable certain features in the Workers runtime. Used
  /// to enable upcoming features or opt in or out of specific changes not
  /// included in a `compatibility_date`.
  final List<String>? compatibilityFlags;

  /// When the script was created.
  final String? createdOn;

  /// Hashed script content, can be used in a If-None-Match header when updating.
  final String? etag;

  /// Declarative exports for the Worker's most recent version, including Durable
  /// Object classes (with their `storage` backend) and named Worker entrypoints.
  /// Tombstoned lifecycle entries are omitted, so only live exports (`created`
  /// and `expecting-transfer`) are returned.
  final Map<String, Object?>? exports;

  /// The names of handlers exported as part of the default export.
  final List<String>? handlers;

  /// Whether a Worker contains assets.
  final bool? hasAssets;

  /// Whether a Worker contains modules.
  final bool? hasModules;

  /// The name used to identify the script.
  final String? id;

  /// The client most recently used to deploy this Worker.
  final String? lastDeployedFrom;

  /// Whether Logpush is turned on for the Worker.
  final bool? logpush;

  /// The tag of the Durable Object migration that was most recently applied for
  /// this Worker.
  final String? migrationTag;

  /// When the script was last modified.
  final String? modifiedOn;

  /// Named exports, such as Durable Object class implementations and named
  /// entrypoints.
  final List<WorkerScriptListWorkersItemNamedHandlersItem>? namedHandlers;

  /// Observability settings for the Worker.
  final Observability? observability;

  /// Configuration for [Smart
  /// Placement](https://developers.cloudflare.com/workers/configuration/smart-placement).
  /// Specify mode='smart' for Smart Placement, or one of region/hostname/host.
  final PlacementInfo? placement;
  final Object? placementMode;
  final Object? placementStatus;

  /// The immutable ID of the script.
  final String? tag;

  /// Tags associated with the Worker.
  final List<String>? tags;

  /// List of Workers that will consume logs from the attached Worker.
  final List<TailConsumersScript>? tailConsumers;

  /// Usage model for the Worker invocations. Allowed values: `standard`,
  /// `bundled`, `unbound`.
  final String? usageModel;

  /// Routes associated with the Worker.
  final List<Route>? routes;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'cache_options',
    'compatibility_date',
    'compatibility_flags',
    'created_on',
    'etag',
    'exports',
    'handlers',
    'has_assets',
    'has_modules',
    'id',
    'last_deployed_from',
    'logpush',
    'migration_tag',
    'modified_on',
    'named_handlers',
    'observability',
    'placement',
    'placement_mode',
    'placement_status',
    'tag',
    'tags',
    'tail_consumers',
    'usage_model',
    'routes',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cacheOptions != null) 'cache_options': cacheOptions!.toJson(),
    if (compatibilityDate != null) 'compatibility_date': compatibilityDate!,
    if (compatibilityFlags != null) 'compatibility_flags': compatibilityFlags!,
    if (createdOn != null) 'created_on': createdOn!,
    if (etag != null) 'etag': etag!,
    if (exports != null) 'exports': exports!,
    if (handlers != null) 'handlers': handlers!,
    if (hasAssets != null) 'has_assets': hasAssets!,
    if (hasModules != null) 'has_modules': hasModules!,
    if (id != null) 'id': id!,
    if (lastDeployedFrom != null) 'last_deployed_from': lastDeployedFrom!,
    if (logpush != null) 'logpush': logpush!,
    if (migrationTag != null) 'migration_tag': migrationTag!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (namedHandlers != null)
      'named_handlers': namedHandlers!.map((e) => e.toJson()).toList(),
    if (observability != null) 'observability': observability!.toJson(),
    if (placement != null) 'placement': placement!.toJson(),
    if (placementMode != null) 'placement_mode': placementMode!,
    if (placementStatus != null) 'placement_status': placementStatus!,
    if (tag != null) 'tag': tag!,
    if (tags != null) 'tags': tags!,
    if (tailConsumers != null)
      'tail_consumers': tailConsumers!.map((e) => e.toJson()).toList(),
    if (usageModel != null) 'usage_model': usageModel!,
    if (routes != null) 'routes': routes!.map((e) => e.toJson()).toList(),
  };

  WorkerScriptListWorkersItem copyWith({
    CacheOptions? cacheOptions,
    String? compatibilityDate,
    List<String>? compatibilityFlags,
    String? createdOn,
    String? etag,
    Map<String, Object?>? exports,
    List<String>? handlers,
    bool? hasAssets,
    bool? hasModules,
    String? id,
    String? lastDeployedFrom,
    bool? logpush,
    String? migrationTag,
    String? modifiedOn,
    List<WorkerScriptListWorkersItemNamedHandlersItem>? namedHandlers,
    Observability? observability,
    PlacementInfo? placement,
    Object? placementMode,
    Object? placementStatus,
    String? tag,
    List<String>? tags,
    List<TailConsumersScript>? tailConsumers,
    String? usageModel,
    List<Route>? routes,
    Map<String, Object?>? extra,
  }) => WorkerScriptListWorkersItem(
    cacheOptions: cacheOptions ?? this.cacheOptions,
    compatibilityDate: compatibilityDate ?? this.compatibilityDate,
    compatibilityFlags: compatibilityFlags ?? this.compatibilityFlags,
    createdOn: createdOn ?? this.createdOn,
    etag: etag ?? this.etag,
    exports: exports ?? this.exports,
    handlers: handlers ?? this.handlers,
    hasAssets: hasAssets ?? this.hasAssets,
    hasModules: hasModules ?? this.hasModules,
    id: id ?? this.id,
    lastDeployedFrom: lastDeployedFrom ?? this.lastDeployedFrom,
    logpush: logpush ?? this.logpush,
    migrationTag: migrationTag ?? this.migrationTag,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    namedHandlers: namedHandlers ?? this.namedHandlers,
    observability: observability ?? this.observability,
    placement: placement ?? this.placement,
    placementMode: placementMode ?? this.placementMode,
    placementStatus: placementStatus ?? this.placementStatus,
    tag: tag ?? this.tag,
    tags: tags ?? this.tags,
    tailConsumers: tailConsumers ?? this.tailConsumers,
    usageModel: usageModel ?? this.usageModel,
    routes: routes ?? this.routes,
    extra: extra ?? this.extra,
  );
}

class WorkerScriptListWorkersItemNamedHandlersItem {
  const WorkerScriptListWorkersItemNamedHandlersItem({
    this.handlers,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory WorkerScriptListWorkersItemNamedHandlersItem.fromJson(
    Map<String, Object?> json,
  ) => WorkerScriptListWorkersItemNamedHandlersItem(
    handlers: asPrimitiveList<String>(json['handlers'], asString),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// The names of handlers exported as part of the named export.
  final List<String>? handlers;

  /// The name of the export.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'handlers', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (handlers != null) 'handlers': handlers!,
    if (name != null) 'name': name!,
  };

  WorkerScriptListWorkersItemNamedHandlersItem copyWith({
    List<String>? handlers,
    String? name,
    Map<String, Object?>? extra,
  }) => WorkerScriptListWorkersItemNamedHandlersItem(
    handlers: handlers ?? this.handlers,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

class Zone {
  const Zone({
    this.account,
    this.activatedOn,
    this.cnameSuffix,
    this.createdOn,
    this.developmentMode,
    this.id,
    this.meta,
    this.modifiedOn,
    this.name,
    this.nameServers,
    this.originalDnshost,
    this.originalNameServers,
    this.originalRegistrar,
    this.owner,
    this.paused,
    this.permissions,
    this.plan,
    this.status,
    this.tenant,
    this.tenantUnit,
    this.type_,
    this.vanityNameServers,
    this.verificationKey,
    this.extra = const <String, Object?>{},
  });

  factory Zone.fromJson(Map<String, Object?> json) => Zone(
    account: asModel(json['account'], ZoneAccount.fromJson),
    activatedOn: asString(json['activated_on']),
    cnameSuffix: asString(json['cname_suffix']),
    createdOn: asString(json['created_on']),
    developmentMode: asNum(json['development_mode']),
    id: asString(json['id']),
    meta: asModel(json['meta'], ZoneMeta.fromJson),
    modifiedOn: asString(json['modified_on']),
    name: asString(json['name']),
    nameServers: asPrimitiveList<String>(json['name_servers'], asString),
    originalDnshost: asString(json['original_dnshost']),
    originalNameServers: asPrimitiveList<String>(
      json['original_name_servers'],
      asString,
    ),
    originalRegistrar: asString(json['original_registrar']),
    owner: asModel(json['owner'], ZoneOwner.fromJson),
    paused: asBool(json['paused']),
    permissions: asPrimitiveList<String>(json['permissions'], asString),
    plan: asModel(json['plan'], ZonePlan.fromJson),
    status: asString(json['status']),
    tenant: asModel(json['tenant'], ZoneTenant.fromJson),
    tenantUnit: asModel(json['tenant_unit'], ZoneTenantUnit.fromJson),
    type_: asString(json['type']),
    vanityNameServers: asPrimitiveList<String>(
      json['vanity_name_servers'],
      asString,
    ),
    verificationKey: asString(json['verification_key']),
    extra: extraOf(json, _knownKeys),
  );

  /// The account the zone belongs to.
  final ZoneAccount? account;

  /// The last time proof of ownership was detected and the zone was made active.
  final String? activatedOn;

  /// Allows the customer to use a custom apex. *Tenants Only Configuration*.
  final String? cnameSuffix;

  /// When the zone was created.
  final String? createdOn;

  /// The interval (in seconds) from when development mode expires (positive
  /// integer) or last expired (negative integer) for the domain. If development
  /// mode has never been enabled, this value is 0.
  final num? developmentMode;

  /// Identifier
  final String? id;

  /// Metadata about the zone.
  final ZoneMeta? meta;

  /// When the zone was last modified.
  final String? modifiedOn;

  /// The domain name. Per [RFC
  /// 1035](https://datatracker.ietf.org/doc/html/rfc1035#section-2.3.4) the
  /// overall zone name can be up to 253 characters, with each segment ("label")
  /// not exceeding 63 characters.
  final String? name;

  /// The name servers Cloudflare assigns to a zone.
  final List<String>? nameServers;

  /// DNS host at the time of switching to Cloudflare.
  final String? originalDnshost;

  /// Original name servers before moving to Cloudflare.
  final List<String>? originalNameServers;

  /// Registrar for the domain at the time of switching to Cloudflare.
  final String? originalRegistrar;

  /// The owner of the zone.
  final ZoneOwner? owner;

  /// Indicates whether the zone is only using Cloudflare DNS services. A true
  /// value means the zone will not receive security or performance benefits.
  final bool? paused;

  /// Legacy permissions based on legacy user membership information.
  final List<String>? permissions;

  /// A Zones subscription information.
  final ZonePlan? plan;

  /// The zone status on Cloudflare. Allowed values: `initializing`, `pending`,
  /// `active`, `moved`.
  final String? status;

  /// The root organizational unit that this zone belongs to (such as a tenant or
  /// organization).
  final ZoneTenant? tenant;

  /// The immediate parent organizational unit that this zone belongs to (such as
  /// under a tenant or sub-organization).
  final ZoneTenantUnit? tenantUnit;

  /// A full zone implies that DNS is hosted with Cloudflare. A partial zone is
  /// typically a partner-hosted zone or a CNAME setup. Allowed values: `full`,
  /// `partial`, `secondary`, `internal`.
  final String? type_;

  /// An array of domains used for custom name servers. This is only available for
  /// Business and Enterprise plans.
  final List<String>? vanityNameServers;

  /// Verification key for partial zone setup.
  final String? verificationKey;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'account',
    'activated_on',
    'cname_suffix',
    'created_on',
    'development_mode',
    'id',
    'meta',
    'modified_on',
    'name',
    'name_servers',
    'original_dnshost',
    'original_name_servers',
    'original_registrar',
    'owner',
    'paused',
    'permissions',
    'plan',
    'status',
    'tenant',
    'tenant_unit',
    'type',
    'vanity_name_servers',
    'verification_key',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (account != null) 'account': account!.toJson(),
    if (activatedOn != null) 'activated_on': activatedOn!,
    if (cnameSuffix != null) 'cname_suffix': cnameSuffix!,
    if (createdOn != null) 'created_on': createdOn!,
    if (developmentMode != null) 'development_mode': developmentMode!,
    if (id != null) 'id': id!,
    if (meta != null) 'meta': meta!.toJson(),
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (name != null) 'name': name!,
    if (nameServers != null) 'name_servers': nameServers!,
    if (originalDnshost != null) 'original_dnshost': originalDnshost!,
    if (originalNameServers != null)
      'original_name_servers': originalNameServers!,
    if (originalRegistrar != null) 'original_registrar': originalRegistrar!,
    if (owner != null) 'owner': owner!.toJson(),
    if (paused != null) 'paused': paused!,
    if (permissions != null) 'permissions': permissions!,
    if (plan != null) 'plan': plan!.toJson(),
    if (status != null) 'status': status!,
    if (tenant != null) 'tenant': tenant!.toJson(),
    if (tenantUnit != null) 'tenant_unit': tenantUnit!.toJson(),
    if (type_ != null) 'type': type_!,
    if (vanityNameServers != null) 'vanity_name_servers': vanityNameServers!,
    if (verificationKey != null) 'verification_key': verificationKey!,
  };

  Zone copyWith({
    ZoneAccount? account,
    String? activatedOn,
    String? cnameSuffix,
    String? createdOn,
    num? developmentMode,
    String? id,
    ZoneMeta? meta,
    String? modifiedOn,
    String? name,
    List<String>? nameServers,
    String? originalDnshost,
    List<String>? originalNameServers,
    String? originalRegistrar,
    ZoneOwner? owner,
    bool? paused,
    List<String>? permissions,
    ZonePlan? plan,
    String? status,
    ZoneTenant? tenant,
    ZoneTenantUnit? tenantUnit,
    String? type_,
    List<String>? vanityNameServers,
    String? verificationKey,
    Map<String, Object?>? extra,
  }) => Zone(
    account: account ?? this.account,
    activatedOn: activatedOn ?? this.activatedOn,
    cnameSuffix: cnameSuffix ?? this.cnameSuffix,
    createdOn: createdOn ?? this.createdOn,
    developmentMode: developmentMode ?? this.developmentMode,
    id: id ?? this.id,
    meta: meta ?? this.meta,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    name: name ?? this.name,
    nameServers: nameServers ?? this.nameServers,
    originalDnshost: originalDnshost ?? this.originalDnshost,
    originalNameServers: originalNameServers ?? this.originalNameServers,
    originalRegistrar: originalRegistrar ?? this.originalRegistrar,
    owner: owner ?? this.owner,
    paused: paused ?? this.paused,
    permissions: permissions ?? this.permissions,
    plan: plan ?? this.plan,
    status: status ?? this.status,
    tenant: tenant ?? this.tenant,
    tenantUnit: tenantUnit ?? this.tenantUnit,
    type_: type_ ?? this.type_,
    vanityNameServers: vanityNameServers ?? this.vanityNameServers,
    verificationKey: verificationKey ?? this.verificationKey,
    extra: extra ?? this.extra,
  );
}

/// The account the zone belongs to.
class ZoneAccount {
  const ZoneAccount({
    this.id,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory ZoneAccount.fromJson(Map<String, Object?> json) => ZoneAccount(
    id: asString(json['id']),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// The name of the account.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
  };

  ZoneAccount copyWith({
    String? id,
    String? name,
    Map<String, Object?>? extra,
  }) => ZoneAccount(
    id: id ?? this.id,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

/// Metadata about the zone.
class ZoneMeta {
  const ZoneMeta({
    this.cdnOnly,
    this.customCertificateQuota,
    this.dnsOnly,
    this.foundationDns,
    this.pageRuleQuota,
    this.phishingDetected,
    this.step,
    this.extra = const <String, Object?>{},
  });

  factory ZoneMeta.fromJson(Map<String, Object?> json) => ZoneMeta(
    cdnOnly: asBool(json['cdn_only']),
    customCertificateQuota: asInt(json['custom_certificate_quota']),
    dnsOnly: asBool(json['dns_only']),
    foundationDns: asBool(json['foundation_dns']),
    pageRuleQuota: asInt(json['page_rule_quota']),
    phishingDetected: asBool(json['phishing_detected']),
    step: asInt(json['step']),
    extra: extraOf(json, _knownKeys),
  );

  /// The zone is only configured for CDN.
  final bool? cdnOnly;

  /// Number of Custom Certificates the zone can have.
  final int? customCertificateQuota;

  /// The zone is only configured for DNS.
  final bool? dnsOnly;

  /// The zone is setup with Foundation DNS.
  final bool? foundationDns;

  /// Number of Page Rules a zone can have.
  final int? pageRuleQuota;

  /// The zone has been flagged for phishing.
  final bool? phishingDetected;
  final int? step;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'cdn_only',
    'custom_certificate_quota',
    'dns_only',
    'foundation_dns',
    'page_rule_quota',
    'phishing_detected',
    'step',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (cdnOnly != null) 'cdn_only': cdnOnly!,
    if (customCertificateQuota != null)
      'custom_certificate_quota': customCertificateQuota!,
    if (dnsOnly != null) 'dns_only': dnsOnly!,
    if (foundationDns != null) 'foundation_dns': foundationDns!,
    if (pageRuleQuota != null) 'page_rule_quota': pageRuleQuota!,
    if (phishingDetected != null) 'phishing_detected': phishingDetected!,
    if (step != null) 'step': step!,
  };

  ZoneMeta copyWith({
    bool? cdnOnly,
    int? customCertificateQuota,
    bool? dnsOnly,
    bool? foundationDns,
    int? pageRuleQuota,
    bool? phishingDetected,
    int? step,
    Map<String, Object?>? extra,
  }) => ZoneMeta(
    cdnOnly: cdnOnly ?? this.cdnOnly,
    customCertificateQuota:
        customCertificateQuota ?? this.customCertificateQuota,
    dnsOnly: dnsOnly ?? this.dnsOnly,
    foundationDns: foundationDns ?? this.foundationDns,
    pageRuleQuota: pageRuleQuota ?? this.pageRuleQuota,
    phishingDetected: phishingDetected ?? this.phishingDetected,
    step: step ?? this.step,
    extra: extra ?? this.extra,
  );
}

/// The owner of the zone.
class ZoneOwner {
  const ZoneOwner({
    this.id,
    this.name,
    this.type_,
    this.extra = const <String, Object?>{},
  });

  factory ZoneOwner.fromJson(Map<String, Object?> json) => ZoneOwner(
    id: asString(json['id']),
    name: asString(json['name']),
    type_: asString(json['type']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Name of the owner.
  final String? name;

  /// The type of owner.
  final String? type_;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name', 'type'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
    if (type_ != null) 'type': type_!,
  };

  ZoneOwner copyWith({
    String? id,
    String? name,
    String? type_,
    Map<String, Object?>? extra,
  }) => ZoneOwner(
    id: id ?? this.id,
    name: name ?? this.name,
    type_: type_ ?? this.type_,
    extra: extra ?? this.extra,
  );
}

/// A Zones subscription information.
class ZonePlan {
  const ZonePlan({
    this.canSubscribe,
    this.currency,
    this.externallyManaged,
    this.frequency,
    this.id,
    this.isSubscribed,
    this.legacyDiscount,
    this.legacyId,
    this.name,
    this.price,
    this.extra = const <String, Object?>{},
  });

  factory ZonePlan.fromJson(Map<String, Object?> json) => ZonePlan(
    canSubscribe: asBool(json['can_subscribe']),
    currency: asString(json['currency']),
    externallyManaged: asBool(json['externally_managed']),
    frequency: asString(json['frequency']),
    id: asString(json['id']),
    isSubscribed: asBool(json['is_subscribed']),
    legacyDiscount: asBool(json['legacy_discount']),
    legacyId: asString(json['legacy_id']),
    name: asString(json['name']),
    price: asNum(json['price']),
    extra: extraOf(json, _knownKeys),
  );

  /// States if the subscription can be activated.
  final bool? canSubscribe;

  /// The denomination of the customer.
  final String? currency;

  /// If this Zone is managed by another company.
  final bool? externallyManaged;

  /// How often the customer is billed.
  final String? frequency;

  /// Identifier
  final String? id;

  /// States if the subscription active.
  final bool? isSubscribed;

  /// If the legacy discount applies to this Zone.
  final bool? legacyDiscount;

  /// The legacy name of the plan.
  final String? legacyId;

  /// Name of the owner.
  final String? name;

  /// How much the customer is paying.
  final num? price;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'can_subscribe',
    'currency',
    'externally_managed',
    'frequency',
    'id',
    'is_subscribed',
    'legacy_discount',
    'legacy_id',
    'name',
    'price',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (canSubscribe != null) 'can_subscribe': canSubscribe!,
    if (currency != null) 'currency': currency!,
    if (externallyManaged != null) 'externally_managed': externallyManaged!,
    if (frequency != null) 'frequency': frequency!,
    if (id != null) 'id': id!,
    if (isSubscribed != null) 'is_subscribed': isSubscribed!,
    if (legacyDiscount != null) 'legacy_discount': legacyDiscount!,
    if (legacyId != null) 'legacy_id': legacyId!,
    if (name != null) 'name': name!,
    if (price != null) 'price': price!,
  };

  ZonePlan copyWith({
    bool? canSubscribe,
    String? currency,
    bool? externallyManaged,
    String? frequency,
    String? id,
    bool? isSubscribed,
    bool? legacyDiscount,
    String? legacyId,
    String? name,
    num? price,
    Map<String, Object?>? extra,
  }) => ZonePlan(
    canSubscribe: canSubscribe ?? this.canSubscribe,
    currency: currency ?? this.currency,
    externallyManaged: externallyManaged ?? this.externallyManaged,
    frequency: frequency ?? this.frequency,
    id: id ?? this.id,
    isSubscribed: isSubscribed ?? this.isSubscribed,
    legacyDiscount: legacyDiscount ?? this.legacyDiscount,
    legacyId: legacyId ?? this.legacyId,
    name: name ?? this.name,
    price: price ?? this.price,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeBody {
  const ZonePurgeBody({
    this.tags,
    this.hosts,
    this.prefixes,
    this.purgeEverything,
    this.files,
    this.extra = const <String, Object?>{},
  });

  factory ZonePurgeBody.fromJson(Map<String, Object?> json) => ZonePurgeBody(
    tags: asPrimitiveList<String>(json['tags'], asString),
    hosts: asPrimitiveList<String>(json['hosts'], asString),
    prefixes: asPrimitiveList<String>(json['prefixes'], asString),
    purgeEverything: asBool(json['purge_everything']),
    files: asModelList(json['files'], ZonePurgeBodyFilesItem.fromJson),
    extra: extraOf(json, _knownKeys),
  );

  /// For more information on cache tags and purging by tags, please refer to
  /// [purge by cache-tags documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-tags/).
  final List<String>? tags;

  /// For more information purging by hostnames, please refer to [purge by
  /// hostname documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-hostname/).
  final List<String>? hosts;

  /// For more information on purging by prefixes, please refer to [purge by
  /// prefix documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge_by_prefix/).
  final List<String>? prefixes;

  /// For more information, please refer to [purge everything documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-everything/).
  final bool? purgeEverything;

  /// For more information on purging files with URL and headers, please refer to
  /// [purge by single-file documentation
  /// page](https://developers.cloudflare.com/cache/how-to/purge-cache/purge-by-single-file/).
  final List<ZonePurgeBodyFilesItem>? files;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'tags',
    'hosts',
    'prefixes',
    'purge_everything',
    'files',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (tags != null) 'tags': tags!,
    if (hosts != null) 'hosts': hosts!,
    if (prefixes != null) 'prefixes': prefixes!,
    if (purgeEverything != null) 'purge_everything': purgeEverything!,
    if (files != null) 'files': files!.map((e) => e.toJson()).toList(),
  };

  ZonePurgeBody copyWith({
    List<String>? tags,
    List<String>? hosts,
    List<String>? prefixes,
    bool? purgeEverything,
    List<ZonePurgeBodyFilesItem>? files,
    Map<String, Object?>? extra,
  }) => ZonePurgeBody(
    tags: tags ?? this.tags,
    hosts: hosts ?? this.hosts,
    prefixes: prefixes ?? this.prefixes,
    purgeEverything: purgeEverything ?? this.purgeEverything,
    files: files ?? this.files,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeBodyFilesItem {
  const ZonePurgeBodyFilesItem({
    this.headers,
    this.url,
    this.extra = const <String, Object?>{},
  });

  factory ZonePurgeBodyFilesItem.fromJson(Map<String, Object?> json) =>
      ZonePurgeBodyFilesItem(
        headers: asMap(json['headers']),
        url: asString(json['url']),
        extra: extraOf(json, _knownKeys),
      );

  final Map<String, Object?>? headers;
  final String? url;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'headers', 'url'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (headers != null) 'headers': headers!,
    if (url != null) 'url': url!,
  };

  ZonePurgeBodyFilesItem copyWith({
    Map<String, Object?>? headers,
    String? url,
    Map<String, Object?>? extra,
  }) => ZonePurgeBodyFilesItem(
    headers: headers ?? this.headers,
    url: url ?? this.url,
    extra: extra ?? this.extra,
  );
}

class ZonePurgeResult {
  const ZonePurgeResult({this.id, this.extra = const <String, Object?>{}});

  factory ZonePurgeResult.fromJson(Map<String, Object?> json) =>
      ZonePurgeResult(
        id: asString(json['id']),
        extra: extraOf(json, _knownKeys),
      );

  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  ZonePurgeResult copyWith({String? id, Map<String, Object?>? extra}) =>
      ZonePurgeResult(id: id ?? this.id, extra: extra ?? this.extra);
}

class ZoneSettingsGetAllZoneSettingsItem {
  const ZoneSettingsGetAllZoneSettingsItem({
    this.editable,
    this.id,
    this.modifiedOn,
    this.value,
    this.timeRemaining,
    this.enabled,
    this.extra = const <String, Object?>{},
  });

  factory ZoneSettingsGetAllZoneSettingsItem.fromJson(
    Map<String, Object?> json,
  ) => ZoneSettingsGetAllZoneSettingsItem(
    editable: asBool(json['editable']),
    id: json['id'],
    modifiedOn: asString(json['modified_on']),
    value: asString(json['value']),
    timeRemaining: asNum(json['time_remaining']),
    enabled: asBool(json['enabled']),
    extra: extraOf(json, _knownKeys),
  );

  /// Whether or not this setting can be modified for this zone (based on your
  /// Cloudflare plan level). Allowed values: `true`, `false`.
  final bool? editable;

  /// ID of the zone setting. Allowed values: `websockets`.
  final Object? id;

  /// last time this setting was modified.
  final String? modifiedOn;

  /// Value of the zone setting. Allowed values: `off`, `on`.
  final String? value;

  /// Value of the zone setting. Notes: The interval (in seconds) from when
  /// development mode expires (positive integer) or last expired (negative
  /// integer) for the domain. If development mode has never been enabled, this
  /// value is false.
  final num? timeRemaining;

  /// ssl-recommender enrollment setting.
  final bool? enabled;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {
    'editable',
    'id',
    'modified_on',
    'value',
    'time_remaining',
    'enabled',
  };

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (editable != null) 'editable': editable!,
    if (id != null) 'id': id!,
    if (modifiedOn != null) 'modified_on': modifiedOn!,
    if (value != null) 'value': value!,
    if (timeRemaining != null) 'time_remaining': timeRemaining!,
    if (enabled != null) 'enabled': enabled!,
  };

  ZoneSettingsGetAllZoneSettingsItem copyWith({
    bool? editable,
    Object? id,
    String? modifiedOn,
    String? value,
    num? timeRemaining,
    bool? enabled,
    Map<String, Object?>? extra,
  }) => ZoneSettingsGetAllZoneSettingsItem(
    editable: editable ?? this.editable,
    id: id ?? this.id,
    modifiedOn: modifiedOn ?? this.modifiedOn,
    value: value ?? this.value,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    enabled: enabled ?? this.enabled,
    extra: extra ?? this.extra,
  );
}

class ZoneSettingsSingleRequest {
  const ZoneSettingsSingleRequest({
    this.enabled,
    this.value,
    this.extra = const <String, Object?>{},
  });

  factory ZoneSettingsSingleRequest.fromJson(Map<String, Object?> json) =>
      ZoneSettingsSingleRequest(
        enabled: asBool(json['enabled']),
        value: asModel(json['value'], SettingValue.fromJson),
        extra: extraOf(json, _knownKeys),
      );

  /// ssl-recommender enrollment setting.
  final bool? enabled;
  final SettingValue? value;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'enabled', 'value'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (enabled != null) 'enabled': enabled!,
    if (value != null) 'value': value!.toJson(),
  };

  ZoneSettingsSingleRequest copyWith({
    bool? enabled,
    SettingValue? value,
    Map<String, Object?>? extra,
  }) => ZoneSettingsSingleRequest(
    enabled: enabled ?? this.enabled,
    value: value ?? this.value,
    extra: extra ?? this.extra,
  );
}

/// The root organizational unit that this zone belongs to (such as a tenant or
/// organization).
class ZoneTenant {
  const ZoneTenant({
    this.id,
    this.name,
    this.extra = const <String, Object?>{},
  });

  factory ZoneTenant.fromJson(Map<String, Object?> json) => ZoneTenant(
    id: asString(json['id']),
    name: asString(json['name']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// The name of the Tenant account.
  final String? name;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id', 'name'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
    if (name != null) 'name': name!,
  };

  ZoneTenant copyWith({
    String? id,
    String? name,
    Map<String, Object?>? extra,
  }) => ZoneTenant(
    id: id ?? this.id,
    name: name ?? this.name,
    extra: extra ?? this.extra,
  );
}

/// The immediate parent organizational unit that this zone belongs to (such as
/// under a tenant or sub-organization).
class ZoneTenantUnit {
  const ZoneTenantUnit({this.id, this.extra = const <String, Object?>{}});

  factory ZoneTenantUnit.fromJson(Map<String, Object?> json) => ZoneTenantUnit(
    id: asString(json['id']),
    extra: extraOf(json, _knownKeys),
  );

  /// Identifier
  final String? id;

  /// Keys returned by Cloudflare that this spec snapshot does
  /// not describe. Preserved so an edit round-trip cannot
  /// silently drop them.
  final Map<String, Object?> extra;

  static const Set<String> _knownKeys = {'id'};

  Map<String, Object?> toJson() => <String, Object?>{
    ...extra,
    if (id != null) 'id': id!,
  };

  ZoneTenantUnit copyWith({String? id, Map<String, Object?>? extra}) =>
      ZoneTenantUnit(id: id ?? this.id, extra: extra ?? this.extra);
}
