import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';

class LogOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _authRepository;

  LogOutUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}
