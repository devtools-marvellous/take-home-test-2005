import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class StorageState extends Equatable {
    const StorageState();
}

class InitialState extends StorageState{
  const InitialState() : super();
  
  @override
  List<Object?> get props => [];
}

class RememberMeState extends StorageState{
  final bool value;
  const RememberMeState(this.value) : super();
  
  @override
  List<Object?> get props => [value];
}