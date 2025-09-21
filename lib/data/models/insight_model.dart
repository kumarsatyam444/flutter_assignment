enum TrendType { up, down, flat }

class InsightModel {
  final String title;
  final String value;
  final String change;
  final TrendType trend;

  const InsightModel({
    required this.title,
    required this.value,
    required this.change,
    required this.trend,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      title: json['title'] as String,
      value: json['value'] as String,
      change: json['change'] as String,
      trend: TrendType.values.firstWhere(
        (e) => e.name == json['trend'],
        orElse: () => TrendType.flat,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'change': change,
      'trend': trend.name,
    };
  }

  InsightModel copyWith({
    String? title,
    String? value,
    String? change,
    TrendType? trend,
  }) {
    return InsightModel(
      title: title ?? this.title,
      value: value ?? this.value,
      change: change ?? this.change,
      trend: trend ?? this.trend,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          value == other.value &&
          change == other.change &&
          trend == other.trend;

  @override
  int get hashCode => Object.hash(title, value, change, trend);

  @override
  String toString() => 'InsightModel(title: $title, value: $value, change: $change, trend: $trend)';
}

class DashboardDataModel {
  final String userName;
  final List<InsightModel> insights;
  final List<String> recommendations;

  const DashboardDataModel({
    required this.userName,
    required this.insights,
    required this.recommendations,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      userName: json['userName'] as String,
      insights: (json['insights'] as List)
          .map((e) => InsightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'insights': insights.map((e) => e.toJson()).toList(),
      'recommendations': recommendations,
    };
  }

  DashboardDataModel copyWith({
    String? userName,
    List<InsightModel>? insights,
    List<String>? recommendations,
  }) {
    return DashboardDataModel(
      userName: userName ?? this.userName,
      insights: insights ?? this.insights,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardDataModel &&
          runtimeType == other.runtimeType &&
          userName == other.userName &&
          insights == other.insights &&
          recommendations == other.recommendations;

  @override
  int get hashCode => Object.hash(userName, insights, recommendations);

  @override
  String toString() => 'DashboardDataModel(userName: $userName, insights: $insights, recommendations: $recommendations)';
}
