import 'package:dio/dio.dart';
import 'failure.dart';

/// Converts any error caught inside ApiService (DioException or otherwise)
/// into a typed Failure. This is the single place error-mapping logic
/// lives — reuse this class as-is across every project.
class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return UnknownFailure(message: error.toString());
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: 'Invalid security certificate');

      case DioExceptionType.unknown:
        return UnknownFailure(
          message: error.message ?? 'An unexpected error occurred.',
        );
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
    }
  }

  static Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data);

    switch (statusCode) {
      case 401:
      case 403:
        return UnauthorizedFailure(
          message: message ?? 'Session expired. Please sign in again.',
          statusCode: statusCode,
        );
      case 404:
        return NotFoundFailure(
          message: message ?? 'Requested resource was not found.',
          statusCode: statusCode,
        );
      case 422:
        return ValidationFailure(
          message: message ?? 'Validation failed.',
          errors: _extractValidationErrors(data),
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          statusCode: statusCode,
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
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
