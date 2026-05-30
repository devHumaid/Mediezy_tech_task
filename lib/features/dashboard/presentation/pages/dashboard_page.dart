import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../attendance/presentation/providers/attendance_provider.dart';
import '../../../leave/presentation/pages/apply_leave_page.dart';
import '../../../route/presentation/pages/route_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch attendance status when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchStatus();
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
              // ── Top bar ──────────────────────────────────────────────
              _buildTopBar(context, auth),
              const SizedBox(height: 20),

              // ── Profile card ─────────────────────────────────────────
              _buildProfileCard(user),
              const SizedBox(height: 16),

              // ── Mark In / Out / Completed Banner ─────────────────────
              _buildAttendanceBanner(),
              const SizedBox(height: 16),

              // ── Quick action tiles ────────────────────────────────────
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // ── Recent Activity ───────────────────────────────────────
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Avatar circle
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

  // ── Attendance Banner (3 states) ─────────────────────────────────────────
  Widget _buildAttendanceBanner() {
    return Consumer<AttendanceProvider>(builder: (_, provider, __) {
      // Show snackbar feedback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(provider.successMessage!),
            backgroundColor: AppColors.success,
          ));
          provider.clearMessages();
        } else if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: AppColors.error,
          ));
          provider.clearMessages();
        }
      });

      return _AttendanceBannerWidget(provider: provider);
    });
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        // Route – dark gradient tile
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RouteListPage()),
            ),
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

        // Apply Leave – white tile
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ApplyLeavePage()),
            ),
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
    );
  }

  // ── Recent Activity Header ────────────────────────────────────────────────
  Widget _buildRecentActivityHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recent Activity',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RouteListPage()),
          ),
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

  // ── Recent Activity List ──────────────────────────────────────────────────
  Widget _buildActivityList() {
    // TODO: Replace with real API data from attendance/route-list
    final items = ['23 Aug 2026', '22 Aug 2026', '21 Aug 2026'];
    return Column(
      children: items.map((date) => Container(
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
      )).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Attendance Banner Widget – handles all 3 states
// ═══════════════════════════════════════════════════════════════════════════
class _AttendanceBannerWidget extends StatelessWidget {
  final AttendanceProvider provider;
  const _AttendanceBannerWidget({required this.provider});

  @override
  Widget build(BuildContext context) {
    // Determine which state to show
    final _BannerState state = _resolveBannerState(provider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: state == _BannerState.completed ? 18 : 14,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: state == _BannerState.completed
          ? _buildCompletedState(provider)
          : _buildActiveState(context, provider, state),
    );
  }

  // ── State 3: Day Completed (no button, centered text) ────────────────────
  Widget _buildCompletedState(AttendanceProvider provider) {
    final att = provider.attendance;
    return Column(
      children: [
        const Text(
          'Your Day Completed',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Started at ${att?.checkInTime ?? "9:29"} Ended at ${att?.checkOutTime ?? "5:31"}',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── State 1 & 2: Mark In / Mark Out (with button) ────────────────────────
  Widget _buildActiveState(
      BuildContext context, AttendanceProvider provider, _BannerState state) {
    final isMarkIn = state == _BannerState.notStarted;
    final isLoading = provider.isLoading;
    final att = provider.attendance;

    return Row(
      children: [
        // Left: text block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMarkIn ? 'Start Your Day!' : 'Your work started',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white),
              ),
              const SizedBox(height: 3),
              Text(
                isMarkIn
                    ? 'Your shift start at 9:30'
                    : 'Checked In at ${att?.checkInTime ?? "9:29"}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Right: Mark In / Mark Out pill button
        GestureDetector(
          onTap: isLoading
              ? null
              : () => provider.markAttendance(markIn: isMarkIn),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        color: AppColors.primaryTeal, strokeWidth: 2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isMarkIn ? Icons.fingerprint : Icons.logout_outlined,
                        size: 16,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isMarkIn ? 'Mark In' : 'Mark Out',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  /// Resolve which of the 3 banner states to show
  _BannerState _resolveBannerState(AttendanceProvider provider) {
    final att = provider.attendance;
    if (att == null) return _BannerState.notStarted;

    // Both check-in AND check-out exist → day completed
    if (att.checkInTime != null && att.checkOutTime != null) {
      return _BannerState.completed;
    }
    // Only check-in exists → currently working
    if (att.isMarkedIn) return _BannerState.working;

    // Default → not started yet
    return _BannerState.notStarted;
  }
}

/// The 3 possible states of the attendance banner
enum _BannerState {
  notStarted, // State 1: Show "Start Your Day!" + Mark In button
  working,    // State 2: Show "Your work started" + Mark Out button
  completed,  // State 3: Show "Your Day Completed" - no button
}