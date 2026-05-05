import 'package:flutter/material.dart';

import '../models/anime_model.dart';

class AlarmItem {
  final String id;
  final TimeOfDay time;
  final String label;
  final List<bool> days; // Sen-Min
  bool isActive;
  final AnimeModel voiceModel;

  AlarmItem({
    required this.id,
    required this.time,
    required this.label,
    required this.days,
    required this.isActive,
    required this.voiceModel,
  });

  String get daysString {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final active = <String>[];
    for (int i = 0; i < 7; i++) {
      if (days[i]) active.add(names[i]);
    }
    if (active.isEmpty) return 'Sekali';
    if (active.length == 7) return 'Setiap Hari';
    if (active.length == 5 &&
        days[0] && days[1] && days[2] && days[3] && days[4] &&
        !days[5] && !days[6]) {
      return 'Hari Kerja';
    }
    return active.join(', ');
  }

  String get periodString => time.hour < 12 ? 'AM' : 'PM';

  String get timeString {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

// ── Alarm Card ────────────────────────────────────────────────────────────────
class _AlarmCard extends StatelessWidget {
  final AlarmItem alarm;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AlarmCard({
    required this.alarm,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final accent = alarm.voiceModel.accentColor;

    return Dismissible(
      key: Key(alarm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 26),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: alarm.isActive
                ? cardBg
                : cardBg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: alarm.isActive
                ? Border.all(
                    color: accent.withValues(alpha: 0.3), width: 1.5)
                : null,
            boxShadow: alarm.isActive
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Voice model avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    alarm.voiceModel.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.face_retouching_natural,
                      color: accent,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Time & info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          alarm.timeString,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: alarm.isActive
                                ? textColor
                                : subColor,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            alarm.periodString,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: alarm.isActive ? accent : subColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(alarm.label,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: alarm.isActive ? textColor : subColor)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.repeat_rounded,
                            size: 12, color: subColor),
                        const SizedBox(width: 4),
                        Text(alarm.daysString,
                            style: TextStyle(
                                fontSize: 11, color: subColor)),
                        const SizedBox(width: 8),
                        Icon(Icons.record_voice_over_outlined,
                            size: 12, color: subColor),
                        const SizedBox(width: 4),
                        Text(alarm.voiceModel.name,
                            style: TextStyle(
                                fontSize: 11, color: subColor)),
                      ],
                    ),
                  ],
                ),
              ),

              // Toggle
              Switch.adaptive(
                value: alarm.isActive,
                activeColor: accent,
                activeTrackColor: accent.withValues(alpha: 0.3),
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Alarm Form Sheet ──────────────────────────────────────────────────────────
class _AlarmFormSheet extends StatefulWidget {
  final AlarmItem? existing;
  final ValueChanged<AlarmItem> onSave;

  const _AlarmFormSheet({this.existing, required this.onSave});

  @override
  State<_AlarmFormSheet> createState() => _AlarmFormSheetState();
}

class _AlarmFormSheetState extends State<_AlarmFormSheet> {
  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  late TimeOfDay _time;
  late TextEditingController _labelCtrl;
  late List<bool> _days;
  late AnimeModel _voiceModel;

  late bool _isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);
    final fieldBg =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDEE2E6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              widget.existing == null ? 'Tambah Alarm' : 'Edit Alarm',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor),
            ),
            const SizedBox(height: 20),

            // Time picker button
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF6B35),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Ketuk untuk ubah waktu',
                        style: TextStyle(fontSize: 12, color: subColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Label
            Text('Label',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subColor)),
            const SizedBox(height: 6),
            TextField(
              controller: _labelCtrl,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldBg,
                hintText: 'Nama alarm...',
                hintStyle:
                    const TextStyle(color: Color(0xFFADB5BD), fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Days
            Text('Ulangi',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => _days[i] = !_days[i]),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _days[i]
                          ? const Color(0xFFFF6B35)
                          : fieldBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _dayNames[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _days[i] ? Colors.white : subColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Suara karakter
            Text('Suara Karakter',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subColor)),
            const SizedBox(height: 8),
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: animeModels.length,
                itemBuilder: (_, i) {
                  final m = animeModels[i];
                  final selected = _voiceModel.id == m.id;
                  return GestureDetector(
                    onTap: () => setState(() => _voiceModel = m),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? m.accentColor.withValues(alpha: 0.15)
                            : fieldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: selected
                            ? Border.all(color: m.accentColor, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: m.accentColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                m.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Icon(
                                  Icons.face_retouching_natural,
                                  color: m.accentColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(m.name,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: selected ? m.accentColor : subColor,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dummy suara info
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 14, color: Color(0xFFFF9F1C)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suara karakter akan tersedia setelah backend siap. Saat ini menggunakan suara default.',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF856404)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  widget.existing == null ? 'Simpan Alarm' : 'Perbarui Alarm',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _time = e?.time ?? TimeOfDay.now();
    _labelCtrl = TextEditingController(text: e?.label ?? 'Alarm Baru');
    _days = e?.days ?? List.filled(7, false);
    _voiceModel = e?.voiceModel ?? animeModels[0];
    _isActive = e?.isActive ?? true;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B35),
            brightness: Theme.of(context).brightness,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    final item = AlarmItem(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      time: _time,
      label: _labelCtrl.text.trim().isEmpty
          ? 'Alarm'
          : _labelCtrl.text.trim(),
      days: List.from(_days),
      isActive: _isActive,
      voiceModel: _voiceModel,
    );
    widget.onSave(item);
  }
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmItem> _alarms = [
    AlarmItem(
      id: 'a1',
      time: const TimeOfDay(hour: 6, minute: 0),
      label: 'Bangun Pagi',
      days: [true, true, true, true, true, false, false],
      isActive: true,
      voiceModel: animeModels[0],
    ),
    AlarmItem(
      id: 'a2',
      time: const TimeOfDay(hour: 8, minute: 30),
      label: 'Sarapan',
      days: [false, false, false, false, false, true, true],
      isActive: true,
      voiceModel: animeModels[1],
    ),
    AlarmItem(
      id: 'a3',
      time: const TimeOfDay(hour: 22, minute: 0),
      label: 'Tidur',
      days: [true, true, true, true, true, true, true],
      isActive: false,
      voiceModel: animeModels[2],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text('Alarm',
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 26),
            color: const Color(0xFFFF6B35),
            onPressed: _addAlarm,
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? _EmptyAlarm(subColor: subColor, onAdd: _addAlarm)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alarms.length,
              itemBuilder: (_, i) => _AlarmCard(
                alarm: _alarms[i],
                isDark: isDark,
                textColor: textColor,
                subColor: subColor,
                onToggle: (val) =>
                    setState(() => _alarms[i].isActive = val),
                onTap: () => _editAlarm(i),
                onDelete: () => _deleteAlarm(i),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _addAlarm() async {
    final result = await showModalBottomSheet<AlarmItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AlarmFormSheet(
        onSave: (item) => Navigator.pop(context, item),
      ),
    );
    if (result != null) {
      setState(() => _alarms.add(result));
    }
  }

  void _deleteAlarm(int index) {
    setState(() => _alarms.removeAt(index));
  }

  void _editAlarm(int index) async {
    final result = await showModalBottomSheet<AlarmItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AlarmFormSheet(
        existing: _alarms[index],
        onSave: (item) => Navigator.pop(context, item),
      ),
    );
    if (result != null) {
      setState(() => _alarms[index] = result);
    }
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyAlarm extends StatelessWidget {
  final Color subColor;
  final VoidCallback onAdd;
  const _EmptyAlarm({required this.subColor, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_off_rounded,
              size: 64, color: subColor.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Belum ada alarm',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: subColor)),
          const SizedBox(height: 8),
          Text('Tambah alarm dan biarkan\nkarakter anime membangunkanmu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subColor)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Alarm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
