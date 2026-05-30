import 'package:flutter/material.dart';
import 'package:mediezy_tech_task/features/leave/presentation/providers/leave_provider.dart';
import 'package:provider/provider.dart';
import 'package:mediezy_tech_task/features/dashboard/presentation/pages/splash_screen.dart';
import 'package:mediezy_tech_task/features/dashboard/presentation/providers/dashboard_provider.dart' show DashboardProvider;

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/route/presentation/providers/route_provider.dart';

class ZyromateApp extends StatelessWidget {
  const ZyromateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),


      ],
      child: MaterialApp(
        title: 'Zyromate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}