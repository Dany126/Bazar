import 'package:e_commerce/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> resetPassword({required String email});

  Future<void> logout();
}
