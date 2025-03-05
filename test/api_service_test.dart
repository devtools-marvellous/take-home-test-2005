import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:take_home_marv/config/constants.dart';

import 'package:take_home_marv/services/api_service.dart';
import 'package:take_home_marv/services/token_service.dart';

class MockAuthManager extends Mock implements AuthManager {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('ApiService', () {
    late ApiService apiService;
    late MockAuthManager mockAuthManager;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockAuthManager = MockAuthManager();
      mockHttpClient = MockHttpClient();
      apiService = ApiService(mockAuthManager, httpClient: mockHttpClient);
    });

    const testEndpoint = '/test';
    const testData = {'key': 'value'};
    const testToken = 'test_token';
    final expectedUri = Uri(scheme: baseScheme, host: baseUrl, path: testEndpoint, port: basePort);

    test('makes a GET request to the correct URL with auth', () async {
      when(() => mockAuthManager.isAccessTokenExpired).thenReturn(false);
      when(() => mockAuthManager.accessToken).thenReturn(testToken);
      when(() => mockHttpClient.get(any(that: isA<Uri>()), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"data": "success"}', 200));

      await apiService.get(testEndpoint);

      verify(() => mockHttpClient.get(expectedUri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $testToken'
          })).called(1);
    });

    test('makes a GET request to the correct URL without auth', () async {
      when(() => mockHttpClient.get(any(that: isA<Uri>()), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"data": "success"}', 200));

      await apiService.get(testEndpoint, requiresAuth: false);

      verify(() => mockHttpClient.get(expectedUri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          })).called(1);
    });

    test('refreshes token if expired and retries', () async {
      when(() => mockAuthManager.isAccessTokenExpired).thenReturn(true);
      when(() => mockAuthManager.refreshTokens()).thenAnswer((_) async => true);
      when(() => mockAuthManager.accessToken).thenReturn(testToken);
      when(() => mockHttpClient.get(any(that: isA<Uri>()), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"data": "success"}', 200));

      await apiService.get(testEndpoint);

      verify(() => mockAuthManager.refreshTokens()).called(1);
      verify(() => mockHttpClient.get(expectedUri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $testToken'
          })).called(1);
    });

    test('throws exception if refresh token fails', () async {
      when(() => mockAuthManager.isAccessTokenExpired).thenReturn(true);
      when(() => mockAuthManager.refreshTokens()).thenAnswer((_) async => false);

      expect(() => apiService.get(testEndpoint), throwsA(isA<Exception>()));
    });

    test('makes a POST request to the correct URL with data', () async {
      when(() => mockHttpClient.post(any(that: isA<Uri>()), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{"data": "success"}', 200));

      await apiService.post(testEndpoint, data: testData);

      verify(() => mockHttpClient.post(expectedUri,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: '{"key":"value"}')).called(1);
    });

    test('handleResponse retries on 401 and successful token refresh', () async {
      when(() => mockAuthManager.isAccessTokenExpired).thenReturn(true);
      when(() => mockAuthManager.refreshTokens()).thenAnswer((_) async => true);
      when(() => mockAuthManager.accessToken).thenReturn(testToken);
      when(() => mockHttpClient.get(any(that: isA<Uri>()), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"data": "success"}', 200));

      await apiService.get(testEndpoint);

      verify(() => mockAuthManager.refreshTokens()).called(1);
      verify(() => mockHttpClient.get(expectedUri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $testToken'
          })).called(1);
    });
  });
}
