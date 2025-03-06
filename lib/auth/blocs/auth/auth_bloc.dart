import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/auth/models/_models.dart';
import 'package:take_home_marv/auth/repositories/auth.repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_home_marv/core/services/setup_locator.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authRepo = locator<AuthRepository>();
  late final StreamSubscription<UserModel?> _authSubscription;

  AuthBloc() : super(const AuthState()) {
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthDeleteRequested>(_onDeleteRequested);
    on<AuthUpdated>(_onAuthUpdated);

    _authSubscription = _authRepo.stream.listen((user) {
      add(AuthUpdated(user));
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepo.logout();
    emit(const AuthState());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepo.checkAuth();
  }

  FutureOr<void> _onAuthUpdated(
    AuthUpdated event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        user: event.user,
        status: event.user != null
            ? AuthStatus.authorised
            : AuthStatus.unauthorised,
      ),
    );
  }

  Future<void> _onDeleteRequested(
    AuthDeleteRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepo.logout();
  }
}
