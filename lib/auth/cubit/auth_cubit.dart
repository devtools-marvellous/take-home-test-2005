import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/auth/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(const InitialState());

  Future<void> initialise() async {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      emit(const LoadingState());

      final isLoggedIn = await authRepository.isLoggedIn();

      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        emit(AuthorizedState(user: user));
      } else {
        emit(const UnauthorizedState());
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(const LoadingState());

      final user = await authRepository.login(email, password);

      emit(AuthorizedState(user: user));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(const LoadingState());

      await authRepository.logout();

      emit(const UnauthorizedState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
