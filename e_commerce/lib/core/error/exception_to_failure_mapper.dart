import 'package:e_commerce/core/error/failure.dart';

import 'exceptions.dart';

/// Centralizes the mapping so every repository does:
///   } on AppException catch (e) {
///     return Left(e.toFailure());
///   }
/// instead of duplicating a chain of `on XException catch` blocks
/// in every single repository method.
extension AppExceptionToFailure on AppException {
  Failure toFailure() {
    final e = this;
    if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is CacheException) {
      return CacheFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is TimeoutException) {
      return TimeoutFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NotFoundException) {
      return NotFoundFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is ValidationException) {
      return ValidationFailure(
        message: e.message,
        errors: e.errors,
        statusCode: e.statusCode,
      );
    }
    return UnknownFailure(message: e.message, statusCode: e.statusCode);
  }
}
