import 'package:flutter/material.dart';

import '../providers/theme_provider.dart';
import '../widgets/coming_soon.dart';

class PengaturanScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  const PengaturanScreen({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text('Pengaturan',
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Logo
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'lib/assets/img/LOGO 2.png',
                height: 72,
                errorBuilder: (_, _, _) => Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.favorite,
                      color: Color(0xFFFF6B35), size: 36),
                ),
              ),
            ),
          ),

          // ── Tampilan ──────────────────────────────────────────────
          _SectionHeader(title: 'Tampilan', color: subColor),

          // Dark Mode toggle
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xFFFF6B35),
                size: 22,
              ),
              title: Text('Dark Mode',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor)),
              subtitle: Text(
                isDark ? 'Mode gelap aktif' : 'Mode terang aktif',
                style: TextStyle(fontSize: 11, color: subColor),
              ),
              trailing: Switch.adaptive(
                value: isDark,
                // ignore: deprecated_member_use
                activeColor: const Color(0xFFFF6B35),
                onChanged: (_) => themeProvider.toggle(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),

        // Remove

          // ── Akun ──────────────────────────────────────────────────
          _SectionHeader(title: 'Akun', color: subColor),
          _SettingsTile(
            icon: Icons.person_outline,
            label: 'Profil',
            cardBg: cardBg,
            textColor: textColor,
            onTap: () => showComingSoon(context, featureName: 'Profil'),
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            label: 'Keamanan',
            cardBg: cardBg,
            textColor: textColor,
            onTap: () => showComingSoon(context, featureName: 'Keamanan'),
          ),
          const SizedBox(height: 16),

          // ── Aplikasi ──────────────────────────────────────────────
          _SectionHeader(title: 'Aplikasi', color: subColor),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            label: 'Notifikasi',
            cardBg: cardBg,
            textColor: textColor,
            onTap: () => showComingSoon(context, featureName: 'Notifikasi'),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            label: 'Bahasa',
            cardBg: cardBg,
            textColor: textColor,
            onTap: () => showComingSoon(context, featureName: 'Bahasa'),
          ),
          const SizedBox(height: 16),

          // ── Lainnya ───────────────────────────────────────────────
          _SectionHeader(title: 'Lainnya', color: subColor),
          _SettingsTile(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            cardBg: cardBg,
            textColor: textColor,
            onTap: () =>
                showComingSoon(context, featureName: 'Tentang Aplikasi'),
          ),
          _SettingsTile(
            icon: Icons.logout,
            label: 'Keluar',
            cardBg: cardBg,
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            onTap: () => showComingSoon(context, featureName: 'Keluar'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(title,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.8)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color cardBg;
  final Color textColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cardBg,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon,
            color: iconColor ?? const Color(0xFF6C757D), size: 22),
        title: Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor)),
        trailing: const Icon(Icons.chevron_right,
            color: Color(0xFFADB5BD), size: 20),
        onTap: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
