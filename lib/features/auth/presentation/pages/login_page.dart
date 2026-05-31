import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_outline_btn.dart';
import '../../../../shared/widgets/custom_primary_btn.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
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
bool get _isFormFilled =>
    _mobileController.text.trim().isNotEmpty &&
    _passwordController.text.trim().isNotEmpty;

@override
void initState() {
  super.initState();
  _mobileController.addListener(() => setState(() {}));
  _passwordController.addListener(() => setState(() {}));
}
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
    //   location permission after successful login 
    await _requestLocationPermission();
    if (!mounted) return;
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

Future<void> _requestLocationPermission() async {
  // check if location service is enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services for attendance marking.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  // Already granted — nothing to do
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) return;

  // Denied → request it
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied. Attendance marking may not work.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
  }

  // Permanently denied → send to app settings
  if (permission == LocationPermission.deniedForever) {
    if (mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'Location permission is permanently denied. '
            'Please enable it from app settings to use attendance marking.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Geolocator.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
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
                const Spacer(flex: 1),
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
                const SizedBox(height: 5),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
    return PrimaryButton(
      label: 'Login',
      onPressed: _isFormFilled ? _handleLogin : null,
      isLoading: auth.status == AuthStatus.loading,
    );
  });
}

Widget _buildCreateAccountButton() {
  return AppOutlineButton(
    label: 'Create Account',
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateAccountPage()),
    ),
  );
}}

class _ZyromateLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 220,

    );
  }
}