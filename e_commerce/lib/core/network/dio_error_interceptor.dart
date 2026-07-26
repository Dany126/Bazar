import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _mapStatusCodeToException(err);

      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      default:
        return const UnknownException();
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
      return data['message'] as String? ?? data['error'] as String?;
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
