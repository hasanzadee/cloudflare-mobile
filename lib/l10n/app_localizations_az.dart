// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class LAz extends L {
  LAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Əsas';

  @override
  String get navZones => 'Zonalar';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navSecurity => 'Təhlükəsizlik';

  @override
  String get navDeveloper => 'Developer';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Daha çox';

  @override
  String get scopeAccount => 'Hesab';

  @override
  String get scopeZone => 'Zona';

  @override
  String get scopeAllAccounts => 'Bütün hesablar';

  @override
  String get scopePickZone => 'Zona seçin';

  @override
  String get scopePickAccount => 'Hesab seçin';

  @override
  String get scopeMoreZones => 'Daha çox zona var — axtarmaq üçün yazın';

  @override
  String get securityIpAccess => 'IP giriş';

  @override
  String get securityPickZone =>
      'Əvvəlcə zona seçin — təhlükəsizlik qaydaları zonaya aiddir.';

  @override
  String get securityNoRules => 'Bu mərhələdə hələ qayda yoxdur';

  @override
  String get securityNewIpRule => 'Yeni IP giriş qaydası';

  @override
  String get securityAction => 'Əməliyyat';

  @override
  String get securityTarget => 'Nəyə tətbiq olunur';

  @override
  String get securityValue => 'Dəyər';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Yaddaş';

  @override
  String get devPickAccount =>
      'Əvvəlcə hesab seçin — bunlar hesab səviyyəsindədir.';

  @override
  String get devKvNamespaces => 'KV ad sahələri';

  @override
  String get devD1 => 'D1 bazaları';

  @override
  String get devR2 => 'R2 bucket-ləri';

  @override
  String get kvSearchHint => 'Açarları süz';

  @override
  String get kvValue => 'Dəyər';

  @override
  String get kvExpires => 'Bitmə vaxtı';

  @override
  String get kvMoreKeys => 'Daha çox açar var — süzgəci dəqiqləşdirin';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'İcra et';

  @override
  String get d1OneStatement => 'Bir dəfəyə bir sorğu';

  @override
  String get d1NoRows => 'Sətir qayıtmadı';

  @override
  String get d1DestructiveWarning => 'Bu sorğu məlumatı dəyişir və ya silir.';

  @override
  String get d1ConfirmTitle => 'Dağıdıcı sorğu icra olunsun?';

  @override
  String get d1ConfirmHint => 'Təsdiq üçün RUN yazın';

  @override
  String get zoneTrafficSubtitle =>
      'Page Rules, balanslaşdırıcılar, gözləmə otaqları';

  @override
  String get zoneTlsSubtitle => 'Sertifikatlar, xüsusi hostname-lər, DNSSEC';

  @override
  String get zoneEmailSubtitle => 'Yönləndirmə qaydaları və alıcı ünvanları';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Yük balanslaşdırıcıları';

  @override
  String get trafficWaitingRooms => 'Gözləmə otaqları';

  @override
  String get tlsCertificates => 'Sertifikat paketləri';

  @override
  String get tlsCustomHostnames => 'Xüsusi hostname-lər';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Yönləndirmə qaydaları';

  @override
  String get emailAddresses => 'Alıcı ünvanları';

  @override
  String get moreAlerts => 'Bildirişlər';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tunellər';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Hazırda heç bir konnektor işləmir';

  @override
  String get ztNoPolicies => 'Bu tətbiqin siyasəti yoxdur';

  @override
  String get commonRetry => 'Yenidən';

  @override
  String get commonCancel => 'İmtina';

  @override
  String get commonSave => 'Yadda saxla';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonClose => 'Bağla';

  @override
  String get commonCopy => 'Kopyala';

  @override
  String get commonCopied => 'Kopyalandı';

  @override
  String get commonSearch => 'Axtarış';

  @override
  String get commonAll => 'Hamısı';

  @override
  String get commonContinue => 'Davam';

  @override
  String get commonAdd => 'Əlavə et';

  @override
  String get commonEdit => 'Dəyiş';

  @override
  String get commonRefresh => 'Yenilə';

  @override
  String get commonNothingHere => 'Hələ boşdur';

  @override
  String get commonLoadMore => 'Daha çox göstər';

  @override
  String get commonDiagnostics => 'Diaqnostikanı kopyala';

  @override
  String get commonUnlock => 'Kiliddən çıxar';

  @override
  String get onboardWelcomeTitle => 'Cloudflare cibinizdə';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zonalar, DNS, keş və API-nin bütün $count endpoint-i. Cihazdan Cloudflare-ə gedən sorğulardan başqa heç nə çıxmır — tətbiqin başqa yerə internet icazəsi yoxdur.';
  }

  @override
  String get authChooseMethod => 'Necə daxil olaq?';

  @override
  String get authApiToken => 'API token';

  @override
  String get authApiTokenBlurb =>
      'Tövsiyə olunur. Yalnız verdiyiniz icazələrlə məhdudlaşır, istənilən vaxt ləğv edilir.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Köhnə üsul. Bütün hesaba məhdudiyyətsiz giriş.';

  @override
  String get authCreateToken => 'Paneldə token yarat';

  @override
  String get authManualPermsTitle => 'Bunları əl ilə əlavə edin';

  @override
  String get authManualPermsBody =>
      'Cloudflare-in link formatında bu icazələr üçün açar yoxdur, ona görə yuxarıdakı düymə onları işarələyə bilmir. Açılan səhifədə Permissions bölməsində hər birini əlavə edin.';

  @override
  String get authPasteToken => 'API token-i yapışdırın';

  @override
  String get authTokenHint => 'Paneldən 40 simvolluq token';

  @override
  String get authVerify => 'Yoxla və davam et';

  @override
  String get authVerifying => 'Token yoxlanılır…';

  @override
  String get authTokenValid => 'Token qəbul edildi';

  @override
  String get authEmail => 'Cloudflare hesabının e-poçtu';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Bu, hesaba tam girişdir';

  @override
  String get authGlobalKeyWarnBody =>
      'Global API Key nə icazələrlə, nə də IP ilə məhdudlaşdırıla bilməz. O, billinqi oxuyub dəyişə və hesabı silə bilər. Xüsusi səbəb yoxdursa, API token istifadə edin.';

  @override
  String get authGlobalKeyConfirm => 'Davam etmək üçün UNRESTRICTED yazın';

  @override
  String get authProfiles => 'Profillər';

  @override
  String get authAddProfile => 'Profil əlavə et';

  @override
  String get authProfileName => 'Profilin adı';

  @override
  String get authSignOut => 'Profili sil';

  @override
  String get lockTitle => 'PIN kodu daxil edin';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'PIN səhvdir';

  @override
  String get lockBiometric => 'Barmaq izi';

  @override
  String get lockSetPin => 'PIN kod təyin edin';

  @override
  String get lockConfirmPin => 'PIN kodu təkrarlayın';

  @override
  String get lockPinTooShort => 'Ən azı 4 rəqəm';

  @override
  String get lockPinMismatch => 'PIN kodlar üst-üstə düşmür';

  @override
  String get lockEnableBiometric => 'Barmaq izi ilə aç';

  @override
  String get permTitle => 'İcazələr';

  @override
  String get permNotificationAccess => 'Bildirişlərə giriş';

  @override
  String permMissing(String permissions) {
    return 'Məlumatlarınızda çatışmır: $permissions';
  }

  @override
  String get permFixCta => 'Bu icazə ilə token yarat';

  @override
  String get zonesTitle => 'Zonalar';

  @override
  String get zonesSearchHint => 'Zonalarda axtar';

  @override
  String get zonesEmpty => 'Bu hesabda zona yoxdur';

  @override
  String get zoneStatusActive => 'Aktiv';

  @override
  String get zonePlan => 'Tarif';

  @override
  String get zoneNameservers => 'Ad serverləri';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count qeyd',
      zero: 'Qeyd yoxdur',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Qeyd əlavə et';

  @override
  String get dnsEditRecord => 'Qeydi dəyiş';

  @override
  String get dnsType => 'Tip';

  @override
  String get dnsName => 'Ad';

  @override
  String get dnsContent => 'Dəyər';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Avto';

  @override
  String get dnsProxied => 'Cloudflare proxy vasitəsilə';

  @override
  String get dnsPriority => 'Prioritet';

  @override
  String get dnsComment => 'Şərh';

  @override
  String get dnsTags => 'Etiketlər';

  @override
  String dnsDeleteConfirm(String name) {
    return '$name silinsin?';
  }

  @override
  String get dnsExport => 'BIND faylı kimi ixrac et';

  @override
  String get dnsSearchHint => 'Qeydlərdə axtar';

  @override
  String get cachePurgeTitle => 'Keşi təmizlə';

  @override
  String get cachePurgeEverything => 'Hamısını təmizlə';

  @override
  String get cachePurgeEverythingWarn =>
      'Zonanın bütün keşini silir və origin yükünü qısa müddətə artırır.';

  @override
  String get cachePurgeConfirm => 'Təsdiq üçün PURGE yazın';

  @override
  String get cachePurgeByUrl => 'URL üzrə təmizlə';

  @override
  String get cachePurged => 'Keş təmizləndi';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Host';

  @override
  String get purgeByPrefix => 'Prefiks';

  @override
  String get purgeByTag => 'Teq';

  @override
  String get purgeTargets => 'Nə təmizlənir';

  @override
  String get purgeOnePerLine => 'Hər sətirdə bir';

  @override
  String get analyticsTitle => 'Analitika';

  @override
  String get analyticsRequests => 'Sorğular';

  @override
  String get analyticsCached => 'Keşdən';

  @override
  String get analyticsBandwidth => 'Trafik';

  @override
  String get analyticsUniques => 'Ziyarətçilər';

  @override
  String get analyticsCacheRatio => 'Keş nisbəti';

  @override
  String get analyticsThreats => 'Təhdidlər';

  @override
  String get analyticsRequestsOverTime => 'Zamana görə sorğular';

  @override
  String get analyticsStatusCodes => 'Cavab kodları';

  @override
  String get analyticsTopCountries => 'Ölkələr';

  @override
  String get analyticsContentTypes => 'Kontent tipləri';

  @override
  String get analyticsSecurityEvents => 'Təhlükəsizlik hadisələri';

  @override
  String get analyticsNoData => 'Bu dövrdə trafik olmayıb';

  @override
  String get zoneAnalyticsSubtitle => 'Trafik, keş nisbəti, təhdidlər';

  @override
  String get zoneDnsSubtitle => 'Qeydlər, proxy statusu, BIND ixracı';

  @override
  String get zonePurgeSubtitle => 'URL, host, prefiks, teq — və ya hamısı';

  @override
  String get explorerTitle => 'API brauzeri';

  @override
  String explorerSubtitle(int count) {
    return '$count endpoint';
  }

  @override
  String get explorerSearchHint => 'Endpoint axtar';

  @override
  String get explorerSend => 'Sorğunu göndər';

  @override
  String get explorerDeprecated => 'Köhnəlmiş';

  @override
  String get explorerRequired => 'Məcburi';

  @override
  String get explorerNoParams => 'Bu endpoint parametr qəbul etmir';

  @override
  String get explorerBody => 'Sorğunun gövdəsi';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAppearance => 'Görünüş';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'İşıqlı';

  @override
  String get settingsThemeDark => 'Qaranlıq';

  @override
  String get settingsDynamicColor => 'Divar kağızının rəngləri';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Sönülü olanda tətbiqin öz palitrası işləyir.';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsSecurity => 'Təhlükəsizlik';

  @override
  String get settingsAutoLock => 'Avtokilid';

  @override
  String get settingsAutoLockImmediate => 'Dərhal';

  @override
  String get settingsAutoLockNever => 'Heç vaxt';

  @override
  String get settingsLockNow => 'İndi kilidlə';

  @override
  String get settingsBlockScreenshots => 'Skrinşotları qadağan et';

  @override
  String get settingsBlockScreenshotsHint =>
      'Tətbiqi skrinşotdan, ekran yazısından və son tətbiqlər önizləməsindən gizlədir.';

  @override
  String get settingsPrivacyTitle => 'Məxfilik';

  @override
  String get settingsPrivacyBody =>
      'Məlumatlar PIN-dən çıxarılan açarla AES-GCM ilə şifrələnir və yalnız bu cihazda saxlanılır. Onlar yalnız api.cloudflare.com-a göndərilir. Heç bir telemetriya yoxdur.';

  @override
  String get settingsWipe => 'Hər şeyi sil';

  @override
  String get settingsWipeConfirm =>
      'Bu, cihazdakı bütün profilləri və giriş məlumatlarını silir.';

  @override
  String get settingsAbout => 'Haqqında';

  @override
  String get errNetworkOffline => 'İnternet bağlantısı yoxdur';

  @override
  String get errNetworkTimeout => 'Cloudflare vaxtında cavab vermədi';

  @override
  String get errAuth => 'Cloudflare bu giriş məlumatlarını rədd etdi';

  @override
  String get errRateLimited => 'Çox tez-tez — bir azdan təkrar edəcəyəm';

  @override
  String get errNotFound => 'Tapılmadı';

  @override
  String get errServer => 'Cloudflare server xətası qaytardı';

  @override
  String get errUnknown => 'Nəsə səhv getdi';
}
