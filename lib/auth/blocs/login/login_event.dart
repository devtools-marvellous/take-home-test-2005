part of "login_bloc.dart";

@immutable
abstract class LoginEvent{
  const LoginEvent();
}


class LoginEmailChanged extends LoginEvent{
  final String value;
  const LoginEmailChanged(this.value);
}

class LoginPasswordChanged extends LoginEvent{
  final String value;
  const LoginPasswordChanged(this.value);
}


class LoginSubmitted extends LoginEvent {}