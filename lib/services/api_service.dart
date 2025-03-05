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

  // Before making requests, use:
  // final token = await TokenService.getValidAccessToken();
  // to ensure the token is valid.

  // GET request
  Future<ApiResponse> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      // Add delay to simulate network
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock successful response
      return ApiResponse(
        success: true,
        data: _getMockData(endpoint),
      );
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

      // Mock successful response
      return ApiResponse(
        success: true,
        data: _getMockData(endpoint),
      );
    } catch (e) {
      return ApiResponse.error(['Network error: ${e.toString()}']);
    }
  }

  // Mock data generator based on endpoint
  dynamic _getMockData(String endpoint) {
    switch (endpoint) {
      case 'login':
        return {
          'user': {
            'id': '1',
            'email': 'test@example.com',
            'firstName': 'Test',
            'lastName': 'User',
            'emailVerified': true,
          },
          'access_token': 'mock_access_token',
          'refresh_token': 'mock_refresh_token',
          'expires_in': 3600,
        };
      case 'user/profile':
        return {
          'id': '1',
          'email': 'test@example.com',
          'firstName': 'Test',
          'lastName': 'User',
          'emailVerified': true,
        };
      default:
        return null;
    }
  }

  // Parse response (kept for interface consistency)
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
}
