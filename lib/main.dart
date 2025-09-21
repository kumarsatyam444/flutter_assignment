import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'data/services/storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/dashboard_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  await StorageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Repository Providers
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        Provider<DashboardRepository>(create: (_) => DashboardRepository()),
        
        // State Providers
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update: (context, authRepository, previous) => 
              previous ?? AuthProvider(authRepository),
        ),
        
        ChangeNotifierProxyProvider<DashboardRepository, DashboardProvider>(
          create: (context) => DashboardProvider(context.read<DashboardRepository>()),
          update: (context, dashboardRepository, previous) => 
              previous ?? DashboardProvider(dashboardRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        switch (authProvider.state) {
          case AuthState.loading:
          case AuthState.initial:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case AuthState.authenticated:
            return const DashboardScreen();
          case AuthState.unauthenticated:
          case AuthState.error:
            return const LoginScreen();
        }
      },
    );
  }
}
