import 'package:flutter/material.dart';

class FontSizeProvider with ChangeNotifier {
  String _fontSize = 'M';

  // 기본 폰트 크기 바꾸고 싶으면 각 화면의 Widget build 밑의 final 변수 확인
  String get fontSize => _fontSize;

  void setFontSize(String newSize) {
    _fontSize = newSize;
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
