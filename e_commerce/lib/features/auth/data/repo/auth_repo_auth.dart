import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_local_data_source.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ApiService apiService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiService,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.signIn(
      email: email,
      password: password,
    );

    if (result.isLeft()) {
      return Left(result.fold((failure) => failure, (_) => throw Exception()));
    }

    final success = result.fold((_) => throw Exception(), (data) => data);

    await apiService.setAccessToken(success.accessToken);
    await localDataSource.cacheUser(success.user);

    return Right(success.user);
  }

  // signUp: same addition — await localDataSource.cacheUser(success.user); after setAccessToken

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await remoteDataSource.logout();

    await apiService.clearAuthTokens();
    await localDataSource.clearUser();

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final result = await remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    if (result.isLeft()) {
      return Left(result.fold((failure) => failure, (_) => throw Exception()));
    }

    final success = result.fold((_) => throw Exception(), (data) => data);

    await apiService.setAccessToken(success.accessToken);
    await localDataSource.cacheUser(success.user);

    return Right(success.user);
  }
}
