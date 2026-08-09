import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repo/auth_repo.dart';

class SignInParams {
  final String email;
  final String password;
  const SignInParams({required this.email, required this.password});
}

class SignInUsecase {
  final AuthRepository authRepository;
  SignInUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    return authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
