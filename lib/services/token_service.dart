import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/enums/auth_enums.dart';

class AccessToken {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresInSeconds;
  final DateTime? expiresAt;
  final String? tokenType;

  const AccessToken({
    this.accessToken,
    this.refreshToken,
    this.expiresInSeconds,
    this.expiresAt,
    this.tokenType,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    final expiresInSeconds = json['expires_in'];
    final expiresAt = json['expires_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['expires_at'])
        : DateTime.now().add(Duration(seconds: expiresInSeconds));

    return AccessToken(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresInSeconds: expiresInSeconds,
      expiresAt: expiresAt,
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt?.millisecondsSinceEpoch,
      'token_type': tokenType,
    };
  }
}

class TokenService {
  final SharedPreferences _sharedPrefs;

  TokenService(this._sharedPrefs);

  static const String _tokenTypeKey = 'token_type';
  static const String _storedTokenKey = 'stored_token';

  AccessToken? _cachedToken;

  AccessToken? getStoredAccessToken() {
    if (_cachedToken != null) return _cachedToken;

    final storedTokenString = _sharedPrefs.getString(_storedTokenKey);
    if (storedTokenString == null) return null;

    final token = AccessToken.fromJson(jsonDecode(storedTokenString));
    _cachedToken = token;
    return token;
  }

  Future<void> setAccessToken(
    AccessToken? token,
    TokenType tokenType,
  ) async {
    _cachedToken = token;

    if (token != null) {
      final jsonString = jsonEncode(token.toJson());
      await _sharedPrefs.setString(_storedTokenKey, jsonString);
      await _sharedPrefs.setString(_tokenTypeKey, tokenType.name);
    }
  }

  Future<bool> isTokenExpired() async {
    final token = _cachedToken ?? getStoredAccessToken();
    if (token == null || token.expiresAt == null) return true;

    final now = DateTime.now();
    final remainingTime = token.expiresAt!.difference(now).inMinutes;
    return remainingTime <= 2;
  }

  Future<TokenType> currentTokenType() async {
    final stringTokenType = _sharedPrefs.getString(_tokenTypeKey);
    return TokenType.fromString(stringTokenType);
  }

  Future<bool> removeTokenData() async {
    _cachedToken = null;
    await _sharedPrefs.remove(_storedTokenKey);
    await _sharedPrefs.remove(_tokenTypeKey);
    return true;
  }
}
