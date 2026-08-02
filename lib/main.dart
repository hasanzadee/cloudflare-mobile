import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/state.dart';
import 'features/catalog_screen.dart';
import 'features/lock_screen.dart';
import 'features/onboarding_screen.dart';
import 'features/rawapi_screen.dart';
import 'features/settings_screen.dart';
import 'features/zones_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CFApp()));
}

class CFApp extends ConsumerStatefulWidget {
  const CFApp({super.key});
  @override
  ConsumerState<CFApp> createState() => _CFAppState();
}

class _CFAppState extends ConsumerState<CFApp> {
  LifecycleObserver? _obs;

  @override
  void initState() {
    super.initState();
    _obs = LifecycleObserver(ref);
    WidgetsBinding.instance.addObserver(_obs!);
  }

  @override
  void dispose() {
    if (_obs != null) WidgetsBinding.instance.removeObserver(_obs!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) => MaterialApp(
        title: 'CF Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: light ??
              ColorScheme.fromSeed(seedColor: const Color(0xFFF6821F)),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: dark ??
              ColorScheme.fromSeed(
                  seedColor: const Color(0xFFF6821F), brightness: Brightness.dark),
        ),
        home: const _Root(),
      ),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (!auth.initialized) return const OnboardingScreen();
    if (!auth.unlocked) return const LockScreen();
    return const _MainShell();
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();
  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _idx = 0;
  static const _titles = ['Зоны', 'Каталог API', 'Raw API', 'Настройки'];

  @override
  Widget build(BuildContext context) {
    final body = switch (_idx) {
      0 => const ZonesScreen(),
      1 => const CatalogScreen(),
      2 => const RawApiScreen(),
      _ => const SettingsScreen(),
    };
    // Catalog screen has its own SliverAppBar.
    final useScaffoldAppBar = _idx != 1;
    return Scaffold(
      appBar: useScaffoldAppBar
          ? AppBar(
              title: Text(_titles[_idx]),
              centerTitle: false,
            )
          : null,
      body: SafeArea(top: !useScaffoldAppBar, bottom: false, child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dns_outlined),
              selectedIcon: Icon(Icons.dns),
              label: 'Зоны'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Каталог'),
          NavigationDestination(
              icon: Icon(Icons.terminal_outlined),
              selectedIcon: Icon(Icons.terminal),
              label: 'Raw API'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Настройки'),
        ],
      ),
    );
  }
}
