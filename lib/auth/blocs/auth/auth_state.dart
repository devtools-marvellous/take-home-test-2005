part of 'auth_bloc.dart';

enum AuthStatus {
  authorised,
  unauthorised,
  initial;

  bool get isAuthorised => this == AuthStatus.authorised;
  bool get isUnauthorised => this == AuthStatus.unauthorised;
  bool get isInitial => this == AuthStatus.initial;
}

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    UserModel? user,
    @Default(AuthStatus.initial) AuthStatus status,
  }) = _AuthState;
}
