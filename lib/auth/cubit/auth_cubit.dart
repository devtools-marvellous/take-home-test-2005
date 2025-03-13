import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/auth/auth_repository.dart';
import 'package:take_home_marv/data/storage_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final StorageRepository storageRepository;

  AuthCubit(this.authRepository, this.storageRepository)
      : super(const InitialState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      emit(const LoadingState());

      final isLoggedIn = await authRepository.isLoggedIn();
      final rememberMe = storageRepository.getRememberMe();

      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        emit(AuthorizedState(user: user));
      } else if (isLoggedIn == false && rememberMe == true) {
        // if not logged in but remember me is true, try to refresh token
        _tryToRefreshToken();
      } else {
        emit(const UnauthorizedState());
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void _tryToRefreshToken() async {
    bool newAccessToken = await authRepository.refreshToken();
    if (newAccessToken) {
      final user = await authRepository.getCurrentUser();
      emit(AuthorizedState(user: user));
    } else {
      emit(const UnauthorizedState());
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
