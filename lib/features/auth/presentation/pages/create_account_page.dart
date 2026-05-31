import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_primary_btn.dart';
import '../providers/auth_provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey         = GlobalKey<FormState>();
  final _firstNameCtrl   = TextEditingController();
  final _lastNameCtrl    = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _addressCtrl     = TextEditingController();
  final _dobCtrl         = TextEditingController();
  final _mobileCtrl      = TextEditingController();
  final _locationCtrl    = TextEditingController();
  final _dojCtrl         = TextEditingController();
  final _passwordCtrl    = TextEditingController();
  bool  _obscurePassword = true;

  @override
  void dispose() {
    for (final c in [_firstNameCtrl, _lastNameCtrl, _emailCtrl, _addressCtrl,
      _dobCtrl, _mobileCtrl, _locationCtrl, _dojCtrl, _passwordCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      firstName: _firstNameCtrl.text.trim(), lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),         password: _passwordCtrl.text.trim(),
      address: _addressCtrl.text.trim(),     dob: _dobCtrl.text.trim(),
      mobileNumber: _mobileCtrl.text.trim(), doj: _dojCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Account created! Please login.'),
        backgroundColor: AppColors.success,
      ));
      Navigator.of(context).pop();
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage!), backgroundColor: AppColors.error,
      ));
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createAccountBg, // F1F7F7
      appBar: CustomAppBar(title: 'Create Account'),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            // ── White card container ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                color: AppColors.createAccountContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.createAccountStroke),
              ),
              child: Column(
                children: [
                  _field(label: 'First Name',    hint: 'Enter First Name',     ctrl: _firstNameCtrl,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                  _field(label: 'Last Name',     hint: 'Enter Last Name',      ctrl: _lastNameCtrl,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                  _field(label: 'Email',         hint: 'Enter Email',          ctrl: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Required' : (!v.contains('@') ? 'Invalid email' : null)),
                  _field(label: 'Address',       hint: 'Enter Address',        ctrl: _addressCtrl,
                      maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
                  _field(label: 'DOB',           hint: 'Enter DOB',            ctrl: _dobCtrl,
                      suffixIcon: Icons.calendar_today_outlined,
                      onSuffixTap: () => _pickDate(_dobCtrl),
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                  _field(label: 'Mobile Number', hint: 'Enter Number',         ctrl: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Required' : (v.length < 10 ? 'Invalid number' : null)),
                  _field(label: 'Location',      hint: 'Enter location',       ctrl: _locationCtrl,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                  _field(label: 'DOJ',           hint: 'Enter Date Of Joining',ctrl: _dojCtrl,
                      suffixIcon: Icons.calendar_today_outlined,
                      onSuffixTap: () => _pickDate(_dojCtrl),
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                  // Password field
                  _passwordField(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Save button (reusable widget) ──
            Consumer<AuthProvider>(builder: (_, auth, __) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PrimaryButton(
                  label: 'Save',
                  onPressed: _handleSave,
                  isLoading: auth.status == AuthStatus.loading,
                  height: 45,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label, required String hint,
    required TextEditingController ctrl,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? suffixIcon, VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(label, style: AppTextStyles.createAccountLabel),
          ),
          const SizedBox(height: 3),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
          style: AppTextStyles.fieldInput,

            decoration: _inputDecoration(hint).copyWith(
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(suffixIcon, size: 18, color: AppColors.textFieldHint),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: AppTextStyles.createAccountLabel),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordCtrl,
          obscureText: _obscurePassword,
          validator: (v) => v!.isEmpty ? 'Required' : (v.length < 6 ? 'Min 6 chars' : null),
         style: AppTextStyles.fieldInput,

          decoration: _inputDecoration('Enter Password').copyWith(
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18, color: AppColors.textFieldHint,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.createAccountHint, // F0F0F0, Bold, 14
        filled: true,
        fillColor: AppColors.createAccountContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.createAccountStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      );

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100),
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
}