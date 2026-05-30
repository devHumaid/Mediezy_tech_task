import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/dashboard_page.dart';
import '../providers/auth_provider.dart';
import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey            = GlobalKey<FormState>();
  final _mobileController   = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _obscurePassword    = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(
      mobileNumber: _mobileController.text.trim(),
      password:     _passwordController.text.trim(),
    );
    if (!mounted) return;
    if (auth.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!), backgroundColor: AppColors.error),
      );
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo
                _ZyromateLogoWidget(),
                const Spacer(flex: 2),
                // Mobile / Username field
                _buildField(
                  controller: _mobileController,
                  hint: 'Username',
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Enter mobile number' : null,
                ),
                const SizedBox(height: 14),
                // Password
                _buildPasswordField(),
                const SizedBox(height: 26),
                // Login btn
                _buildLoginButton(),
                const SizedBox(height: 12),
                // Create account btn
                _buildCreateAccountButton(),
                const Spacer(flex: 3),
                const Text(
                  'Powered by Mediezy',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textFieldHint),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.loginFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textFieldHint),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textFieldHint, size: 20,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.loginFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(builder: (_, auth, __) {
      final loading = auth.status == AuthStatus.loading;
      return Container(
        width: double.infinity, height: 50,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: loading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
              : const Text('Login',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white)),
        ),
      );
    });
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity, height: 50,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateAccountPage()),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.textPrimary, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('Create Account',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ),
    );
  }
}

class _ZyromateLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/zyromate_logo.png',
      width: 200,
      errorBuilder: (_, __, ___) => RichText(
        text: const TextSpan(children: [
          TextSpan(text: 'zyro',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark, letterSpacing: -1)),
          TextSpan(text: 'mate',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300,
                  color: AppColors.primaryTeal, letterSpacing: -1)),
        ]),
      ),
    );
  }
}