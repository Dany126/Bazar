import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class SignUpUsecase extends UseCase<void, SignUpParams> {
  final AuthRepository _authRepository;

  SignUpUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await _authRepository.signUp(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String phone;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}
