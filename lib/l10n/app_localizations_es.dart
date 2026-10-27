// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Inicio';

  @override
  String get navZones => 'Zonas';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navSecurity => 'Seguridad';

  @override
  String get navDeveloper => 'Desarrollo';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Más';

  @override
  String get scopeAccount => 'Cuenta';

  @override
  String get scopeZone => 'Zona';

  @override
  String get scopeAllAccounts => 'Todas las cuentas';

  @override
  String get scopePickZone => 'Elegir zona';

  @override
  String get scopePickAccount => 'Elegir cuenta';

  @override
  String get scopeMoreZones => 'Hay más zonas — escribe para buscar';

  @override
  String get securityIpAccess => 'Acceso por IP';

  @override
  String get securityPickZone =>
      'Elige primero una zona: las reglas de seguridad son por zona.';

  @override
  String get securityNoRules => 'Todavía no hay reglas en esta fase';

  @override
  String get securityNewIpRule => 'Nueva regla de acceso por IP';

  @override
  String get securityNewCustomRule => 'Nueva regla personalizada';

  @override
  String get securityNewRateLimitRule => 'Nueva regla de límite de tasa';

  @override
  String get securityExpression => 'Expresión';

  @override
  String get securityExpressionHelp =>
      'Sintaxis de Ruleset Engine. Cloudflare la valida al guardar y dice qué está mal.';

  @override
  String get securityExpressionRequired => 'Hace falta una expresión';

  @override
  String get securityRequests => 'Solicitudes';

  @override
  String get securityPeriod => 'Por segundos';

  @override
  String get securityRateLimitHelp =>
      'Se cuenta por IP de cliente y centro de datos. El bloqueo dura lo mismo que el periodo.';

  @override
  String get securityAction => 'Acción';

  @override
  String get securityTarget => 'Se aplica a';

  @override
  String get securityValue => 'Valor';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Almacenamiento';

  @override
  String get devPickAccount =>
      'Elige primero una cuenta: esto vive a nivel de cuenta.';

  @override
  String get devKvNamespaces => 'Espacios de nombres KV';

  @override
  String get devD1 => 'Bases de datos D1';

  @override
  String get devR2 => 'Buckets de R2';

  @override
  String get kvSearchHint => 'Filtrar claves';

  @override
  String get kvValue => 'Valor';

  @override
  String get kvExpires => 'Caduca';

  @override
  String get kvMoreKeys => 'Hay más claves: afina el filtro';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => 'Ejecutar';

  @override
  String get d1OneStatement => 'Una sentencia cada vez';

  @override
  String get d1NoRows => 'No se devolvieron filas';

  @override
  String get d1DestructiveWarning => 'Esta sentencia modifica o elimina datos.';

  @override
  String get d1ConfirmTitle => '¿Ejecutar una sentencia destructiva?';

  @override
  String get d1ConfirmHint => 'Escribe RUN para confirmar';

  @override
  String get zoneTrafficSubtitle =>
      'Page Rules, balanceadores, salas de espera';

  @override
  String get zoneTlsSubtitle => 'Certificados, nombres de host propios, DNSSEC';

  @override
  String get zoneEmailSubtitle => 'Reglas de reenvío y direcciones de destino';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => 'Balanceadores de carga';

  @override
  String get trafficWaitingRooms => 'Salas de espera';

  @override
  String get tlsCertificates => 'Paquetes de certificados';

  @override
  String get tlsCustomHostnames => 'Nombres de host propios';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => 'Reglas de reenvío';

  @override
  String get emailAddresses => 'Direcciones de destino';

  @override
  String get moreAlerts => 'Alertas';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => 'Túneles';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Ahora mismo no hay ningún conector en marcha';

  @override
  String get ztNoPolicies => 'Esta aplicación no tiene políticas';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonCopied => 'Copiado';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonAll => 'Todo';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonRefresh => 'Actualizar';

  @override
  String get commonNothingHere => 'Aquí todavía no hay nada';

  @override
  String get commonLoadMore => 'Cargar más';

  @override
  String get commonDiagnostics => 'Copiar diagnóstico';

  @override
  String get commonUnlock => 'Desbloquear';

  @override
  String get onboardWelcomeTitle => 'Gestiona Cloudflare desde el móvil';

  @override
  String onboardWelcomeBody(int count) {
    return 'Zonas, DNS, caché y los $count endpoints de la API. Del dispositivo no sale nada salvo las llamadas a Cloudflare: la app no tiene permiso de internet para nada más.';
  }

  @override
  String get authChooseMethod => '¿Cómo quieres iniciar sesión?';

  @override
  String get authApiToken => 'Token de API';

  @override
  String get authApiTokenBlurb =>
      'Recomendado. Limitado exactamente a los permisos que concedas y revocable en cualquier momento.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Método antiguo. Acceso sin restricciones a toda la cuenta.';

  @override
  String get authCreateToken => 'Crear un token en el panel';

  @override
  String get authManualPermsTitle => 'Añade estos a mano';

  @override
  String get authManualPermsBody =>
      'El formato de enlace de Cloudflare no tiene clave para estos permisos, así que el botón de arriba no puede marcarlos. Añade cada uno en la sección Permissions de la página que se acaba de abrir.';

  @override
  String get authPasteToken => 'Pega tu token de API';

  @override
  String get authTokenHint => 'Token de 40 caracteres del panel';

  @override
  String get authVerify => 'Verificar y continuar';

  @override
  String get authVerifying => 'Comprobando el token…';

  @override
  String get authTokenValid => 'Token aceptado';

  @override
  String get authEmail => 'Correo de la cuenta de Cloudflare';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Esto concede acceso total a la cuenta';

  @override
  String get authGlobalKeyWarnBody =>
      'Una Global API Key no se puede limitar por permisos ni por IP. Puede leer y cambiar la facturación, y eliminar la cuenta. Usa un token de API salvo que tengas un motivo concreto.';

  @override
  String get authGlobalKeyConfirm => 'Escribe UNRESTRICTED para continuar';

  @override
  String get authProfiles => 'Perfiles';

  @override
  String get authAddProfile => 'Añadir perfil';

  @override
  String get authProfileName => 'Nombre del perfil';

  @override
  String get authSignOut => 'Eliminar perfil';

  @override
  String get lockTitle => 'Introduce tu PIN';

  @override
  String get lockPin => 'PIN';

  @override
  String get lockWrongPin => 'PIN incorrecto';

  @override
  String get lockBiometric => 'Usar huella';

  @override
  String get lockSetPin => 'Elige un PIN';

  @override
  String get lockConfirmPin => 'Repite el PIN';

  @override
  String get lockPinTooShort => 'Al menos 4 dígitos';

  @override
  String get lockPinMismatch => 'Los PIN no coinciden';

  @override
  String get lockEnableBiometric => 'Desbloquear con huella';

  @override
  String get permTitle => 'Permisos';

  @override
  String get permNotificationAccess => 'Acceso a notificaciones';

  @override
  String permMissing(String permissions) {
    return 'A tus credenciales les falta: $permissions';
  }

  @override
  String get permFixCta => 'Crear un token con ese permiso';

  @override
  String get zonesTitle => 'Zonas';

  @override
  String get zonesSearchHint => 'Buscar zonas';

  @override
  String get zonesEmpty => 'No hay zonas en esta cuenta';

  @override
  String get zoneStatusActive => 'Activa';

  @override
  String get zonePlan => 'Plan';

  @override
  String get zoneNameservers => 'Servidores de nombres';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
      zero: 'Sin registros',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Añadir registro';

  @override
  String get dnsEditRecord => 'Editar registro';

  @override
  String get dnsType => 'Tipo';

  @override
  String get dnsName => 'Nombre';

  @override
  String get dnsContent => 'Contenido';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Automático';

  @override
  String get dnsProxied => 'Con proxy de Cloudflare';

  @override
  String get dnsPriority => 'Prioridad';

  @override
  String get dnsComment => 'Comentario';

  @override
  String get dnsTags => 'Etiquetas';

  @override
  String dnsDeleteConfirm(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get dnsExport => 'Exportar como archivo BIND';

  @override
  String get dnsSearchHint => 'Buscar registros';

  @override
  String get cachePurgeTitle => 'Purgar caché';

  @override
  String get cachePurgeEverything => 'Purgar todo';

  @override
  String get cachePurgeEverythingWarn =>
      'Descarta todos los archivos en caché de esta zona y aumentará brevemente la carga del origen.';

  @override
  String get cachePurgeConfirm => 'Escribe PURGE para confirmar';

  @override
  String get cachePurgeByUrl => 'Purgar por URL';

  @override
  String get cachePurged => 'Caché purgada';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Host';

  @override
  String get purgeByPrefix => 'Prefijo';

  @override
  String get purgeByTag => 'Etiqueta';

  @override
  String get purgeTargets => 'Qué purgar';

  @override
  String get purgeOnePerLine => 'Uno por línea';

  @override
  String get analyticsTitle => 'Analítica';

  @override
  String get analyticsRequests => 'Solicitudes';

  @override
  String get analyticsCached => 'Desde caché';

  @override
  String get analyticsBandwidth => 'Ancho de banda';

  @override
  String get analyticsUniques => 'Visitantes';

  @override
  String get analyticsCacheRatio => 'Aciertos de caché';

  @override
  String get analyticsThreats => 'Amenazas';

  @override
  String get analyticsRequestsOverTime => 'Solicitudes en el tiempo';

  @override
  String get analyticsStatusCodes => 'Códigos de estado';

  @override
  String get analyticsTopCountries => 'Países';

  @override
  String get analyticsContentTypes => 'Tipos de contenido';

  @override
  String get analyticsSecurityEvents => 'Eventos de seguridad';

  @override
  String get analyticsNoData => 'No hubo tráfico en este periodo';

  @override
  String get zoneAnalyticsSubtitle => 'Tráfico, aciertos de caché, amenazas';

  @override
  String get zoneDnsSubtitle => 'Registros, estado del proxy, exportación BIND';

  @override
  String get zonePurgeSubtitle => 'Por URL, host, prefijo, etiqueta — o todo';

  @override
  String get explorerTitle => 'Explorador de la API';

  @override
  String explorerSubtitle(int count) {
    return '$count endpoints';
  }

  @override
  String get explorerSearchHint => 'Buscar endpoints';

  @override
  String get explorerSend => 'Enviar solicitud';

  @override
  String get explorerDeprecated => 'Obsoleto';

  @override
  String get explorerRequired => 'Obligatorio';

  @override
  String get explorerNoParams => 'Este endpoint no admite parámetros';

  @override
  String get explorerBody => 'Cuerpo de la solicitud';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsDynamicColor => 'Combinar con mi fondo de pantalla';

  @override
  String get settingsDynamicColorHint =>
      'Material You. Desactivado se usa la paleta propia de la app.';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsAutoLock => 'Bloqueo automático';

  @override
  String get settingsAutoLockImmediate => 'Inmediato';

  @override
  String get settingsAutoLockNever => 'Nunca';

  @override
  String get settingsLockNow => 'Bloquear ahora';

  @override
  String get settingsBlockScreenshots => 'Bloquear capturas de pantalla';

  @override
  String get settingsBlockScreenshotsHint =>
      'Oculta la app de las capturas, la grabación de pantalla y la vista de apps recientes.';

  @override
  String get settingsPrivacyTitle => 'Privacidad';

  @override
  String get settingsPrivacyBody =>
      'Las credenciales se cifran con AES-GCM usando una clave derivada de tu PIN y se guardan solo en este dispositivo. Se envían a api.cloudflare.com y a ningún otro sitio. No hay telemetría.';

  @override
  String get settingsWipe => 'Borrarlo todo';

  @override
  String get settingsWipeConfirm =>
      'Elimina de este dispositivo todos los perfiles y credenciales guardados.';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get errNetworkOffline => 'Sin conexión a internet';

  @override
  String get errNetworkTimeout => 'Cloudflare no respondió a tiempo';

  @override
  String get errAuth => 'Cloudflare rechazó esta credencial';

  @override
  String get errRateLimited =>
      'Demasiadas solicitudes: se reintentará en breve';

  @override
  String get errNotFound => 'No encontrado';

  @override
  String get errServer => 'Cloudflare devolvió un error de servidor';

  @override
  String get errUnknown => 'Algo ha salido mal';

  @override
  String dsTypeToConfirm(String word) {
    return 'Escribe $word para confirmar';
  }

  @override
  String get pulseTitle => 'Pulso';

  @override
  String get pulseRequests24h => 'Solicitudes · últimas 24 horas';

  @override
  String get pulseCredentialProblem => 'Problema con el token';

  @override
  String get pulseAnalyticsUnavailable =>
      'Para ver el tráfico, el token necesita Zone Analytics: Read.';

  @override
  String get pulseAttention => 'Requiere atención';

  @override
  String get pulseAllClear => 'Ahora mismo no hay nada pendiente.';

  @override
  String pulseTunnelDown(String name) {
    return 'El túnel $name está caído';
  }

  @override
  String pulseTunnelDegraded(String name) {
    return 'El túnel $name está degradado';
  }

  @override
  String get pulseOpenTunnels => 'Abrir túneles';

  @override
  String pulseZoneNotActive(String name, String status) {
    return '$name: $status';
  }

  @override
  String get pulseZoneNotActiveBody =>
      'Cloudflare no la sirve hasta que los servidores de nombres apunten aquí.';

  @override
  String get pulseOpenZone => 'Abrir zona';

  @override
  String pulseAllZones(int count) {
    return 'Todas ($count)';
  }

  @override
  String get zoneQuickActions => 'Acciones rápidas';

  @override
  String get zoneUnderAttack => 'Bajo ataque';

  @override
  String get zoneUnderAttackCaption => 'Verificar a todos';

  @override
  String get zoneUnderAttackNote =>
      'Cada visitante ve una página de verificación durante unos segundos. Actívalo durante un ataque y desactívalo después.';

  @override
  String get zoneUnderAttackOffNote =>
      'La página de verificación desaparece y el nivel de seguridad vuelve al anterior.';

  @override
  String get zoneStateOn => 'Activado';

  @override
  String get zoneDevMode => 'Modo dev';

  @override
  String get zoneDevModeCaption => 'Sin caché 3 h';

  @override
  String zoneDevModeLeft(String time) {
    return 'quedan $time';
  }

  @override
  String get zoneDevModeNote =>
      'Cloudflare deja de almacenar en caché durante tres horas y luego lo desactiva solo. Mientras tanto, tu origen recibe toda la carga.';

  @override
  String get zonePurgeCaption => 'URL o todo';

  @override
  String get zoneLast24h => 'Últimas 24 horas';

  @override
  String get zoneManage => 'Gestionar';

  @override
  String get zoneSecuritySubtitle =>
      'Reglas WAF, limitación de tasa, acceso por IP';

  @override
  String get zoneTlsTitle => 'SSL/TLS';

  @override
  String get zoneEmailTitle => 'Correo';

  @override
  String get zoneOpenDashboard => 'Abrir en el panel de Cloudflare';

  @override
  String get zonePaused => 'En pausa';

  @override
  String zoneNotActiveTitle(String status) {
    return 'La zona está $status';
  }

  @override
  String get zoneNotActiveBody =>
      'Configura estos servidores de nombres en tu registrador. Cloudflare empezará a servir la zona en cuanto los vea.';

  @override
  String get zoneCopyNameservers => 'Copiar servidores de nombres';

  @override
  String zoneSslWeakTitle(String mode) {
    return 'SSL está en $mode';
  }

  @override
  String get zoneSslWeakBody =>
      'El tramo entre Cloudflare y tu origen no se verifica, así que puede leerse o alterarse.';

  @override
  String get zoneSslUseStrict => 'Cambiar a Full (strict)';

  @override
  String get zoneSslStrictNote =>
      'Tu origen debe presentar un certificado válido (sirve uno gratuito de Cloudflare Origin CA); si no, los visitantes verán el error 526.';

  @override
  String get zoneHttpsOffTitle => 'Aún se sirve HTTP sin cifrar';

  @override
  String get zoneHttpsOffBody =>
      'Quien escriba http:// se queda en una conexión sin cifrar.';

  @override
  String get zoneTurnOn => 'Activar';

  @override
  String get zoneApply => 'Aplicar';

  @override
  String zoneChangeTitle(String setting) {
    return '¿Cambiar $setting?';
  }

  @override
  String pulseAnalyticsPartial(int count) {
    return 'Zonas sin acceso a analíticas con este token: $count';
  }

  @override
  String get dnsStateProxied => 'Con proxy';

  @override
  String get dnsStateDnsOnly => 'Solo DNS';

  @override
  String dnsProxyOnTitle(String name) {
    return '¿Pasar $name por el proxy de Cloudflare?';
  }

  @override
  String dnsProxyOffTitle(String name) {
    return '¿Dejar de usar el proxy para $name?';
  }

  @override
  String get dnsProxyOnNote =>
      'El tráfico pasa por Cloudflare: con caché, protegido y con la dirección del origen oculta. Mientras esté activo, Cloudflare gestiona el TTL.';

  @override
  String get dnsProxyOffNote =>
      'Los visitantes se conectan directamente a tu origen: su IP queda pública y la caché y el firewall de Cloudflare dejan de aplicarse a este nombre.';

  @override
  String get dnsEmptyTitle => 'Aún no hay registros';

  @override
  String get dnsEmptyBody =>
      'Un registro que añadas aquí estará activo en los servidores de nombres de Cloudflare en segundos.';

  @override
  String get moreProducts => 'Productos';

  @override
  String get moreApp => 'Aplicación';

  @override
  String get moreAlertsSubtitle =>
      'Políticas de notificación, alertas recientes';

  @override
  String get moreSettingsSubtitle => 'Tema, idioma, perfiles, bloqueo';

  @override
  String get settingsAddProfileHint =>
      'Otra cuenta u otro token con distintos permisos';

  @override
  String get settingsBiometricHint =>
      'La clave del almacén se cifra con una clave del Keystore que solo se abre tras verificar la huella.';

  @override
  String get settingsBiometricUnavailable =>
      'No hay hardware biométrico disponible';

  @override
  String get settingsPrivacyHeadline =>
      'Del teléfono solo salen llamadas a la API';

  @override
  String get settingsAboutBody =>
      'Código abierto, Apache-2.0. Sin relación con Cloudflare, Inc.';

  @override
  String get securityDeleteRule => '¿Eliminar esta regla?';

  @override
  String get securityNoIpRules => 'No hay reglas de acceso por IP';

  @override
  String get securityEmptyCustomBody =>
      'Bloquea, verifica u omite las solicitudes que coincidan con una expresión: un país, una ruta, un user agent.';

  @override
  String get securityEmptyRateLimitBody =>
      'Limita cuántas solicitudes puede hacer un cliente en un periodo, por IP y centro de datos.';

  @override
  String get securityEmptyIpBody =>
      'Permite, bloquea o verifica una IP, un rango, un país o un ASN en toda la zona.';

  @override
  String get devNoWorkers => 'No hay Workers en esta cuenta';

  @override
  String get devNoPages => 'No hay proyectos de Pages en esta cuenta';

  @override
  String get moreAlertHistory => 'Alertas recientes';

  @override
  String get ztNoTunnels => 'No hay túneles en esta cuenta';

  @override
  String get ztNoApps => 'No hay aplicaciones de Access';

  @override
  String get ztNoGatewayRules => 'No hay reglas de Gateway';

  @override
  String ztConnectors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conectores',
      one: '1 conector',
    );
    return '$_temp0';
  }

  @override
  String get onboardTokenBody =>
      'Cloudflare se abre con los permisos correctos ya marcados. Crea el token y pégalo aquí.';

  @override
  String get onboardPresetFull => 'Lectura y escritura';

  @override
  String get onboardPresetDns => 'Solo DNS';

  @override
  String get onboardPresetRead => 'Solo lectura';

  @override
  String get onboardPinBody =>
      'El PIN cifra tu credencial en este dispositivo. Nunca se envía a ningún sitio y no se puede recuperar: si lo olvidas, tendrás que empezar de nuevo.';

  @override
  String get authPasteFirst => 'Pega primero un token';

  @override
  String get authProfileNameHint => 'Trabajo, cliente, personal…';

  @override
  String get commonRecommended => 'Recomendado';
}
