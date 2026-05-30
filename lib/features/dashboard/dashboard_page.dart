import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../auth/presentation/pages/login_page.dart';
import '../auth/presentation/providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dashboard',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (_) => false,
                        );
                      }
                    },
                    child: const Icon(Icons.logout_outlined, color: AppColors.textSecondary, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Profile card ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundLight,
                        border: Border.all(color: AppColors.divider, width: 2),
                      ),
                      child: const Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hi ${user?.fullName.isNotEmpty == true ? user!.fullName : "Valentin Alexandre"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.role ?? 'Sales Executive',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          user?.location ?? 'Ernakulam',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Mark In banner ───────────────────────────────────────
              GestureDetector(
                // onTap: () => Navigator.of(context).push(
                //   MaterialPageRoute(builder: (_) => const MarkInPage()),
                // ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Your Day!',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
                            SizedBox(height: 2),
                            Text('Your shift start at 9:30',
                                style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.white.withOpacity(0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.fingerprint, size: 16, color: AppColors.white),
                            SizedBox(width: 6),
                            Text('Mark In',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Quick actions ─────────────────────────────────────────
              Row(
                children: [
                  // Route – active dark tile
                  Expanded(
                    child: GestureDetector(
                      // onTap: () => Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => const RouteListPage()),
                      // ),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white.withOpacity(0.15),
                              ),
                              child: const Icon(Icons.map_outlined, size: 20, color: AppColors.white),
                            ),
                            const SizedBox(height: 8),
                            const Text('Route',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Apply Leave – light tile
                  Expanded(
                    child: GestureDetector(
                      // onTap: () => Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => const ApplyLeavePage()),
                      // ),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.backgroundLight),
                              child: const Icon(Icons.calendar_month_outlined, size: 20, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            const Text('Apply Leave',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Recent activity ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Activity',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  GestureDetector(
                    // onTap: () => Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (_) => const RouteListPage()),
                    // ),
                    child: const Row(
                      children: [
                        Text('View All', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Static recent activity items (will be replaced by API data)
              ...['23 Aug 2026', '22 Aug 2026', '21 Aug 2026'].map(
                (date) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white, borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.backgroundLight),
                        child: const Icon(Icons.person, size: 20, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 3),
                          const Row(
                            children: [
                              Text('Marked in at 9:30', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              SizedBox(width: 6),
                              SizedBox(width: 1, height: 10, child: ColoredBox(color: AppColors.divider)),
                              SizedBox(width: 6),
                              Text('Marked out at 6:30', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}