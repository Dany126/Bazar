import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repo/auth_repo.dart';

class LogOutUseCase {
  final AuthRepository authRepository;
  LogOutUseCase({required this.authRepository});

  Future<Either<Failure, void>> call() {
    return authRepository.logout();
  }
}
