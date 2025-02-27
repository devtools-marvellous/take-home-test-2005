import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:take_home_marv/services/token_service.dart';

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

class ApiService {
  static const String baseUrl = 'https://mockapiurl.com/api';

  // GET request
  Future<ApiResponse> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Add delay to simulate network
      await Future.delayed(const Duration(milliseconds: 500));

      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParams,
      );

      final token = await TokenService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(uri, headers: headers);

      // Simulate token expiry randomly (10% chance)
      if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
        await _handleTokenRefresh();
      }

      return _parseResponse(response);
    } catch (e) {
      return ApiResponse.error(['Network error: ${e.toString()}']);
    }
  }

  // POST request
  Future<ApiResponse> post(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      // Add delay to simulate network
      await Future.delayed(const Duration(milliseconds: 500));

      final uri = Uri.parse('$baseUrl/$endpoint');

      final token = await TokenService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );

      // Simulate token expiry randomly (10% chance)
      if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
        await _handleTokenRefresh();
      }

      return _parseResponse(response);
    } catch (e) {
      return ApiResponse.error(['Network error: ${e.toString()}']);
    }
  }

  // Parse response
  ApiResponse _parseResponse(http.Response response) {
    try {
      final jsonBody = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonBody);
    } catch (e) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(success: true);
      } else {
        return ApiResponse.error(
          ['Failed to parse response: ${response.statusCode}'],
        );
      }
    }
  }

  // Refresh token handling
  Future<void> _handleTokenRefresh() async {
    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null) {
        return;
      }

      // Mock refresh token response
      final tokenData = await TokenService.requestOAuthToken();

      await TokenService.setAccessToken(
        tokenData['access_token'],
        TokenType.user,
      );
      await TokenService.setRefreshToken(tokenData['refresh_token']);
      await TokenService.setTokenExpire(tokenData['expires_in']);
    } catch (e) {
      print('Failed to refresh token: $e');
    }
  }
}
