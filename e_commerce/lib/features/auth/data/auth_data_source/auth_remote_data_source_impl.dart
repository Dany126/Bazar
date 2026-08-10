import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/api_services.dart';

abstract class AuthRemoteDataSource {
  Future<
    Either<Failure, ({UserModel user, String accessToken, String refreshToken})>
  >
  signIn({required String email, required String password});

  Future<
    Either<Failure, ({UserModel user, String accessToken, String refreshToken})>
  >
  signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, void>> logout({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<
    Either<Failure, ({UserModel user, String accessToken, String refreshToken})>
  >
  signIn({required String email, required String password}) async {
    final response = await apiService.post(
      '${kBaseUrl}/user/login',
      data: {'email': email, 'password': password},
    );

    return response.fold(
      (failure) {
        return Left<
          Failure,
          ({UserModel user, String accessToken, String refreshToken})
        >(failure);
      },
      (data) {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;

        return Right<
          Failure,
          ({UserModel user, String accessToken, String refreshToken})
        >((user: user, accessToken: accessToken, refreshToken: refreshToken));
      },
    );
  }

  @override
  Future<
    Either<Failure, ({UserModel user, String accessToken, String refreshToken})>
  >
  signUp({
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
        return Left<
          Failure,
          ({UserModel user, String accessToken, String refreshToken})
        >(failure);
      },
      (data) {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;

        return Right<
          Failure,
          ({UserModel user, String accessToken, String refreshToken})
        >((user: user, accessToken: accessToken, refreshToken: refreshToken));
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout({required String refreshToken}) async {
    final response = await apiService.post(
      '$kBaseUrl/user/logout',
      data: {'refresh_token': refreshToken},
    );

    await apiService.clearAuthTokens();

    return response.fold(
      (failure) => Left<Failure, void>(failure),
      (_) => const Right<Failure, void>(null),
    );
  }
}
