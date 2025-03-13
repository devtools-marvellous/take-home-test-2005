import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/data/cubit/storage_cubit.dart';
import 'package:take_home_marv/data/storage_repository.dart';
import 'auth/auth_repository.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';
import 'pages/login_page.dart';
import 'pages/success_page.dart';

void main() {
  // This line is needed to ensure the SharedPreferences 
  // can be initialised during app start.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final StorageRepository storageRepository = StorageRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Refactor Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepository, storageRepository),
          ),
          BlocProvider(
            create: (context) => StorageCubit(storageRepository),
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
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
