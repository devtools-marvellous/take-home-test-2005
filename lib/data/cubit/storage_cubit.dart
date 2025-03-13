import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/data/cubit/storage_state.dart';
import 'package:take_home_marv/data/storage_repository.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageRepository repository;

  StorageCubit(this.repository) : super(const InitialState());

  void saveRememberMe(bool rememberMe) {
    repository.saveRememberMe(rememberMe);
    emit(RememberMeState(rememberMe));
  }

  bool getRememberMe() {
    return repository.getRememberMe();
  }
}
