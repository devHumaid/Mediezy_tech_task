import 'package:flutter/material.dart';
import 'package:mediezy_tech_task/features/route/presentation/pages/route%20details_page..dart' show RouteDetailPage;
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/activitycard.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../providers/route_provider.dart';
import '../../data/models/route_model.dart';

class MyRoutePage extends StatefulWidget {
  const MyRoutePage({super.key});
  @override
  State<MyRoutePage> createState() => _MyRoutePageState();
}

class _MyRoutePageState extends State<MyRoutePage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteProvider>().fetchRouteList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createAccountBg,
      appBar: const CustomAppBar(), // no title
      body: Consumer<RouteProvider>(builder: (_, provider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page title ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 20, 16),
              child: Text(
                'My Route',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ),

            // ── Search Bar ─────────────────────────────────────────
            _buildSearchBar(),
            const SizedBox(height: 12),

            // ── List ───────────────────────────────────────────────
            Expanded(child: _buildList(provider)),
          ],
        );
      }),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────
 Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.createAccountBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryDark,width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Search', style:AppTextStyles.heading5),
        
        ],
      ),
    ),
  );
}
  // ── List ─────────────────────────────────────────────────────────────────
  Widget _buildList(RouteProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(provider.errorMessage!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: provider.fetchRouteList,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Retry',
                    style: AppTextStyles.label.copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.routes.isEmpty) {
      return Center(
        child: Text('No routes found', style: AppTextStyles.bodySmall),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.routes.length,
      itemBuilder: (_, i) {
        final route = provider.routes[i];
        return GestureDetector(
  onTap: () => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => RouteDetailPage(route: provider.routes[i]),
    ),
  ),
  child: ActivityCard(
            date: _formatDate(route.date),
            markInTime: route.markInTime,
            markOutTime: route.markOutTime,
          ),
        );
      },
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final m = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${months[m]} ${parts[0]}';
    } catch (_) {
      return date ?? '';
    }
  }
}