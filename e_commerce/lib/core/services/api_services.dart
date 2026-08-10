import 'package:cookie_jar/cookie_jar.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../error/failure.dart';

class ApiService {
  final Dio dio;
  final CookieJar cookieJar;

  String? _accessToken;

  ApiService({required this.dio, required this.cookieJar}) {
    // IMPORTANT:
    // This automatically saves Set-Cookie from the server
    // and automatically sends cookies with future requests.
    dio.interceptors.add(CookieManager(cookieJar));

    // Automatically add access token to requests.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }

          handler.next(options);
        },
      ),
    );
  }

  // ============================================================
  // ACCESS TOKEN
  // ============================================================

  Future<void> setAccessToken(String accessToken) async {
    _accessToken = accessToken;

    print('ACCESS TOKEN SAVED: $_accessToken');
  }

  String? get accessToken => _accessToken;

  // ============================================================
  // POST
  // ============================================================

  Future<Either<Failure, dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('======================================');
      print('REQUEST: POST $url');
      print('ACCESS TOKEN: $_accessToken');

      final response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      return Right(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR RESPONSE: ${e.response?.data}');

      return Left(
        ServerFailure(
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
                    e.message ??
                    'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // GET
  // ============================================================

  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('======================================');
      print('REQUEST: GET $url');
      print('ACCESS TOKEN: $_accessToken');

      final response = await dio.get(url, queryParameters: queryParameters);

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      return Right(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR RESPONSE: ${e.response?.data}');

      return Left(
        ServerFailure(
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
                    e.message ??
                    'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // PUT
  // ============================================================

  Future<Either<Failure, dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('======================================');
      print('REQUEST: PUT $url');
      print('ACCESS TOKEN: $_accessToken');

      final response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      return Right(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR RESPONSE: ${e.response?.data}');

      return Left(
        ServerFailure(
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
                    e.message ??
                    'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // PATCH
  // ============================================================

  Future<Either<Failure, dynamic>> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('======================================');
      print('REQUEST: PATCH $url');
      print('ACCESS TOKEN: $_accessToken');

      final response = await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      return Right(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR RESPONSE: ${e.response?.data}');

      return Left(
        ServerFailure(
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
                    e.message ??
                    'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<Either<Failure, dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('======================================');
      print('REQUEST: DELETE $url');
      print('ACCESS TOKEN: $_accessToken');

      final response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      return Right(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('STATUS CODE: ${e.response?.statusCode}');
      print('ERROR RESPONSE: ${e.response?.data}');

      return Left(
        ServerFailure(
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
                    e.message ??
                    'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // COOKIE
  // ============================================================

  /// Get all cookies for a URL.
  Future<List<Cookie>> getCookies(String url) async {
    return await cookieJar.loadForRequest(Uri.parse(url));
  }

  /// Get one specific cookie.
  Future<String?> getCookie(String url, String cookieName) async {
    final cookies = await cookieJar.loadForRequest(Uri.parse(url));

    for (final cookie in cookies) {
      if (cookie.name == cookieName) {
        return cookie.value;
      }
    }

    return null;
  }

  // ============================================================
  // CLEAR AUTH
  // ============================================================

  Future<void> clearAuthTokens() async {
    // Remove access token from memory.
    _accessToken = null;

    // Remove refresh token cookie.
    await cookieJar.deleteAll();

    print('AUTH TOKENS CLEARED');
  }

  Future<void> clearCookies() async {
    await cookieJar.deleteAll();

    print('COOKIES CLEARED');
  }
}
