import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode = StorageService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setThemeMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDarkMode) async {
    if (_isDarkMode != isDarkMode) {
      _isDarkMode = isDarkMode;
      await StorageService.setThemeMode(_isDarkMode);
      notifyListeners();
    }
  }
}
