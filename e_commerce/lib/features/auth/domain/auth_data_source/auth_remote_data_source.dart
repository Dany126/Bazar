import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, ({UserModel user, String accessToken})>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, ({UserModel user, String accessToken})>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, String>> refreshToken();

  Future<Either<Failure, void>> logout();
}
