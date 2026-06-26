import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  final FlutterSecureStorage _storage;

  ThemeController(this._storage) : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  Future<void> loadTheme() async {
    final savedTheme = await _storage.read(key: _themeKey);
    value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool enabled) async {
    value = enabled ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(key: _themeKey, value: enabled ? 'dark' : 'light');
  }

  Future<void> toggleTheme() => setDarkMode(!isDark);
}
