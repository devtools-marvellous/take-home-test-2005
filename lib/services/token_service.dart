import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/token.model.dart';
import '/config/logger.dart';
import '/config/constants.dart';

abstract class AuthManager {
  String? get accessToken;
  String? get refreshToken;
  bool get isAccessTokenExpired;
  Future<bool> refreshTokens();
  Future<void> storeTokens(String accessToken, String refreshToken, DateTime accessTokenExpiry);
  Future<void> clearTokens();
}

class TokenService implements AuthManager {
  TokenService(this._prefs) {
    _accessToken = _prefs.getString(accessTokenKey);
    _refreshToken = _prefs.getString(refreshTokenKey);
    final expiryString = _prefs.getString(tokenExpireKey);
    if (expiryString != null) {
      _accessTokenExpiry = DateTime.tryParse(expiryString)?.toUtc();
    }
  }

  final SharedPreferences _prefs;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiry;

  @override
  Future<bool> refreshTokens() async {
    if (_refreshToken == null) {
      logger.d('No refresh token available');
      return false;
    }

    final uri = Uri(scheme: baseScheme, host: baseUrl, port: basePort, path: 'refresh');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'refresh_token': _refreshToken});

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final token = Token.fromJson(jsonDecode(response.body));
        final newAccessToken = token.accessToken;
        final newRefreshToken = token.refreshToken;
        final expiresIn = token.expiresIn ?? 0;

        if (newAccessToken != null && newRefreshToken != null) {
          final accessTokenExpiry = DateTime.now().toUtc().add(Duration(seconds: expiresIn));
          await storeTokens(newAccessToken, newRefreshToken, accessTokenExpiry);
          _accessToken = newAccessToken; // Ensure access token is updated
          _refreshToken = newRefreshToken; // Ensure refresh token is updated
          _accessTokenExpiry = accessTokenExpiry; // Ensure expiry is updated
          logger.i('Token refreshed successfully');
          return true;
        } else {
          logger.d('Error during token refresh: Missing access or refresh token');
          return false;
        }
      } else {
        logger.e('Error during token refresh: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Error during token refresh: ${e.toString()}');
      return false;
    }
  }

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  bool get isAccessTokenExpired {
    if (_accessTokenExpiry == null) {
      return false; // NO expired if no expiry is set
    }
    return DateTime.now().toUtc().isAfter(_accessTokenExpiry!);
  }

  @override
  Future<void> storeTokens(String accessToken, String refreshToken, DateTime accessTokenExpiry) async {
    await _prefs.setString(accessTokenKey, accessToken);
    await _prefs.setString(refreshTokenKey, refreshToken);
    await _prefs.setString(tokenExpireKey, accessTokenExpiry.toIso8601String());
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _accessTokenExpiry = accessTokenExpiry;
  }

  @override
  Future<void> clearTokens() async {
    await _prefs.remove(accessTokenKey);
    await _prefs.remove(refreshTokenKey);
    await _prefs.remove(tokenExpireKey);
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiry = null;
  }
}
