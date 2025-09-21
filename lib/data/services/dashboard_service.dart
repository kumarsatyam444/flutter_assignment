import 'dart:async';
import 'dart:math';
import '../models/insight_model.dart';

class DashboardService {
  static final Random _random = Random();

  /// Mock dashboard data - simulates API call
  static Future<DashboardDataModel> getDashboardData(String userName) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    return DashboardDataModel(
      userName: userName,
      insights: _generateMockInsights(),
      recommendations: _generateMockRecommendations(),
    );
  }

  /// Generate random insights to simulate dynamic data
  static List<InsightModel> _generateMockInsights() {
    final insights = [
      InsightModel(
        title: 'Productivity Score',
        value: '${85 + _random.nextInt(10)}%',
        change: '${_random.nextBool() ? '+' : '-'}${1 + _random.nextInt(10)}%',
        trend: _randomTrend(),
      ),
      InsightModel(
        title: 'Focus Time',
        value: '${3 + _random.nextDouble() * 2}${_random.nextBool() ? '.5' : '.0'} hrs',
        change: '${_random.nextBool() ? '+' : '-'}${5 + _random.nextInt(15)}%',
        trend: _randomTrend(),
      ),
      InsightModel(
        title: 'Distraction Level',
        value: _randomDistractionLevel(),
        change: _randomStabilityChange(),
        trend: _randomTrend(),
      ),
      InsightModel(
        title: 'Tasks Completed',
        value: '${15 + _random.nextInt(20)}',
        change: '${_random.nextBool() ? '+' : '-'}${1 + _random.nextInt(5)}',
        trend: _randomTrend(),
      ),
      InsightModel(
        title: 'Energy Level',
        value: '${70 + _random.nextInt(25)}%',
        change: '${_random.nextBool() ? '+' : '-'}${2 + _random.nextInt(8)}%',
        trend: _randomTrend(),
      ),
    ];

    // Return 3-5 insights randomly
    insights.shuffle();
    return insights.take(3 + _random.nextInt(3)).toList();
  }

  /// Generate mock recommendations
  static List<String> _generateMockRecommendations() {
    final allRecommendations = [
      'Try a Pomodoro technique today.',
      'Reduce multitasking during meetings.',
      'Review yesterday\'s focus periods.',
      'Take a 5-minute break every hour.',
      'Consider blocking distracting websites.',
      'Schedule your most important tasks for the morning.',
      'Use noise-canceling headphones for better focus.',
      'Set specific time blocks for checking emails.',
      'Practice deep breathing exercises between tasks.',
      'Keep your workspace clean and organized.',
      'Stay hydrated throughout the day.',
      'Plan tomorrow\'s priorities before ending today.',
    ];

    allRecommendations.shuffle();
    return allRecommendations.take(3 + _random.nextInt(3)).toList();
  }

  static TrendType _randomTrend() {
    final trends = TrendType.values;
    return trends[_random.nextInt(trends.length)];
  }

  static String _randomDistractionLevel() {
    final levels = ['Very Low', 'Low', 'Medium', 'High'];
    return levels[_random.nextInt(levels.length)];
  }

  static String _randomStabilityChange() {
    final changes = ['Stable', 'Improving', 'Declining', 'Fluctuating'];
    return changes[_random.nextInt(changes.length)];
  }

  /// Simulate refreshing data
  static Future<DashboardDataModel> refreshDashboard(String userName) async {
    return await getDashboardData(userName);
  }
}
