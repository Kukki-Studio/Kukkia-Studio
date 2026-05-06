import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alarm/alarm_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'ngobrol/ngobrol_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'pengaturan/pengaturan_screen.dart';
import 'pilih_model/pilih_model_screen.dart';
import 'providers/theme_provider.dart';
import 'set_latar/set_latar_screen.dart';
import 'shell/main_shell.dart';
import 'splash/splash_screen.dart';

void main() async {
  // Wajib sebelum pakai plugin apapun
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah onboarding sudah pernah dilakukan
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  runApp(KukkiaApp(onboardingDone: onboardingDone));
}

class KukkiaApp extends StatefulWidget {
  final bool onboardingDone;
  const KukkiaApp({super.key, required this.onboardingDone});

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
      // Kalau onboarding belum, mulai dari onboarding
      // Kalau sudah, langsung splash → home
      initialRoute: '/',
      routes: {
        '/': (_) => widget.onboardingDone
            ? const SplashScreen()
            : const OnboardingScreen(),
        '/splash': (_) => const SplashScreen(),
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
