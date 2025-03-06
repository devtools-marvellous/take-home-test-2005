import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.model.freezed.dart';

part 'user.model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? address,
    String? address2,
    @Default(false) bool emailVerified,
    DateTime? emailVerifiedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
