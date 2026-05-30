import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch current attendance status when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchAttendanceStatus();
    });
  }

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
              _buildTopBar(context, auth),
              const SizedBox(height: 20),
              _buildProfileCard(user),
              const SizedBox(height: 16),
              _buildAttendanceBanner(context),  // ← 3-state banner
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentActivityHeader(context),
              const SizedBox(height: 12),
              _buildActivityList(),
              const SizedBox(height: 16),
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
    );
  }

  // ── Profile Card ─────────────────────────────────────────────────────────
  Widget _buildProfileCard(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(16),
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
          Text(user?.role ?? 'Sales Executive',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
    );
  }

  // ── Attendance Banner ─────────────────────────────────────────────────────
  Widget _buildAttendanceBanner(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (_, provider, __) {
      // Show snackbar feedback after marking
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(provider.successMessage!),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ));
          provider.clearMessages();
        } else if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ));
          provider.clearMessages();
        }
      });

      return _AttendanceBanner(provider: provider);
    });
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        // Route tile – dark gradient
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
                      shape: BoxShape.circle, color: AppColors.white.withOpacity(0.15),
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

        // Apply Leave tile – white
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
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
    );
  }

  // ── Recent Activity ───────────────────────────────────────────────────────
  Widget _buildRecentActivityHeader(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildActivityList() {
    // TODO: Replace with real data from GET /attendance/route-list
    return Column(
      children: ['23 Aug 2026', '22 Aug 2026', '21 Aug 2026'].map((date) =>
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
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
                  Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  const Row(children: [
                    Text('Marked in at 9:30', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    SizedBox(width: 6),
                    SizedBox(width: 1, height: 10, child: ColoredBox(color: AppColors.divider)),
                    SizedBox(width: 6),
                    Text('Marked out at 6:30', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Attendance Banner – 3 states (separate widget for clarity)
// ═══════════════════════════════════════════════════════════════════════════
class _AttendanceBanner extends StatelessWidget {
  final DashboardProvider provider;
  const _AttendanceBanner({required this.provider});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(provider.bannerState),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: provider.bannerState == BannerState.completed ? 20 : 14,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildBannerContent(context),
      ),
    );
  }

  Widget _buildBannerContent(BuildContext context) {
    switch (provider.bannerState) {

      // ── State 1: Not started → Mark In ────────────────────────────
case BannerState.notStarted:
  return _buildWithButton(
    title:       'Start Your Day!',
    subtitle:    'Your shift starts at ${provider.attendance?.shiftStartTime ?? "09:00"}',  // ← CHANGE THIS
    buttonLabel: 'Mark In',
    buttonIcon:  Icons.fingerprint,
    onTap: () => provider.markAttendance(markIn: true),
  );

      // ── State 2: Working → Mark Out ───────────────────────────────
      case BannerState.working:
        return _buildWithButton(
          title:    'Your work started',
          subtitle: 'Checked In at ${provider.attendance?.checkInTime ?? "9:29"}',
          buttonLabel: 'Mark Out',
          buttonIcon:  Icons.logout_outlined,
          onTap: () => provider.markAttendance(markIn: false),
        );

      // ── State 3: Day completed → no button ───────────────────────
      case BannerState.completed:
        return Column(
          children: [
            const Text(
              'Your Day Completed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Started at ${provider.attendance?.checkInTime ?? "9:29"} '
              'Ended at ${provider.attendance?.checkOutTime ?? "5:31"}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  /// Shared layout for State 1 & 2 (text left + white pill button right)
  Widget _buildWithButton({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData buttonIcon,
    required VoidCallback onTap,
  }) {
    final isLoading = provider.isLoading;
    return Row(
      children: [
        // Left text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Right white pill button
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(color: AppColors.primaryTeal, strokeWidth: 2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(buttonIcon, size: 16, color: AppColors.primaryTeal),
                      const SizedBox(width: 6),
                      Text(buttonLabel,
                          style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryTeal,
                          )),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}