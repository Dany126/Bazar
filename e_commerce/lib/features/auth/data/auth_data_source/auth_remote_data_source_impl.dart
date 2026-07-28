import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      '${apiService.baseUrl}/user/login',
      data: {'email': email, 'password': password},
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },

      (data) {
        return Right(UserModel.fromJson(data['user']));
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await apiService.post(
      '${apiService.baseUrl}/user/register',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },

      (data) {
        return Right(UserModel.fromJson(data['user']));
      },
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    final response = await apiService.post(
      '${apiService.baseUrl}/user/reset-password',
      data: {'email': email},
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },

      (_) {
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final response = await apiService.post('${apiService.baseUrl}/auth/logout');

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


// danyashraf012@gmail.com