import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';
import '../models/anime_model.dart';
import '../pilih_model/pilih_model_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _CardBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CardBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Model aktif yang dipilih user (default: Kukki)
  AnimeModel _activeModel = animeModels[0];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);
    final accent = _activeModel.accentColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Header ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting(),
                          style: TextStyle(
                              fontSize: 13,
                              color: subColor,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 2),
                      Text('Kukkia',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: accent)),
                    ],
                  ),
                  // Logo kecil
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/img/LOGO 2.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            Icon(Icons.favorite, color: accent, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Karakter Card ────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.85),
                      accent.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Karakter image kanan
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(24)),
                        child: Image.asset(
                          _activeModel.imagePath,
                          width: 160,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomRight,
                          errorBuilder: (_, _, _) => SizedBox(
                            width: 160,
                            child: Icon(Icons.face_retouching_natural,
                                size: 80,
                                color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ),
                      ),
                    ),
                    // Text overlay kiri
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _activeModel.personality,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _activeModel.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 180,
                            child: Text(
                              _activeModel.openingLine,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                height: 1.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _CardBtn(
                                label: 'Ngobrol',
                                icon: Icons.chat_bubble_outline_rounded,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChatScreen(model: _activeModel),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _CardBtn(
                                label: 'Ganti',
                                icon: Icons.swap_horiz_rounded,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PilihModelScreen(),
                                    ),
                                  );
                                  if (result is AnimeModel) {
                                    setState(() => _activeModel = result);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Info Row ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.access_time_rounded,
                      label: 'Waktu',
                      value: _timeString(),
                      accent: accent,
                      cardBg: cardBg,
                      textColor: textColor,
                      subColor: subColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.chat_rounded,
                      label: 'Chat',
                      value: '0 Pesan',
                      accent: accent,
                      cardBg: cardBg,
                      textColor: textColor,
                      subColor: subColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Quick Actions ────────────────────────────────────
              Text('Aksi Cepat',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
                children: [
                  _QuickAction(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Ngobrol',
                    color: accent,
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(model: _activeModel)),
                    ),
                  ),
                  _QuickAction(
                    icon: Icons.alarm_rounded,
                    label: 'Alarm',
                    color: const Color(0xFF4CC9F0),
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () {
                      // Navigasi ke tab alarm via callback — coming soon
                    },
                  ),
                  _QuickAction(
                    icon: Icons.face_retouching_natural,
                    label: 'Pilih Model',
                    color: const Color(0xFF9B5DE5),
                    cardBg: cardBg,
                    textColor: textColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PilihModelScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Model List Preview ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Model Tersedia',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor)),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PilihModelScreen()),
                    ),
                    child: Text('Lihat Semua',
                        style: TextStyle(
                            fontSize: 12,
                            color: accent,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: animeModels.length,
                  itemBuilder: (_, i) {
                    final m = animeModels[i];
                    final isActive = m.id == _activeModel.id;
                    return GestureDetector(
                      onTap: () => setState(() => _activeModel = m),
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? m.accentColor.withValues(alpha: 0.15)
                              : cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: isActive
                              ? Border.all(
                                  color: m.accentColor, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: m.accentColor
                                    .withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  m.imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.face_retouching_natural,
                                    color: m.accentColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? m.accentColor
                                    : subColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 5) return 'Selamat Malam';
    if (h < 11) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 19) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _timeString() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  const _InfoCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.accent,
      required this.cardBg,
      required this.textColor,
      required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 11, color: subColor)),
              Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color cardBg;
  final Color textColor;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.cardBg,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: cardBg, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        ),
      ),
    );
  }
}
