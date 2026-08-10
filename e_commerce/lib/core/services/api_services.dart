import 'dart:async';
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../error/failure.dart';

class ApiService {
  final Dio dio;
  final CookieJar cookieJar;

  /// Endpoint that reads the refresh token (sent automatically as a cookie
  /// by CookieManager) and returns a new access token.
  /// Example: '/auth/refresh'
  final String refreshTokenUrl;

  String? _accessToken;

  // ----- refresh-token coordination -----
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];
  Timer? _refreshTimer;

  /// How long before expiry to trigger a proactive refresh.
  static const Duration _refreshBuffer = Duration(seconds: 30);

  ApiService({
    required this.dio,
    required this.cookieJar,
    required this.refreshTokenUrl,
  }) {
    // IMPORTANT:
    // This automatically saves Set-Cookie from the server
    // and automatically sends cookies (incl. the refresh token) with
    // future requests.
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(
      InterceptorsWrapper(
        // Automatically add access token to requests.
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }

          handler.next(options);
        },

        // Automatically refresh the access token on 401 and retry once.
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isRefreshCall = error.requestOptions.path == refreshTokenUrl;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          if (isUnauthorized && !isRefreshCall && !alreadyRetried) {
            try {
              await _refreshAccessToken();

              // Retry the original request with the new access token.
              final retryOptions = error.requestOptions;
              retryOptions.extra['retried'] = true;
              if (_accessToken != null && _accessToken!.isNotEmpty) {
                retryOptions.headers['Authorization'] = 'Bearer $_accessToken';
              }

              final response = await dio.fetch(retryOptions);
              return handler.resolve(response);
            } catch (e) {
              print('TOKEN REFRESH FAILED: $e');

              // Refresh failed (e.g. refresh token also expired) -> log out.
              await clearAuthTokens();
              return handler.next(error);
            }
          }

          return handler.next(error);
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

    _scheduleProactiveRefresh(accessToken);
  }

  String? get accessToken => _accessToken;

  // ============================================================
  // PROACTIVE REFRESH (listens for the access token expiring)
  // ============================================================

  /// Decodes the JWT's `exp` claim (seconds since epoch) and schedules
  /// a timer to refresh the access token shortly before it expires,
  /// instead of waiting for a request to fail with 401.
  void _scheduleProactiveRefresh(String jwt) {
    _refreshTimer?.cancel();

    final expiry = _getJwtExpiry(jwt);
    if (expiry == null) {
      print('COULD NOT READ TOKEN EXPIRY - proactive refresh disabled');
      return;
    }

    final timeUntilExpiry = expiry.difference(DateTime.now());
    final delay = timeUntilExpiry - _refreshBuffer;

    if (delay.isNegative) {
      // Token is already expired or about to expire - refresh right away.
      print('ACCESS TOKEN ALREADY NEAR/PAST EXPIRY - refreshing now');
      unawaited(_safeProactiveRefresh());
      return;
    }

    print('ACCESS TOKEN EXPIRES AT $expiry - scheduling refresh in $delay');

    _refreshTimer = Timer(delay, () {
      unawaited(_safeProactiveRefresh());
    });
  }

  Future<void> _safeProactiveRefresh() async {
    try {
      await _refreshAccessToken();
    } catch (e) {
      print('PROACTIVE TOKEN REFRESH FAILED: $e');
      // Leave it to the 401 interceptor / caller to handle logout,
      // since a proactive refresh failing doesn't necessarily mean
      // the session is dead (could just be offline).
    }
  }

  /// Parses a JWT's payload and returns its `exp` claim as a DateTime,
  /// or null if it can't be read.
  DateTime? _getJwtExpiry(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;

      var payload = parts[1];
      // base64Url requires padding to a multiple of 4.
      payload = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');

      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded) as Map<String, dynamic>;

      final exp = map['exp'];
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch((exp as num).toInt() * 1000);
    } catch (e) {
      print('FAILED TO DECODE JWT EXPIRY: $e');
      return null;
    }
  }

  // ============================================================
  // REFRESH TOKEN FLOW
  // ============================================================

  /// Refreshes the access token using the refresh token cookie.
  /// If a refresh is already in progress, callers just wait on it
  /// instead of firing a duplicate request.
  Future<void> _refreshAccessToken() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      print('======================================');
      print('REQUEST: POST $refreshTokenUrl (refreshing access token)');

      // Use dio directly (not this.post) so this call never gets
      // caught in its own retry logic.
      final response = await dio.post(refreshTokenUrl);

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.data}');

      final newAccessToken = response.data is Map
          ? response.data['accessToken']?.toString()
          : null;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw Exception('Refresh endpoint did not return an accessToken');
      }

      await setAccessToken(newAccessToken);

      print('ACCESS TOKEN REFRESHED');

      for (final completer in _refreshQueue) {
        completer.complete();
      }
      _refreshQueue.clear();
    } catch (e) {
      for (final completer in _refreshQueue) {
        completer.completeError(e);
      }
      _refreshQueue.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  // ============================================================
  // FCM TOKEN
  // ============================================================

  /// Fetches the device's FCM token and sends it to the backend.
  /// Call this right after register (or login) succeeds.
  Future<Either<Failure, dynamic>> sendFcmToken(String url) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        print('FCM TOKEN: could not get device token');
        return Left(ServerFailure(message: 'Could not get FCM token'));
      }

      print('FCM TOKEN: $fcmToken');

      return await post(url, data: {'fcmToken': fcmToken});
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

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
    // Stop any scheduled proactive refresh.
    _refreshTimer?.cancel();
    _refreshTimer = null;

    // Remove access token from memory.
    _accessToken = null;

    // Remove refresh token cookie.
    await cookieJar.deleteAll();

    print('AUTH TOKENS CLEARED');
  }

  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  /// Call this when the ApiService is no longer needed
  /// (e.g. in a top-level provider's dispose) to cancel the timer.
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
