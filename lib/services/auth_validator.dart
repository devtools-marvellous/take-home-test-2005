// Define an enum to represent different types of validation errors.
enum ValidationError {
  emptyFields,
  invalidEmail,
  passwordTooShort,
}

class AuthValidator {
  // Checks the credentials and returns a corresponding ValidationError if found.
  ValidationError? getValidationError(String email, String password) {
    if (email.isEmpty || password.isEmpty) return ValidationError.emptyFields;
    if (!email.contains('@')) return ValidationError.invalidEmail;
    if (password.length < 6) return ValidationError.passwordTooShort;
    return null;
  }

  // Validates the credentials and throws an exception based on the error type.
  void validateCredentials(String email, String password) {
    final error = getValidationError(email, password);
    if (error != null) {
      switch (error) {
        case ValidationError.emptyFields:
          throw Exception('Email and password cannot be empty');
        case ValidationError.invalidEmail:
          throw Exception('Please enter a valid email');
        case ValidationError.passwordTooShort:
          throw Exception('Password must be at least 6 characters');
      }
    }
  }
}
