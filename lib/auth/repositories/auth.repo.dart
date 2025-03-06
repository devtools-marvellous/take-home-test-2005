import 'package:flutter/widgets.dart';
import 'package:take_home_marv/auth/models/_models.dart';
import 'package:take_home_marv/auth/services/_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:take_home_marv/core/exceptions/token_exception.dart';
import 'package:take_home_marv/core/services/setup_locator.dart';

class AuthRepository {
  UserModel? _currentUser;
  final BehaviorSubject<UserModel?> _currentUserSubject =
      BehaviorSubject<UserModel?>();

  AuthRepository();

  /// Stream containing the [UserModel]
  Stream<UserModel?> get stream => _currentUserSubject.stream;
  UserModel? get currentUser => _currentUser;

  final tokenService = TokenService.instance;
  final ApiService _apiService = ApiService();
  static const String _userKey = 'current_user';

  // Login to app
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // First request OAuth token
      final tokenData = await TokenService.requestOAuthToken();
      await tokenService.setAccessToken(
        tokenData['access_token'],
        TokenType.user,
      );
      await tokenService.setRefreshToken(tokenData['refresh_token']);
      await tokenService.setTokenExpire(tokenData['expires_in']);

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
        final user = UserModel(
          id: '1',
          email: email,
          firstName: 'Test',
          lastName: 'User',
          emailVerified: true,
        );

        _setCurrentUser(user);
        debugPrint('User: $user');

        if (locator.currentScopeName != 'loggedIn') {
          locator.pushNewScope(
            scopeName: 'loggedIn',
            init: (i) => postLoginSetup(user.id, i),
          );
        }

        return user;
      } else {
        throw Exception(response.errors?.join(', ') ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel?> checkAuth() async {
    try {
      final tokenType = await tokenService.currentTokenType();
      final isExpired = await tokenService.isTokenExpired();
      final isValid = tokenType == TokenType.user && !isExpired;

      final user = isValid ? await getCurrentUser() : null;

      _setCurrentUser(user);
      debugPrint('User logged in : $user');

      if (user != null && locator.currentScopeName != 'loggedIn') {
        locator.pushNewScope(
          scopeName: 'loggedIn',
          init: (i) => postLoginSetup(user.id, i),
        );
      }

      return user;
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Make a logout API call
      await _apiService.post('logout');

      _setCurrentUser(null);
      debugPrint('popScopes');
      await locator.popScopesTill('loggedIn');
      await tokenService.removeTokenData();
    } catch (e) {
      // Even if API call fails, clear local data
      _setCurrentUser(null);
      debugPrint('popScopes');
      await locator.popScopesTill('loggedIn');

      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      // Check if token is still valid
      final user = await checkAuth();
      if (user == null) {
        throw TokenException(message: 'Token is invalid');
      }

      // In a real app, we would fetch the latest user data from the API
      // Here we're just returning the cached user
      final response = await _apiService.get('user/profile');

      if (!response.success) {
        throw Exception(
            response.errors?.join(', ') ?? 'Failed to get user profile');
      }

      return user;
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    _currentUserSubject.add(user);
  }
}
