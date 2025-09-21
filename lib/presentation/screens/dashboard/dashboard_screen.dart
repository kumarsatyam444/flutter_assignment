import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/dashboard/insight_card.dart';
import '../../widgets/dashboard/recommendation_tile.dart';
import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _insightAnimationController;
  late AnimationController _recommendationAnimationController;

  @override
  void initState() {
    super.initState();

    _insightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _recommendationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  @override
  void dispose() {
    _insightAnimationController.dispose();
    _recommendationAnimationController.dispose();
    super.dispose();
  }

  void _loadDashboard() {
    final authProvider = context.read<AuthProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    if (authProvider.user != null) {
      dashboardProvider.loadDashboard(authProvider.user!.name).then((_) {
        if (mounted) {
          _insightAnimationController.forward();
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _recommendationAnimationController.forward();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, DashboardProvider>(
        builder: (context, authProvider, dashboardProvider, child) {
          // Navigate to login if not authenticated
          if (!authProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            });
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: () => _handleRefresh(dashboardProvider, authProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  _buildWelcomeHeader(authProvider),
                  const SizedBox(height: 24),

                  // Dashboard Content
                  if (dashboardProvider.isLoading && !dashboardProvider.hasData)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: LoadingWidget(message: 'Loading insights...'),
                      ),
                    )
                  else if (dashboardProvider.errorMessage != null && !dashboardProvider.hasData)
                    _buildErrorWidget(dashboardProvider)
                  else if (dashboardProvider.hasData)
                    _buildDashboardContent(dashboardProvider)
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Text('No data available'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(AuthProvider authProvider) {
    final user = authProvider.user;
    final greeting = _getGreeting();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                        ),
                  ),
                  Text(
                    user?.name ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardProvider dashboardProvider) {
    final data = dashboardProvider.dashboardData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Insights Section
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.insights,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (dashboardProvider.isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Insights Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: data.insights.length,
          itemBuilder: (context, index) {
            final insight = data.insights[index];
            return InsightCard(
              insight: insight,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _insightAnimationController,
                  curve: Interval(
                    (index * 0.2).clamp(0.0, 1.0),
                    ((index * 0.2) + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Recommendations Section
        Text(
          AppStrings.recommendations,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Recommendations List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.recommendations.length,
          itemBuilder: (context, index) {
            return RecommendationTile(
              recommendation: data.recommendations[index],
              index: index,
              animation: _recommendationAnimationController,
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorWidget(DashboardProvider dashboardProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              dashboardProvider.errorMessage ?? AppStrings.somethingWentWrong,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final authProvider = context.read<AuthProvider>();
                if (authProvider.user != null) {
                  dashboardProvider.loadDashboard(authProvider.user!.name);
                }
              },
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> _handleRefresh(DashboardProvider dashboardProvider, AuthProvider authProvider) async {
    if (authProvider.user != null) {
      await dashboardProvider.refreshDashboard(authProvider.user!.name);
      if (mounted) {
        _insightAnimationController.reset();
        _recommendationAnimationController.reset();
        _insightAnimationController.forward();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _recommendationAnimationController.forward();
          }
        });
      }
    }
  }
}
