import 'dart:async';
import '../models/user_model.dart';
import '../../core/constants/app_strings.dart';
import 'storage_service.dart';

class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;

  const AuthResult({
    required this.success,
    this.error,
    this.user,
  });

  factory AuthResult.success(UserModel user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}

class AuthService {
  static const List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'test@example.com',
      'password': 'password123',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'password': 'password123',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'email': 'mike@example.com',
      'password': 'password123',
    },
  ];

  /// Mock login - simulates API call delay
  static Future<AuthResult> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Find user in mock data
      final userMap = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userMap.isEmpty) {
        return AuthResult.failure(AppStrings.invalidCredentials);
      }

      final user = UserModel(
        id: userMap['id']!,
        name: userMap['name']!,
        email: userMap['email']!,
      );

      // Save login state
      await StorageService.setLoginStatus(true);
      await StorageService.saveUserData(user);

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(AppStrings.somethingWentWrong);
    }
  }

  /// Check if user is currently logged in
  static Future<bool> isLoggedIn() async {
    return StorageService.getLoginStatus();
  }

  /// Get current user data
  static UserModel? getCurrentUser() {
    return StorageService.getUserData();
  }

  /// Logout user
  static Future<void> logout() async {
    await StorageService.logout();
  }

  /// Auto-login check - returns user if already logged in
  static Future<UserModel?> autoLogin() async {
    if (await isLoggedIn()) {
      return getCurrentUser();
    }
    return null;
  }
}
