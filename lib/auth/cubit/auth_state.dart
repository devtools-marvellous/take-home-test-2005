import 'package:flutter/foundation.dart';
import 'package:take_home_marv/models/user_model.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class InitialState extends AuthState {
  const InitialState() : super();
}

class LoadingState extends AuthState {
  const LoadingState() : super();
}

class UnauthorizedState extends AuthState {
  const UnauthorizedState() : super();
}

class ErrorState extends AuthState {
  final String message;

  const ErrorState(this.message) : super();
}

class AuthorizedState extends AuthState {
  final User user;

  const AuthorizedState({required this.user}) : super();
}
