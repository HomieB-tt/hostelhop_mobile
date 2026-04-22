import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages light/dark theme state and persists preference.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadPreference();
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('hostelhop_dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hostelhop_dark_mode', isDark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hostelhop_dark_mode', isDark);
  }
}
