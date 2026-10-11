// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LIt extends L {
  LIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Panoramica';

  @override
  String get navZones => 'Zone';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navSecurity => 'Sicurezza';

  @override
  String get navDeveloper => 'Sviluppo';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Altro';

  @override
  String get scopeAccount => 'Account';

  @override
  String get scopeZone => 'Zona';

  @override
  String get scopeAllAccounts => 'Tutti gli account';

  @override
  String get scopePickZone => 'Scegli una zona';

  @override
  String get scopePickAccount => 'Scegli un account';

  @override
  String get scopeMoreZones => 'Ci sono altre zone — digita per cercare';

  @override
  String get securityIpAccess => 'Accesso IP';

  @override
  String get securityPickZone =>
      'Scegli prima una zona: le regole di sicurezza sono specifiche per ogni zona.';

  @override
  String get securityNoRules => 'In questa fase non ci sono ancora regole';

  @override
  String get securityNewIpRule => 'Nuova regola di accesso IP';

  @override
  String get securityNewCustomRule => 'Nuova regola personalizzata';

  @override
  String get securityNewRateLimitRule => 'Nuova regola di rate limiting';

  @override
  String get securityExpression => 'Espressione';

  @override
  String get securityExpressionHelp =>
      'Sintassi del Ruleset Engine. Cloudflare la convalida al salvataggio e segnala eventuali errori.';

  @override
  String get securityExpressionRequired => 'L\'espressione è obbligatoria';

  @override
  String get securityRequests => 'Richieste';

  @override
  String get securityPeriod => 'Intervallo (secondi)';

  @override
  String get securityRateLimitHelp =>
      'Conteggiate per IP del client e per data center. Il blocco dura quanto l\'intervallo.';

  @override
  String get securityAction => 'Azione';

  @override
  String get securityTarget => 'Si applica a';

  @override
  String get securityValue => 'Valore';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Archiviazione';

  @override
  String get devPickAccount =>
      'Scegli prima un account: queste risorse sono a livello di account.';

  @override
  String get devKvNamespaces => 'Namespace KV';

  @override
  String get devD1 => 'Database D1';

  @override
  String get devR2 => 'Bucket R2';

  @override
  String get kvSearchHint => 'Filtra le chiavi';

  @override
  String get kvValue => 'Valore';

  @override
  String get kvExpires => 'Scadenza';

  @override
  String get kvMoreKeys => 'Ci sono altre chiavi — restringi il filtro';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Esegui';

  @override
  String get d1OneStatement => 'Una sola istruzione alla volta';

  @override
  String get d1NoRows => 'Nessuna riga restituita';

  @override
  String get d1DestructiveWarning =>
      'Questa istruzione modifica o elimina dati.';

  @override
  String get d1ConfirmTitle => 'Eseguire un\'istruzione distruttiva?';

  @override
  String get d1ConfirmHint => 'Digita RUN per confermare';

  @override
  String get zoneTrafficSubtitle =>
      'Page Rules, bilanciatori di carico, Waiting Room';

  @override
  String get zoneTlsSubtitle => 'Certificati, nomi host personalizzati, DNSSEC';

  @override
  String get zoneEmailSubtitle =>
      'Regole di instradamento e indirizzi di destinazione';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Bilanciatori di carico';

  @override
  String get trafficWaitingRooms => 'Waiting Room';

  @override
  String get tlsCertificates => 'Pacchetti di certificati';

  @override
  String get tlsCustomHostnames => 'Nomi host personalizzati';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Regole di instradamento';

  @override
  String get emailAddresses => 'Indirizzi di destinazione';

  @override
  String get moreAlerts => 'Avvisi';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tunnel';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Al momento non ci sono connettori attivi';

  @override
  String get ztNoPolicies => 'Nessun criterio per questa applicazione';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonCopy => 'Copia';

  @override
  String get commonCopied => 'Copiato';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonAll => 'Tutti';

  @override
  String get commonContinue => 'Continua';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonRefresh => 'Aggiorna';

  @override
  String get commonNothingHere => 'Non c\'è ancora nulla qui';

  @override
  String get commonLoadMore => 'Carica altri';

  @override
  String get commonDiagnostics => 'Copia dati diagnostici';

  @override
  String get commonUnlock => 'Sblocca';

  @override
  String get onboardWelcomeTitle => 'Gestisci Cloudflare dal tuo telefono';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zone, DNS, cache e tutti i $count endpoint dell\'API. Dal dispositivo non esce nulla, tranne le chiamate a Cloudflare: l\'app non ha altri permessi di rete.';
  }

  @override
  String get authChooseMethod => 'Come vuoi accedere?';

  @override
  String get authApiToken => 'Token API';

  @override
  String get authApiTokenBlurb =>
      'Consigliato. Limitato alle sole autorizzazioni che concedi, revocabile in qualsiasi momento.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Metodo legacy. Accesso senza limiti all\'intero account.';

  @override
  String get authCreateToken => 'Crea un token nella dashboard';

  @override
  String get authManualPermsTitle => 'Aggiungili manualmente';

  @override
  String get authManualPermsBody =>
      'Il formato dei link di Cloudflare non prevede una chiave per queste autorizzazioni, quindi il pulsante qui sopra non può selezionarle. Aggiungile una per una nella sezione Autorizzazioni (Permissions) della pagina appena aperta.';

  @override
  String get authPasteToken => 'Incolla il tuo token API';

  @override
  String get authTokenHint => 'Token di 40 caratteri dalla dashboard';

  @override
  String get authVerify => 'Verifica e continua';

  @override
  String get authVerifying => 'Verifica del token…';

  @override
  String get authTokenValid => 'Token accettato';

  @override
  String get authEmail => 'Indirizzo email dell\'account Cloudflare';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle =>
      'Questa chiave dà accesso completo all\'account';

  @override
  String get authGlobalKeyWarnBody =>
      'Una Global API Key non può essere limitata né per autorizzazioni né per IP. Può leggere e modificare la fatturazione ed eliminare l\'account. Usa un token API, a meno che tu non abbia un motivo preciso per non farlo.';

  @override
  String get authGlobalKeyConfirm => 'Digita UNRESTRICTED per continuare';

  @override
  String get authProfiles => 'Profili';

  @override
  String get authAddProfile => 'Aggiungi profilo';

  @override
  String get authProfileName => 'Nome del profilo';

  @override
  String get authSignOut => 'Rimuovi profilo';

  @override
  String get lockTitle => 'Inserisci il PIN';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'PIN errato';

  @override
  String get lockBiometric => 'Usa l\'impronta digitale';

  @override
  String get lockSetPin => 'Imposta un PIN';

  @override
  String get lockConfirmPin => 'Ripeti il PIN';

  @override
  String get lockPinTooShort => 'Almeno 4 cifre';

  @override
  String get lockPinMismatch => 'I PIN non corrispondono';

  @override
  String get lockEnableBiometric => 'Sblocca con l\'impronta digitale';

  @override
  String get permTitle => 'Autorizzazioni';

  @override
  String get permNotificationAccess => 'Accesso alle notifiche';

  @override
  String permMissing(String permissions) {
    return 'Alle tue credenziali manca: $permissions';
  }

  @override
  String get permFixCta => 'Crea un token con questa autorizzazione';

  @override
  String get zonesTitle => 'Zone';

  @override
  String get zonesSearchHint => 'Cerca zone';

  @override
  String get zonesEmpty => 'Nessuna zona in questo account';

  @override
  String get zoneStatusActive => 'Attiva';

  @override
  String get zonePlan => 'Piano';

  @override
  String get zoneNameservers => 'Nameserver';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count record',
      one: '1 record',
      zero: 'Nessun record',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Aggiungi record';

  @override
  String get dnsEditRecord => 'Modifica record';

  @override
  String get dnsType => 'Tipo';

  @override
  String get dnsName => 'Nome';

  @override
  String get dnsContent => 'Contenuto';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Automatico';

  @override
  String get dnsProxied => 'Tramite proxy Cloudflare';

  @override
  String get dnsPriority => 'Priorità';

  @override
  String get dnsComment => 'Commento';

  @override
  String get dnsTags => 'Tag';

  @override
  String dnsDeleteConfirm(String name) {
    return 'Eliminare $name?';
  }

  @override
  String get dnsExport => 'Esporta come file BIND';

  @override
  String get dnsSearchHint => 'Cerca record';

  @override
  String get cachePurgeTitle => 'Svuota cache';

  @override
  String get cachePurgeEverything => 'Svuota tutto';

  @override
  String get cachePurgeEverythingWarn =>
      'Questa operazione elimina tutti i file in cache di questa zona e aumenterà temporaneamente il carico sul server di origine.';

  @override
  String get cachePurgeConfirm => 'Digita PURGE per confermare';

  @override
  String get cachePurgeByUrl => 'Svuota per URL';

  @override
  String get cachePurged => 'Cache svuotata';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Host';

  @override
  String get purgeByPrefix => 'Prefisso';

  @override
  String get purgeByTag => 'Tag';

  @override
  String get purgeTargets => 'Cosa svuotare';

  @override
  String get purgeOnePerLine => 'Uno per riga';

  @override
  String get analyticsTitle => 'Analisi';

  @override
  String get analyticsRequests => 'Richieste';

  @override
  String get analyticsCached => 'Dalla cache';

  @override
  String get analyticsBandwidth => 'Larghezza di banda';

  @override
  String get analyticsUniques => 'Visitatori';

  @override
  String get analyticsCacheRatio => 'Tasso di cache hit';

  @override
  String get analyticsThreats => 'Minacce';

  @override
  String get analyticsRequestsOverTime => 'Richieste nel tempo';

  @override
  String get analyticsStatusCodes => 'Codici di stato';

  @override
  String get analyticsTopCountries => 'Paesi principali';

  @override
  String get analyticsContentTypes => 'Tipi di contenuto';

  @override
  String get analyticsSecurityEvents => 'Eventi di sicurezza';

  @override
  String get analyticsNoData => 'Nessun traffico in questo periodo';

  @override
  String get zoneAnalyticsSubtitle => 'Traffico, tasso di cache hit, minacce';

  @override
  String get zoneDnsSubtitle => 'Record, stato del proxy, esportazione BIND';

  @override
  String get zonePurgeSubtitle => 'Per URL, host, prefisso, tag — o tutto';

  @override
  String get explorerTitle => 'Esplora API';

  @override
  String explorerSubtitle(int count) {
    return '$count endpoint';
  }

  @override
  String get explorerSearchHint => 'Cerca endpoint';

  @override
  String get explorerSend => 'Invia richiesta';

  @override
  String get explorerDeprecated => 'Deprecato';

  @override
  String get explorerRequired => 'Obbligatorio';

  @override
  String get explorerNoParams => 'Questo endpoint non accetta parametri';

  @override
  String get explorerBody => 'Corpo della richiesta';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsDynamicColor => 'Abbina allo sfondo';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Se disattivato, l\'app usa la propria tavolozza.';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsSecurity => 'Sicurezza';

  @override
  String get settingsAutoLock => 'Blocco automatico';

  @override
  String get settingsAutoLockImmediate => 'Immediatamente';

  @override
  String get settingsAutoLockNever => 'Mai';

  @override
  String get settingsLockNow => 'Blocca ora';

  @override
  String get settingsBlockScreenshots => 'Blocca gli screenshot';

  @override
  String get settingsBlockScreenshotsHint =>
      'Nasconde l\'app dagli screenshot, dalle registrazioni dello schermo e dall\'anteprima delle app recenti.';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsPrivacyBody =>
      'Le credenziali sono crittografate con AES-GCM tramite una chiave derivata dal tuo PIN e restano solo su questo dispositivo. Vengono inviate esclusivamente ad api.cloudflare.com. Nessuna telemetria.';

  @override
  String get settingsWipe => 'Cancella tutto';

  @override
  String get settingsWipeConfirm =>
      'Questa operazione elimina tutti i profili e le credenziali salvati su questo dispositivo.';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get errNetworkOffline => 'Nessuna connessione internet';

  @override
  String get errNetworkTimeout => 'Cloudflare non ha risposto in tempo';

  @override
  String get errAuth => 'Cloudflare ha rifiutato queste credenziali';

  @override
  String get errRateLimited => 'Troppe richieste — nuovo tentativo a breve';

  @override
  String get errNotFound => 'Non trovato';

  @override
  String get errServer => 'Cloudflare ha restituito un errore del server';

  @override
  String get errUnknown => 'Si è verificato un errore';
}
