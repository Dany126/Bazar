import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('======================================');
    print('DIO INTERCEPTOR ERROR');
    print('TYPE: ${err.type}');
    print('MESSAGE: ${err.message}');
    print('ERROR: ${err.error}');
    print('STATUS: ${err.response?.statusCode}');
    print('URL: ${err.requestOptions.uri}');
    print('METHOD: ${err.requestOptions.method}');
    print('RESPONSE: ${err.response?.data}');
    print('======================================');

    final appException = _mapDioExceptionToAppException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        response: err.response,
        type: err.type,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return NetworkException(
          message: [
            'Network connection failed.',
            if (err.message != null) 'message: ${err.message}',
            if (err.error != null) 'error: ${err.error}',
          ].join(' | '),
        );

      case DioExceptionType.badResponse:
        return _mapStatusCodeToException(err);

      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return UnknownException(
          message: [
            'Bad certificate.',
            if (err.message != null) 'message: ${err.message}',
            if (err.error != null) 'error: ${err.error}',
          ].join(' | '),
        );

      case DioExceptionType.unknown:
        return UnknownException(
          message: [
            'Dio unknown error.',
            if (err.message != null) 'message: ${err.message}',
            if (err.error != null) 'error: ${err.error}',
          ].join(' | '),
        );
    }
  }

  AppException _mapStatusCodeToException(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    final message = _extractMessage(data);

    switch (statusCode) {
      case 401:
      case 403:
        return UnauthorizedException(
          message: message ?? 'Session expired. Please sign in again.',
          statusCode: statusCode,
        );

      case 404:
        return NotFoundException(
          message: message ?? 'Requested resource was not found.',
          statusCode: statusCode,
        );

      case 422:
        return ValidationException(
          message: message ?? 'Validation failed.',
          errors: _extractValidationErrors(data),
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: message ?? 'Something went wrong. Please try again.',
          statusCode: statusCode,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }

    return null;
  }

  Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      final rawErrors = data['errors'] as Map<String, dynamic>;

      return rawErrors.map(
        (key, value) => MapEntry(
          key,
          value is List
              ? value.map((e) => e.toString()).toList()
              : [value.toString()],
        ),
      );
    }

    return null;
  }
}
