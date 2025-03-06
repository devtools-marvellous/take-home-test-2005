import 'package:take_home_marv/services/token/token_service.dart';

// An implementatiopn of ITokenSerice for use with encrypted storage
class SecureStorageTokenService implements ITokenService {
  @override
  Future<TokenType> currentTokenType() {
    // TODO: implement currentTokenType
    throw UnimplementedError();
  }

  @override
  Future<String?> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenExpired() {
    // TODO: implement isTokenExpired
    throw UnimplementedError();
  }

  @override
  Future<bool> removeTokenData() {
    // TODO: implement removeTokenData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> requestOAuthToken() {
    // TODO: implement requestOAuthToken
    throw UnimplementedError();
  }

  @override
  Future<void> setAccessToken(String? token, TokenType tokenType) {
    // TODO: implement setAccessToken
    throw UnimplementedError();
  }

  @override
  Future<void> setRefreshToken(String? token) {
    // TODO: implement setRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> setTokenExpire(int expireInSeconds) {
    // TODO: implement setTokenExpire
    throw UnimplementedError();
  }
  
  @override
  Future<void> handleTokenRefresh() {
    // TODO: implement handleTokenRefresh
    throw UnimplementedError();
  }
}
