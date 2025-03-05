import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_home_marv/config/constants.dart';

import 'package:take_home_marv/services/token_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('TokenService', () {
    late TokenService tokenService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      tokenService = TokenService(mockSharedPreferences);
    });

    test('Initializes tokens from SharedPreferences', () {
      when(() => mockSharedPreferences.getString(accessTokenKey)).thenReturn('testAccessToken');
      when(() => mockSharedPreferences.getString(refreshTokenKey)).thenReturn('testRefreshToken');
      when(() => mockSharedPreferences.getString(tokenExpireKey)).thenReturn(DateTime.now().toIso8601String());

      tokenService = TokenService(mockSharedPreferences);

      expect(tokenService.accessToken, 'testAccessToken');
      expect(tokenService.refreshToken, 'testRefreshToken');
    });

    test('isAccessTokenExpired returns false when no expiry is set', () {
      expect(tokenService.isAccessTokenExpired, false);
    });

    test('storeTokens stores tokens in SharedPreferences', () async {
      const accessToken = 'newAccessToken';
      const refreshToken = 'newRefreshToken';
      final accessTokenExpiry = DateTime.now().toUtc().add(const Duration(days: 1));
      final accessTokenExpiryString = accessTokenExpiry.toIso8601String();

      // Stub SharedPreferences' setString method to return Future<bool>
      when(() => mockSharedPreferences.setString(accessTokenKey, accessToken)).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setString(refreshTokenKey, refreshToken)).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setString(tokenExpireKey, accessTokenExpiryString))
          .thenAnswer((_) async => true);

      await tokenService.storeTokens(accessToken, refreshToken, accessTokenExpiry);

      // Verify that SharedPreferences' setString method was called with the correct arguments
      verify(() => mockSharedPreferences.setString(accessTokenKey, accessToken)).called(1);
      verify(() => mockSharedPreferences.setString(refreshTokenKey, refreshToken)).called(1);
      verify(() => mockSharedPreferences.setString(tokenExpireKey, accessTokenExpiryString)).called(1);

      // Assert that the tokens are stored in the TokenService (DefaultAuthManager) instance
      expect(tokenService.accessToken, accessToken);
      expect(tokenService.refreshToken, refreshToken);
    });

    test('clearTokens removes tokens from SharedPreferences', () async {
      when(() => mockSharedPreferences.remove(accessTokenKey)).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.remove(refreshTokenKey)).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.remove(tokenExpireKey)).thenAnswer((_) async => true);

      await tokenService.clearTokens();

      verify(() => mockSharedPreferences.remove(accessTokenKey)).called(1);
      verify(() => mockSharedPreferences.remove(refreshTokenKey)).called(1);
      verify(() => mockSharedPreferences.remove(tokenExpireKey)).called(1);

      expect(tokenService.accessToken, null);
      expect(tokenService.refreshToken, null);
    });
  });
}
