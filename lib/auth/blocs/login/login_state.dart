part of 'login_bloc.dart';

@freezed
@JsonSerializable()
class LoginState with _$LoginState {
  const factory LoginState({
    @JsonStringConverter() required FormInputModel<String> email,
    @JsonStringConverter() required FormInputModel<String> password,
    @Default(BlocStatus.initial) BlocStatus status,
    String? formError,
  }) = _LoginState;

  factory LoginState.initial() => LoginState(
        email: FormInputModel(
            validator: (value) => value?.required() ?? value?.validateEmail()),
        password: FormInputModel(
            validator: (value) => value.required() ?? value?.validateLength(6)),
      );
}
