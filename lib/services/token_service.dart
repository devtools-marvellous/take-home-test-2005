import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/auth_exceptions.dart';

enum TokenType { user, api, none }

extension TokenTypeExtension on TokenType {
  String get stringRepresentation {
    switch (this) {
      case TokenType.user:
        return 'user';
      case TokenType.api:
        return 'api';
      default:
        return 'none';
    }
  }

  static TokenType fromString(String? stringTokenType) {
    switch (stringTokenType ?? "") {
      case 'user':
        return TokenType.user;
      case 'api':
        return TokenType.api;
      default:
        return TokenType.none;
    }
  }
}

class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpireKey = 'token_expire';

  // Mock API credentials
  static const String _clientId = '1';
  static const String _clientSecret = 'mock_client_secret';

  // A grace period before token expiry to preemptively refresh the token.
  Duration _expiryBuffer = Duration(seconds: 60);

  // Static variable to hold a token refresh Future to prevent race conditions.
  Future<void>? _refreshingTokenFuture;

  // Returns a valid access token.
  // If the current token is expired, attempts to refresh it.
  Future<String?> getValidAccessToken() async {
    if (await isTokenExpired()) {
      // If a refresh is already in progress, wait for it to complete.
      if (_refreshingTokenFuture != null) {
        await _refreshingTokenFuture;
      } else {
        _refreshingTokenFuture = _refreshToken();
        try {
          final tokenData = await requestOAuthToken();
          await setAccessToken(tokenData['access_token'], TokenType.user);
          await setRefreshToken(tokenData['refresh_token']);
          await setTokenExpire(tokenData['expires_in']);
        } catch (e) {
          throw TokenException('Failed to refresh token: ${e.toString()}');
        }
      }
    }
    return getAccessToken();
  }

  // Handles the token refresh process.
  Future<void> _refreshToken() async {
    try {
      final tokenData = await requestOAuthToken();
      await setAccessToken(tokenData['access_token'], TokenType.user);
      await setRefreshToken(tokenData['refresh_token']);
      await setTokenExpire(tokenData['expires_in']);
    } catch (e) {
      // If refresh fails, clear tokens and rethrow the error.
      await removeTokenData();
      rethrow;
    }
  }

  // Retrieves the current access token from storage.
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Stores the access token and its type.
  Future<void> setAccessToken(
    String? token,
    TokenType tokenType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token ?? '');
    await prefs.setString(_tokenTypeKey, tokenType.stringRepresentation);
  }

  // Retrieves the refresh token from storage.
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Stores the refresh token
  Future<void> setRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token ?? '');
  }

  // Sets the token expiry time in storage.
  Future<void> setTokenExpire(int expireInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(Duration(seconds: expireInSeconds)).subtract(_expiryBuffer).millisecondsSinceEpoch;
    await prefs.setInt(_tokenExpireKey, expiryTime);
  }

  // Checks if the token is expired (or near expiry, considering the buffer)
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_tokenExpireKey);

    if (expiryTime == null) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  // Retrieves the current token type
  Future<TokenType> currentTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    final stringTokenType = prefs.getString(_tokenTypeKey);
    return TokenTypeExtension.fromString(stringTokenType);
  }

  // Remove all token-related data from storage.
  Future<bool> removeTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_tokenExpireKey);
    return true;
  }

  // Mock method to simulate requesting an OAuth token
  Future<Map<String, dynamic>> requestOAuthToken() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'access_token': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'expires_in': 3600, // 1 hour
      'token_type': 'bearer',
    };
  }
}
