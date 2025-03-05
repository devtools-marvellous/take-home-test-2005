import 'package:take_home_marv/config/logger.dart';
import 'package:take_home_marv/services/user_service.dart';

import '/models/auth_response.model.dart';
import '/models/user.model.dart';
import '/services/api_service.dart';
import '../services/token_service.dart';

class AuthRepository {
  AuthRepository(this._apiService, this._tokenService, this._userService);

  // Depend on the interface, not the concrete class
  final ApiBase _apiService;
  final AuthManager _tokenService;
  final UserManager _userService;

  // Login to app
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        'login',
        data: {'email': email, 'password': password},
        requiresAuth: false, // Login doesn't require auth
      );

      final authResponse = AuthResponse.fromJson(response);
      final newAccessToken = authResponse.token?.accessToken;
      final newRefreshToken = authResponse.token?.refreshToken;

      if (newAccessToken != null && newRefreshToken != null) {
        // Store the tokens using the AuthManager
        final accessTokenExpiry = DateTime.now().toUtc().add(Duration(seconds: authResponse.token?.expiresIn ?? 0));
        await _tokenService.storeTokens(newAccessToken, newRefreshToken, accessTokenExpiry);
        // Store the user data if available
        if (authResponse.user != null) {
          await _userService.storeUserData(authResponse.user!);
        } else {
          await _userService.removeUserData();
        }

        return true; // Successful login
      } else {
        throw Exception('Invalid login response: Missing access or refresh token.');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  bool get isAuthenticated {
    return (_tokenService.accessToken ?? '').isNotEmpty && !_tokenService.isAccessTokenExpired;
  }

  Future<void> logout() async {
    try {
      // Make a logout API call
      await _apiService.post('logout', requiresAuth: true);
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    } finally {
      logger.d('Clearing user data and tokens');
      await _userService.removeUserData();
      await _tokenService.clearTokens();
    }
  }

  Future<User> retrieveCachedUser() async {
    return _userService.retrieveUserData();
  }

  Future<User> fetchUserProfile() async {
    try {
      final response = await _apiService.get('user/profile');
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }
}
