import 'package:flutter/material.dart';

/// Tampilkan bottom sheet "Coming Soon" ketika fitur belum tersedia.
void showComingSoon(BuildContext context, {String? featureName}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ComingSoonSheet(featureName: featureName),
  );
}

class _ComingSoonSheet extends StatelessWidget {
  final String? featureName;
  const _ComingSoonSheet({this.featureName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.rocket_launch_outlined,
              color: Color(0xFF4361EE),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            featureName != null ? featureName! : 'Coming Soon',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fitur ini sedang dalam pengembangan.\nNantikan pembaruan berikutnya!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6C757D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4361EE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Oke, Mengerti',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
