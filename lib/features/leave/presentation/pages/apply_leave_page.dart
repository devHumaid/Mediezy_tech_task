import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/leave_provider.dart';
import 'leave_list_page.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});
  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey       = GlobalKey<FormState>();
  final _fromCtrl      = TextEditingController();
  final _toCtrl        = TextEditingController();
  final _reasonCtrl    = TextEditingController();

  String  _leaveMode   = 'full_day'; // 'full_day' | 'half_day'
  String? _leaveType;

  final List<String> _leaveTypes = [
    'Casual', 'Sick', 'Annual', 'Maternity', 'Paternity', 'Other'
  ];

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryTeal),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      // API expects yyyy-MM-dd
      ctrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _handleApply() async {
    if (!_formKey.currentState!.validate()) return;
    if (_leaveType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a leave type'),
        backgroundColor: AppColors.error,
      ));
      return;
    }

    final provider = context.read<LeaveProvider>();
    final success = await provider.applyLeave(
      leaveMode: _leaveMode,
      leaveType: _leaveType!.toLowerCase(),
      startDate: _fromCtrl.text.trim(),
      endDate:   _toCtrl.text.trim(),
      reason:    _reasonCtrl.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Leave applied successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ));
      provider.clearMessages();
      // Reset form
      _fromCtrl.clear();
      _toCtrl.clear();
      _reasonCtrl.clear();
      setState(() => _leaveType = null);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(provider.errorMessage!),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
      provider.clearMessages();
    }
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
        title: const Text('Apply Leave',
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            // ── Full Day / Half Day Toggle ──────────────────────────
            _buildModeToggle(),
            const SizedBox(height: 20),

            // ── White card with form fields ─────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From
                  _buildLabel('From'),
                  const SizedBox(height: 6),
                  _buildDateField(
                    ctrl: _fromCtrl,
                    hint: 'DD/MM/YYYY',
                    onTap: () => _pickDate(_fromCtrl),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // To
                  _buildLabel('To'),
                  const SizedBox(height: 6),
                  _buildDateField(
                    ctrl: _toCtrl,
                    hint: 'DD/MM/YYYY',
                    onTap: () => _pickDate(_toCtrl),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Reason
                  _buildLabel('Reason'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _reasonCtrl,
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textPrimary),
                    decoration: _inputDecoration('Enter Leave reason'),
                  ),
                  const SizedBox(height: 14),

                  // Leave Type dropdown
                  _buildLabel('Leave Type'),
                  const SizedBox(height: 6),
                  _buildLeaveTypeDropdown(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Apply Button ────────────────────────────────────────
            Consumer<LeaveProvider>(builder: (_, provider, __) {
              return Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2))
                      : const Text('Apply',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white)),
                ),
              );
            }),
            const SizedBox(height: 12),

            // ── Leave List Button ───────────────────────────────────
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const LeaveListPage()),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(
                      color: AppColors.textPrimary, width: 1.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Leave List',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mode Toggle ─────────────────────────────────────────────────────────
  Widget _buildModeToggle() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _modeTab('Full Day', 'full_day'),
          _modeTab('Half Day', 'half_day'),
        ],
      ),
    );
  }

  Widget _modeTab(String label, String value) {
    final selected = _leaveMode == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _leaveMode = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textSecondary,
              )),
        ),
      ),
    );
  }

  // ── Date Field ──────────────────────────────────────────────────────────
  Widget _buildDateField({
    required TextEditingController ctrl,
    required String hint,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: const Icon(Icons.calendar_today_outlined,
            size: 18, color: AppColors.textFieldHint),
      ),
    );
  }

  // ── Leave Type Dropdown ─────────────────────────────────────────────────
  Widget _buildLeaveTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.createAccountFieldBorder),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _leaveType,
          hint: const Text('Select your Leave type',
              style: TextStyle(fontSize: 14, color: AppColors.textFieldHint)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textFieldHint),
          items: _leaveTypes.map((type) => DropdownMenuItem(
            value: type,
            child: Text(type,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary)),
          )).toList(),
          onChanged: (val) => setState(() => _leaveType = val),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 14, color: AppColors.textFieldHint),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.createAccountFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
      );
}