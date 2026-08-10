import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/services/api_services.dart';
import '../../domain/entity/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ApiService apiService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
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

    return Right(success.user);
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

    return Right(success.user);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // CookieManager automatically sends the refreshToken cookie.
    final result = await remoteDataSource.logout();

    // Remove access token and refresh-token cookie locally.
    await apiService.clearAuthTokens();

    return result.fold(
      (failure) {
        return Left(failure);
      },
      (_) {
        return const Right(null);
      },
    );
  }
}
