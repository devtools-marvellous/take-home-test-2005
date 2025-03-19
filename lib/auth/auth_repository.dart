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

      // First request OAuth token
      await TokenService.requestOAuthToken().then((tokenData) async {
        await TokenService.setAccessToken(
          tokenData['access_token'],
          TokenType.user,
        );
        await TokenService.setRefreshToken(tokenData['refresh_token']);
        await TokenService.setTokenExpire(tokenData['expires_in']);
      });


      // Mock API call with our service
      final response = await _apiService.post(
        AuthApiEndpoints.login,
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
      await _sharedPrefs.setString(_userKey, jsonEncode(user.toJson()));
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

      // Clear local storage
      await _sharedPrefs.remove(_userKey);
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
}
