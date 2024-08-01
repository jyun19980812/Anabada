import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider with ChangeNotifier {
  static const String _fontSizeKey = 'fontSize';
  String _fontSize = 'M';

  FontSizeProvider() {
    _loadFontSize();
  }

  String get fontSize => _fontSize;

  Future<void> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getString(_fontSizeKey) ?? 'M';
    notifyListeners();
  }

  Future<void> setFontSize(String newSize) async {
    _fontSize = newSize;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontSizeKey, newSize);
    notifyListeners();
  }

  double getFontSize(double baseSize) {
    switch (_fontSize) {
      case 'S':
        return baseSize * 0.8;
      case 'L':
        return baseSize * 1.2;
      case 'M':
      default:
        return baseSize;
    }
  }
}
