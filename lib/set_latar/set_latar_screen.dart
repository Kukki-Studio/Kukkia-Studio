import 'package:flutter/material.dart';

import '../widgets/coming_soon.dart';

class SetLatarScreen extends StatefulWidget {
  const SetLatarScreen({super.key});

  @override
  State<SetLatarScreen> createState() => _SetLatarScreenState();
}

class _LatarItem {
  final String label;
  final Color color;
  const _LatarItem({required this.label, required this.color});
}

class _SetLatarScreenState extends State<SetLatarScreen> {
  int _selected = 0;

  final List<_LatarItem> _items = const [
    _LatarItem(label: 'Default', color: Color(0xFFF8F9FA)),
    _LatarItem(label: 'Gelap', color: Color(0xFF212529)),
    _LatarItem(label: 'Biru', color: Color(0xFF4361EE)),
    _LatarItem(label: 'Hijau', color: Color(0xFF2DC653)),
    _LatarItem(label: 'Merah', color: Color(0xFFFF6B6B)),
    _LatarItem(label: 'Ungu', color: Color(0xFF9B5DE5)),
    _LatarItem(label: 'Kuning', color: Color(0xFFFFBE0B)),
    _LatarItem(label: 'Oranye', color: Color(0xFFFF9F1C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF212529), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set Latar Belakang',
          style: TextStyle(
            color: Color(0xFF212529),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview area
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              color: _items[_selected].color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _items[_selected].color.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _items[_selected].label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _selected == 0
                      ? const Color(0xFF212529)
                      : Colors.white,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Pilih Warna',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C757D),
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Color grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = _selected == index;
                return GestureDetector(
                  onTap: () => setState(() => _selected = index),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF4361EE), width: 3)
                              : Border.all(
                                  color: const Color(0xFFDEE2E6), width: 1),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4361EE)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 22)
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF4361EE)
                              : const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    showComingSoon(context, featureName: 'Set Latar Belakang'),
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
                  'Terapkan',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
