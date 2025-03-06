import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:take_home_marv/auth/auth_repository.dart';
import 'package:take_home_marv/auth/cubit/auth_cubit.dart';
import 'package:take_home_marv/auth/cubit/auth_state.dart';
import 'package:take_home_marv/main.dart';
import 'package:take_home_marv/models/user.model.dart';
import 'package:take_home_marv/pages/login_page.dart';
import 'package:take_home_marv/pages/success_page.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('AuthenticationWrapper', () {
    testWidgets('renders LoginPage when state is not AuthorizedState', (WidgetTester tester) async {
      // Arrange
      final mockAuthCubit = MockAuthCubit();
      when(() => mockAuthCubit.state).thenReturn(const UnauthorizedState());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>(
            create: (context) => mockAuthCubit,
            child: const AuthenticationWrapper(),
          ),
        ),
      );

      // Assert
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(SuccessPage), findsNothing);
    });

    testWidgets('renders SuccessPage when state is AuthorizedState', (WidgetTester tester) async {
      // Arrange
      final mockAuthCubit = MockAuthCubit();
      when(() => mockAuthCubit.state).thenReturn(AuthorizedState(user: User(id: '1', email: 'test@example.com')));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>(
            create: (context) => mockAuthCubit,
            child: const AuthenticationWrapper(),
          ),
        ),
      );

      // Assert
      expect(find.byType(SuccessPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });
}

class MockAuthRepository extends Mock implements AuthRepository {}
