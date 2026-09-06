import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  });

  Either<Failure, UserEntity> getCachedUser();
}
