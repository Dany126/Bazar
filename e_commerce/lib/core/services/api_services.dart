import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_commerce/core/error/api_error_handler.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:dartz/dartz.dart';

/// Generic, reusable API service for any Flutter project, with token-based
/// auth: access token is auto-attached to every request, refreshed on 401,
/// and persisted in secure storage across app restarts.
///
/// Usage:
///   final apiService = ApiService(
///     baseUrl: 'https://api.example.com',
///     refreshTokenPath: '/auth/refresh',
///   );
///
///   // after login:
///   await apiService.setAuthTokens(accessToken: at, refreshToken: rt);
///
///   final result = await apiService.get('/books', queryParameters: {'q': 'flutter'});
///   result.fold(
///     (failure) => print(failure.message),
///     (data) => print(data),
///   );
///
///   // on logout:
///   await apiService.clearAuthTokens();
class ApiService {
  final Dio _dio;
  final String baseUrl;
  final FlutterSecureStorage _storage;

  /// Endpoint used to exchange a refresh token for a new access token,
  /// e.g. '/auth/refresh'. If null, expired tokens are never auto-refreshed
  /// (a 401 just bubbles up as a Failure).
  final String? refreshTokenPath;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'user/refresh';

  String? _accessToken;
  String? _refreshToken;

  ApiService({
    required this.baseUrl,
    this.refreshTokenPath,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage(),
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
       ) {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          _accessToken ??= await _storage.read(key: _accessTokenKey);
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          if (isUnauthorized && !alreadyRetried && refreshTokenPath != null) {
            final refreshed = await _refreshAccessToken();

            if (refreshed) {
              final retryOptions = error.requestOptions
                ..headers['Authorization'] = 'Bearer $_accessToken'
                ..extra['retried'] = true;

              try {
                final response = await _dio.fetch(retryOptions);
                return handler.resolve(response);
              } on DioException catch (e) {
                return handler.next(e);
              }
            } else {
              // Refresh failed — session is dead, clear it out.
              await clearAuthTokens();
            }
          }
          handler.next(error);
        },
      ),
    );

    // Log every request/response while developing.
    // Remove or wrap in kDebugMode check before shipping to production.
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<bool> _refreshAccessToken() async {
    _refreshToken ??= await _storage.read(key: _refreshTokenKey);
    if (_refreshToken == null || refreshTokenPath == null) return false;

    try {
      // Separate Dio instance: avoids re-triggering this same interceptor
      // and creating an infinite refresh loop.
      final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
      final response = await refreshDio.post(
        refreshTokenPath!,
        data: {'refresh_token': _refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken == null) return false;

      await setAuthTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? _refreshToken!,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Call after login (or after a manual token refresh) to persist tokens
  /// and attach them to all future requests.
  Future<void> setAuthTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    await _storage.write(key: _accessTokenKey, value: accessToken);

    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Call on logout to wipe tokens from memory and secure storage.
  Future<void> clearAuthTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Checks storage (not just memory) so it's reliable right after app start.
  Future<bool> get isLoggedIn async {
    _accessToken ??= await _storage.read(key: _accessTokenKey);
    return _accessToken != null;
  }

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
