import 'package:flutter/material.dart';
import 'package:mediezy_tech_task/features/dashboard/presentation/pages/splash_screen.dart';
import 'package:mediezy_tech_task/features/dashboard/presentation/providers/dashboard_provider.dart' show DashboardProvider;
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.instance.init();

  runApp(const ZyromateApp());
}

class ZyromateApp extends StatelessWidget {
  const ZyromateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),


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