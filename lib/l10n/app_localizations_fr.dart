// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LFr extends L {
  LFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Accueil';

  @override
  String get navZones => 'Zones';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Réglages';

  @override
  String get navSecurity => 'Sécurité';

  @override
  String get navDeveloper => 'Développement';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Plus';

  @override
  String get scopeAccount => 'Compte';

  @override
  String get scopeZone => 'Zone';

  @override
  String get scopeAllAccounts => 'Tous les comptes';

  @override
  String get scopePickZone => 'Choisir une zone';

  @override
  String get scopePickAccount => 'Choisir un compte';

  @override
  String get scopeMoreZones => 'Il y a d\'autres zones — tapez pour chercher';

  @override
  String get securityIpAccess => 'Accès par IP';

  @override
  String get securityPickZone =>
      'Choisissez d\'abord une zone : les règles de sécurité sont par zone.';

  @override
  String get securityNoRules => 'Aucune règle dans cette phase pour l\'instant';

  @override
  String get securityNewIpRule => 'Nouvelle règle d\'accès par IP';

  @override
  String get securityAction => 'Action';

  @override
  String get securityTarget => 'S\'applique à';

  @override
  String get securityValue => 'Valeur';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Stockage';

  @override
  String get devPickAccount =>
      'Choisissez d\'abord un compte : ces ressources sont au niveau du compte.';

  @override
  String get devKvNamespaces => 'Espaces de noms KV';

  @override
  String get devD1 => 'Bases D1';

  @override
  String get devR2 => 'Buckets R2';

  @override
  String get kvSearchHint => 'Filtrer les clés';

  @override
  String get kvValue => 'Valeur';

  @override
  String get kvExpires => 'Expire';

  @override
  String get kvMoreKeys => 'Il y a d\'autres clés : affinez le filtre';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Exécuter';

  @override
  String get d1OneStatement => 'Une instruction à la fois';

  @override
  String get d1NoRows => 'Aucune ligne renvoyée';

  @override
  String get d1DestructiveWarning =>
      'Cette instruction modifie ou supprime des données.';

  @override
  String get d1ConfirmTitle => 'Exécuter une instruction destructive ?';

  @override
  String get d1ConfirmHint => 'Tapez RUN pour confirmer';

  @override
  String get zoneTrafficSubtitle =>
      'Page Rules, équilibreurs de charge, salles d\'attente';

  @override
  String get zoneTlsSubtitle =>
      'Certificats, noms d\'hôte personnalisés, DNSSEC';

  @override
  String get zoneEmailSubtitle =>
      'Règles de routage et adresses de destination';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Équilibreurs de charge';

  @override
  String get trafficWaitingRooms => 'Salles d\'attente';

  @override
  String get tlsCertificates => 'Packs de certificats';

  @override
  String get tlsCustomHostnames => 'Noms d\'hôte personnalisés';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Règles de routage';

  @override
  String get emailAddresses => 'Adresses de destination';

  @override
  String get moreAlerts => 'Alertes';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Tunnels';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Aucun connecteur ne tourne pour le moment';

  @override
  String get ztNoPolicies => 'Cette application n\'a aucune politique';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonCopy => 'Copier';

  @override
  String get commonCopied => 'Copié';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonAll => 'Tout';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonRefresh => 'Actualiser';

  @override
  String get commonNothingHere => 'Rien ici pour l\'instant';

  @override
  String get commonLoadMore => 'Charger plus';

  @override
  String get commonDiagnostics => 'Copier le diagnostic';

  @override
  String get commonUnlock => 'Déverrouiller';

  @override
  String get onboardWelcomeTitle => 'Gérez Cloudflare depuis votre téléphone';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zones, DNS, cache et les $count points de terminaison de l\'API. Rien ne quitte l\'appareil hormis les appels à Cloudflare — l\'application n\'a aucune autre permission réseau.';
  }

  @override
  String get authChooseMethod => 'Comment voulez-vous vous connecter ?';

  @override
  String get authApiToken => 'Jeton d\'API';

  @override
  String get authApiTokenBlurb =>
      'Recommandé. Limité exactement aux permissions accordées et révocable à tout moment.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Ancienne méthode. Accès sans restriction à tout le compte.';

  @override
  String get authCreateToken => 'Créer un jeton dans le tableau de bord';

  @override
  String get authManualPermsTitle => 'À ajouter à la main';

  @override
  String get authManualPermsBody =>
      'Le format de lien de Cloudflare n\'a pas de clé pour ces permissions, le bouton ci-dessus ne peut donc pas les cocher. Ajoutez-les une par une dans la section Permissions de la page qui vient de s\'ouvrir.';

  @override
  String get authPasteToken => 'Collez votre jeton d\'API';

  @override
  String get authTokenHint => 'Jeton de 40 caractères issu du tableau de bord';

  @override
  String get authVerify => 'Vérifier et continuer';

  @override
  String get authVerifying => 'Vérification du jeton…';

  @override
  String get authTokenValid => 'Jeton accepté';

  @override
  String get authEmail => 'E-mail du compte Cloudflare';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Cela donne un accès total au compte';

  @override
  String get authGlobalKeyWarnBody =>
      'Une Global API Key ne peut être limitée ni par permissions ni par IP. Elle peut lire et modifier la facturation, et supprimer le compte. Utilisez un jeton d\'API sauf raison précise.';

  @override
  String get authGlobalKeyConfirm => 'Tapez UNRESTRICTED pour continuer';

  @override
  String get authProfiles => 'Profils';

  @override
  String get authAddProfile => 'Ajouter un profil';

  @override
  String get authProfileName => 'Nom du profil';

  @override
  String get authSignOut => 'Supprimer le profil';

  @override
  String get lockTitle => 'Saisissez votre code PIN';

  @override
  String get lockPin => 'Code PIN';

  @override
  String get lockWrongPin => 'Code PIN incorrect';

  @override
  String get lockBiometric => 'Utiliser l\'empreinte';

  @override
  String get lockSetPin => 'Définissez un code PIN';

  @override
  String get lockConfirmPin => 'Répétez le code PIN';

  @override
  String get lockPinTooShort => 'Au moins 4 chiffres';

  @override
  String get lockPinMismatch => 'Les codes PIN ne correspondent pas';

  @override
  String get lockEnableBiometric => 'Déverrouiller par empreinte';

  @override
  String get permTitle => 'Permissions';

  @override
  String get permNotificationAccess => 'Accès aux notifications';

  @override
  String permMissing(String permissions) {
    return 'Il manque à vos identifiants : $permissions';
  }

  @override
  String get permFixCta => 'Créer un jeton avec cette permission';

  @override
  String get zonesTitle => 'Zones';

  @override
  String get zonesSearchHint => 'Rechercher des zones';

  @override
  String get zonesEmpty => 'Aucune zone sur ce compte';

  @override
  String get zoneStatusActive => 'Active';

  @override
  String get zonePlan => 'Formule';

  @override
  String get zoneNameservers => 'Serveurs de noms';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrements',
      one: '1 enregistrement',
      zero: 'Aucun enregistrement',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Ajouter un enregistrement';

  @override
  String get dnsEditRecord => 'Modifier l\'enregistrement';

  @override
  String get dnsType => 'Type';

  @override
  String get dnsName => 'Nom';

  @override
  String get dnsContent => 'Contenu';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Auto';

  @override
  String get dnsProxied => 'Passe par le proxy Cloudflare';

  @override
  String get dnsPriority => 'Priorité';

  @override
  String get dnsComment => 'Commentaire';

  @override
  String get dnsTags => 'Étiquettes';

  @override
  String dnsDeleteConfirm(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get dnsExport => 'Exporter en fichier BIND';

  @override
  String get dnsSearchHint => 'Rechercher des enregistrements';

  @override
  String get cachePurgeTitle => 'Purger le cache';

  @override
  String get cachePurgeEverything => 'Tout purger';

  @override
  String get cachePurgeEverythingWarn =>
      'Supprime tous les fichiers en cache de cette zone et augmentera brièvement la charge sur l\'origine.';

  @override
  String get cachePurgeConfirm => 'Tapez PURGE pour confirmer';

  @override
  String get cachePurgeByUrl => 'Purger par URL';

  @override
  String get cachePurged => 'Cache purgé';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Hôte';

  @override
  String get purgeByPrefix => 'Préfixe';

  @override
  String get purgeByTag => 'Étiquette';

  @override
  String get purgeTargets => 'Quoi purger';

  @override
  String get purgeOnePerLine => 'Un par ligne';

  @override
  String get analyticsTitle => 'Analytique';

  @override
  String get analyticsRequests => 'Requêtes';

  @override
  String get analyticsCached => 'Depuis le cache';

  @override
  String get analyticsBandwidth => 'Bande passante';

  @override
  String get analyticsUniques => 'Visiteurs';

  @override
  String get analyticsCacheRatio => 'Taux de cache';

  @override
  String get analyticsThreats => 'Menaces';

  @override
  String get analyticsRequestsOverTime => 'Requêtes dans le temps';

  @override
  String get analyticsStatusCodes => 'Codes de statut';

  @override
  String get analyticsTopCountries => 'Pays';

  @override
  String get analyticsContentTypes => 'Types de contenu';

  @override
  String get analyticsSecurityEvents => 'Événements de sécurité';

  @override
  String get analyticsNoData => 'Aucun trafic sur cette période';

  @override
  String get zoneAnalyticsSubtitle => 'Trafic, taux de cache, menaces';

  @override
  String get zoneDnsSubtitle => 'Enregistrements, statut du proxy, export BIND';

  @override
  String get zonePurgeSubtitle => 'Par URL, hôte, préfixe, étiquette — ou tout';

  @override
  String get explorerTitle => 'Explorateur d\'API';

  @override
  String explorerSubtitle(int count) {
    return '$count points de terminaison';
  }

  @override
  String get explorerSearchHint => 'Rechercher un point de terminaison';

  @override
  String get explorerSend => 'Envoyer la requête';

  @override
  String get explorerDeprecated => 'Obsolète';

  @override
  String get explorerRequired => 'Obligatoire';

  @override
  String get explorerNoParams =>
      'Ce point de terminaison n\'accepte aucun paramètre';

  @override
  String get explorerBody => 'Corps de la requête';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsDynamicColor => 'S\'accorder à mon fond d\'écran';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Désactivé, l\'application utilise sa propre palette.';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsAutoLock => 'Verrouillage automatique';

  @override
  String get settingsAutoLockImmediate => 'Immédiat';

  @override
  String get settingsAutoLockNever => 'Jamais';

  @override
  String get settingsLockNow => 'Verrouiller maintenant';

  @override
  String get settingsBlockScreenshots => 'Bloquer les captures d\'écran';

  @override
  String get settingsBlockScreenshotsHint =>
      'Masque l\'application dans les captures, l\'enregistrement d\'écran et l\'aperçu des applis récentes.';

  @override
  String get settingsPrivacyTitle => 'Confidentialité';

  @override
  String get settingsPrivacyBody =>
      'Les identifiants sont chiffrés en AES-GCM avec une clé dérivée de votre code PIN et conservés uniquement sur cet appareil. Ils ne sont envoyés qu\'à api.cloudflare.com. Aucune télémétrie.';

  @override
  String get settingsWipe => 'Tout effacer';

  @override
  String get settingsWipeConfirm =>
      'Supprime de cet appareil tous les profils et identifiants enregistrés.';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get errNetworkOffline => 'Pas de connexion internet';

  @override
  String get errNetworkTimeout => 'Cloudflare n\'a pas répondu à temps';

  @override
  String get errAuth => 'Cloudflare a rejeté cet identifiant';

  @override
  String get errRateLimited => 'Trop de requêtes — nouvelle tentative sous peu';

  @override
  String get errNotFound => 'Introuvable';

  @override
  String get errServer => 'Cloudflare a renvoyé une erreur serveur';

  @override
  String get errUnknown => 'Une erreur est survenue';
}
