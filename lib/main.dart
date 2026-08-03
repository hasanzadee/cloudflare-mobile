import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_settings.dart';
import 'app/theme.dart';
import 'auth/application/auth_providers.dart';
import 'auth/presentation/lock_screen.dart';
import 'auth/presentation/onboarding_screen.dart';
import 'core/security/secure_flag.dart';
import 'features/developer/developer_screen.dart';
import 'features/home/home_screen.dart';
import 'features/more/more_screen.dart';
import 'features/security/security_screen.dart';
import 'features/zones/zone_screen.dart';
import 'features/zones/zones_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CloudflareMobileApp()));
}

class CloudflareMobileApp extends ConsumerWidget {
  const CloudflareMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Cloudflare Mobile',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(
          dynamicScheme: settings.useDynamicColor ? lightDynamic : null,
          mode: Brightness.light,
        ),
        darkTheme: buildTheme(
          dynamicScheme: settings.useDynamicColor ? darkDynamic : null,
          mode: Brightness.dark,
        ),
        themeMode: settings.themeMode,
        // Null follows the system, which is the default.
        locale: settings.locale,
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: const _Root(),
      ),
    );
  }
}

/// Decides between onboarding, the lock screen and the app shell, and applies
/// FLAG_SECURE as soon as there is a UI to protect.
class _Root extends ConsumerStatefulWidget {
  const _Root();

  @override
  ConsumerState<_Root> createState() => _RootState();
}

class _RootState extends ConsumerState<_Root> with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On by default from the first frame; the listener below then follows any
    // change, including the one that arrives when preferences finish loading.
    const SecureFlag().set(enabled: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _backgroundedAt = DateTime.now();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        final after = ref.read(appSettingsProvider).autoLock;
        // A ten-year "never" beats a nullable duration: one comparison, no
        // special case to forget.
        if (since != null && DateTime.now().difference(since) >= after) {
          ref.read(authProvider.notifier).lock();
        }
        _backgroundedAt = null;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    // Kept in sync here rather than only where the switch lives, so the flag is
    // also right after a restart and after the stored value loads from disk.
    ref.listen(appSettingsProvider.select((s) => s.blockScreenshots), (_, on) {
      const SecureFlag().set(enabled: on);
    });

    // Locking swaps what `home` renders, but pushed routes sit *above* home and
    // survive that swap. Without this, "Lock now" left the screen you were on
    // fully visible with the lock screen hidden underneath — and auto-lock on
    // resume did the same, which is worse, because the screens worth pushing
    // are the ones showing KV values, D1 rows and credentials.
    ref.listen(authProvider.select((s) => s.valueOrNull?.status), (_, status) {
      if (status == AuthStatus.unlocked) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    });

    return auth.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (state) => switch (state.status) {
        AuthStatus.uninitialized => const OnboardingScreen(),
        AuthStatus.locked => const LockScreen(),
        AuthStatus.unlocked => const AppShell(),
      },
    );
  }
}

/// Bottom-navigation shell.
///
/// IndexedStack keeps each tab's scroll position and state, which the
/// prototype's `switch (_idx)` body threw away on every tab change.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenZones: () => setState(() => _index = 1)),
          ZonesScreen(
            onOpenZone: (zone) {
              // Tapping a zone lands on the zone hub — DNS, purge and settings
              // — rather than jumping straight into DNS as the prototype did.
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ZoneScreen(
                    zoneId: zone.id ?? '',
                    zoneName: zone.name ?? '',
                  ),
                ),
              );
            },
          ),
          const SecurityScreen(),
          const DeveloperScreen(),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.public_outlined),
            selectedIcon: const Icon(Icons.public),
            label: l.navZones,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: const Icon(Icons.shield),
            label: l.navSecurity,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bolt_outlined),
            selectedIcon: const Icon(Icons.bolt),
            label: l.navDeveloper,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            label: l.navMore,
          ),
        ],
      ),
    );
  }
}
