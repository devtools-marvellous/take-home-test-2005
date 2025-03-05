import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/models/user_model.dart';
import 'package:take_home_marv/services/token_service.dart';
import 'package:take_home_marv/services/api_service.dart';

import '../services/auth_validator.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  static const String _userKey = 'current_user';

  // Login to app
  Future<User> login(String email, String password) async {
    try {
      // First request OAuth token
      await TokenService.requestOAuthToken().then((tokenData) async {
        await TokenService.setAccessToken(
          tokenData['access_token'],
          TokenType.user,
        );
        await TokenService.setRefreshToken(tokenData['refresh_token']);
        await TokenService.setTokenExpire(tokenData['expires_in']);
      });

      // Validate credentials using the new validator
      AuthValidator().validateCredentials(email, password);

      // // Simple validation (should be in a separate validator class)
      // if (email.isEmpty || password.isEmpty) {
      //   throw Exception('Email and password cannot be empty');
      // }

      // if (!email.contains('@')) {
      //   throw Exception('Please enter a valid email');
      // }

      // if (password.length < 6) {
      //   throw Exception('Password must be at least 6 characters');
      // }

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
    final tokenType = await TokenService.currentTokenType();
    final isExpired = await TokenService.isTokenExpired();

    return tokenType == TokenType.user && !isExpired;
  }

  Future<void> logout() async {
    try {
      // Make a logout API call
      await _apiService.post('logout');

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await TokenService.removeTokenData();
    } catch (e) {
      // Even if API call fails, clear local data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await TokenService.removeTokenData();

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
        throw Exception(response.errors?.join(', ') ?? 'Failed to get user profile');
      }

      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }
}
