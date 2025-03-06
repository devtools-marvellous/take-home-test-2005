import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/models/user_model.dart';
import 'package:take_home_marv/services/api/api_service.dart';
import 'package:take_home_marv/services/token/token_service.dart';

class AuthRepository {
  final IApiService _apiService;
  final ITokenService _tokenService;
  static const String _userKey = 'current_user';

  AuthRepository(this._apiService, this._tokenService);

  // Login to app
  Future<User> login(String email, String password) async {
    try {
      // First request OAuth token
      await _tokenService.requestOAuthToken().then((tokenData) async {
        await _tokenService.setAccessToken(
          tokenData['access_token'],
          TokenType.user,
        );
        await _tokenService.setRefreshToken(tokenData['refresh_token']);
        await _tokenService.setTokenExpire(tokenData['expires_in']);
      });

      // Mock API call with our service
      final response = await _apiService.post(
        'login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.success) {
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user.toJson()));

        return user;
      } else {
        throw Exception(response.errors?.join(', ') ?? 'Login failed');
      }
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
      await _apiService.post('logout');

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await _tokenService.removeTokenData();
    } catch (e) {
      // Even if API call fails, clear local data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await _tokenService.removeTokenData();

      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

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
      final response = await _apiService.get('user/profile');

      if (!response.success) {
        throw Exception(
            response.errors?.join(', ') ?? 'Failed to get user profile');
      }

      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }
}
