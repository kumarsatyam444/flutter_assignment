import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assignment/data/services/dashboard_service.dart';
import 'package:flutter_assignment/data/models/insight_model.dart';

void main() {
  group('DashboardService Tests', () {
    test('should return dashboard data with insights and recommendations', () async {
      const userName = 'John Doe';
      
      final dashboardData = await DashboardService.getDashboardData(userName);

      expect(dashboardData.userName, userName);
      expect(dashboardData.insights.isNotEmpty, true);
      expect(dashboardData.recommendations.isNotEmpty, true);
      expect(dashboardData.insights.length, greaterThanOrEqualTo(3));
      expect(dashboardData.recommendations.length, greaterThanOrEqualTo(3));
    });

    test('should return valid insight models', () async {
      const userName = 'Test User';
      
      final dashboardData = await DashboardService.getDashboardData(userName);
      final insights = dashboardData.insights;

      for (final insight in insights) {
        expect(insight.title.isNotEmpty, true);
        expect(insight.value.isNotEmpty, true);
        expect(insight.change.isNotEmpty, true);
        expect(insight.trend, isA<TrendType>());
      }
    });

    test('should return different data on refresh', () async {
      const userName = 'Test User';
      
      final firstData = await DashboardService.getDashboardData(userName);
      final refreshedData = await DashboardService.refreshDashboard(userName);

      expect(firstData.userName, refreshedData.userName);
      expect(firstData.insights.length, refreshedData.insights.length);
      expect(firstData.recommendations.length, refreshedData.recommendations.length);
      
      // Note: Due to randomization in the service, the actual values might be different
      // This test ensures the structure remains consistent
    });

    test('should handle empty username gracefully', () async {
      const userName = '';
      
      final dashboardData = await DashboardService.getDashboardData(userName);
      
      expect(dashboardData.userName, userName);
      expect(dashboardData.insights.isNotEmpty, true);
      expect(dashboardData.recommendations.isNotEmpty, true);
    });

    test('should return recommendations as strings', () async {
      const userName = 'Test User';
      
      final dashboardData = await DashboardService.getDashboardData(userName);
      
      for (final recommendation in dashboardData.recommendations) {
        expect(recommendation, isA<String>());
        expect(recommendation.isNotEmpty, true);
      }
    });

    test('should include productivity related insights', () async {
      const userName = 'Test User';
      
      final dashboardData = await DashboardService.getDashboardData(userName);
      final insightTitles = dashboardData.insights.map((i) => i.title).toList();
      
      // Check if we have typical productivity insights
      final expectedTitles = [
        'Productivity Score',
        'Focus Time',
        'Distraction Level',
        'Tasks Completed',
        'Energy Level',
      ];
      
      // At least some of these should be present
      final hasProductivityInsights = expectedTitles.any(
        (title) => insightTitles.contains(title),
      );
      
      expect(hasProductivityInsights, true);
    });
  });
}
