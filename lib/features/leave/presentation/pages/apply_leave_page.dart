import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_outline_btn.dart';
import '../../../../shared/widgets/custom_primary_btn.dart';
import '../providers/leave_provider.dart';
import 'leave_list_page.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});
  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey    = GlobalKey<FormState>();
  final _fromCtrl   = TextEditingController();
  final _toCtrl     = TextEditingController();
  final _reasonCtrl = TextEditingController();

  String  _leaveMode = 'full_day';
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
      backgroundColor: AppColors.createAccountBg,
      appBar: const CustomAppBar(), // no title
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          children: [
            // ── Page title ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Apply Leave',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Full Day / Half Day Toggle ──────────────────────────
            _buildModeToggle(),
            const SizedBox(height: 20),

            // ── White card ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('From'),
                  _buildDateField(
                    ctrl: _fromCtrl,
                    hint: 'DD/MM/YYYY',
                    onTap: () => _pickDate(_fromCtrl),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  _buildLabel('To'),
                  _buildDateField(
                    ctrl: _toCtrl,
                    hint: 'DD/MM/YYYY',
                    onTap: () => _pickDate(_toCtrl),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  _buildLabel('Reason'),
                  TextFormField(
                    controller: _reasonCtrl,
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    style: AppTextStyles.fieldInput,
                    decoration: _inputDecoration('Enter Leave reason'),
                  ),

                  _buildLabel('Leave Type'),
                  _buildLeaveTypeDropdown(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Apply Button ────────────────────────────────────────
           Column(children: [
             Consumer<LeaveProvider>(builder: (_, provider, __) {
              return PrimaryButton(

                label: 'Apply',
                onPressed: _handleApply,
                isLoading: provider.isLoading,
                height: 40,
              );
            }),
            const SizedBox(height: 12),

            // ── Leave List Button ───────────────────────────────────
            AppOutlineButton(
              label: 'Leave List',
              height: 40,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LeaveListPage()),
              ),
            ),
           ],)
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Container(
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
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.white : AppColors.primaryDark,fontWeight: selected ? FontWeight.w700: FontWeight.w400 
            ),
          ),
        ),
      ),
    );
  }

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
      style: AppTextStyles.fieldInput,
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: const Icon(Icons.calendar_month_rounded,
            size: 18, color: AppColors.textFieldHint),
      ),
    );
  }

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
          hint: Text('Select your Leave type', style: AppTextStyles.fieldHint),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textFieldHint),
          items: _leaveTypes.map((type) => DropdownMenuItem(
            value: type,
            child: Text(type, style: AppTextStyles.fieldInput),
          )).toList(),
          onChanged: (val) => setState(() => _leaveType = val),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Text(text, style: AppTextStyles.createAccountLabel),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.createAccountHint,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.createAccountFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      );
}