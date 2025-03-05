import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:take_home_marv/auth/auth_repository.dart';
import 'package:take_home_marv/auth/cubit/auth_cubit.dart';
import 'package:take_home_marv/auth/cubit/auth_state.dart';
import 'package:take_home_marv/models/user.model.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('AuthCubit', () {
    late AuthRepository authRepository;
    late AuthCubit authCubit;

    setUp(() {
      authRepository = MockAuthRepository();
      authCubit = AuthCubit(authRepository: authRepository);
    });

    tearDown(() {
      authCubit.close();
    });

    test('initial state is Uninitialized', () {
      expect(authCubit.state, isA<InitialState>());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when appStarted and authRepository.isAuthenticated returns false',
      build: () {
        when(() => authRepository.isAuthenticated).thenAnswer((_) => false);
        return authCubit;
      },
      seed: () => const InitialState(),
      act: (cubit) => cubit.appStarted(),
      expect: () => [const UnauthorizedState()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Authorized] when appStarted and authRepository.isAuthenticated returns true',
      build: () {
        when(() => authRepository.isAuthenticated).thenAnswer((_) => true);
        when(() => authRepository.retrieveCachedUser())
            .thenAnswer((_) async => User(id: '123', email: 'test@example.com'));
        return authCubit;
      },
      seed: () => const InitialState(),
      act: (cubit) => cubit.appStarted(),
      expect: () => [isA<LoadingState>(), isA<AuthorizedState>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Authorized] when logIn is called',
      build: () {
        when(() => authRepository.login(any(), any())).thenAnswer((_) async {
          return true;
        });
        when(() => authRepository.fetchUserProfile())
            .thenAnswer((_) async => User(id: '123', email: 'test@example.com'));
        return authCubit;
      },
      seed: () => const InitialState(),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [isA<LoadingState>(), isA<AuthorizedState>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when logOut is called',
      build: () {
        when(() => authRepository.logout()).thenAnswer((_) async {});
        return authCubit;
      },
      seed: () => const InitialState(),
      act: (cubit) => cubit.logout(),
      expect: () => [const UnauthorizedState()],
    );
  });
}

class MockAuthRepository extends Mock implements AuthRepository {}
