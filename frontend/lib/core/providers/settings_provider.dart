import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('ar');

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  // المفتاح المستخدم في SharedPreferences
  static const String _keyDark = 'pref_dark_mode';
  static const String _keyLocale = 'pref_locale';

  SettingsProvider();

  // استدعاء عند التشغيل لقراءة القيم من SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_keyDark) ?? false;
    final code = prefs.getString(_keyLocale) ?? 'ar';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDark, value);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await setDarkMode(!_isDarkMode);
  }

  Future<void> setLocale(Locale value) async {
    _locale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, value.languageCode);
    notifyListeners();
  }
}
