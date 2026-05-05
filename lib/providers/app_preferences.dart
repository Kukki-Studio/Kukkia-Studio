import 'package:shared_preferences/shared_preferences.dart';

/// Simpan preferensi user secara persisten.
/// Dipakai untuk mode chat, background, dll.
class AppPreferences {
  static const _keyViewMode = 'chat_view_mode';      // 'immersive' | 'chat'
  static const _keyBgPreset = 'chat_bg_preset_';     // + modelId
  static const _keyBgCustom = 'chat_bg_custom_';     // + modelId (path)
  static const _keyUnlocked = 'unlocked_models';     // comma-separated ids

  // ── View mode ─────────────────────────────────────────────────────────────

  static Future<String> getViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyViewMode) ?? 'immersive'; // default: berhadapan
  }

  static Future<void> setViewMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyViewMode, mode);
  }

  // ── Background preset per model ───────────────────────────────────────────

  static Future<int> getBgPreset(String modelId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_keyBgPreset$modelId') ?? 0;
  }

  static Future<void> setBgPreset(String modelId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_keyBgPreset$modelId', index);
    // Hapus custom bg kalau pilih preset
    await prefs.remove('$_keyBgCustom$modelId');
  }

  // ── Background custom path per model ─────────────────────────────────────

  static Future<String?> getBgCustom(String modelId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_keyBgCustom$modelId');
  }

  static Future<void> setBgCustom(String modelId, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_keyBgCustom$modelId', path);
  }

  static Future<void> removeBgCustom(String modelId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyBgCustom$modelId');
  }

  // ── Unlocked models ───────────────────────────────────────────────────────

  static Future<Set<String>> getUnlockedModels() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUnlocked) ?? '';
    if (raw.isEmpty) return {};
    return raw.split(',').toSet();
  }

  static Future<void> addUnlockedModel(String modelId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUnlockedModels();
    current.add(modelId);
    await prefs.setString(_keyUnlocked, current.join(','));
  }
}
