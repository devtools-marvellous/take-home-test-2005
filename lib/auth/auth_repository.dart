import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/constants/api_endpoints.dart'
    show AuthApiEndpoints;
import 'package:take_home_marv/models/user_model.dart';
import 'package:take_home_marv/utils/validator_helper.dart';
import 'package:take_home_marv/services/token_service.dart';
import 'package:take_home_marv/services/api_service.dart';
import 'package:take_home_marv/enums/auth_enums.dart';

class AuthRepository {
  final ApiService _apiService;
  final TokenService _tokenService;
  final SharedPreferences _sharedPrefs;

  static const String _userKey = 'current_user';
  static const String _clientId = '1';
  static const String _clientSecret = 'mock_client_secret';

  AuthRepository(
    this._apiService,
    this._tokenService,
    this._sharedPrefs,
  );

  // Login to app
  Future<User> login(String email, String password) async {
    try {
      ValidatorHelper.validateEmail(email);
      ValidatorHelper.validatePassword(password);

      await requestOAuthToken();

      // Mock API call with our service
      final response = await _apiService.post(
        AuthApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (!response.success) {
        throw Exception(response.errors?.join(', ') ?? 'Login failed');
      }

      // In a real app, the user would come from the response
      // Here we're creating a mock user
      final user = User(
        id: '1',
        email: email,
        firstName: 'Test',
        lastName: 'User',
        emailVerified: true,
      );

      // Save the user in SharedPreferences
      await _sharedPrefs.setString(_userKey, jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    final tokenType = await _tokenService.currentTokenType();
    final isExpired = await _tokenService.isTokenExpired();

    return tokenType == TokenType.user && !isExpired;
  }

  Future<void> logout() async {
    try {
      // Make a logout API call
      await _apiService.post(AuthApiEndpoints.logout);
    } catch (e) {
      // TODO: better to log out error here
      throw Exception('Logout failed: ${e.toString()}');
    }

    // Clear local storage
    await _sharedPrefs.remove(_userKey);
    await _tokenService.removeTokenData();
  }

  Future<User> getCurrentUser() async {
    try {
      final userJson = _sharedPrefs.getString(_userKey);

      if (userJson == null) {
        throw Exception('User not found');
      }

      // Check if token is still valid
      final isLoggedIn = await this.isLoggedIn();
      if (!isLoggedIn) {
        throw Exception('Token expired, please login again');
      }

      // In a real app, we would fetch the latest user data from the API
      // Here we're just returning the cached user
      final response = await _apiService.get(AuthApiEndpoints.userProfile);

      if (!response.success) {
        throw Exception(
            response.errors?.join(', ') ?? 'Failed to get user profile');
      }

      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  // Mock method to simulate requesting an OAuth token
  Future<AccessToken> requestOAuthToken() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockTokenJson = {
      'access_token':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token':
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'expires_in': 3600, // 1 hour
      'token_type': 'bearer',
    };

    final token = AccessToken.fromJson(mockTokenJson);
    await _tokenService.setAccessToken(token, TokenType.user);
    return token;
  }

  Future<void> refreshTokenIfNeeded() async {
    final isExpired = await _tokenService.isTokenExpired();
    if (isExpired) {
      await _refreshToken();
    }
  }

  Future<void> _refreshToken() async {
    try {
      final storedToken = _tokenService.getStoredAccessToken();
      if (storedToken?.refreshToken == null) {
        await logout();
        return;
      }

      final response = await _apiService.post(
        AuthApiEndpoints.tokenRequest,
        data: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'refresh_token': storedToken!.refreshToken,
        },
      );

      if (!response.success) {
        throw Exception(
            response.errors?.join(', ') ?? 'Failed to refresh token');
      }

      final newToken = AccessToken.fromJson(response.data);
      await _tokenService.setAccessToken(newToken, TokenType.user);
    } catch (e) {
      throw Exception('Failed to get OAuthToken');
    }
  }
}
