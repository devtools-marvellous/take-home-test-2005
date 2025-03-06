import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:take_home_marv/services/api/api_service.dart';

import '../token/token_service.dart';

class MockApiService implements IApiService {
  final ITokenService _tokenService;

  MockApiService(this._tokenService);

  // Not used?
  static const String _baseUrl = 'https://mockapiurl.com/api';
  // Mock API credentials
  static const String _clientId = '1';
  static const String _clientSecret = 'mock_client_secret';

  // GET request
  @override
  Future<ApiResponse> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Add delay to simulate network
      await Future.delayed(const Duration(milliseconds: 500));

      // refresh token
      await _handleTokenRefresh();

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
  @override
  Future<ApiResponse> post(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      // Add delay to simulate network
      await Future.delayed(const Duration(milliseconds: 500));

      ApiResponse response;
      if (data?["forceMockError"] == true) {
        response = ApiResponse(
          success: false,
          data: null,
          errors: ['This is a simulated error response.'],
        );
      } else {
        response = ApiResponse(
          success: true,
          data: _getMockData(endpoint),
        );
      }

      if (!response.success && await _tokenService.isTokenExpired()) {
        await _handleTokenRefresh();
      }

      // But now we need to retry the request - wrapper function?

      return response;
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

  // Refresh token handling
  Future<void> _handleTokenRefresh() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        return;
      }

      // Mock refresh token response
      final tokenData = await _tokenService.requestOAuthToken();

      await _tokenService.setAccessToken(
        tokenData['access_token'],
        TokenType.user,
      );
      await _tokenService.setRefreshToken(tokenData['refresh_token']);
      await _tokenService.setTokenExpire(tokenData['expires_in']);
    } catch (e) {
      print('Failed to refresh token: $e');
    }
  }
}
