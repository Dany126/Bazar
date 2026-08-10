import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/services/api_services.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, ({UserModel user, String accessToken})>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      '$kBaseUrl/user/login',
      data: {'email': email, 'password': password},
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        try {
          final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

          final accessToken = data['accessToken'] as String;

          return Right((user: user, accessToken: accessToken));
        } catch (e) {
          return Left(ServerFailure(message: 'Invalid login response: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ({UserModel user, String accessToken})>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await apiService.post(
      '$kBaseUrl/user/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        try {
          final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

          final accessToken = data['accessToken'] as String;

          return Right((user: user, accessToken: accessToken));
        } catch (e) {
          return Left(ServerFailure(message: 'Invalid register response: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    final response = await apiService.post('$kBaseUrl/user/refresh');

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        try {
          final accessToken = data['accessToken'] as String;

          return Right(accessToken);
        } catch (e) {
          return Left(ServerFailure(message: 'Invalid refresh response: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final response = await apiService.post('$kBaseUrl/user/logout');

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (_) {
        return const Right(null);
      },
    );
  }
}
