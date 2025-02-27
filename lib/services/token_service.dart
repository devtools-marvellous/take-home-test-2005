import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> setAccessToken(
    String? token,
    TokenType tokenType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token ?? '');
    await prefs.setString(_tokenTypeKey, tokenType.stringRepresentation);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> setRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token ?? '');
  }

  static Future<void> setTokenExpire(int expireInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now()
        .add(Duration(seconds: expireInSeconds))
        .millisecondsSinceEpoch;
    await prefs.setInt(_tokenExpireKey, expiryTime);
  }

  static Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_tokenExpireKey);

    if (expiryTime == null) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  static Future<TokenType> currentTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    final stringTokenType = prefs.getString(_tokenTypeKey);
    return TokenTypeExtension.fromString(stringTokenType);
  }

  static Future<bool> removeTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_tokenExpireKey);
    return true;
  }

  // Mock method to simulate requesting an OAuth token
  static Future<Map<String, dynamic>> requestOAuthToken() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'access_token':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token':
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'expires_in': 3600, // 1 hour
      'token_type': 'bearer',
    };
  }
}
