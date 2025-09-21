import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';
  static const String _themeKey = 'theme_mode';

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // Auth related methods
  static Future<bool> setLoginStatus(bool isLoggedIn) async {
    return await preferences.setBool(_isLoggedInKey, isLoggedIn);
  }

  static bool getLoginStatus() {
    return preferences.getBool(_isLoggedInKey) ?? false;
  }

  static Future<bool> saveUserData(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    return await preferences.setString(_userDataKey, userJson);
  }

  static UserModel? getUserData() {
    final userJson = preferences.getString(_userDataKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  // Theme related methods
  static Future<bool> setThemeMode(bool isDarkMode) async {
    return await preferences.setBool(_themeKey, isDarkMode);
  }

  static bool isDarkMode() {
    return preferences.getBool(_themeKey) ?? false;
  }

  // Clear all data
  static Future<bool> clearAllData() async {
    return await preferences.clear();
  }

  // Logout - clear auth data but keep theme preference
  static Future<void> logout() async {
    await preferences.remove(_isLoggedInKey);
    await preferences.remove(_userDataKey);
  }
}
