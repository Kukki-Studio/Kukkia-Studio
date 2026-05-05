import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../ngobrol/ngobrol_screen.dart';
import '../alarm/alarm_screen.dart';
import '../pengaturan/pengaturan_screen.dart';
import '../providers/theme_provider.dart';

class MainShell extends StatefulWidget {
  final ThemeProvider themeProvider;
  const MainShell({super.key, required this.themeProvider});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _accent = Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE9ECEF);
    final adBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final adText = isDark ? Colors.white : const Color(0xFF212529);
    final adSub =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);

    final pages = [
      const DashboardScreen(),
      const NgobrolScreen(),
      const AlarmScreen(),
      PengaturanScreen(themeProvider: widget.themeProvider),
    ];

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Ads Banner ────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: adBg,
              border: Border(
                top: BorderSide(color: borderColor),
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Ad',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _accent)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Ad Here',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: adText)),
                      Text('Tap to learn more',
                          style:
                              TextStyle(fontSize: 11, color: adSub)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Install',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Nav Bar ────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: navBg,
              border:
                  Border(top: BorderSide(color: borderColor, width: 0.5)),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              backgroundColor: Colors.transparent,
              selectedItemColor: _accent,
              unselectedItemColor: isDark
                  ? const Color(0xFF6C757D)
                  : const Color(0xFFADB5BD),
              selectedLabelStyle: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 10),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  activeIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Ngobrol',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.alarm_outlined),
                  activeIcon: Icon(Icons.alarm_rounded),
                  label: 'Alarm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings_rounded),
                  label: 'Pengaturan',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
