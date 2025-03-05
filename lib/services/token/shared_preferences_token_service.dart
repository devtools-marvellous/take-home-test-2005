import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/services/token/token_service.dart';

// An implementatiopn of ITokenSerice for use with SharedPreferences
class SharedPreferencesTokenService implements ITokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpireKey = 'token_expire';

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<void> setAccessToken(
    String? token,
    TokenType tokenType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token ?? '');
    await prefs.setString(_tokenTypeKey, tokenType.stringRepresentation);
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> setRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token ?? '');
  }

  @override
  Future<void> setTokenExpire(int expireInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now()
        .add(Duration(seconds: expireInSeconds))
        .millisecondsSinceEpoch;
    await prefs.setInt(_tokenExpireKey, expiryTime);
  }

  @override
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_tokenExpireKey);

    if (expiryTime == null) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  Future<void> ensureValidAccessToken() async {
    if (await isTokenExpired()) {
      await handleTokenRefresh(); // Use refresh token to get a new access token.
    }
  }

  @override
  Future<TokenType> currentTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    final stringTokenType = prefs.getString(_tokenTypeKey);
    return TokenTypeExtension.fromString(stringTokenType);
  }

  @override
  Future<bool> removeTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_tokenExpireKey);
    return true;
  }

  // Refresh token handling
  @override
  Future<void> handleTokenRefresh() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return;
      }

      // Mock refresh token response
      final tokenData = await requestOAuthToken();

      await setAccessToken(
        tokenData['access_token'],
        TokenType.user,
      );
      await setRefreshToken(tokenData['refresh_token']);
      await setTokenExpire(tokenData['expires_in']);
    } catch (e) {
      print('Failed to refresh token: $e');
    }
  }

  // Mock method to simulate requesting an OAuth token
  @override
  Future<Map<String, dynamic>> requestOAuthToken() async {
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
