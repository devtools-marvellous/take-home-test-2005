import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_repository.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';
import 'pages/login_page.dart';
import 'pages/success_page.dart';
import 'services/api_service.dart';
import 'services/token_service.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Client httpClient = http.Client();

  // Create the dependencies
  final AuthManager tokenService = TokenService(prefs);
  final UserManager userService = UserService(prefs);
  final ApiBase apiService = ApiService(tokenService, httpClient: httpClient);

  final AuthRepository authRepository = AuthRepository(apiService, tokenService, userService);

  // Create the Bloc and inject the dependencies
  final AuthCubit authCubit = AuthCubit(authRepository: authRepository);

  runApp(MaterialApp(
    title: 'Login Refactor Test',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
    ),
    home: BlocProvider<AuthCubit>(
      create: (_) => authCubit..appStarted(),
      child: const AuthenticationWrapper(),
    ),
  ));
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthorizedState) {
          return const SuccessPage();
        }
        return const LoginPage();
      },
    );
  }
}
