import '../models/user_model.dart';
import '../services/auth_service.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResult> login(String email, String password);
  Future<bool> isLoggedIn();
  UserModel? getCurrentUser();
  Future<void> logout();
  Future<UserModel?> autoLogin();
}

class AuthRepository implements AuthRepositoryInterface {
  @override
  Future<AuthResult> login(String email, String password) async {
    return await AuthService.login(email, password);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await AuthService.isLoggedIn();
  }

  @override
  UserModel? getCurrentUser() {
    return AuthService.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    await AuthService.logout();
  }

  @override
  Future<UserModel?> autoLogin() async {
    return await AuthService.autoLogin();
  }
}
