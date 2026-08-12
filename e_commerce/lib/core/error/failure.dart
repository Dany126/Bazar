import 'package:equatable/equatable.dart';

/// Base class for all Failures returned to the presentation layer.
// ignore: unintended_html_in_doc_comment
/// Every repository/service method returns Either<Failure, T>, so the UI
/// never deals with try/catch — only pattern matching via fold().
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server responded with an error (5xx, malformed body, generic 4xx not
/// covered by a more specific Failure below).
class ServerFailure extends Failure {
  const ServerFailure( {required super.message, super.statusCode});
}

/// No internet connection, or Dio couldn't establish a connection at all.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

/// Connect/send/receive timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}

/// 401 / 403 — invalid, missing, or expired token.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please sign in again.',
    super.statusCode,
  });
}

/// 404 — resource doesn't exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Requested resource was not found.',
    super.statusCode,
  });
}

/// 422 — validation errors, optionally with field-level messages.
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
    super.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Local cache/storage failure (shared_preferences, hive, sqlite, etc.)
/// Kept here even though ApiService won't throw it, since repositories
/// that mix remote + local sources (e.g. cart, wishlist) will need it.
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

/// Anything that doesn't match a known Dio error shape.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
  });
}
