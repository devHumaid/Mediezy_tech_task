import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
        ),
        title: const Text('Leave List',
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
      body: Consumer<LeaveProvider>(builder: (_, provider, __) {
        return Column(
          children: [
            // ── Filter Tabs ───────────────────────────────────────
            _buildFilterTabs(provider),
            const SizedBox(height: 12),

            // ── Month + Count Row ─────────────────────────────────
            _buildMonthRow(provider),
            const SizedBox(height: 12),

            // ── List ──────────────────────────────────────────────
            Expanded(child: _buildList(provider)),
          ],
        );
      }),
    );
  }

  // ── Filter Tabs ─────────────────────────────────────────────────────────
  Widget _buildFilterTabs(LeaveProvider provider) {
  return SingleChildScrollView(          // ← wrap this
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: _filters.map((filter) {
        final isSelected =
            provider.selectedFilter == filter.toLowerCase() ||
            (filter == 'All' && provider.selectedFilter == 'all') ||
            (filter == 'Reject' && provider.selectedFilter == 'rejected');
        return GestureDetector(
          onTap: () {
            String val = filter.toLowerCase();
            if (filter == 'Reject') val = 'rejected';
            provider.setFilter(val);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textSecondary,
                )),
          ),
        );
      }).toList(),
    ),
  );
}

  // ── Month Row ────────────────────────────────────────────────────────────
  Widget _buildMonthRow(LeaveProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Month dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.createAccountFieldBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedMonth,
                icon: const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: AppColors.textSecondary),
                isDense: true,
                items: List.generate(12, (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text(_months[i],
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary)),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.createAccountFieldBorder),
            ),
            child: Text(
              'Your Leave  ${provider.leaves.length.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // ── List ─────────────────────────────────────────────────────────────────
  Widget _buildList(LeaveProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage!,
            style: const TextStyle(color: AppColors.error)),
      );
    }

    if (provider.leaves.isEmpty) {
      return const Center(
        child: Text('No leaves found',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.leaves.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _LeaveCard(leave: provider.leaves[i]),
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
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              if (status == 'pending')
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.delete_outline,
                      size: 18, color: AppColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 4),

          // ── Date ───────────────────────────────────────────────
          Text(
            _formatDate(leave.startDate),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),

          // ── Leave type label ────────────────────────────────────
          Text(
            _capitalize(leave.leaveType ?? 'Casual'),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal),
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
      children: [
        _statusStep(label: 'Create',   done: true),
        _connector(),
        _statusStep(label: 'Review',   done: true),
        _connector(),
        _statusStep(
          label: _capitalize(status),
          done: status == 'approved',
          pending: status == 'pending',
          rejected: status == 'rejected',
        ),
      ],
    );
  }

  Widget _statusStep({
    required String label,
    bool done     = false,
    bool pending  = false,
    bool rejected = false,
  }) {
    Color color;
    IconData icon;

    if (rejected) {
      color = AppColors.error;
      icon  = Icons.cancel;
    } else if (pending) {
      color = Colors.orange;
      icon  = Icons.check_circle;
    } else if (done) {
      color = AppColors.success;
      icon  = Icons.check_circle;
    } else {
      color = AppColors.divider;
      icon  = Icons.check_circle_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color)),
      ],
    );
  }

  Widget _connector() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
            width: 20, height: 1, color: AppColors.divider),
      );

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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
      return '${_dayWithSuffix(int.tryParse(parts[2]) ?? 0)}, ${months[m]} ${parts[0]}';
    } catch (_) {
      return date;
    }
  }

  String _dayWithSuffix(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1: return '${day}st';
      case 2: return '${day}nd';
      case 3: return '${day}rd';
      default: return '${day}th';
    }
  }
}