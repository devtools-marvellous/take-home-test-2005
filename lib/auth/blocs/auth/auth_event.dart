part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthUpdated extends AuthEvent {
  final UserModel? user;

  AuthUpdated(this.user);
}

class AuthDeleteRequested extends AuthEvent {
  AuthDeleteRequested();
}
