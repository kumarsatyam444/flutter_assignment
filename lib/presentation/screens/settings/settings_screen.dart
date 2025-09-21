import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: Consumer3<AuthProvider, ThemeProvider, DashboardProvider>(
        builder: (context, authProvider, themeProvider, dashboardProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Profile Section
              _buildUserProfileCard(context, authProvider),
              const SizedBox(height: 24),

              // Theme Section
              _buildSectionTitle(context, 'Appearance'),
              _buildThemeSection(context, themeProvider),
              const SizedBox(height: 24),

              // App Info Section
              _buildSectionTitle(context, 'About'),
              _buildAppInfoSection(context),
              const SizedBox(height: 24),

              // Logout Section
              _buildLogoutSection(context, authProvider, dashboardProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    
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
                    user?.name ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
            ),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Report Issue'),
            subtitle: const Text('Send feedback or report a bug'),
            onTap: () {
              _showReportIssueDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    AuthProvider authProvider,
    DashboardProvider dashboardProvider,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Theme.of(context).colorScheme.error,
        ),
        title: Text(
          AppStrings.logout,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text('Sign out of your account'),
        onTap: () => _showLogoutDialog(context, authProvider, dashboardProvider),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.insights,
        size: 64,
        color: Theme.of(context).primaryColor,
      ),
      children: [
        const Text(
          'AI Insights is a productivity tracking app that provides AI-generated insights '
          'into your work patterns and offers personalized recommendations.',
        ),
        const SizedBox(height: 16),
        const Text('Built with Flutter 💙'),
      ],
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: const Text(
          'To report an issue or provide feedback, please contact us at:\n\nsupport@aiinsights.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
    DashboardProvider dashboardProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              
              await authProvider.logout();
              dashboardProvider.reset();
              
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
