// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LZh extends L {
  LZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Cloudflare Mobile';

  @override
  String get navHome => '主页';

  @override
  String get navZones => '站点';

  @override
  String get navExplorer => 'API';

  @override
  String get navSettings => '设置';

  @override
  String get navSecurity => '安全';

  @override
  String get navDeveloper => '开发';

  @override
  String get navZeroTrust => 'Zero Trust';

  @override
  String get navMore => '更多';

  @override
  String get scopeAccount => '账户';

  @override
  String get scopeZone => '站点';

  @override
  String get scopeAllAccounts => '全部账户';

  @override
  String get scopePickZone => '选择站点';

  @override
  String get scopePickAccount => '选择账户';

  @override
  String get scopeMoreZones => '还有更多站点 — 输入以搜索';

  @override
  String get securityIpAccess => 'IP 访问';

  @override
  String get securityPickZone => '请先选择站点 — 安全规则按站点设置。';

  @override
  String get securityNoRules => '该阶段暂无规则';

  @override
  String get securityNewIpRule => '新建 IP 访问规则';

  @override
  String get securityAction => '动作';

  @override
  String get securityTarget => '作用于';

  @override
  String get securityValue => '值';

  @override
  String get devWorkers => 'Workers';

  @override
  String get devPages => 'Pages';

  @override
  String get devStorage => '存储';

  @override
  String get devPickAccount => '请先选择账户 — 这些属于账户级资源。';

  @override
  String get devKvNamespaces => 'KV 命名空间';

  @override
  String get devD1 => 'D1 数据库';

  @override
  String get devR2 => 'R2 存储桶';

  @override
  String get kvSearchHint => '筛选键';

  @override
  String get kvValue => '值';

  @override
  String get kvExpires => '过期时间';

  @override
  String get kvMoreKeys => '还有更多键 — 请缩小筛选范围';

  @override
  String get d1Query => 'SQL';

  @override
  String get d1Run => '执行';

  @override
  String get d1OneStatement => '一次只能执行一条语句';

  @override
  String get d1NoRows => '没有返回任何行';

  @override
  String get d1DestructiveWarning => '该语句会修改或删除数据。';

  @override
  String get d1ConfirmTitle => '执行破坏性语句？';

  @override
  String get d1ConfirmHint => '输入 RUN 以确认';

  @override
  String get zoneTrafficSubtitle => 'Page Rules、负载均衡、等候室';

  @override
  String get zoneTlsSubtitle => '证书、自定义主机名、DNSSEC';

  @override
  String get zoneEmailSubtitle => '转发规则与目标地址';

  @override
  String get trafficPageRules => 'Page Rules';

  @override
  String get trafficLoadBalancers => '负载均衡';

  @override
  String get trafficWaitingRooms => '等候室';

  @override
  String get tlsCertificates => '证书包';

  @override
  String get tlsCustomHostnames => '自定义主机名';

  @override
  String get tlsDnssec => 'DNSSEC';

  @override
  String get tlsUniversal => 'Universal SSL';

  @override
  String get emailRules => '转发规则';

  @override
  String get emailAddresses => '目标地址';

  @override
  String get moreAlerts => '通知';

  @override
  String get moreTurnstile => 'Turnstile';

  @override
  String get ztTunnels => '隧道';

  @override
  String get ztAccess => 'Access';

  @override
  String get ztGateway => 'Gateway';

  @override
  String get ztNoConnectors => '当前没有正在运行的连接器';

  @override
  String get ztNoPolicies => '该应用没有任何策略';

  @override
  String get commonRetry => '重试';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '删除';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCopy => '复制';

  @override
  String get commonCopied => '已复制';

  @override
  String get commonSearch => '搜索';

  @override
  String get commonAll => '全部';

  @override
  String get commonContinue => '继续';

  @override
  String get commonAdd => '添加';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonRefresh => '刷新';

  @override
  String get commonNothingHere => '这里还什么都没有';

  @override
  String get commonLoadMore => '加载更多';

  @override
  String get commonDiagnostics => '复制诊断信息';

  @override
  String get commonUnlock => '解锁';

  @override
  String get onboardWelcomeTitle => '在手机上管理 Cloudflare';

  @override
  String onboardWelcomeBody(int count) {
    return '站点、DNS、缓存，以及全部 $count 个 API 端点。除了发往 Cloudflare 的请求，没有任何数据离开设备 — 本应用没有其他联网权限。';
  }

  @override
  String get authChooseMethod => '选择登录方式';

  @override
  String get authApiToken => 'API 令牌';

  @override
  String get authApiTokenBlurb => '推荐。权限完全由你授予，可随时吊销。';

  @override
  String get authGlobalKey => 'Global API Key';

  @override
  String get authGlobalKeyBlurb => '旧方式。对整个账户拥有不受限的访问权。';

  @override
  String get authCreateToken => '在控制台创建令牌';

  @override
  String get authPasteToken => '粘贴你的 API 令牌';

  @override
  String get authTokenHint => '来自控制台的 40 位令牌';

  @override
  String get authVerify => '验证并继续';

  @override
  String get authVerifying => '正在检查令牌…';

  @override
  String get authTokenValid => '令牌已通过';

  @override
  String get authEmail => 'Cloudflare 账户邮箱';

  @override
  String get authGlobalKeyField => 'Global API Key';

  @override
  String get authGlobalKeyWarnTitle => '这将授予账户的完全访问权';

  @override
  String get authGlobalKeyWarnBody =>
      'Global API Key 无法按权限或 IP 限制。它能读取和修改账单，也能删除账户。若无特殊理由，请改用 API 令牌。';

  @override
  String get authGlobalKeyConfirm => '输入 UNRESTRICTED 以继续';

  @override
  String get authProfiles => '配置档案';

  @override
  String get authAddProfile => '添加配置档案';

  @override
  String get authProfileName => '档案名称';

  @override
  String get authSignOut => '移除配置档案';

  @override
  String get lockTitle => '请输入 PIN 码';

  @override
  String get lockPin => 'PIN 码';

  @override
  String get lockWrongPin => 'PIN 码错误';

  @override
  String get lockBiometric => '使用指纹';

  @override
  String get lockSetPin => '设置 PIN 码';

  @override
  String get lockConfirmPin => '再次输入 PIN 码';

  @override
  String get lockPinTooShort => '至少 4 位数字';

  @override
  String get lockPinMismatch => '两次 PIN 码不一致';

  @override
  String get lockEnableBiometric => '用指纹解锁';

  @override
  String get permTitle => '权限';

  @override
  String get permNotificationAccess => '通知访问权限';

  @override
  String permMissing(String permissions) {
    return '凭据缺少以下权限：$permissions';
  }

  @override
  String get permFixCta => '创建带该权限的令牌';

  @override
  String get zonesTitle => '站点';

  @override
  String get zonesSearchHint => '搜索站点';

  @override
  String get zonesEmpty => '该账户下没有站点';

  @override
  String get zoneStatusActive => '已启用';

  @override
  String get zonePlan => '套餐';

  @override
  String get zoneNameservers => '域名服务器';

  @override
  String get dnsTitle => 'DNS';

  @override
  String dnsRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条记录',
      zero: '没有记录',
    );
    return '$_temp0';
  }

  @override
  String get dnsAddRecord => '添加记录';

  @override
  String get dnsEditRecord => '编辑记录';

  @override
  String get dnsType => '类型';

  @override
  String get dnsName => '名称';

  @override
  String get dnsContent => '内容';

  @override
  String get dnsTtl => 'TTL';

  @override
  String get dnsTtlAuto => '自动';

  @override
  String get dnsProxied => '经 Cloudflare 代理';

  @override
  String get dnsPriority => '优先级';

  @override
  String get dnsComment => '备注';

  @override
  String get dnsTags => '标签';

  @override
  String dnsDeleteConfirm(String name) {
    return '删除 $name？';
  }

  @override
  String get dnsExport => '导出为 BIND 文件';

  @override
  String get dnsSearchHint => '搜索记录';

  @override
  String get cachePurgeTitle => '清除缓存';

  @override
  String get cachePurgeEverything => '全部清除';

  @override
  String get cachePurgeEverythingWarn => '将清空该站点的所有缓存文件，源站负载会短时间上升。';

  @override
  String get cachePurgeConfirm => '输入 PURGE 以确认';

  @override
  String get cachePurgeByUrl => '按 URL 清除';

  @override
  String get cachePurged => '缓存已清除';

  @override
  String get purgeByUrl => 'URL';

  @override
  String get purgeByHost => '主机';

  @override
  String get purgeByPrefix => '前缀';

  @override
  String get purgeByTag => '标签';

  @override
  String get purgeTargets => '清除范围';

  @override
  String get purgeOnePerLine => '每行一个';

  @override
  String get analyticsTitle => '分析';

  @override
  String get analyticsRequests => '请求数';

  @override
  String get analyticsCached => '命中缓存';

  @override
  String get analyticsBandwidth => '流量';

  @override
  String get analyticsUniques => '访客';

  @override
  String get analyticsCacheRatio => '缓存命中率';

  @override
  String get analyticsThreats => '威胁';

  @override
  String get analyticsRequestsOverTime => '请求随时间变化';

  @override
  String get analyticsStatusCodes => '状态码';

  @override
  String get analyticsTopCountries => '国家和地区';

  @override
  String get analyticsContentTypes => '内容类型';

  @override
  String get analyticsSecurityEvents => '安全事件';

  @override
  String get analyticsNoData => '该时段没有流量';

  @override
  String get zoneAnalyticsSubtitle => '流量、缓存命中率、威胁';

  @override
  String get zoneDnsSubtitle => '记录、代理状态、BIND 导出';

  @override
  String get zonePurgeSubtitle => '按 URL、主机、前缀、标签 — 或全部';

  @override
  String get explorerTitle => 'API 浏览器';

  @override
  String explorerSubtitle(int count) {
    return '$count 个端点';
  }

  @override
  String get explorerSearchHint => '搜索端点';

  @override
  String get explorerSend => '发送请求';

  @override
  String get explorerDeprecated => '已弃用';

  @override
  String get explorerRequired => '必填';

  @override
  String get explorerNoParams => '该端点不接受任何参数';

  @override
  String get explorerBody => '请求体';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsDynamicColor => '跟随壁纸配色';

  @override
  String get settingsDynamicColorHint => 'Material You。关闭后使用应用自带配色。';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsAutoLock => '自动锁定';

  @override
  String get settingsAutoLockImmediate => '立即';

  @override
  String get settingsAutoLockNever => '从不';

  @override
  String get settingsLockNow => '立即锁定';

  @override
  String get settingsBlockScreenshots => '禁止截屏';

  @override
  String get settingsBlockScreenshotsHint => '在截屏、录屏和最近任务预览中隐藏本应用。';

  @override
  String get settingsPrivacyTitle => '隐私';

  @override
  String get settingsPrivacyBody =>
      '凭据使用由 PIN 码派生的密钥经 AES-GCM 加密，仅保存在本设备上，并且只发送到 api.cloudflare.com。没有任何遥测。';

  @override
  String get settingsWipe => '清除全部数据';

  @override
  String get settingsWipeConfirm => '将从本设备删除所有已保存的配置档案和凭据。';

  @override
  String get settingsAbout => '关于';

  @override
  String get errNetworkOffline => '没有网络连接';

  @override
  String get errNetworkTimeout => 'Cloudflare 未在规定时间内响应';

  @override
  String get errAuth => 'Cloudflare 拒绝了该凭据';

  @override
  String get errRateLimited => '请求过于频繁 — 稍后将自动重试';

  @override
  String get errNotFound => '未找到';

  @override
  String get errServer => 'Cloudflare 返回了服务器错误';

  @override
  String get errUnknown => '出了点问题';
}
