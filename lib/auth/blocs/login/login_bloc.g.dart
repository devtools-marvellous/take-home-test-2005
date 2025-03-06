// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginState _$LoginStateFromJson(Map<String, dynamic> json) => LoginState(
      email: const JsonStringConverter().fromJson(json['email'] as String),
      password:
          const JsonStringConverter().fromJson(json['password'] as String),
      status: $enumDecode(_$BlocStatusEnumMap, json['status']),
      formError: json['form_error'] as String?,
    );

Map<String, dynamic> _$LoginStateToJson(LoginState instance) =>
    <String, dynamic>{
      'email': const JsonStringConverter().toJson(instance.email),
      'password': const JsonStringConverter().toJson(instance.password),
      'status': _$BlocStatusEnumMap[instance.status]!,
      if (instance.formError case final value?) 'form_error': value,
    };

const _$BlocStatusEnumMap = {
  BlocStatus.initial: 'initial',
  BlocStatus.loading: 'loading',
  BlocStatus.success: 'success',
  BlocStatus.error: 'error',
};
