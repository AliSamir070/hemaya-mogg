class AppValidators {
  AppValidators._();

  static String? validateUsername(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'This field is required';
    }
    if (val.trim().length < 3) {
      return 'Enter a valid username (at least 3 characters)';
    }
    return null;
  }

  static String? validateFullName(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'This field is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(val.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'This field is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(val.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    }
    if (val.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    }
    if (val != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
