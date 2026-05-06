import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _notifGranted = false;
  bool _storageGranted = false;
  bool _loading = false;

  static const _accent = Color(0xFFFF6B35);

  @override
  void initState() {
    super.initState();
    _checkExisting();
  }

  Future<void> _checkExisting() async {
    final notif = await Permission.notification.status;
    final storage = await Permission.photos.status;
    if (mounted) {
      setState(() {
        _notifGranted = notif.isGranted;
        _storageGranted = storage.isGranted;
      });
    }
  }

  Future<void> _requestNotif() async {
    final status = await Permission.notification.request();
    if (mounted) setState(() => _notifGranted = status.isGranted);
  }

  Future<void> _requestStorage() async {
    final status = await Permission.photos.request();
    if (mounted) setState(() => _storageGranted = status.isGranted);
  }

  Future<void> _continue() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color(0x14FF6B35),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'lib/assets/img/LOGO 2.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.favorite,
                          color: _accent,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang di Kukkia!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF212529),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sebelum mulai, Kukkia butuh\nbeberapa izin untuk bekerja dengan baik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _PermissionCard(
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFF4CC9F0),
                title: 'Notifikasi & Alarm',
                desc: 'Agar karakter anime bisa membangunkanmu dan mengirim sapaan harian.',
                isGranted: _notifGranted,
                onRequest: _requestNotif,
              ),
              const SizedBox(height: 12),
              _PermissionCard(
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF9B5DE5),
                title: 'Galeri / Penyimpanan',
                desc: 'Untuk memilih foto sebagai background chat kamu.',
                isGranted: _storageGranted,
                onRequest: _requestStorage,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF6C757D)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Izin bisa diubah kapanpun di Pengaturan HP kamu.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _loading ? null : _continue,
                  child: const Text(
                    'Lewati untuk sekarang',
                    style: TextStyle(fontSize: 13, color: Color(0xFFADB5BD)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String desc;
  final bool isGranted;
  final VoidCallback onRequest;

  const _PermissionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.desc,
    required this.isGranted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted
              ? const Color(0x662DC653)
              : const Color(0xFFE9ECEF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212529))),
                const SizedBox(height: 3),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6C757D),
                        height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          isGranted
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x1A2DC653),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded,
                          color: Color(0xFF2DC653), size: 14),
                      SizedBox(width: 4),
                      Text('Izin',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2DC653))),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: onRequest,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Izinkan',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
