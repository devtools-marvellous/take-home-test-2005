import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/utils/locator.dart';
import 'auth/auth_repository.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';
import 'pages/login_page.dart';
import 'pages/success_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(getIt<AuthRepository>()),
        ),
      ],
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
    );
  }
}
