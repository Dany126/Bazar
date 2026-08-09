import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<Either<Failure, UserEntity>> logout({required String refreshToken});
}
