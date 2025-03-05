// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      success: json['success'] as bool? ?? false,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: AuthResponse._tokenFromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errors': instance.errors,
      'user': instance.user,
      'token': instance.token,
    };
