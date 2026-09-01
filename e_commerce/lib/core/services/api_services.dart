import 'dart:async';
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../error/failure.dart';

class ApiService {
  final Dio dio;
  final CookieJar cookieJar;
  final String refreshTokenUrl;

  String? _accessToken;

  bool _isRefreshing = false;

  final List<Completer<void>> _refreshQueue = [];

  Timer? _refreshTimer;

  static const Duration _refreshBuffer = Duration(seconds: 30);

  ApiService({
    required this.dio,
    required this.cookieJar,
    required this.refreshTokenUrl,
  }) {
    // ======================================================
    // COOKIE MANAGER (Native only)
    // ======================================================

    if (!kIsWeb) {
      dio.interceptors.add(CookieManager(cookieJar));
    }

    // ======================================================
    // AUTH INTERCEPTOR
    // ======================================================

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }

          print('======================================');
          print('REQUEST: ${options.method} ${options.uri}');
          print('ACCESS TOKEN: $_accessToken');

          handler.next(options);
        },

        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          final request = error.requestOptions;

          final isRefreshRequest =
              request.path == refreshTokenUrl ||
              request.uri.toString() == refreshTokenUrl;

          final alreadyRetried = request.extra['retried'] == true;

          print('======================================');
          print('ERROR STATUS: $statusCode');
          print('ERROR URL: ${request.uri}');

          if (statusCode == 401 && !isRefreshRequest && !alreadyRetried) {
            try {
              print('401 DETECTED -> REFRESHING TOKEN');

              await _refreshAccessToken();

              final retryOptions = request.copyWith(
                extra: {...request.extra, 'retried': true},
              );

              if (_accessToken != null && _accessToken!.isNotEmpty) {
                retryOptions.headers['Authorization'] = 'Bearer $_accessToken';
              }

              print(
                'RETRYING: '
                '${retryOptions.method} '
                '${retryOptions.uri}',
              );

              final response = await dio.fetch(retryOptions);

              return handler.resolve(response);
            } catch (e) {
              print('TOKEN REFRESH FAILED: $e');

              await clearAuthTokens();

              return handler.next(error);
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  // ==========================================================
  // ACCESS TOKEN
  // ==========================================================

  Future<void> setAccessToken(String accessToken) async {
    _accessToken = accessToken;

    print('ACCESS TOKEN SAVED: $_accessToken');

    _scheduleProactiveRefresh(accessToken);
  }

  String? get accessToken => _accessToken;

  // ==========================================================
  // JWT EXPIRATION
  // ==========================================================

  DateTime? _getJwtExpiry(String jwt) {
    try {
      final parts = jwt.split('.');

      if (parts.length != 3) {
        return null;
      }

      var payload = parts[1];

      payload = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');

      final decoded = utf8.decode(base64Url.decode(payload));

      final map = jsonDecode(decoded) as Map<String, dynamic>;

      final exp = map['exp'];

      if (exp == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch((exp as num).toInt() * 1000);
    } catch (e) {
      print('FAILED TO DECODE JWT: $e');

      return null;
    }
  }

  // ==========================================================
  // PROACTIVE REFRESH
  // ==========================================================

  void _scheduleProactiveRefresh(String jwt) {
    _refreshTimer?.cancel();

    final expiry = _getJwtExpiry(jwt);

    if (expiry == null) {
      print('JWT EXPIRY NOT FOUND');
      return;
    }

    final timeUntilExpiry = expiry.difference(DateTime.now());

    final delay = timeUntilExpiry - _refreshBuffer;

    print('ACCESS TOKEN EXPIRES: $expiry');

    if (delay.isNegative) {
      print('TOKEN IS EXPIRED/NEAR EXPIRY -> REFRESH');

      unawaited(_safeProactiveRefresh());

      return;
    }

    print('PROACTIVE REFRESH IN: $delay');

    _refreshTimer = Timer(delay, () {
      unawaited(_safeProactiveRefresh());
    });
  }

  Future<void> _safeProactiveRefresh() async {
    try {
      await _refreshAccessToken();
    } catch (e) {
      print('PROACTIVE REFRESH FAILED: $e');
    }
  }

  // ==========================================================
  // REFRESH ACCESS TOKEN
  // ==========================================================

  Future<void> _refreshAccessToken() async {
    if (_isRefreshing) {
      final completer = Completer<void>();

      _refreshQueue.add(completer);

      return completer.future;
    }

    _isRefreshing = true;

    try {
      print('======================================');
      print('REFRESH ACCESS TOKEN');
      print('URL: $refreshTokenUrl');

      // ======================================================
      // LOAD COOKIES
      // ======================================================

      final cookies = await cookieJar.loadForRequest(
        Uri.parse(refreshTokenUrl),
      );

      print('COOKIES BEFORE REFRESH:');

      for (final cookie in cookies) {
        print('${cookie.name} = ${cookie.value}');
      }

      // IMPORTANT:
      // Your server cookie is called refreshToken.
      final refreshCookie = cookies.where(
        (cookie) => cookie.name == 'refreshToken' && cookie.value.isNotEmpty,
      );

      if (refreshCookie.isEmpty) {
        throw Exception('Refresh token cookie not found');
      }

      // ======================================================
      // REFRESH REQUEST
      // ======================================================

      final response = await dio.post(refreshTokenUrl);

      print(
        'REFRESH STATUS: '
        '${response.statusCode}',
      );

      print(
        'REFRESH RESPONSE: '
        '${response.data}',
      );

      // ======================================================
      // RESPONSE
      // ======================================================

      if (response.data is! Map) {
        throw Exception('Invalid refresh response');
      }

      final newAccessToken = response.data['accessToken']?.toString();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw Exception('Refresh response does not contain accessToken');
      }

      // ======================================================
      // SAVE ACCESS TOKEN
      // ======================================================

      await setAccessToken(newAccessToken);

      print('ACCESS TOKEN REFRESHED SUCCESSFULLY');

      // ======================================================
      // RELEASE WAITING REQUESTS
      // ======================================================

      for (final completer in _refreshQueue) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }

      _refreshQueue.clear();
    } catch (e) {
      print('REFRESH ERROR: $e');

      for (final completer in _refreshQueue) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }

      _refreshQueue.clear();

      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  // ==========================================================
  // RESTORE SESSION
  // ==========================================================

  Future<bool> restoreSession() async {
    print('======================================');
    print('CHECKING SESSION');

    try {
      final cookies = await cookieJar.loadForRequest(
        Uri.parse(refreshTokenUrl),
      );

      print('STORED COOKIES: $cookies');

      for (final cookie in cookies) {
        print(
          'COOKIE: '
          '${cookie.name} = ${cookie.value}',
        );
      }

      // IMPORTANT:
      // Server sends refreshToken
      final hasRefreshToken = cookies.any(
        (cookie) => cookie.name == 'refreshToken' && cookie.value.isNotEmpty,
      );

      if (!hasRefreshToken) {
        print('NO REFRESH TOKEN COOKIE');

        return false;
      }

      print('REFRESH TOKEN FOUND');

      // ======================================================
      // GET NEW ACCESS TOKEN
      // ======================================================

      await _refreshAccessToken();

      print('SESSION RESTORED');

      return true;
    } catch (e) {
      print('SESSION RESTORE FAILED: $e');

      // Don't allow cookie filesystem errors
      // to crash the application.
      await clearAuthTokens();

      return false;
    }
  }

  // ==========================================================
  // FCM TOKEN
  // ==========================================================

  Future<Either<Failure, String>> getFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) {
        return Left(ServerFailure(message: 'Could not get FCM token'));
      }

      print('FCM TOKEN: $token');

      return Right(token);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // SEND FCM TOKEN
  // ==========================================================

  Future<Either<Failure, dynamic>> sendFcmToken(String url) async {
    final result = await getFcmToken();

    return result.fold((failure) => Left(failure), (token) {
      return post(url, data: {'fcm_token': token});
    });
  }

  // ==========================================================
  // POST
  // ==========================================================

  Future<Either<Failure, dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // GET
  // ==========================================================

  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // PUT
  // ==========================================================

  Future<Either<Failure, dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // PATCH
  // ==========================================================

  Future<Either<Failure, dynamic>> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<Either<Failure, dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // DIO ERROR
  // ==========================================================

  ServerFailure _handleDioError(DioException e) {
    String message = 'Something went wrong';

    if (e.response?.data is Map) {
      final data = e.response!.data as Map;

      message = data['message']?.toString() ?? e.message ?? message;
    } else {
      message = e.message ?? message;
    }

    print('DIO ERROR: $message');

    print('STATUS: ${e.response?.statusCode}');

    print('URL: ${e.requestOptions.uri}');

    return ServerFailure(message: message);
  }

  // ==========================================================
  // GET ALL COOKIES
  // ==========================================================

  Future<List<Cookie>> getCookies(String url) async {
    return cookieJar.loadForRequest(Uri.parse(url));
  }

  // ==========================================================
  // GET SPECIFIC COOKIE
  // ==========================================================

  Future<String?> getCookie(String url, String cookieName) async {
    final cookies = await cookieJar.loadForRequest(Uri.parse(url));

    for (final cookie in cookies) {
      if (cookie.name == cookieName) {
        return cookie.value;
      }
    }

    return null;
  }

  // ==========================================================
  // DEBUG COOKIES
  // ==========================================================

  Future<void> debugCookies() async {
    final cookies = await cookieJar.loadForRequest(Uri.parse(refreshTokenUrl));

    print('======================================');
    print('STORED COOKIES');

    if (cookies.isEmpty) {
      print('NO COOKIES FOUND');
    }

    for (final cookie in cookies) {
      print('${cookie.name} = ${cookie.value}');
    }

    print('======================================');
  }

  // ==========================================================
  // CLEAR AUTH
  // ==========================================================

  Future<void> clearAuthTokens() async {
    _refreshTimer?.cancel();

    _refreshTimer = null;

    _accessToken = null;

    try {
      await cookieJar.deleteAll();
    } catch (e) {
      print('ERROR CLEARING COOKIES: $e');
    }

    print('AUTH TOKENS CLEARED');
  }

  // ==========================================================
  // CLEAR COOKIES
  // ==========================================================

  Future<void> clearCookies() async {
    try {
      await cookieJar.deleteAll();
    } catch (e) {
      print('ERROR CLEARING COOKIES: $e');
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  void dispose() {
    _refreshTimer?.cancel();

    _refreshTimer = null;
  }
}
