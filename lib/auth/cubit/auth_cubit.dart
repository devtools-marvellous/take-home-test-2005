import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/config/logger.dart';

import 'auth_state.dart';
import '/models/user.model.dart';

import '../auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository}) : super(const InitialState());

  final AuthRepository authRepository;

  Future<void> appStarted() async {
    try {
      if (authRepository.isAuthenticated) {
        emit(const LoadingState());
        final user = await authRepository.retrieveCachedUser();
        emit(AuthorizedState(user: user));
      } else {
        emit(const UnauthorizedState());
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    logger.d('Logging in with email: $email');
    emit(const LoadingState());
    try {
      final bool loginSuccess = await authRepository.login(email, password);
      if (loginSuccess) {
        final User user = await authRepository.fetchUserProfile();
        emit(AuthorizedState(user: user));
      } else {
        emit(const ErrorState('Login failed.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> refreshProfile() async {
    logger.d('Refresh user profile');
    emit(const LoadingState());
    try {
      final User user = await authRepository.fetchUserProfile();
      emit(AuthorizedState(user: user));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(const UnauthorizedState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
