import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/anime_model.dart';
import '../providers/app_preferences.dart';

// ── Background presets ────────────────────────────────────────────────────────
class _BgPreset {
  final String label;
  final Color color;
  final Color darkColor;
  const _BgPreset({required this.label, required this.color, required this.darkColor});
}

const List<_BgPreset> _presets = [
  _BgPreset(label: 'Default', color: Color(0xFFF8F9FA), darkColor: Color(0xFF121212)),
  _BgPreset(label: 'Sakura',  color: Color(0xFFFFF0F5), darkColor: Color(0xFF2A1520)),
  _BgPreset(label: 'Ocean',   color: Color(0xFFEFF8FF), darkColor: Color(0xFF0D1F2D)),
  _BgPreset(label: 'Forest',  color: Color(0xFFF0FFF4), darkColor: Color(0xFF0D2018)),
  _BgPreset(label: 'Sunset',  color: Color(0xFFFFF5EE), darkColor: Color(0xFF2D1A0D)),
  _BgPreset(label: 'Night',   color: Color(0xFFF5F0FF), darkColor: Color(0xFF150D2A)),
];

// ── Chat Screen ───────────────────────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  final AnimeModel model;
  final bool embedded;
  const ChatScreen({super.key, required this.model, this.embedded = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Msg> _messages = [];
  bool _isTyping = false;
  int _replyIndex = 0;

  // View mode: 'immersive' = berhadapan, 'chat' = teks
  String _viewMode = 'immersive';

  // Background
  int _presetIndex = 0;
  String? _customBgPath;

  // Typing dots animation
  late List<AnimationController> _dotCtrls;
  late List<Animation<double>> _dotAnims;

  @override
  void initState() {
    super.initState();
    _initDots();
    _loadPrefs();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _addModelMsg(widget.model.openingLine);
    });
  }

  void _initDots() {
    _dotCtrls = List.generate(3, (i) => AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500)));
    _dotAnims = List.generate(3, (i) => Tween<double>(begin: 0, end: -5)
      .animate(CurvedAnimation(parent: _dotCtrls[i], curve: Curves.easeInOut)));
  }

  void _startDots() {
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) _dotCtrls[i].repeat(reverse: true);
      });
    }
  }

  void _stopDots() {
    for (final c in _dotCtrls) { c.stop(); c.reset(); }
  }

  Future<void> _loadPrefs() async {
    final mode = await AppPreferences.getViewMode();
    final preset = await AppPreferences.getBgPreset(widget.model.id);
    final custom = await AppPreferences.getBgCustom(widget.model.id);
    if (mounted) {
      setState(() {
        _viewMode = mode;
        _presetIndex = preset;
        _customBgPath = custom;
      });
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    for (final c in _dotCtrls) { c.dispose(); }
    super.dispose();
  }

  void _addModelMsg(String text) {
    setState(() => _messages.add(_Msg(text: text, isUser: false)));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: text, isUser: true));
      _input.clear();
      _isTyping = true;
    });
    _startDots();
    _scrollToBottom();

    await Future.delayed(Duration(milliseconds: 900 + (text.length * 15).clamp(0, 1000)));
    if (!mounted) return;

    _stopDots();
    final replies = widget.model.dummyReplies;
    setState(() {
      _isTyping = false;
      _messages.add(_Msg(text: replies[_replyIndex % replies.length], isUser: false));
      _replyIndex++;
    });
    _scrollToBottom();
  }

  void _toggleMode() {
    final next = _viewMode == 'immersive' ? 'chat' : 'immersive';
    setState(() => _viewMode = next);
    AppPreferences.setViewMode(next);
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showBgPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BgPickerSheet(
        presetIndex: _presetIndex,
        hasCustom: _customBgPath != null,
        accentColor: widget.model.accentColor,
        onSelectPreset: (i) async {
          setState(() { _presetIndex = i; _customBgPath = null; });
          await AppPreferences.setBgPreset(widget.model.id, i);
          if (mounted) Navigator.pop(context);
        },
        onPickGallery: () async {
          Navigator.pop(context);
          await _pickFromGallery();
        },
        onRemoveCustom: () async {
          setState(() => _customBgPath = null);
          await AppPreferences.removeBgCustom(widget.model.id);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() => _customBgPath = picked.path);
        await AppPreferences.setBgCustom(widget.model.id, picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e'), backgroundColor: Colors.redAccent));
      }
    }
  }

  Widget _buildBg(bool isDark) {
    if (_customBgPath != null) {
      if (kIsWeb) {
        return Image.network(_customBgPath!, fit: BoxFit.cover,
            width: double.infinity, height: double.infinity,
            errorBuilder: (_, __, ___) => _presetBg(isDark));
      } else {
        return Image.file(File(_customBgPath!), fit: BoxFit.cover,
            width: double.infinity, height: double.infinity,
            errorBuilder: (_, __, ___) => _presetBg(isDark));
      }
    }
    return _presetBg(isDark);
  }

  Widget _presetBg(bool isDark) {
    final color = isDark ? _presets[_presetIndex].darkColor : _presets[_presetIndex].color;
    return Container(color: color);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.model.accentColor;
    final barBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final isImmersive = _viewMode == 'immersive';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.embedded ? null : _buildAppBar(isDark, accent, barBg, isImmersive),
      body: Stack(
        children: [
          Positioned.fill(child: _buildBg(isDark)),
          if (_customBgPath != null)
            Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.15))),
          isImmersive ? _buildImmersive(isDark, accent, barBg) : _buildChatMode(isDark, accent, barBg),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark, Color accent, Color barBg, bool isImmersive) {
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    return AppBar(
      backgroundColor: barBg,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: ClipOval(child: Image.asset(widget.model.imagePath, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(Icons.face_retouching_natural, color: accent, size: 18))),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.model.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)),
            Text(widget.model.personality, style: TextStyle(fontSize: 10, color: accent, fontWeight: FontWeight.w500)),
          ]),
        ],
      ),
      actions: [
        // Toggle mode button
        GestureDetector(
          onTap: _toggleMode,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(isImmersive ? Icons.chat_bubble_outline_rounded : Icons.face_retouching_natural,
                  color: accent, size: 14),
              const SizedBox(width: 4),
              Text(isImmersive ? 'Chat' : 'Berhadapan',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent)),
            ]),
          ),
        ),
        // Background button
        IconButton(
          icon: Icon(Icons.wallpaper_rounded, color: accent, size: 20),
          tooltip: 'Ganti Background',
          onPressed: _showBgPicker,
        ),
        // Home button
        IconButton(
          icon: Icon(Icons.home_rounded, color: textColor, size: 22),
          tooltip: 'Beranda',
          onPressed: () => _goHome(context),
        ),
      ],
    );
  }

  // ── Mode Berhadapan (Immersive) ───────────────────────────────────────────
  Widget _buildImmersive(bool isDark, Color accent, Color barBg) {
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);
    final inputBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
    final lastMsg = _messages.isNotEmpty ? _messages.last : null;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Karakter besar di tengah-bawah
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Center(
                  child: Image.asset(
                    widget.model.imagePath,
                    height: MediaQuery.of(context).size.height * 0.55,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.face_retouching_natural, size: 220,
                      color: accent.withValues(alpha: 0.25)),
                  ),
                ),
              ),

              // Nama & tipe di kiri bawah
              Positioned(
                bottom: 12, left: 16,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.model.name, style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: accent,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8)])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(widget.model.personality,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent)),
                  ),
                ]),
              ),

              // Speech bubble di atas
              if (lastMsg != null || _isTyping)
                Positioned(
                  top: 16, left: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.92),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16), topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4)),
                      boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: _isTyping
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${widget.model.name} mengetik',
                                style: TextStyle(fontSize: 13, color: subColor)),
                            const SizedBox(width: 8),
                            Row(mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (i) => AnimatedBuilder(
                                animation: _dotAnims[i],
                                builder: (_, __) => Transform.translate(
                                  offset: Offset(0, _dotAnims[i].value),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    width: 6, height: 6,
                                    decoration: BoxDecoration(color: accent.withValues(alpha: 0.6), shape: BoxShape.circle),
                                  ),
                                ),
                              ))),
                          ])
                        : Text(
                            lastMsg!.isUser ? '"${lastMsg.text}"' : lastMsg.text,
                            style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
                          ),
                  ),
                ),
            ],
          ),
        ),

        // Input bar
        _buildInputBar(isDark, accent, barBg, inputBg),
      ],
    );
  }

  // ── Mode Chat (teks) ──────────────────────────────────────────────────────
  Widget _buildChatMode(bool isDark, Color accent, Color barBg) {
    final inputBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (_, i) {
              if (_isTyping && i == _messages.length) {
                return _TypingBubble(color: accent, anims: _dotAnims);
              }
              return _Bubble(
                msg: _messages[i], accentColor: accent,
                imagePath: widget.model.imagePath,
                isDark: isDark, hasCustomBg: _customBgPath != null,
              );
            },
          ),
        ),
        _buildInputBar(isDark, accent, barBg, inputBg),
      ],
    );
  }

  Widget _buildInputBar(bool isDark, Color accent, Color barBg, Color inputBg) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: barBg.withValues(alpha: 0.95),
        border: Border(top: BorderSide(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE9ECEF))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _input,
              onSubmitted: (_) => _send(),
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF212529), fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Katakan sesuatu kepada ${widget.model.name}...',
                hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 13),
                filled: true, fillColor: inputBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background Picker Sheet ───────────────────────────────────────────────────
class _BgPickerSheet extends StatelessWidget {
  final int presetIndex;
  final bool hasCustom;
  final Color accentColor;
  final ValueChanged<int> onSelectPreset;
  final VoidCallback onPickGallery;
  final VoidCallback onRemoveCustom;

  const _BgPickerSheet({
    required this.presetIndex, required this.hasCustom,
    required this.accentColor, required this.onSelectPreset,
    required this.onPickGallery, required this.onRemoveCustom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final subColor = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: sheetBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: const Color(0xFFDEE2E6), borderRadius: BorderRadius.circular(2)))),
          Text('Background Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onPickGallery,
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.photo_library_rounded, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(hasCustom ? 'Ganti Foto dari Galeri' : 'Pilih Foto dari Galeri',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: accentColor)),
              ]),
            ),
          ),
          if (hasCustom) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onRemoveCustom,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3), width: 1.5)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 8),
                  Text('Hapus Foto Custom', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                ]),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: Divider(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE9ECEF))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('atau pilih warna', style: TextStyle(fontSize: 11, color: subColor))),
            Expanded(child: Divider(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE9ECEF))),
          ]),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4),
            itemCount: _presets.length,
            itemBuilder: (_, i) {
              final preset = _presets[i];
              final selected = !hasCustom && presetIndex == i;
              final displayColor = isDark ? preset.darkColor : preset.color;
              return GestureDetector(
                onTap: () => onSelectPreset(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: displayColor, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? accentColor : const Color(0xFFDEE2E6), width: selected ? 2.5 : 1)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (selected) Icon(Icons.check_circle, color: accentColor, size: 18),
                    const SizedBox(height: 2),
                    Text(preset.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF495057))),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Chat Bubble ───────────────────────────────────────────────────────────────
class _Bubble extends StatelessWidget {
  final _Msg msg;
  final Color accentColor;
  final String imagePath;
  final bool isDark;
  final bool hasCustomBg;

  const _Bubble({required this.msg, required this.accentColor,
      required this.imagePath, required this.isDark, required this.hasCustomBg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.isUser;
    final bubbleBg = isUser ? accentColor
        : (isDark || hasCustomBg ? Colors.black.withValues(alpha: 0.55) : Colors.white);
    final textColor = isUser ? Colors.white
        : (isDark || hasCustomBg ? Colors.white : const Color(0xFF212529));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(width: 30, height: 30,
              decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(Icons.face_retouching_natural, color: accentColor, size: 16)))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4), bottomRight: Radius.circular(isUser ? 4 : 16)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))]),
              child: Text(msg.text, style: TextStyle(fontSize: 14, color: textColor, height: 1.4)),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ── Typing Bubble ─────────────────────────────────────────────────────────────
class _TypingBubble extends StatelessWidget {
  final Color color;
  final List<Animation<double>> anims;
  const _TypingBubble({required this.color, required this.anims});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(width: 30, height: 30,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(Icons.face_retouching_natural, color: color, size: 16)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16),
              bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))]),
          child: Row(mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => AnimatedBuilder(
              animation: anims[i],
              builder: (_, __) => Transform.translate(
                offset: Offset(0, anims[i].value),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 7, height: 7,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.5), shape: BoxShape.circle),
                ),
              ),
            ))),
        ),
      ]),
    );
  }
}

// ── Message model ─────────────────────────────────────────────────────────────
class _Msg {
  final String text;
  final bool isUser;
  _Msg({required this.text, required this.isUser});
}
