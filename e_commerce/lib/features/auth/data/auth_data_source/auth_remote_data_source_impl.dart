import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      '${apiService.baseUrl}/auth/login',
      data: {'email': email, 'password': password},
    );

    return response.fold(
      (failure) {
        throw failure;
      },

      (data) {
        return UserModel.fromJson(data['user']);
      },
    );
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await apiService.post(
      '/auth/register',

      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    return response.fold(
      (failure) {
        throw failure;
      },

      (data) {
        return UserModel.fromJson(data['user']);
      },
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    final response = await apiService.post(
      '/auth/reset-password',

      data: {'email': email},
    );

    response.fold(
      (failure) {
        throw failure;
      },

      (_) {
        return;
      },
    );
  }

  @override
  Future<void> logout() async {
    final response = await apiService.post('/auth/logout');

    response.fold(
      (failure) {
        throw failure;
      },

      (_) {
        return;
      },
    );
  }
}
