import 'package:flutter/material.dart';
import '../../data/models/insight_model.dart';
import '../../data/repositories/dashboard_repository.dart';

enum DashboardState { initial, loading, loaded, error, refreshing }

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository;
  
  DashboardState _state = DashboardState.initial;
  DashboardDataModel? _dashboardData;
  String? _errorMessage;

  DashboardProvider(this._dashboardRepository);

  DashboardState get state => _state;
  DashboardDataModel? get dashboardData => _dashboardData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == DashboardState.loading;
  bool get isRefreshing => _state == DashboardState.refreshing;
  bool get hasData => _dashboardData != null;

  Future<void> loadDashboard(String userName) async {
    _setState(DashboardState.loading);
    _clearError();

    try {
      _dashboardData = await _dashboardRepository.getDashboardData(userName);
      _setState(DashboardState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
    }
  }

  Future<void> refreshDashboard(String userName) async {
    if (_state == DashboardState.loading) return;
    
    _setState(DashboardState.refreshing);
    _clearError();

    try {
      _dashboardData = await _dashboardRepository.refreshDashboard(userName);
      _setState(DashboardState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
    }
  }

  void _setState(DashboardState newState) {
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

  void reset() {
    _state = DashboardState.initial;
    _dashboardData = null;
    _clearError();
    notifyListeners();
  }
}
