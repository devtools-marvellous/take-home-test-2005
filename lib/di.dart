import 'package:get_it/get_it.dart';

import 'auth/auth_repository.dart';
import 'services/api_service.dart';
import 'services/auth_validator.dart';
import 'services/token_service.dart';

final getIt = GetIt.instance;

// Sets up the dependency injection locator.
// Registers sercices as a lazy singleton.
// Ensures a single shared instance is used throughout the app.
void setupLocator() {
  getIt.registerLazySingleton<AuthValidator>(() => AuthValidator());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<TokenService>(() => TokenService());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiService: getIt<ApiService>(),
      tokenService: getIt<TokenService>(),
      authValidator: getIt<AuthValidator>(),
    ),
  );
}
