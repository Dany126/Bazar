/// Base class for all custom exceptions thrown from the data layer
/// (data sources). These get caught in repositories and mapped to Failures.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Thrown when the remote server (API) returns an error response
/// (4xx/5xx, malformed body, business-logic error from backend, etc.)
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

/// Thrown when a local cache/storage operation fails
/// (shared_preferences, hive, sqlite, secure storage, etc.)
class CacheException extends AppException {
  const CacheException({required super.message, super.statusCode});
}

/// Thrown when there's no internet connectivity, detected at the
/// data-source level before even attempting the request.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

/// Thrown when a request takes too long (connect/send/receive timeout).
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}

/// Thrown when the server returns 401/403 (invalid/expired token, no permission).
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
    super.statusCode,
  });
}

/// Thrown when the requested resource doesn't exist (404).
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Requested resource was not found.',
    super.statusCode,
  });
}

/// Thrown on validation errors returned by the backend (422),
/// typically carrying field-level messages.
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    required super.message,
    this.errors,
    super.statusCode,
  });
}

/// Thrown for any error that doesn't fit the above (unexpected/parsing errors).
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
  });
}
