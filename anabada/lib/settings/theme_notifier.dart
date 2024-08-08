import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = isEnabled;
    await prefs.setBool('isDarkMode', isEnabled);
    notifyListeners();
  }
}
