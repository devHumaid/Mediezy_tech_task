import 'package:flutter/material.dart';
import 'package:mediezy_tech_task/features/auth/presentation/pages/login_page.dart';
import 'package:mediezy_tech_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──────────────────────────────────────────────
              _buildTopBar(context, auth),

              const SizedBox(height: 20),

              // ── Profile Card ─────────────────────────────────────────
              _buildProfileCard(auth),

              const SizedBox(height: 16),

              // ── Mark In Banner ───────────────────────────────────────
              _buildMarkInBanner(context),

              const SizedBox(height: 16),

              // ── Quick Actions ─────────────────────────────────────────
              _buildQuickActions(context),

              const SizedBox(height: 24),

              // ── Recent Activity ───────────────────────────────────────
              _buildRecentActivityHeader(),
              const SizedBox(height: 12),
              _buildActivityList(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
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
          child: const Icon(Icons.logout_outlined,
              color: AppColors.textSecondary, size: 22),
        ),
      ],
    );
  }

  // ── Profile Card ─────────────────────────────────────────────────────────
  Widget _buildProfileCard(AuthProvider auth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundLight,
              border: Border.all(color: AppColors.divider, width: 2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            auth.userName ?? 'Valentin Alexandre',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Role
          const Text(
            'Sales Executive',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textSecondary),
              SizedBox(width: 3),
              Text(
                'Ernakulam',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Mark In Banner ───────────────────────────────────────────────────────
  Widget _buildMarkInBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Text block
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Your Day!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your shift start at 9:30',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Mark In button
          GestureDetector(
            onTap: () {
              // TODO: navigate to Mark In page
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.white.withOpacity(0.4), width: 1),
              ),
              child: Row(
                children: const [
                  Icon(Icons.fingerprint, size: 16, color: AppColors.white),
                  SizedBox(width: 6),
                  Text(
                    'Mark In',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Tiles ───────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        // Route Tile (active – dark)
        Expanded(
          child: _buildActionTile(
            icon: Icons.map_outlined,
            label: 'Route',
            isDark: true,
            onTap: () {
              // TODO: navigate to Route page
            },
          ),
        ),
        const SizedBox(width: 14),

        // Apply Leave Tile (light)
        Expanded(
          child: _buildActionTile(
            icon: Icons.calendar_month_outlined,
            label: 'Apply Leave',
            isDark: false,
            onTap: () {
              // TODO: navigate to Apply Leave page
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.primaryGradient : null,
          color: isDark ? null : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.white.withOpacity(0.15)
                    : AppColors.backgroundLight,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Activity Header ───────────────────────────────────────────────
  Widget _buildRecentActivityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: navigate to full activity list
          },
          child: Row(
            children: const [
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 2),
              Icon(Icons.chevron_right,
                  size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }

  // ── Recent Activity List ─────────────────────────────────────────────────
  Widget _buildActivityList() {
    final activities = [
      {'date': '23 Aug 2026', 'in': '9:30', 'out': '6:30'},
      {'date': '22 Aug 2026', 'in': '9:30', 'out': '6:30'},
      {'date': '21 Aug 2026', 'in': '9:30', 'out': '6:30'},
    ];

    return Column(
      children: activities
          .map((a) => _buildActivityItem(
                date: a['date']!,
                markIn: a['in']!,
                markOut: a['out']!,
              ))
          .toList(),
    );
  }

  Widget _buildActivityItem({
    required String date,
    required String markIn,
    required String markOut,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar icon
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundLight,
            ),
            child: const Icon(Icons.person,
                size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),

          // Date & times
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'Marked in at $markIn',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 1,
                      height: 10,
                      color: AppColors.divider,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Marked out at $markOut',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}