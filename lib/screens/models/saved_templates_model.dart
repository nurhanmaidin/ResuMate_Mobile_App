import 'dart:convert';
import 'package:resumate/mock_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedTemplatesModel {
  static List<Map<String, String>> _templates = [];

  static List<Map<String, String>> get all => _templates;

  // Key is user-specific using Firebase UID
  static String get _prefsKey {
    final uid = MockAuthService.currentUserEmail();
    return 'saved_templates_$uid';
  }

  /// Loads saved templates from SharedPreferences for current user
  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedJson = prefs.getStringList(_prefsKey) ?? [];

    _templates = savedJson.map((item) {
      return Map<String, String>.from(jsonDecode(item));
    }).toList();
  }

  /// Saves templates to SharedPreferences for current user
  static Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = _templates
        .map((template) => jsonEncode(template))
        .toList();
    await prefs.setStringList(_prefsKey, encoded);
  }

  /// Adds a template only if it's not already saved (based on title + image)
  static Future<bool> addTemplate(Map<String, String> template) async {
    // Prevent duplicates
    bool exists = _templates.any(
      (t) => t['title'] == template['title'] && t['image'] == template['image'],
    );

    if (!exists) {
      _templates.add(template);
      await saveToPrefs();
      return true;
    }
    return false;
  }

  /// Removes a template at index
  static void removeTemplate(int index) {
    if (index >= 0 && index < _templates.length) {
      _templates.removeAt(index);
    }
  }

  /// Clears all templates (if needed)
  static Future<void> clearAll() async {
    _templates.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
