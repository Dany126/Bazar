import 'package:church_project/Core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

/// Generic, reusable API service for any Flutter project.
///
/// Usage:
///   final apiService = ApiService(baseUrl: 'https://api.example.com');
///   final result = await apiService.get('/books', queryParameters: {'q': 'flutter'});
///   result.fold(
///     (failure) => print(failure.message),
///     (data) => print(data),
///   );
class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({required this.baseUrl, String? authToken})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      ) {
    // Log every request/response while developing.
    // Remove or wrap in kDebugMode check before shipping to production.
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// Call this after login to attach the auth token to all future requests.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Call this on logout.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
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
