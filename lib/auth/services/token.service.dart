import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:take_home_marv/core/exceptions/token_exception.dart';

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
    switch (stringTokenType ?? '') {
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
  TokenService._();

  /// Singleton instance
  static final instance = TokenService._();

  /// Secure storage
  final _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpireKey = 'token_expire';

  // Mock API credentials
  static const String _clientId = '1';
  static const String _clientSecret = 'mock_client_secret';

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> setAccessToken(
    String? token,
    TokenType tokenType,
  ) async {
    await _storage.write(key: _accessTokenKey, value: token ?? '');
    await _storage.write(
        key: _tokenTypeKey, value: tokenType.stringRepresentation);
  }

  Future<void> setRefreshToken(String? token) async {
    await _storage.write(key: _refreshTokenKey, value: token ?? '');
  }

  Future<void> setTokenExpire(int expireInSeconds) async {
    final expiryTime = DateTime.now()
        .toUtc()
        .add(Duration(seconds: expireInSeconds))
        .millisecondsSinceEpoch;

    await _storage.write(key: _tokenExpireKey, value: expiryTime.toString());
  }

  Future<bool> isTokenExpired() async {
    final expiryTimeString = await _storage.read(key: _tokenExpireKey);
    if (expiryTimeString == null) {
      return true;
    }

    final expiryTime = int.tryParse(expiryTimeString);
    if (expiryTime == null) {
      return true;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime >= expiryTime) {
      debugPrint('Token expired try');
      await refreshToken();
      return false;
    }

    debugPrint('Token not expired');
    return false;
  }

  Future<void> refreshToken() async {
    try {
      final newTokenData = await TokenService.requestOAuthToken();

      await TokenService.instance
          .setAccessToken(newTokenData['access_token'], TokenType.user);
      await TokenService.instance
          .setRefreshToken(newTokenData['refresh_token']);
      await TokenService.instance.setTokenExpire(newTokenData['expires_in']);
    } catch (e) {
      throw TokenException(message: 'Failed to refresh token');
    }
  }

  Future<TokenType> currentTokenType() async {
    final stringTokenType = await _storage.read(key: _tokenTypeKey);
    return TokenTypeExtension.fromString(stringTokenType);
  }

  Future<bool> removeTokenData() async {
    try {
      await _storage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> getTokenExpiryTime() async {
    final expiryTimeString = await _storage.read(key: _tokenExpireKey);
    if (expiryTimeString == null) return null;

    final expiryTime = int.tryParse(expiryTimeString);
    if (expiryTime == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(expiryTime).toUtc();
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
      'expires_in': 60,
      'token_type': 'bearer',
    };
  }
}
