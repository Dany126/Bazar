import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:e_commerce/core/error/api_error_handler.dart';
import 'package:e_commerce/core/error/failure.dart';

class ApiService {
  late final Dio _dio;

  final String baseUrl;
  final FlutterSecureStorage _storage;

  final String refreshTokenPath;

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  String? _accessToken;
  String? _refreshToken;

  ApiService({
    required this.baseUrl,
    required this.refreshTokenPath,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  // ============================================================
  // INTERCEPTORS
  // ============================================================

  void _setupInterceptors() {
    // ----------------------------------------------------------
    // DEBUG LOGGING ONLY (no header logic here — single source
    // of truth for attaching the Authorization header lives in
    // the QueuedInterceptorsWrapper below).
    // ----------------------------------------------------------
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('======================================');
          print('REQUEST: ${options.method} ${options.uri}');
          print('ACCESS TOKEN (in memory): $_accessToken');
          print('AUTH HEADER: ${options.headers['Authorization']}');
          print('======================================');

          handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        // ========================================================
        // REQUEST
        // ========================================================
        onRequest: (options, handler) async {
          final isAuthRequest = _isAuthRequest(options.path);

          if (!isAuthRequest) {
            _accessToken ??= await _storage.read(key: _accessTokenKey);

            if (_accessToken != null && _accessToken!.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $_accessToken';
            }
          }

          handler.next(options);
        },

        // ========================================================
        // ERROR
        // ========================================================
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          final isRefreshRequest = _isRefreshRequest(error.requestOptions.path);

          if (statusCode == 401 && !alreadyRetried && !isRefreshRequest) {
            print('>>> Got 401, attempting token refresh...');

            final refreshed = await _refreshAccessToken();

            print('>>> Refresh result: $refreshed');

            if (refreshed) {
              final requestOptions = error.requestOptions;

              requestOptions.headers['Authorization'] = 'Bearer $_accessToken';

              requestOptions.extra['retried'] = true;

              try {
                final response = await _dio.fetch(requestOptions);

                return handler.resolve(response);
              } on DioException catch (e) {
                return handler.next(e);
              }
            }

            // Refresh failed.
            await clearAuthTokens();
          }

          handler.next(error);
        },
      ),
    );

    // ============================================================
    // LOGGING
    // ============================================================

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  // ============================================================
  // AUTH REQUEST
  // ============================================================

  bool _isAuthRequest(String path) {
    return path.contains('/user/login') ||
        path.contains('/user/register') ||
        path.contains('/user/signup') ||
        path.contains(refreshTokenPath);
  }

  bool _isRefreshRequest(String path) {
    return path.contains(refreshTokenPath);
  }

  // ============================================================
  // SAVE TOKENS
  // ============================================================

  Future<void> setAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    await _storage.write(key: _accessTokenKey, value: accessToken);

    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // ============================================================
  // ACCESS TOKEN
  // ============================================================

  Future<String?> getAccessToken() async {
    _accessToken ??= await _storage.read(key: _accessTokenKey);

    return _accessToken;
  }

  // ============================================================
  // REFRESH TOKEN
  // ============================================================

  Future<String?> getRefreshToken() async {
    _refreshToken ??= await _storage.read(key: _refreshTokenKey);

    return _refreshToken;
  }

  // ============================================================
  // REFRESH ACCESS TOKEN
  // ============================================================

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        print('>>> No refresh token available in storage.');
        return false;
      }

      // IMPORTANT:
      // Separate Dio instance.
      // This prevents an infinite refresh loop.

      final refreshDio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            )
            ..interceptors.add(
              // TEMP DIAGNOSTIC LOGGING — remove once refresh flow is confirmed working.
              LogInterceptor(
                requestBody: true,
                responseBody: true,
                error: true,
              ),
            );

      final response = await refreshDio.post(
        refreshTokenPath,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        print('>>> Refresh response was not a JSON object: $data');
        return false;
      }

      final newAccessToken = data['accessToken'] as String?;

      final newRefreshToken = data['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        print('>>> Refresh response had no accessToken: $data');
        return false;
      }

      await setAuthTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );

      return true;
    } catch (e) {
      print('>>> Refresh threw an exception: $e');
      return false;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> clearAuthTokens() async {
    _accessToken = null;
    _refreshToken = null;

    await _storage.delete(key: _accessTokenKey);

    await _storage.delete(key: _refreshTokenKey);
  }

  // ============================================================
  // IS LOGGED IN
  // ============================================================

  Future<bool> get isLoggedIn async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  // ============================================================
  // GET
  // ============================================================

  Future<Either<Failure, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      return Right(response.data);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  // ============================================================
  // POST
  // ============================================================

  Future<Either<Failure, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  // ============================================================
  // PUT
  // ============================================================

  Future<Either<Failure, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  // ============================================================
  // PATCH
  // ============================================================

  Future<Either<Failure, dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<Either<Failure, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
