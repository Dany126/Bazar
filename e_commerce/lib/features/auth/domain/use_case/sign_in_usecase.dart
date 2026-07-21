import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class SignInUsecase extends UseCase<UserEntity, SignInParams> {
  final AuthRepository _authRepository;

  SignInUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    var result = await _authRepository.signIn(
      email: params.email,
      password: params.password,
    );
    return result.fold((failure) => Left(failure), (user) => Right(user));
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
