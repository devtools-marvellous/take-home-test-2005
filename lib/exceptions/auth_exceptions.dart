import 'package:take_home_marv/models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class LoginException extends AuthException {
  LoginException(super.message);
}

class LogoutException extends AuthException {
  LogoutException(super.message);
}

class UserException extends AuthException {
  UserException(super.message);
}

class TokenException extends AuthException {
  TokenException(super.message);
}
