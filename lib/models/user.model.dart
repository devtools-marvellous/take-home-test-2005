import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.address2,
    this.emailVerified = false,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? address2;
  final bool emailVerified;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$UserToJson(this);
    json['email_verified_at'] = emailVerified ? DateTime.now().toIso8601String() : null;
    return json;
  }
}
