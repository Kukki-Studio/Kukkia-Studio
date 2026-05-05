import 'package:flutter/material.dart';

import 'alarm/alarm_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'ngobrol/ngobrol_screen.dart';
import 'pengaturan/pengaturan_screen.dart';
import 'pilih_model/pilih_model_screen.dart';
import 'providers/theme_provider.dart';
import 'set_latar/set_latar_screen.dart';
import 'shell/main_shell.dart';
import 'splash/splash_screen.dart';

void main() {
  runApp(const KukkiaApp());
}

class KukkiaApp extends StatefulWidget {
  const KukkiaApp({super.key});

  @override
  State<KukkiaApp> createState() => _KukkiaAppState();
}

class _KukkiaAppState extends State<KukkiaApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kukkia',
      debugShowCheckedModeBanner: false,
      theme: _themeProvider.lightTheme,
      darkTheme: _themeProvider.darkTheme,
      themeMode:
          _themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/home': (_) => MainShell(themeProvider: _themeProvider),
        '/dashboard': (_) => const DashboardScreen(),
        '/ngobrol': (_) => const NgobrolScreen(),
        '/alarm': (_) => const AlarmScreen(),
        '/pengaturan': (_) =>
            PengaturanScreen(themeProvider: _themeProvider),
        '/pilih-model': (_) => const PilihModelScreen(),
        '/set-latar': (_) => const SetLatarScreen(),
      },
    );
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(() => setState(() {}));
  }
}
