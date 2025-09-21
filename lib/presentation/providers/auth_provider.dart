import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _checkAuthStatus();
  }

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  Future<void> _checkAuthStatus() async {
    _setState(AuthState.loading);
    
    try {
      final user = await _authRepository.autoLogin();
      if (user != null) {
        _user = user;
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
    }
  }

  Future<bool> login(String email, String password) async {
    _setState(AuthState.loading);
    _clearError();

    try {
      final result = await _authRepository.login(email, password);
      
      if (result.success && result.user != null) {
        _user = result.user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _errorMessage = result.error ?? 'Login failed';
        _setState(AuthState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
      return false;
    }
  }

  Future<void> logout() async {
    _setState(AuthState.loading);
    
    try {
      await _authRepository.logout();
      _user = null;
      _clearError();
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
    }
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
