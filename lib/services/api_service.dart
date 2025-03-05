import 'dart:convert';
import 'package:http/http.dart' as http;

import '/config/constants.dart';
import '/config/logger.dart';

import 'token_service.dart';

abstract class ApiBase {
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams, bool requiresAuth});
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data, bool requiresAuth});
}

class ApiService implements ApiBase {
  ApiService(
    this._tokenService, {
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final AuthManager _tokenService;
  final http.Client _httpClient;

  @override
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true, // default is true for GET, to encourage secure-by-default behavior
  }) async {
    return _makeRequest(
      endpoint,
      queryParams: queryParams,
      requiresAuth: requiresAuth,
      method: 'GET',
    );
  }

  @override
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? data,
    bool requiresAuth = false,
  }) async {
    return _makeRequest(
      endpoint,
      data: data,
      requiresAuth: requiresAuth,
      method: 'POST',
    );
  }

  Future<dynamic> _makeRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    bool requiresAuth = false,
    required String method,
  }) async {
    final uri = Uri(scheme: baseScheme, host: baseUrl, path: endpoint, port: basePort, queryParameters: queryParams);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      if (_tokenService.isAccessTokenExpired) {
        // Token expired, trigger refresh.  We don't throw an exception here.
        try {
          //Attempt to refresh token
          final refreshSucess = await _tokenService.refreshTokens();
          if (!refreshSucess) {
            throw Exception('Could not refresh token');
          }
        } catch (e) {
          rethrow;
        }
      }

      final accessToken = _tokenService.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Unauthenticated: No access token found.');
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      http.Response response;
      if (method == 'GET') {
        response = await _httpClient.get(uri, headers: headers);
      } else if (method == 'POST') {
        final body = data != null ? jsonEncode(data) : null;
        response = await _httpClient.post(uri, headers: headers, body: body);
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      return _handleResponse(
        response,
        endpoint,
        () => _makeRequest(
          endpoint,
          queryParams: queryParams,
          data: data,
          requiresAuth: requiresAuth,
          method: method,
        ),
      );
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> _handleResponse(
    http.Response response,
    String endpoint,
    Future<dynamic> Function() retry,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        return jsonDecode(response.body);
      } else {
        return response.bodyBytes;
      }
    } else if (response.statusCode == 401 && _tokenService.refreshToken != null) {
      // Token expired, attempt refresh
      logger.i('Token expired, attempting to refresh...');
      try {
        await _tokenService.refreshTokens();
        logger.d('Token refreshed, retrying original request...');
        return await retry();
      } catch (refreshError) {
        logger.e('Token refresh failed: $refreshError');
        throw Exception('Authentication failed: Could not refresh token. Please log in again.');
      }
    } else {
      logger.e('API Error: ${response.statusCode} - ${response.body}');
      try {
        final errorBody = jsonDecode(response.body);
        if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
          throw Exception('API Error: ${errorBody['message']}');
        } else {
          throw Exception('API Error: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('API Error: ${response.statusCode}');
      }
    }
  }
}
