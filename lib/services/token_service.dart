import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/enums/auth_enums.dart';

class AccessToken {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final int? tokenType;

  const AccessToken({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
}

class TokenService {
  final SharedPreferences _sharedPrefs;

  TokenService(this._sharedPrefs);

  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpireKey = 'token_expire';

  // Mock API credentials
  static const String _clientId = '1';
  static const String _clientSecret = 'mock_client_secret';

  Future<String?> getAccessToken() async {
    return _sharedPrefs.getString(_accessTokenKey);
  }

  Future<void> setAccessToken(
    String? token,
    TokenType tokenType,
  ) async {
    await _sharedPrefs.setString(_accessTokenKey, token ?? '');
    await _sharedPrefs.setString(_tokenTypeKey, tokenType.name);
  }

  Future<String?> getRefreshToken() async {
    return _sharedPrefs.getString(_refreshTokenKey);
  }

  Future<void> setRefreshToken(String? token) async {
    await _sharedPrefs.setString(_refreshTokenKey, token ?? '');
  }

  Future<void> setTokenExpire(int expireInSeconds) async {
    final expiryTime = DateTime.now()
        .add(Duration(seconds: expireInSeconds))
        .millisecondsSinceEpoch;
    await _sharedPrefs.setInt(_tokenExpireKey, expiryTime);
  }

  Future<bool> isTokenExpired() async {
    final expiryTime = _sharedPrefs.getInt(_tokenExpireKey);

    if (expiryTime == null) return true;

    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  Future<TokenType> currentTokenType() async {
    final stringTokenType = _sharedPrefs.getString(_tokenTypeKey);
    return TokenType.fromString(stringTokenType);
  }

  Future<bool> removeTokenData() async {
    await _sharedPrefs.remove(_accessTokenKey);
    await _sharedPrefs.remove(_refreshTokenKey);
    await _sharedPrefs.remove(_tokenTypeKey);
    await _sharedPrefs.remove(_tokenExpireKey);
    return true;
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
    return AccessToken.fromJson(mockTokenJson);
  }

  // Refresh token handling
  Future<void> _handleTokenRefresh() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return;
      }

      // Mock refresh token response
      final tokenData = await requestOAuthToken();

      await setAccessToken(
        tokenData.accessToken,
        TokenType.user,
      );
      await setRefreshToken(tokenData.refreshToken);
      await setTokenExpire(tokenData.expiresIn ?? 0);
    } catch (e) {
      print('Failed to refresh token: $e');
    }
  }
}
