import 'package:json_annotation/json_annotation.dart';

part 'token.model.g.dart';

@JsonSerializable()
class Token {
  Token({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
