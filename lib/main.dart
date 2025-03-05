import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/services/api/api_service.dart';
import 'package:take_home_marv/services/token/token_service.dart';

import 'auth/auth_repository.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';
import 'pages/login_page.dart';
import 'pages/success_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ITokenService _apiService = SharedPreferencesTokenService();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepository(
              MockApiService(_apiService),
              _apiService,
            ),
        child: BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(context.read<AuthRepository>()),
          child: MaterialApp(
            title: 'Login Refactor Test',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true,
            ),
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthorizedState) {
                  return const SuccessPage();
                }
                return const LoginPage();
              },
            ),
          ),
        ));
  }
}
