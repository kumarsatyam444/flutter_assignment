import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_assignment/data/services/auth_service.dart';
import 'package:flutter_assignment/data/services/storage_service.dart';
import 'package:flutter_assignment/core/constants/app_strings.dart';

void main() {
  group('AuthService Tests', () {
    setUp(() async {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      await StorageService.init();
    });

    test('should return success for valid credentials', () async {
      final result = await AuthService.login(
        AppStrings.mockEmail,
        AppStrings.mockPassword,
      );

      expect(result.success, true);
      expect(result.user, isNotNull);
      expect(result.user!.email, AppStrings.mockEmail);
      expect(result.user!.name, 'John Doe');
      expect(result.error, isNull);
    });

    test('should return failure for invalid credentials', () async {
      final result = await AuthService.login(
        'invalid@email.com',
        'wrongpassword',
      );

      expect(result.success, false);
      expect(result.user, isNull);
      expect(result.error, AppStrings.invalidCredentials);
    });

    test('should return failure for invalid email format', () async {
      final result = await AuthService.login(
        'invalid-email',
        AppStrings.mockPassword,
      );

      expect(result.success, false);
      expect(result.user, isNull);
      expect(result.error, AppStrings.invalidCredentials);
    });

    test('should save login state after successful login', () async {
      await AuthService.login(
        AppStrings.mockEmail,
        AppStrings.mockPassword,
      );

      final isLoggedIn = await AuthService.isLoggedIn();
      expect(isLoggedIn, true);

      final user = AuthService.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.email, AppStrings.mockEmail);
    });

    test('should clear login state after logout', () async {
      // First login
      await AuthService.login(
        AppStrings.mockEmail,
        AppStrings.mockPassword,
      );
      
      expect(await AuthService.isLoggedIn(), true);

      // Then logout
      await AuthService.logout();

      expect(await AuthService.isLoggedIn(), false);
      expect(AuthService.getCurrentUser(), isNull);
    });

    test('should return user data on auto login if logged in', () async {
      // Login first
      await AuthService.login(
        AppStrings.mockEmail,
        AppStrings.mockPassword,
      );

      // Test auto login
      final user = await AuthService.autoLogin();
      expect(user, isNotNull);
      expect(user!.email, AppStrings.mockEmail);
    });

    test('should return null on auto login if not logged in', () async {
      final user = await AuthService.autoLogin();
      expect(user, isNull);
    });
  });
}
