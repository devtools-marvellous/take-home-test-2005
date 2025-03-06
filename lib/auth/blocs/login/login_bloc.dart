import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_home_marv/auth/_auth.dart';
import 'package:take_home_marv/core/exceptions/token_exception.dart';
import 'package:take_home_marv/core/extensions/validation.dart';
import 'dart:async';

import 'package:take_home_marv/core/models/bloc_status.model.dart';
import 'package:take_home_marv/core/models/form_input.model.dart/form_input.model.dart';
import 'package:take_home_marv/core/services/setup_locator.dart';

part 'login_state.dart';
part 'login_event.dart';
part 'login_bloc.freezed.dart';
part 'login_bloc.g.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);

    on<LoginPasswordChanged>(_onPasswordChanged);

    on<LoginSubmitted>(_onSubmit);
  }

  FutureOr<void> _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith.email(value: event.value));
  }

  FutureOr<void> _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith.password(value: event.value));
  }

  Future<void> _onSubmit(
    LoginSubmitted _,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final newState = state
        .copyWith(
          email: state.email.setDirty(),
          password: state.password.setDirty(),
        )
        .copyWith(status: BlocStatus.initial);

    if (newState.email.error == null && newState.password.error == null) {
      try {
        await locator<AuthRepository>().login(
          email: newState.email.value!,
          password: newState.password.value!,
        );
      } on TokenException {
        emit(newState.copyWith(formError: 'Invalid email or password'));
      } catch (e) {
        emit(
          newState.copyWith(
            formError: 'Error logging in, please try again later',
          ),
        );
      }
      emit(newState.copyWith(status: BlocStatus.success));
    } else {
      emit(newState.copyWith(status: BlocStatus.initial));
    }
  }
}
