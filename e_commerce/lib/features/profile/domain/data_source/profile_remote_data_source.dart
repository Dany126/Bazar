import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  });
}
