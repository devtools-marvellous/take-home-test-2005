class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? address2;
  final bool emailVerified;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.address2,
    this.emailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      address2: json['address2'],
      emailVerified: json['email_verified_at'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'address2': address2,
      'email_verified_at':
          emailVerified ? DateTime.now().toIso8601String() : null,
    };
  }
}
