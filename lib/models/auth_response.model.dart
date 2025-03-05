import 'package:json_annotation/json_annotation.dart';

import 'token.model.dart';
import 'user.model.dart';

part 'auth_response.model.g.dart';

@JsonSerializable()
class AuthResponse {
  AuthResponse({
    this.success = false,
    this.errors,
    this.user,
    this.token,
  });

  final bool success;
  final List<String>? errors;
  final User? user;
  @JsonKey(fromJson: _tokenFromJson)
  final Token? token;

  static Token? _tokenFromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return null;
    }
    return Token.fromJson(json);
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  static Future<AuthResponse> error(List<String> errors) async {
    throw Exception('Error: ${errors.join(', ')}');
  }
}
