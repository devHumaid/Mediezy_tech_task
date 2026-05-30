import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
        ),
        title: const Text('My Route',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.white,
              child: const Icon(Icons.person_outline,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
      body: Consumer<RouteProvider>(builder: (_, provider, __) {
        return Column(
          children: [
            // ── Search Bar ────────────────────────────────────────
            _buildSearchBar(provider),
            const SizedBox(height: 12),

            // ── List ──────────────────────────────────────────────
            Expanded(child: _buildList(provider)),
          ],
        );
      }),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar(RouteProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.createAccountFieldBorder),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: provider.search,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 14, color: AppColors.textFieldHint),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_searchCtrl.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  provider.search('');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(Icons.close,
                      size: 16, color: AppColors.textSecondary),
                ),
              ),
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
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: provider.fetchRouteList,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Retry',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.routes.isEmpty) {
      return const Center(
        child: Text('No routes found',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.routes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _RouteCard(route: provider.routes[i]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Route Card
// ═══════════════════════════════════════════════════════════════════════════
class _RouteCard extends StatelessWidget {
  final RouteModel route;
  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ── Avatar ───────────────────────────────────────────
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundLight,
            ),
            child: const Icon(Icons.person,
                size: 22, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),

          // ── Date + times ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(route.date),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Marked in at ${route.markInTime ?? "--"}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary),
                    ),
                    if (route.markOutTime != null) ...[
                      const SizedBox(width: 6),
                      const SizedBox(
                          width: 1, height: 10,
                          child: ColoredBox(color: AppColors.divider)),
                      const SizedBox(width: 6),
                      Text(
                        'Marked out at ${route.markOutTime}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;
      final months = [
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