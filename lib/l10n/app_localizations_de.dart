// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class LDe extends L {
  LDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Start';

  @override
  String get navZones => 'Zonen';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navSecurity => 'Sicherheit';

  @override
  String get navDeveloper => 'Entwicklung';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Mehr';

  @override
  String get scopeAccount => 'Konto';

  @override
  String get scopeZone => 'Zone';

  @override
  String get scopeAllAccounts => 'Alle Konten';

  @override
  String get scopePickZone => 'Zone wählen';

  @override
  String get scopePickAccount => 'Konto wählen';

  @override
  String get scopeMoreZones => 'Es gibt weitere Zonen — tippen zum Suchen';

  @override
  String get securityIpAccess => 'IP-Zugriff';

  @override
  String get securityPickZone =>
      'Zuerst eine Zone wählen — Sicherheitsregeln gelten pro Zone.';

  @override
  String get securityNoRules => 'In dieser Phase gibt es noch keine Regeln';

  @override
  String get securityNewIpRule => 'Neue IP-Zugriffsregel';

  @override
  String get securityAction => 'Aktion';

  @override
  String get securityTarget => 'Gilt für';

  @override
  String get securityValue => 'Wert';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Speicher';

  @override
  String get devPickAccount =>
      'Zuerst ein Konto wählen — das sind Ressourcen auf Kontoebene.';

  @override
  String get devKvNamespaces => 'KV-Namespaces';

  @override
  String get devD1 => 'D1-Datenbanken';

  @override
  String get devR2 => 'R2-Buckets';

  @override
  String get kvSearchHint => 'Schlüssel filtern';

  @override
  String get kvValue => 'Wert';

  @override
  String get kvExpires => 'Läuft ab';

  @override
  String get kvMoreKeys => 'Es gibt weitere Schlüssel — Filter eingrenzen';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Ausführen';

  @override
  String get d1OneStatement => 'Nur eine Anweisung auf einmal';

  @override
  String get d1NoRows => 'Keine Zeilen zurückgegeben';

  @override
  String get d1DestructiveWarning =>
      'Diese Anweisung ändert oder löscht Daten.';

  @override
  String get d1ConfirmTitle => 'Verändernde Anweisung ausführen?';

  @override
  String get d1ConfirmHint => 'Zum Bestätigen RUN eingeben';

  @override
  String get zoneTrafficSubtitle => 'Page Rules, Load Balancer, Warteräume';

  @override
  String get zoneTlsSubtitle => 'Zertifikate, eigene Hostnamen, DNSSEC';

  @override
  String get zoneEmailSubtitle => 'Weiterleitungsregeln und Zieladressen';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Load Balancer';

  @override
  String get trafficWaitingRooms => 'Warteräume';

  @override
  String get tlsCertificates => 'Zertifikatspakete';

  @override
  String get tlsCustomHostnames => 'Eigene Hostnamen';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Weiterleitungsregeln';

  @override
  String get emailAddresses => 'Zieladressen';

  @override
  String get moreAlerts => 'Benachrichtigungen';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tunnel';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Derzeit läuft kein Connector';

  @override
  String get ztNoPolicies => 'Diese Anwendung hat keine Richtlinien';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonCopied => 'Kopiert';

  @override
  String get commonSearch => 'Suchen';

  @override
  String get commonAll => 'Alle';

  @override
  String get commonContinue => 'Weiter';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonRefresh => 'Aktualisieren';

  @override
  String get commonNothingHere => 'Hier ist noch nichts';

  @override
  String get commonLoadMore => 'Mehr laden';

  @override
  String get commonDiagnostics => 'Diagnose kopieren';

  @override
  String get commonUnlock => 'Entsperren';

  @override
  String get onboardWelcomeTitle => 'Cloudflare vom Handy aus verwalten';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zonen, DNS, Cache und alle $count API-Endpunkte. Außer den Aufrufen an Cloudflare verlässt nichts das Gerät — die App hat darüber hinaus keine Internetberechtigung.';
  }

  @override
  String get authChooseMethod => 'Wie möchtest du dich anmelden?';

  @override
  String get authApiToken => 'API-Token';

  @override
  String get authApiTokenBlurb =>
      'Empfohlen. Genau auf die erteilten Berechtigungen begrenzt und jederzeit widerrufbar.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Veraltet. Uneingeschränkter Zugriff auf das gesamte Konto.';

  @override
  String get authCreateToken => 'Token im Dashboard erstellen';

  @override
  String get authPasteToken => 'API-Token einfügen';

  @override
  String get authTokenHint => '40-stelliger Token aus dem Dashboard';

  @override
  String get authVerify => 'Prüfen und fortfahren';

  @override
  String get authVerifying => 'Token wird geprüft…';

  @override
  String get authTokenValid => 'Token akzeptiert';

  @override
  String get authEmail => 'E-Mail des Cloudflare-Kontos';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Das gewährt vollen Kontozugriff';

  @override
  String get authGlobalKeyWarnBody =>
      'Ein Global API Key lässt sich weder auf Berechtigungen noch auf IP-Adressen einschränken. Er kann die Abrechnung lesen und ändern und das Konto löschen. Nimm einen API-Token, wenn nichts ausdrücklich dagegen spricht.';

  @override
  String get authGlobalKeyConfirm => 'Zum Fortfahren UNRESTRICTED eingeben';

  @override
  String get authProfiles => 'Profile';

  @override
  String get authAddProfile => 'Profil hinzufügen';

  @override
  String get authProfileName => 'Profilname';

  @override
  String get authSignOut => 'Profil entfernen';

  @override
  String get lockTitle => 'PIN eingeben';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'Falsche PIN';

  @override
  String get lockBiometric => 'Fingerabdruck verwenden';

  @override
  String get lockSetPin => 'PIN festlegen';

  @override
  String get lockConfirmPin => 'PIN wiederholen';

  @override
  String get lockPinTooShort => 'Mindestens 4 Ziffern';

  @override
  String get lockPinMismatch => 'PINs stimmen nicht überein';

  @override
  String get lockEnableBiometric => 'Mit Fingerabdruck entsperren';

  @override
  String get permTitle => 'Berechtigungen';

  @override
  String get permNotificationAccess => 'Zugriff auf Benachrichtigungen';

  @override
  String permMissing(String permissions) {
    return 'Deinen Zugangsdaten fehlt: $permissions';
  }

  @override
  String get permFixCta => 'Token mit dieser Berechtigung erstellen';

  @override
  String get zonesTitle => 'Zonen';

  @override
  String get zonesSearchHint => 'Zonen durchsuchen';

  @override
  String get zonesEmpty => 'Keine Zonen in diesem Konto';

  @override
  String get zoneStatusActive => 'Aktiv';

  @override
  String get zonePlan => 'Tarif';

  @override
  String get zoneNameservers => 'Nameserver';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
      zero: 'Keine Einträge',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Eintrag hinzufügen';

  @override
  String get dnsEditRecord => 'Eintrag bearbeiten';

  @override
  String get dnsType => 'Typ';

  @override
  String get dnsName => 'Name';

  @override
  String get dnsContent => 'Inhalt';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Automatisch';

  @override
  String get dnsProxied => 'Über Cloudflare geproxyt';

  @override
  String get dnsPriority => 'Priorität';

  @override
  String get dnsComment => 'Kommentar';

  @override
  String get dnsTags => 'Tags';

  @override
  String dnsDeleteConfirm(String name) {
    return '$name löschen?';
  }

  @override
  String get dnsExport => 'Als BIND-Datei exportieren';

  @override
  String get dnsSearchHint => 'Einträge durchsuchen';

  @override
  String get cachePurgeTitle => 'Cache leeren';

  @override
  String get cachePurgeEverything => 'Alles leeren';

  @override
  String get cachePurgeEverythingWarn =>
      'Verwirft jede zwischengespeicherte Datei dieser Zone und erhöht kurzzeitig die Last am Origin.';

  @override
  String get cachePurgeConfirm => 'Zum Bestätigen PURGE eingeben';

  @override
  String get cachePurgeByUrl => 'Nach URL leeren';

  @override
  String get cachePurged => 'Cache geleert';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Host';

  @override
  String get purgeByPrefix => 'Präfix';

  @override
  String get purgeByTag => 'Tag';

  @override
  String get purgeTargets => 'Was geleert wird';

  @override
  String get purgeOnePerLine => 'Eines pro Zeile';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsRequests => 'Anfragen';

  @override
  String get analyticsCached => 'Aus dem Cache';

  @override
  String get analyticsBandwidth => 'Datenvolumen';

  @override
  String get analyticsUniques => 'Besucher';

  @override
  String get analyticsCacheRatio => 'Cache-Trefferquote';

  @override
  String get analyticsThreats => 'Bedrohungen';

  @override
  String get analyticsRequestsOverTime => 'Anfragen im Zeitverlauf';

  @override
  String get analyticsStatusCodes => 'Statuscodes';

  @override
  String get analyticsTopCountries => 'Länder';

  @override
  String get analyticsContentTypes => 'Inhaltstypen';

  @override
  String get analyticsSecurityEvents => 'Sicherheitsereignisse';

  @override
  String get analyticsNoData => 'In diesem Zeitraum gab es keinen Traffic';

  @override
  String get zoneAnalyticsSubtitle =>
      'Traffic, Cache-Trefferquote, Bedrohungen';

  @override
  String get zoneDnsSubtitle => 'Einträge, Proxy-Status, BIND-Export';

  @override
  String get zonePurgeSubtitle => 'Nach URL, Host, Präfix, Tag — oder alles';

  @override
  String get explorerTitle => 'API-Explorer';

  @override
  String explorerSubtitle(int count) {
    return '$count Endpunkte';
  }

  @override
  String get explorerSearchHint => 'Endpunkte durchsuchen';

  @override
  String get explorerSend => 'Anfrage senden';

  @override
  String get explorerDeprecated => 'Veraltet';

  @override
  String get explorerRequired => 'Erforderlich';

  @override
  String get explorerNoParams =>
      'Dieser Endpunkt nimmt keine Parameter entgegen';

  @override
  String get explorerBody => 'Anfragetext';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsDynamicColor => 'An mein Hintergrundbild anpassen';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Ausgeschaltet gilt die eigene Farbpalette der App.';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsAutoLock => 'Automatisch sperren';

  @override
  String get settingsAutoLockImmediate => 'Sofort';

  @override
  String get settingsAutoLockNever => 'Nie';

  @override
  String get settingsLockNow => 'Jetzt sperren';

  @override
  String get settingsBlockScreenshots => 'Screenshots blockieren';

  @override
  String get settingsBlockScreenshotsHint =>
      'Verbirgt die App vor Screenshots, Bildschirmaufnahmen und der Vorschau in den letzten Apps.';

  @override
  String get settingsPrivacyTitle => 'Datenschutz';

  @override
  String get settingsPrivacyBody =>
      'Zugangsdaten werden mit AES-GCM und einem aus deiner PIN abgeleiteten Schlüssel verschlüsselt und nur auf diesem Gerät gespeichert. Sie gehen ausschließlich an api.cloudflare.com. Es gibt keinerlei Telemetrie.';

  @override
  String get settingsWipe => 'Alles löschen';

  @override
  String get settingsWipeConfirm =>
      'Löscht jedes gespeicherte Profil und alle Zugangsdaten von diesem Gerät.';

  @override
  String get settingsAbout => 'Über die App';

  @override
  String get errNetworkOffline => 'Keine Internetverbindung';

  @override
  String get errNetworkTimeout =>
      'Cloudflare hat nicht rechtzeitig geantwortet';

  @override
  String get errAuth => 'Cloudflare hat diese Zugangsdaten abgelehnt';

  @override
  String get errRateLimited =>
      'Zu viele Anfragen — es wird gleich erneut versucht';

  @override
  String get errNotFound => 'Nicht gefunden';

  @override
  String get errServer => 'Cloudflare hat einen Serverfehler zurückgegeben';

  @override
  String get errUnknown => 'Etwas ist schiefgelaufen';
}
