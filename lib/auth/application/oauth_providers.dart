import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/oauth_client.dart';
import 'auth_providers.dart';

/// Runtime overrides for the OAuth client.
///
/// Neither value is secret — a public PKCE client has no secret — so plain
/// preferences are the right place, and it lets anyone point the app at their
/// own registered client without rebuilding.
class OAuthSettings {
  const OAuthSettings({required this.clientId, required this.redirectUri});

  static const String keyClientId = 'oauth_client_id';
  static const String keyRedirect = 'oauth_redirect_uri';

  final String clientId;
  final String redirectUri;
}

final oauthSettingsProvider = FutureProvider<OAuthSettings>((ref) async {
  final prefs = await ref.watch(sharedPrefsProvider.future);
  return OAuthSettings(
    clientId:
        prefs.getString(OAuthSettings.keyClientId) ??
        OAuthConfig.clientIdFromBuild,
    redirectUri:
        prefs.getString(OAuthSettings.keyRedirect) ??
        OAuthConfig.redirectFromBuild,
  );
});

Future<void> saveOAuthSettings(
  SharedPreferences prefs, {
  required String clientId,
  required String redirectUri,
}) async {
  await prefs.setString(OAuthSettings.keyClientId, clientId.trim());
  await prefs.setString(OAuthSettings.keyRedirect, redirectUri.trim());
}

final oauthConfigProvider = FutureProvider<OAuthConfig>((ref) async {
  final settings = await ref.watch(oauthSettingsProvider.future);
  return OAuthConfig(
    clientId: settings.clientId,
    redirectUri: settings.redirectUri,
  );
});

/// The browser hop.
///
/// Cloudflare requires an https redirect, and the bridge Worker bounces that
/// to `io.cfmgr.app://`, which is the scheme this listens on.
Future<String> _openInBrowser({required String url, required String scheme}) =>
    FlutterWebAuth2.authenticate(url: url, callbackUrlScheme: scheme);

final cloudflareOAuthProvider = FutureProvider<CloudflareOAuth>((ref) async {
  final config = await ref.watch(oauthConfigProvider.future);
  return CloudflareOAuth(
    config: config,
    // A bare Dio: the token endpoint speaks OAuth, not the Cloudflare
    // envelope, and must not carry the app's auth headers.
    dio: Dio(),
    openBrowser: _openInBrowser,
  );
});
