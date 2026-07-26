import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/api_error_handler.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.signIn(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        return Left(failure);
      },

      (userModel) {
        return Right(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await remoteDataSource.signUp(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    return result.fold(
      (failure) {
        return Left(failure);
      },
      (userModel) {
        return Right(
          UserEntity(
            id: userModel.id,
            email: userModel.email,
            name: name,
            phone: phone,
            token: userModel.token,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);

      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();

      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
