// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LTr extends L {
  LTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navZones => 'Bölgeler';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navSecurity => 'Güvenlik';

  @override
  String get navDeveloper => 'Geliştirici';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Daha fazla';

  @override
  String get scopeAccount => 'Hesap';

  @override
  String get scopeZone => 'Bölge';

  @override
  String get scopeAllAccounts => 'Tüm hesaplar';

  @override
  String get scopePickZone => 'Bölge seç';

  @override
  String get scopePickAccount => 'Hesap seç';

  @override
  String get scopeMoreZones => 'Daha fazla bölge var — aramak için yazın';

  @override
  String get securityIpAccess => 'IP erişimi';

  @override
  String get securityPickZone =>
      'Önce bir bölge seçin — güvenlik kuralları bölgeye özeldir.';

  @override
  String get securityNoRules => 'Bu aşamada henüz kural yok';

  @override
  String get securityNewIpRule => 'Yeni IP erişim kuralı';

  @override
  String get securityAction => 'Eylem';

  @override
  String get securityTarget => 'Neye uygulanır';

  @override
  String get securityValue => 'Değer';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Depolama';

  @override
  String get devPickAccount =>
      'Önce bir hesap seçin — bunlar hesap düzeyindedir.';

  @override
  String get devKvNamespaces => 'KV ad alanları';

  @override
  String get devD1 => 'D1 veritabanları';

  @override
  String get devR2 => 'R2 kovaları';

  @override
  String get kvSearchHint => 'Anahtarları filtrele';

  @override
  String get kvValue => 'Değer';

  @override
  String get kvExpires => 'Sona eriyor';

  @override
  String get kvMoreKeys => 'Daha fazla anahtar var — filtreyi daraltın';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Çalıştır';

  @override
  String get d1OneStatement => 'Aynı anda tek sorgu';

  @override
  String get d1NoRows => 'Satır dönmedi';

  @override
  String get d1DestructiveWarning => 'Bu sorgu veriyi değiştirir veya siler.';

  @override
  String get d1ConfirmTitle => 'Yıkıcı sorgu çalıştırılsın mı?';

  @override
  String get d1ConfirmHint => 'Onaylamak için RUN yazın';

  @override
  String get zoneTrafficSubtitle =>
      'Page Rules, yük dengeleyiciler, bekleme odaları';

  @override
  String get zoneTlsSubtitle => 'Sertifikalar, özel ana makine adları, DNSSEC';

  @override
  String get zoneEmailSubtitle => 'Yönlendirme kuralları ve hedef adresler';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Yük dengeleyiciler';

  @override
  String get trafficWaitingRooms => 'Bekleme odaları';

  @override
  String get tlsCertificates => 'Sertifika paketleri';

  @override
  String get tlsCustomHostnames => 'Özel ana makine adları';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Yönlendirme kuralları';

  @override
  String get emailAddresses => 'Hedef adresler';

  @override
  String get moreAlerts => 'Uyarılar';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tüneller';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Şu anda çalışan bağlayıcı yok';

  @override
  String get ztNoPolicies => 'Bu uygulamada politika yok';

  @override
  String get commonRetry => 'Yeniden dene';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonCopy => 'Kopyala';

  @override
  String get commonCopied => 'Kopyalandı';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonAll => 'Tümü';

  @override
  String get commonContinue => 'Devam';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonRefresh => 'Yenile';

  @override
  String get commonNothingHere => 'Burası henüz boş';

  @override
  String get commonLoadMore => 'Daha fazla göster';

  @override
  String get commonDiagnostics => 'Tanılamayı kopyala';

  @override
  String get commonUnlock => 'Kilidi aç';

  @override
  String get onboardWelcomeTitle => 'Cloudflare cebinizde';

  @override
  String onboardWelcomeBody(int count) {
    return 'Bölgeler, DNS, önbellek ve API\'nin $count uç noktasının tamamı. Cihazdan Cloudflare\'e giden isteklerin dışında hiçbir şey çıkmaz — uygulamanın başka yere internet izni yok.';
  }

  @override
  String get authChooseMethod => 'Nasıl giriş yapalım?';

  @override
  String get authApiToken => 'API belirteci';

  @override
  String get authApiTokenBlurb =>
      'Önerilir. Yalnızca verdiğiniz izinlerle sınırlıdır, istediğiniz zaman iptal edilir.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb => 'Eski yöntem. Tüm hesaba sınırsız erişim.';

  @override
  String get authCreateToken => 'Panelde belirteç oluştur';

  @override
  String get authPasteToken => 'API belirtecini yapıştırın';

  @override
  String get authTokenHint => 'Panelden 40 karakterlik belirteç';

  @override
  String get authVerify => 'Doğrula ve devam et';

  @override
  String get authVerifying => 'Belirteç kontrol ediliyor…';

  @override
  String get authTokenValid => 'Belirteç kabul edildi';

  @override
  String get authEmail => 'Cloudflare hesabının e-postası';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Bu, hesaba tam erişim verir';

  @override
  String get authGlobalKeyWarnBody =>
      'Global API Key ne izinlerle ne de IP ile sınırlandırılabilir. Faturalandırmayı okuyup değiştirebilir ve hesabı silebilir. Özel bir nedeniniz yoksa API belirteci kullanın.';

  @override
  String get authGlobalKeyConfirm => 'Devam etmek için UNRESTRICTED yazın';

  @override
  String get authProfiles => 'Profiller';

  @override
  String get authAddProfile => 'Profil ekle';

  @override
  String get authProfileName => 'Profil adı';

  @override
  String get authSignOut => 'Profili kaldır';

  @override
  String get lockTitle => 'PIN kodunuzu girin';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'PIN yanlış';

  @override
  String get lockBiometric => 'Parmak izi';

  @override
  String get lockSetPin => 'Bir PIN belirleyin';

  @override
  String get lockConfirmPin => 'PIN\'i tekrarlayın';

  @override
  String get lockPinTooShort => 'En az 4 rakam';

  @override
  String get lockPinMismatch => 'PIN kodları eşleşmiyor';

  @override
  String get lockEnableBiometric => 'Parmak iziyle aç';

  @override
  String get permTitle => 'İzinler';

  @override
  String get permNotificationAccess => 'Bildirim erişimi';

  @override
  String permMissing(String permissions) {
    return 'Kimlik bilgilerinizde eksik: $permissions';
  }

  @override
  String get permFixCta => 'Bu izinle belirteç oluştur';

  @override
  String get zonesTitle => 'Bölgeler';

  @override
  String get zonesSearchHint => 'Bölgelerde ara';

  @override
  String get zonesEmpty => 'Bu hesapta bölge yok';

  @override
  String get zoneStatusActive => 'Etkin';

  @override
  String get zonePlan => 'Plan';

  @override
  String get zoneNameservers => 'Ad sunucuları';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt',
      zero: 'Kayıt yok',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Kayıt ekle';

  @override
  String get dnsEditRecord => 'Kaydı düzenle';

  @override
  String get dnsType => 'Tür';

  @override
  String get dnsName => 'Ad';

  @override
  String get dnsContent => 'İçerik';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Otomatik';

  @override
  String get dnsProxied => 'Cloudflare üzerinden proxy';

  @override
  String get dnsPriority => 'Öncelik';

  @override
  String get dnsComment => 'Yorum';

  @override
  String get dnsTags => 'Etiketler';

  @override
  String dnsDeleteConfirm(String name) {
    return '$name silinsin mi?';
  }

  @override
  String get dnsExport => 'BIND dosyası olarak dışa aktar';

  @override
  String get dnsSearchHint => 'Kayıtlarda ara';

  @override
  String get cachePurgeTitle => 'Önbelleği temizle';

  @override
  String get cachePurgeEverything => 'Hepsini temizle';

  @override
  String get cachePurgeEverythingWarn =>
      'Bölgenin tüm önbelleğini siler ve origin yükünü kısa süreliğine artırır.';

  @override
  String get cachePurgeConfirm => 'Onaylamak için PURGE yazın';

  @override
  String get cachePurgeByUrl => 'URL\'ye göre temizle';

  @override
  String get cachePurged => 'Önbellek temizlendi';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Ana makine';

  @override
  String get purgeByPrefix => 'Önek';

  @override
  String get purgeByTag => 'Etiket';

  @override
  String get purgeTargets => 'Ne temizlenecek';

  @override
  String get purgeOnePerLine => 'Her satıra bir tane';

  @override
  String get analyticsTitle => 'Analitik';

  @override
  String get analyticsRequests => 'İstekler';

  @override
  String get analyticsCached => 'Önbellekten';

  @override
  String get analyticsBandwidth => 'Bant genişliği';

  @override
  String get analyticsUniques => 'Ziyaretçiler';

  @override
  String get analyticsCacheRatio => 'Önbellek isabeti';

  @override
  String get analyticsThreats => 'Tehditler';

  @override
  String get analyticsRequestsOverTime => 'Zamana göre istekler';

  @override
  String get analyticsStatusCodes => 'Durum kodları';

  @override
  String get analyticsTopCountries => 'Ülkeler';

  @override
  String get analyticsContentTypes => 'İçerik türleri';

  @override
  String get analyticsSecurityEvents => 'Güvenlik olayları';

  @override
  String get analyticsNoData => 'Bu dönemde trafik olmadı';

  @override
  String get zoneAnalyticsSubtitle => 'Trafik, önbellek isabeti, tehditler';

  @override
  String get zoneDnsSubtitle => 'Kayıtlar, proxy durumu, BIND dışa aktarma';

  @override
  String get zonePurgeSubtitle => 'URL, ana makine, önek, etiket — ya da hepsi';

  @override
  String get explorerTitle => 'API gezgini';

  @override
  String explorerSubtitle(int count) {
    return '$count uç nokta';
  }

  @override
  String get explorerSearchHint => 'Uç nokta ara';

  @override
  String get explorerSend => 'İsteği gönder';

  @override
  String get explorerDeprecated => 'Kullanımdan kaldırıldı';

  @override
  String get explorerRequired => 'Zorunlu';

  @override
  String get explorerNoParams => 'Bu uç nokta parametre almıyor';

  @override
  String get explorerBody => 'İstek gövdesi';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsDynamicColor => 'Duvar kâğıdımla eşleştir';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Kapalıyken uygulamanın kendi paleti kullanılır.';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsSecurity => 'Güvenlik';

  @override
  String get settingsAutoLock => 'Otomatik kilit';

  @override
  String get settingsAutoLockImmediate => 'Hemen';

  @override
  String get settingsAutoLockNever => 'Asla';

  @override
  String get settingsLockNow => 'Şimdi kilitle';

  @override
  String get settingsBlockScreenshots => 'Ekran görüntülerini engelle';

  @override
  String get settingsBlockScreenshotsHint =>
      'Uygulamayı ekran görüntüsü, ekran kaydı ve son uygulamalar önizlemesinden gizler.';

  @override
  String get settingsPrivacyTitle => 'Gizlilik';

  @override
  String get settingsPrivacyBody =>
      'Kimlik bilgileri PIN\'inizden türetilen bir anahtarla AES-GCM ile şifrelenir ve yalnızca bu cihazda saklanır. Yalnızca api.cloudflare.com adresine gönderilirler. Hiçbir telemetri yoktur.';

  @override
  String get settingsWipe => 'Her şeyi sil';

  @override
  String get settingsWipeConfirm =>
      'Bu cihazdaki tüm profilleri ve kimlik bilgilerini siler.';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get errNetworkOffline => 'İnternet bağlantısı yok';

  @override
  String get errNetworkTimeout => 'Cloudflare zamanında yanıt vermedi';

  @override
  String get errAuth => 'Cloudflare bu kimlik bilgisini reddetti';

  @override
  String get errRateLimited => 'Çok sık — birazdan yeniden denenecek';

  @override
  String get errNotFound => 'Bulunamadı';

  @override
  String get errServer => 'Cloudflare sunucu hatası döndürdü';

  @override
  String get errUnknown => 'Bir şeyler ters gitti';
}
