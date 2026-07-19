import 'package:dio/dio.dart';

/// Represents a failure that occurred somewhere in the app

/// (API call, cache, etc). Use this with dartz's Either<Failure, T.
class Failure {
  final String message;
  final int? statusCode;

  Failure({required this.message, this.statusCode});

  @override
  String toString() => 'Failure(statusCode: $statusCode, message: $message)';
}

/// Converts any error thrown during an API call into a clean [Failure].
/// Call this inside a catch block in your ApiService.
class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return Failure(message: 'Unexpected error, please try again.');
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure(message: 'Connection timeout. Check your internet.');

      case DioExceptionType.badCertificate:
        return Failure(message: 'Secure connection failed.');

      case DioExceptionType.connectionError:
        return Failure(message: 'No internet connection.');

      case DioExceptionType.cancel:
        return Failure(message: 'Request was cancelled.');

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.unknown:
      default:
        return Failure(message: 'Something went wrong. Please try again.');
    }
  }

  static Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Try to extract a server-provided message, fall back to a default per status code.
    String message =
        _extractServerMessage(data) ?? _defaultMessageFor(statusCode);

    return Failure(message: message, statusCode: statusCode);
  }

  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Adjust these keys to match your backend's error response shape.
      return data['message'] ?? data['error'] ?? data['error_description'];
    }
    return null;
  }

  static String _defaultMessageFor(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'You don\'t have permission to do that.';
      case 404:
        return 'Requested resource not found.';
      case 409:
        return 'Conflict with current data state.';
      case 422:
        return 'Validation error, check your input.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong (code: $statusCode).';
    }
  }
}
