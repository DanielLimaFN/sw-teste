import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sw_test/core/constants/app_constants.dart';

class HttpHelper {
  final Dio _dio = Dio();
  final _secureStorage = const FlutterSecureStorage();

  Future<bool> hasStoredToken() async {
    final token = await _secureStorage.read(key: 'techtest_access_token');
    return token != null && token.isNotEmpty;
  }

  Future<bool> verifyStoredTokenIsValid() async {
    await _ensureToken();
    try {
      await _dio.get(AppConstants.baseUrl + AppConstants.userEndpoint);
      return true;
    } catch (_) {
      await refreshToken();
      try {
        await _dio.get(AppConstants.baseUrl + AppConstants.userEndpoint);
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'techtest_access_token');
  }

  Future<String?> _getRefreshToken() async {
    return await _secureStorage.read(key: 'techtest_refresh_token');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'techtest_access_token', value: accessToken);
    await _secureStorage.write(key: 'techtest_refresh_token', value: refreshToken);
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<void> login(String username, String password) async {
    final response = await _dio.post(
      AppConstants.baseUrl + AppConstants.tokenEndpoint,
      data: {
        'grant_type': 'password',
        'client_id': AppConstants.clientId,
        'username': username,
        'password': password,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    await _saveTokens(
      response.data['access_token'],
      response.data['refresh_token'] ?? '',
    );
  }

  Future<void> refreshToken() async {
    final storedRefresh = await _getRefreshToken();
    if (storedRefresh == null || storedRefresh.isEmpty) return;
    try {
      final response = await _dio.post(
        AppConstants.baseUrl + AppConstants.tokenEndpoint,
        data: {
          'grant_type': 'refresh_token',
          'client_id': AppConstants.clientId,
          'refresh_token': storedRefresh
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      await _saveTokens(
        response.data['access_token'],
        response.data['refresh_token'] ?? '',
      );
    } catch (_) {}
  }

  Future<void> _ensureToken() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> getRequest(String path, {Map<String, dynamic>? queryParams}) async {
    await _ensureToken();
    try {
      return await _dio.get(AppConstants.baseUrl + path, queryParameters: queryParams);
    } catch (_) {
      await refreshToken();
      return await _dio.get(AppConstants.baseUrl + path, queryParameters: queryParams);
    }
  }

  Future<Response> postRequest(String path, dynamic data) async {
    await _ensureToken();
    try {
      return await _dio.post(AppConstants.baseUrl + path, data: data);
    } catch (_) {
      await refreshToken();
      return await _dio.post(AppConstants.baseUrl + path, data: data);
    }
  }

  Future<Response> putRequest(String path, dynamic data) async {
    await _ensureToken();
    try {
      return await _dio.put(AppConstants.baseUrl + path, data: data);
    } catch (_) {
      await refreshToken();
      return await _dio.put(AppConstants.baseUrl + path, data: data);
    }
  }
}
