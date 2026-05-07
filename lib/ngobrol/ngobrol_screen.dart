import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';
import '../models/anime_model.dart';

/// Tab Ngobrol = halaman pilih model anime.
/// Pilih karakter → jika bebas langsung ke chat,
/// jika terkunci → tonton iklan dummy → baru ke chat.
class NgobrolScreen extends StatefulWidget {
  const NgobrolScreen({super.key});

  @override
  State<NgobrolScreen> createState() => _NgobrolScreenState();
}

// ── Ad Unlock Bottom Sheet ────────────────────────────────────────────────────
class _AdUnlockSheet extends StatefulWidget {
  final AnimeModel model;
  final VoidCallback onUnlocked;

  const _AdUnlockSheet({required this.model, required this.onUnlocked});

  @override
  State<_AdUnlockSheet> createState() => _AdUnlockSheetState();
}

class _AdUnlockSheetState extends State<_AdUnlockSheet> {
  bool _watching = false;
  bool _done = false;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);
    final accent = widget.model.accentColor;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFDEE2E6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                widget.model.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.face_retouching_natural,
                  size: 40,
                  color: accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Title
          Text(
            _done
                ? '${widget.model.name} Terbuka! 🎉'
                : 'Buka ${widget.model.name}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _done ? const Color(0xFF2DC653) : textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _done
                ? 'Selamat! Kamu bisa mulai ngobrol dengan ${widget.model.name}.'
                : 'Tonton iklan singkat untuk membuka karakter ${widget.model.personality} ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: subColor, height: 1.5),
          ),
          const SizedBox(height: 20),

          // Progress bar
          if (_watching) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE9ECEF),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Menonton iklan... ${(_progress * 100).toInt()}%',
              style: TextStyle(fontSize: 12, color: subColor),
            ),
            const SizedBox(height: 16),
          ],

          // Dummy ad placeholder
          if (!_watching && !_done)
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFDEE2E6),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline,
                        color: subColor, size: 28),
                    const SizedBox(height: 4),
                    Text('Iklan akan ditampilkan di sini',
                        style: TextStyle(fontSize: 12, color: subColor)),
                  ],
                ),
              ),
            ),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _watching
                  ? null
                  : _done
                      ? widget.onUnlocked
                      : _startWatching,
              style: ElevatedButton.styleFrom(
                backgroundColor: _done ? const Color(0xFF2DC653) : accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: accent.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                _watching
                    ? 'Sedang Menonton...'
                    : _done
                        ? 'Mulai Ngobrol dengan ${widget.model.name} →'
                        : 'Tonton Iklan Sekarang',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          if (!_done) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal',
                  style: TextStyle(fontSize: 13, color: subColor)),
            ),
          ],
        ],
      ),
    );
  }

  void _startWatching() async {
    setState(() => _watching = true);
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      setState(() => _progress = i / 20);
    }
    if (!mounted) return;
    setState(() {
      _done = true;
      _watching = false;
    });
  }
}

// ── Model Card ────────────────────────────────────────────────────────────────
class _ModelCard extends StatelessWidget {
  final AnimeModel model;
  final bool isUnlocked;
  final Color cardBg;
  final VoidCallback onTap;

  const _ModelCard({
    required this.model,
    required this.isUnlocked,
    required this.cardBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: model.accentColor.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Konten kartu ────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar karakter
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: model.accentColor.withValues(alpha: 0.08),
                    child: Center(
                      child: Image.asset(
                        model.imagePath,
                        height: 110,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.face_retouching_natural,
                          size: 64,
                          color: model.accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: model.accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          model.personality,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: model.accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        model.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF9E9E9E)
                              : const Color(0xFF6C757D),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Lock overlay ─────────────────────────────────────
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tonton Iklan\nuntuk Buka',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Unlocked badge ───────────────────────────────────
            if (isUnlocked && model.isLocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DC653),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✓ Terbuka',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NgobrolScreenState extends State<NgobrolScreen> {
  final Set<String> _unlockedByAds = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Pilih Model',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Pilih karakter anime yang akan menemanimu.\nModel terkunci bisa dibuka gratis dengan menonton iklan.',
              style: TextStyle(fontSize: 13, color: subColor, height: 1.5),
            ),
          ),

          // Grid karakter
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: animeModels.length,
              itemBuilder: (_, i) {
                final model = animeModels[i];
                final isUnlocked =
                    !model.isLocked || _unlockedByAds.contains(model.id);
                return _ModelCard(
                  model: model,
                  isUnlocked: isUnlocked,
                  cardBg: cardBg,
                  onTap: () => _onTap(model),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUnlocked();
  }

  void _goToChat(AnimeModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(model: model)),
    );
  }

  Future<void> _loadUnlocked() async {
    final unlocked = await AppPreferences.getUnlockedModels();
    if (mounted) setState(() => _unlockedByAds.addAll(unlocked));
  }

  void _onTap(AnimeModel model) {
    final unlocked = !model.isLocked || _unlockedByAds.contains(model.id);
    if (unlocked) {
      _goToChat(model);
    } else {
      _showAdSheet(model);
    }
  }

  void _showAdSheet(AnimeModel model) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AdUnlockSheet(
        model: model,
        onUnlocked: () {
          setState(() => _unlockedByAds.add(model.id));
          AppPreferences.addUnlockedModel(model.id);
          Navigator.pop(context); // tutup sheet
          _goToChat(model);
        },
      ),
    );
  }
}
