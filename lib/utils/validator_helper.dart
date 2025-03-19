class ValidatorHelper {
  static void validateEmail(String email) {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (!email.contains('@')) {
      throw Exception('Please enter a valid email');
    }
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
  }
}
