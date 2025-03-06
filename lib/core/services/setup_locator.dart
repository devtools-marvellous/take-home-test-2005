import 'package:get_it/get_it.dart';
import 'package:take_home_marv/auth/repositories/auth.repo.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(AuthRepository.new);
}

void postLoginSetup(String userId, GetIt i) {}
