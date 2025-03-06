class ApiResponse {
  final bool success;
  final dynamic data;
  final List<String>? errors;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  ApiResponse({
    required this.success,
    this.data,
    this.errors,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'],
      errors: json['errors'] != null
          ? List<String>.from(json['errors'].map((e) => e.toString()))
          : null,
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
    );
  }

  factory ApiResponse.error(List<String> errors) {
    return ApiResponse(
      success: false,
      errors: errors,
    );
  }
}
