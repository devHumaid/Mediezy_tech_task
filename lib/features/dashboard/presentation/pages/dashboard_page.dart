import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/activitycard.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../leave/presentation/pages/apply_leave_page.dart';
import '../../../route/presentation/pages/my_route_page.dart.dart';
import '../../../route/presentation/pages/route details_page..dart';
import '../../../route/presentation/providers/route_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchAttendanceStatus();
      context.read<RouteProvider>().fetchRouteList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.createAccountBg, // F1F7F7
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildTopBar(context, auth),
              const SizedBox(height: 40),
              _buildProfileCard(user),
              const SizedBox(height: 16),
              _buildAttendanceBanner(context),
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



  Widget _buildProfileCard(user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.backgroundLight,
          child: ClipOval(
            child: Image.asset(
              'assets/icons/profile_icon.png',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Hi ${user?.fullName.isNotEmpty == true ? user!.fullName : "Valentin Alexandre"}',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 0),
        Text(
          user?.role ?? 'Sales Executive',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 3),
            Text(
              user?.location ?? 'Ernakulam',
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceBanner(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (_, provider, __) {
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

Widget _buildQuickActions(BuildContext context) {
  return Row(
    children: [
      // Route tile
      Expanded(
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MyRoutePage()),
          ),
          child: Container(
            height: 98,
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(0.15),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/route_icon.png',
                      width: 12, height: 13,
                      color: AppColors.white, // tint white
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Route', style: AppTextStyles.label.copyWith(color: AppColors.white,fontWeight: FontWeight.bold,fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(width: 14),

      // Apply Leave tile
      Expanded(
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ApplyLeavePage()),
          ),
          child: Container(
            height: 98,
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryDark, // dark circle like Figma
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/calendar.png',
                      width: 12, height: 13,
                      color: AppColors.white, // tint white
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Apply Leave', style: AppTextStyles.label.copyWith(color: AppColors.primaryDark,fontWeight: FontWeight.bold,fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildRecentActivityHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recent Activity', style: AppTextStyles.heading4),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MyRoutePage()),
          ),
          child: Row(
            children: [
              Text('View All', style: AppTextStyles.heading5),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }

  
Widget _buildActivityList() {
  return Consumer<RouteProvider>(builder: (_, provider, __) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      );
    }
    if (provider.routes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No recent activity', style: AppTextStyles.bodySmall),
        ),
      );
    }
    final recent = provider.routes.take(3).toList();
    return Column(
      children: recent.map((route) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteDetailPage(route: route),
          ),
        ),
        child: ActivityCard(
          date: route.date ?? '',   
          markInTime: route.markInTime,
          markOutTime: route.markOutTime,
        ),
      )).toList(),
    );
  });
}}

// banner
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
          horizontal: 25,
          vertical: provider.bannerState == BannerState.completed ? 20 : 14,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(50),
        ),
        child: _buildBannerContent(context),
      ),
    );
  }

  Widget _buildBannerContent(BuildContext context) {
    switch (provider.bannerState) {
      case BannerState.notStarted:
        return _buildWithButton(
          title: 'Start Your Day!',
          subtitle: 'Your shift starts at ${provider.attendance?.shiftStartTime ?? "09:00"}',
          buttonLabel: 'Mark In',
          onTap: () => provider.markAttendance(markIn: true),
        );
      case BannerState.working:
        return _buildWithButton(
          title: 'Your work started',
          subtitle: 'Checked In at ${provider.attendance?.checkInTime ?? "9:29"}',
          buttonLabel: 'Mark Out',
          onTap: () => provider.markAttendance(markIn: false),
        );
      case BannerState.completed:
        return Column(
          children: [
            Text(
              'Your Day Completed',
              style: AppTextStyles.heading3.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Started at ${provider.attendance?.checkInTime ?? "9:29"} '
              'Ended at ${provider.attendance?.checkOutTime ?? "5:31"}',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  Widget _buildWithButton({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    final isLoading = provider.isLoading;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.label.copyWith(
                      fontSize: 13.5, color: AppColors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: AppTextStyles.caption.copyWith(color:AppColors.white,fontSize: 11.5)),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
                    child: CircularProgressIndicator(
                        color: AppColors.primaryTeal, strokeWidth: 2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/icons/marking.png",height: 13.5,width: 11.5,),
                      const SizedBox(width: 3),
                      Text(buttonLabel,
                          style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,fontSize: 11.5)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}