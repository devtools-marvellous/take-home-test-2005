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

abstract class ITokenService {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? token, TokenType tokenType);
  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String? token);
  Future<bool> isTokenExpired();
  Future<Map<String, dynamic>> requestOAuthToken(); // Fetch new tokens
  Future<void> setTokenExpire(int expireInSeconds); // Set expiration time
  Future <TokenType> currentTokenType();
  Future <bool> removeTokenData();
  Future <void> handleTokenRefresh();
}