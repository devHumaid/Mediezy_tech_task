import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../providers/leave_provider.dart';
import '../../data/models/leave_model.dart';

class LeaveListPage extends StatefulWidget {
  const LeaveListPage({super.key});
  @override
  State<LeaveListPage> createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
  final List<String> _filters = ['All', 'Pending', 'Approved', 'Reject'];
  final List<String> _months  = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  int _selectedMonth = DateTime.now().month;

  // ── Dummy data for design preview ──
  final List<LeaveModel> _dummyLeaves = [
    LeaveModel(
      leaveMode: 'half_day', leaveType: 'casual',
      startDate: '2025-08-20', status: 'approved',
    ),
    LeaveModel(
      leaveMode: 'half_day', leaveType: 'casual',
      startDate: '2025-08-20', status: 'pending',
    ),
    LeaveModel(
      leaveMode: 'half_day', leaveType: 'casual',
      startDate: '2025-08-20', status: 'rejected',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveProvider>().fetchLeaves();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createAccountBg,
      appBar: const CustomAppBar(),
      body: Consumer<LeaveProvider>(builder: (_, provider, __) {
        // ── use dummy while empty ──
        final leaves = provider.leaves.isEmpty ? _dummyLeaves : provider.leaves;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page title ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 20, 16),
              child: Text(
                'Leave List',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ),

            // ── Filter Tabs ───────────────────────────────────
            _buildFilterTabs(provider),
            const SizedBox(height: 14),

            // ── Month + Count Row ─────────────────────────────
            _buildMonthRow(provider, leaves.length),
            const SizedBox(height: 14),

            // ── List ──────────────────────────────────────────
            Expanded(child: _buildList(provider, leaves)),
          ],
        );
      }),
    );
  }

  // ── Filter Tabs ─────────────────────────────────────────────────────────
  Widget _buildFilterTabs(LeaveProvider provider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _filters.map((filter) {
          final isSelected =
              provider.selectedFilter == filter.toLowerCase() ||
              (filter == 'All'    && provider.selectedFilter == 'all') ||
              (filter == 'Reject' && provider.selectedFilter == 'rejected');
          return GestureDetector(
            onTap: () {
              String val = filter.toLowerCase();
              if (filter == 'Reject') val = 'rejected';
              provider.setFilter(val);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                filter,
                style: AppTextStyles.label.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

 Widget _buildMonthRow(LeaveProvider provider, int count) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Month dropdown
        Container(
          height: 38,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryDark, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedMonth,
              icon: Image.asset(
                'assets/icons/arrow_icon.png', // replace with your asset
                width: 18, height: 18,
              ),
              isDense: true,
              alignment: Alignment.center,
              items: List.generate(12, (i) => DropdownMenuItem(
                value: i + 1,
                alignment: Alignment.center,
                child: Text(_months[i], style: AppTextStyles.label),
              )),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedMonth = val);
                  provider.setMonth(val.toString());
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Leave count pill
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryDark, width: 1.5),
          ),
          child: Center(
            child: Text(
              'Your Leave  ${count.toString().padLeft(2, '0')}',
              style: AppTextStyles.label,
            ),
          ),
        ),
      ],
    ),
  );
}

  // ── List ─────────────────────────────────────────────────────────────────
  Widget _buildList(LeaveProvider provider, List<LeaveModel> leaves) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      );
    }
    if (provider.errorMessage != null && provider.leaves.isNotEmpty) {
      return Center(
        child: Text(provider.errorMessage!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: leaves.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _LeaveCard(leave: leaves[i]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Leave Card
// ═══════════════════════════════════════════════════════════════════════════
class _LeaveCard extends StatelessWidget {
  final LeaveModel leave;
  const _LeaveCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    final status = leave.status?.toLowerCase() ?? 'pending';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_capitalize(leave.leaveMode ?? 'Full Day')} Application',
                style: AppTextStyles.caption,
              ),
              if (status == 'pending')
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/icons/delete_icon.png', // replace with your asset
                    width: 18, height: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          // ── Date ───────────────────────────────────────────────
          Text(
            _formatDate(leave.startDate),
            style: AppTextStyles.label.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // ── Leave type ─────────────────────────────────────────
          Text(
            _capitalize(leave.leaveType ?? 'Casual'),
            style: AppTextStyles.label.copyWith(
              color: AppColors.casual,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // ── Status pipeline ─────────────────────────────────────
          _buildStatusRow(status),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statusStep(label: 'Create', type: 'done'),
        _connector(),
        _statusStep(label: 'Review', type: 'done'),
        _connector(),
        _statusStep(
          label: _capitalize(status),
          type: status, // 'approved' | 'pending' | 'rejected'
        ),
      ],
    );
  }

  Widget _statusStep({required String label, required String type}) {
    String iconAsset;

    switch (type) {
      case 'rejected':
        iconAsset = 'assets/icons/Group 6.png'; // replace
        break;
      case 'pending':
        iconAsset = 'assets/icons/pending_icon.png'; // replace
        break;
      case 'approved':
      case 'done':
      default:
        iconAsset = 'assets/icons/complete_icon.png'; // replace
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconAsset, width: 16, height: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodyMedium
        ),
      ],
    );
  }

  Widget _connector() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(width: 20, height: 1, color: AppColors.divider),
      );

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final m   = int.tryParse(parts[1]) ?? 0;
      final day = int.tryParse(parts[2]) ?? 0;
      final dow = _dayOfWeek(int.tryParse(parts[0]) ?? 0, m, day);
      return '$dow, ${months[m]} $day, ${parts[0]}';
    } catch (_) {
      return date ?? '';
    }
  }

  String _dayOfWeek(int y, int m, int d) {
    final dt = DateTime(y, m, d);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }
}