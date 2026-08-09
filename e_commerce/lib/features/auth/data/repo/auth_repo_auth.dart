import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_remote_data_source_impl.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/api_services.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repo/auth_repo.dart';

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
      return result.fold(
        (failure) => Left<Failure, UserEntity>(failure),
        (_) => throw Exception(),
      );
    }

    final success = result.fold((_) => throw Exception(), (data) => data);

    await apiService.setAuthTokens(
      accessToken: success.accessToken,
      refreshToken: success.refreshToken,
    );

    return Right<Failure, UserEntity>(success.user);
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
      return result.fold(
        (failure) => Left<Failure, UserEntity>(failure),
        (_) => throw Exception(),
      );
    }

    final success = result.fold((_) => throw Exception(), (data) => data);

    await apiService.setAuthTokens(
      accessToken: success.accessToken,
      refreshToken: success.refreshToken,
    );

    return Right<Failure, UserEntity>(success.user);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final refreshToken = apiService.refreshTokenPath;

    if (refreshToken.isNotEmpty) {
      await remoteDataSource.logout(refreshToken: refreshToken);
    }

    await apiService.clearAuthTokens();

    return const Right<Failure, void>(null);
  }
}
