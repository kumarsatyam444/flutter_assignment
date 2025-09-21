import '../models/insight_model.dart';
import '../services/dashboard_service.dart';

abstract class DashboardRepositoryInterface {
  Future<DashboardDataModel> getDashboardData(String userName);
  Future<DashboardDataModel> refreshDashboard(String userName);
}

class DashboardRepository implements DashboardRepositoryInterface {
  @override
  Future<DashboardDataModel> getDashboardData(String userName) async {
    return await DashboardService.getDashboardData(userName);
  }

  @override
  Future<DashboardDataModel> refreshDashboard(String userName) async {
    return await DashboardService.refreshDashboard(userName);
  }
}
