import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class ResetPasswordUsecase extends UseCase<void, String> {
  final AuthRepository _authRepository;

  ResetPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await _authRepository.resetPassword(email: email);
  }
}
