// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      address: json['address'] as String?,
      address2: json['address2'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      if (instance.firstName case final value?) 'first_name': value,
      if (instance.lastName case final value?) 'last_name': value,
      if (instance.address case final value?) 'address': value,
      if (instance.address2 case final value?) 'address2': value,
      'email_verified': instance.emailVerified,
      if (instance.emailVerifiedAt?.toIso8601String() case final value?)
        'email_verified_at': value,
    };
