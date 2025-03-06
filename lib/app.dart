import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/auth/pages/_pages.dart';
import 'auth/repositories/auth.repo.dart';
import 'auth/blocs/auth/auth_bloc.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Refactor Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status.isAuthorised) {
              return const SuccessPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
