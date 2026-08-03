// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LRu extends L {
  LRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => 'Главная';

  @override
  String get navZones => 'Зоны';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navSecurity => 'Защита';

  @override
  String get navDeveloper => 'Разработка';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => 'Ещё';

  @override
  String get securityIpAccess => 'IP-доступ';

  @override
  String get securityPickZone =>
      'Сначала выберите зону — правила защиты задаются на зону.';

  @override
  String get securityNoRules => 'В этой фазе правил пока нет';

  @override
  String get securityNewIpRule => 'Новое IP-правило';

  @override
  String get securityAction => 'Действие';

  @override
  String get securityTarget => 'Применять к';

  @override
  String get securityValue => 'Значение';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => 'Хранилища';

  @override
  String get devPickAccount =>
      'Сначала выберите аккаунт — это ресурсы уровня аккаунта.';

  @override
  String get devKvNamespaces => 'Пространства KV';

  @override
  String get devD1 => 'Базы D1';

  @override
  String get devR2 => 'Бакеты R2';

  @override
  String get ztTunnels => 'Туннели';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => 'Сейчас ни один коннектор не запущен';

  @override
  String get ztNoPolicies => 'У этого приложения нет политик';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonCopy => 'Скопировать';

  @override
  String get commonCopied => 'Скопировано';

  @override
  String get commonSearch => 'Поиск';

  @override
  String get commonAll => 'Все';

  @override
  String get commonContinue => 'Дальше';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonEdit => 'Изменить';

  @override
  String get commonRefresh => 'Обновить';

  @override
  String get commonNothingHere => 'Пока пусто';

  @override
  String get commonLoadMore => 'Показать ещё';

  @override
  String get commonDiagnostics => 'Скопировать диагностику';

  @override
  String get commonUnlock => 'Разблокировать';

  @override
  String get onboardWelcomeTitle => 'Cloudflare под рукой';

  @override
  String onboardWelcomeBody(int count) {
    return 'Зоны, DNS, кэш и все $count эндпоинтов API. С устройства ничего не уходит, кроме запросов к самому Cloudflare — разрешения выходить в интернет куда-либо ещё у приложения нет.';
  }

  @override
  String get authChooseMethod => 'Как войдём?';

  @override
  String get authApiToken => 'API-токен';

  @override
  String get authApiTokenBlurb =>
      'Рекомендуется. Ограничен ровно теми правами, что вы выдали, и отзывается в любой момент.';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb =>
      'Устаревший способ. Неограниченный доступ ко всему аккаунту.';

  @override
  String get authCreateToken => 'Создать токен в панели';

  @override
  String get authPasteToken => 'Вставьте API-токен';

  @override
  String get authTokenHint => '40 символов из панели Cloudflare';

  @override
  String get authVerify => 'Проверить и продолжить';

  @override
  String get authVerifying => 'Проверяю токен…';

  @override
  String get authTokenValid => 'Токен принят';

  @override
  String get authEmail => 'Почта аккаунта Cloudflare';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => 'Это полный доступ к аккаунту';

  @override
  String get authGlobalKeyWarnBody =>
      'Global API Key нельзя ограничить ни правами, ни по IP. Он читает и меняет биллинг и позволяет удалить аккаунт. Используйте API-токен, если нет отдельной причины.';

  @override
  String get authGlobalKeyConfirm => 'Введите UNRESTRICTED, чтобы продолжить';

  @override
  String get authProfiles => 'Профили';

  @override
  String get authAddProfile => 'Добавить профиль';

  @override
  String get authProfileName => 'Название профиля';

  @override
  String get authSignOut => 'Удалить профиль';

  @override
  String get lockTitle => 'Введите пин-код';

  @override
  String get lockPin => 'Пин-код';

  @override
  String get lockWrongPin => 'Неверный пин';

  @override
  String get lockBiometric => 'Отпечаток';

  @override
  String get lockSetPin => 'Задайте пин-код';

  @override
  String get lockConfirmPin => 'Повторите пин-код';

  @override
  String get lockPinTooShort => 'Минимум 4 цифры';

  @override
  String get lockPinMismatch => 'Пин-коды не совпадают';

  @override
  String get lockEnableBiometric => 'Разблокировка отпечатком';

  @override
  String get permTitle => 'Права';

  @override
  String get permNotificationAccess => 'Доступ к уведомлениям';

  @override
  String permMissing(String permissions) {
    return 'Учётным данным не хватает прав: $permissions';
  }

  @override
  String get permFixCta => 'Создать токен с этим правом';

  @override
  String get zonesTitle => 'Зоны';

  @override
  String get zonesSearchHint => 'Поиск по зонам';

  @override
  String get zonesEmpty => 'В этом аккаунте нет зон';

  @override
  String get zoneStatusActive => 'Активна';

  @override
  String get zonePlan => 'Тариф';

  @override
  String get zoneNameservers => 'NS-серверы';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записей',
      few: '$count записи',
      one: '$count запись',
      zero: 'Записей нет',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => 'Добавить запись';

  @override
  String get dnsEditRecord => 'Изменить запись';

  @override
  String get dnsType => 'Тип';

  @override
  String get dnsName => 'Имя';

  @override
  String get dnsContent => 'Значение';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => 'Авто';

  @override
  String get dnsProxied => 'Через прокси Cloudflare';

  @override
  String get dnsPriority => 'Приоритет';

  @override
  String get dnsComment => 'Комментарий';

  @override
  String get dnsTags => 'Метки';

  @override
  String dnsDeleteConfirm(String name) {
    return 'Удалить $name?';
  }

  @override
  String get dnsExport => 'Выгрузить BIND-файл';

  @override
  String get dnsSearchHint => 'Поиск по записям';

  @override
  String get cachePurgeTitle => 'Очистка кэша';

  @override
  String get cachePurgeEverything => 'Очистить всё';

  @override
  String get cachePurgeEverythingWarn =>
      'Сбросит весь кэш зоны и ненадолго поднимет нагрузку на origin.';

  @override
  String get cachePurgeConfirm => 'Введите PURGE для подтверждения';

  @override
  String get cachePurgeByUrl => 'Очистить по URL';

  @override
  String get cachePurged => 'Кэш очищен';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => 'Хост';

  @override
  String get purgeByPrefix => 'Префикс';

  @override
  String get purgeByTag => 'Тег';

  @override
  String get purgeTargets => 'Что чистим';

  @override
  String get purgeOnePerLine => 'По одному в строке';

  @override
  String get analyticsTitle => 'Аналитика';

  @override
  String get analyticsRequests => 'Запросы';

  @override
  String get analyticsCached => 'Из кэша';

  @override
  String get analyticsBandwidth => 'Трафик';

  @override
  String get analyticsUniques => 'Посетители';

  @override
  String get analyticsCacheRatio => 'Попаданий';

  @override
  String get analyticsThreats => 'Угрозы';

  @override
  String get analyticsRequestsOverTime => 'Запросы по времени';

  @override
  String get analyticsStatusCodes => 'Коды ответов';

  @override
  String get analyticsTopCountries => 'Страны';

  @override
  String get analyticsContentTypes => 'Типы контента';

  @override
  String get analyticsSecurityEvents => 'События безопасности';

  @override
  String get analyticsNoData => 'За этот период трафика не было';

  @override
  String get zoneAnalyticsSubtitle => 'Трафик, попадания в кэш, угрозы';

  @override
  String get zoneDnsSubtitle => 'Записи, статус прокси, выгрузка BIND';

  @override
  String get zonePurgeSubtitle => 'По URL, хосту, префиксу, тегу — или всё';

  @override
  String get explorerTitle => 'Обозреватель API';

  @override
  String explorerSubtitle(int count) {
    return '$count эндпоинтов';
  }

  @override
  String get explorerSearchHint => 'Поиск по эндпоинтам';

  @override
  String get explorerSend => 'Отправить запрос';

  @override
  String get explorerDeprecated => 'Устаревший';

  @override
  String get explorerRequired => 'Обязательный';

  @override
  String get explorerNoParams => 'У этого эндпоинта нет параметров';

  @override
  String get explorerBody => 'Тело запроса';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSecurity => 'Безопасность';

  @override
  String get settingsAutoLock => 'Автоблокировка';

  @override
  String get settingsAutoLockImmediate => 'Сразу';

  @override
  String get settingsAutoLockNever => 'Никогда';

  @override
  String get settingsBlockScreenshots => 'Запретить скриншоты';

  @override
  String get settingsPrivacyTitle => 'Приватность';

  @override
  String get settingsPrivacyBody =>
      'Учётные данные шифруются AES-GCM ключом, выведенным из вашего пин-кода, и хранятся только на этом устройстве. Отправляются они исключительно на api.cloudflare.com. Никакой телеметрии нет.';

  @override
  String get settingsWipe => 'Стереть всё';

  @override
  String get settingsWipeConfirm =>
      'Удалит с устройства все сохранённые профили и учётные данные.';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get errNetworkOffline => 'Нет соединения с интернетом';

  @override
  String get errNetworkTimeout => 'Cloudflare не ответил вовремя';

  @override
  String get errAuth => 'Cloudflare отклонил эти учётные данные';

  @override
  String get errRateLimited => 'Слишком часто — повторю через момент';

  @override
  String get errNotFound => 'Не найдено';

  @override
  String get errServer => 'Cloudflare вернул ошибку сервера';

  @override
  String get errUnknown => 'Что-то пошло не так';
}
