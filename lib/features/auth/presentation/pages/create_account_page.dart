import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController    = TextEditingController();
  final _lastNameController     = TextEditingController();
  final _emailController        = TextEditingController();
  final _addressController      = TextEditingController();
  final _dobController          = TextEditingController();
  final _mobileController       = TextEditingController();
  final _locationController     = TextEditingController();
  final _dojController          = TextEditingController();
  final _passwordController     = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _dojController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.register(
      firstName:    _firstNameController.text.trim(),
      lastName:     _lastNameController.text.trim(),
      email:        _emailController.text.trim(),
      password:     _passwordController.text.trim(),
      address:      _addressController.text.trim(),
      dob:          _dobController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      doj:          _dojController.text.trim(),
      location:     _locationController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created! Please login.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _buildField(
              label: 'First Name',
              hint: 'Enter First Name',
              controller: _firstNameController,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter first name' : null,
            ),
            _buildField(
              label: 'Last Name',
              hint: 'Enter Last Name',
              controller: _lastNameController,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter last name' : null,
            ),
            _buildField(
              label: 'Email',
              hint: 'Enter Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter email';
                if (!v.contains('@')) return 'Enter valid email';
                return null;
              },
            ),
            _buildField(
              label: 'Address',
              hint: 'Enter Address',
              controller: _addressController,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter address' : null,
            ),
            _buildField(
              label: 'DOB',
              hint: 'Enter DOB',
              controller: _dobController,
              keyboardType: TextInputType.datetime,
              suffixIcon: Icons.calendar_today_outlined,
              onSuffixTap: () => _pickDate(_dobController),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter date of birth' : null,
            ),
            _buildField(
              label: 'Mobile Number',
              hint: 'Enter Number',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter mobile number';
                if (v.length < 10) return 'Enter valid number';
                return null;
              },
            ),
            _buildField(
              label: 'Location',
              hint: 'Enter location',
              controller: _locationController,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter location' : null,
            ),
            _buildField(
              label: 'DOJ',
              hint: 'Enter Date Of Joining',
              controller: _dojController,
              keyboardType: TextInputType.datetime,
              suffixIcon: Icons.calendar_today_outlined,
              onSuffixTap: () => _pickDate(_dojController),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter date of joining' : null,
            ),
            _buildPasswordField(),

            const SizedBox(height: 32),

            Consumer<AuthProvider>(
              builder: (_, auth, __) {
                final isLoading = auth.status == AuthStatus.loading;
                return Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save', style: AppTextStyles.buttonPrimary),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios_new,
            size: 18, color: AppColors.textPrimary),
      ),
      title: const Text(
        'Create Account',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.backgroundLight,
            child: const Icon(Icons.person_outline,
                size: 20, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: AppTextStyles.fieldInput,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.fieldHint,
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(suffixIcon,
                          size: 18, color: AppColors.textFieldHint),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.createAccountFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.primaryTeal, width: 1.5),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Password', style: AppTextStyles.label),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: AppTextStyles.fieldInput,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter password';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter Password',
              hintStyle: AppTextStyles.fieldHint,
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textFieldHint,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.createAccountFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.primaryTeal, width: 1.5),
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
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Picker 
  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryTeal),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }
}