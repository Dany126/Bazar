import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/services/hive_server.dart';
import '../../../../core/error/failure.dart';

import '../../domain/entity/user_entity.dart';
import '../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, void>> cacheUser(UserModel user);
  Either<Failure, UserEntity> getCachedUser();
  Future<Either<Failure, void>> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _userKey = 'user';

  @override
  Future<Either<Failure, void>> cacheUser(UserModel user) async {
    try {
      await HiveService.authBox.put(_userKey, user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to cache user: $e'));
    }
  }

  @override
  Either<Failure, UserEntity> getCachedUser() {
    final data = HiveService.authBox.get(_userKey);
    if (data == null) {
      return Left(CacheFailure(message: 'No cached user found'));
    }
    try {
      return Right(UserModel.fromJson(Map<String, dynamic>.from(data)));
    } catch (e) {
      return Left(CacheFailure(message: 'Corrupted cached user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await HiveService.authBox.delete(_userKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear cache: $e'));
    }
  }
}
