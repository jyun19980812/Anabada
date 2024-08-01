import 'package:shared_preferences/shared_preferences.dart';

class SettingOptions {
  Future<bool> isKgEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isKgEnabled') ?? false;
  }

  Future<void> setKgEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isKgEnabled', isEnabled);
  }
}
