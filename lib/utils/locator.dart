import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/auth/auth_repository.dart';
import 'package:take_home_marv/constants/api_endpoints.dart';
import 'package:take_home_marv/services/token_service.dart';
import 'package:take_home_marv/services/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<TokenService>(
      TokenService(getIt<SharedPreferences>()));

  getIt.registerSingleton<AuthRepository>(
    AuthRepository(
      ApiService(AuthApiEndpoints.baseUrl),
      getIt<TokenService>(),
      getIt<SharedPreferences>(),
    ),
  );
}
