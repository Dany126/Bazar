import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repo/auth_repo.dart';

class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String phone;
  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class SignUpUsecase {
  final AuthRepository authRepository;
  SignUpUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return authRepository.signUp(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}
