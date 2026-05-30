/// Form field validators used across the app
class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.isEmpty) return 'Enter mobile number';
    if (value.length < 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Enter email address';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? date(String? value, [String fieldName = 'Date']) {
    if (value == null || value.isEmpty) return 'Select $fieldName';
    return null;
  }
}