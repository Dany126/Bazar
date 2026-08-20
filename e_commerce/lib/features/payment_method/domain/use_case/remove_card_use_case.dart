import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

import '../repo/payment_repo.dart';

class RemoveCardUseCase {
  RemoveCardUseCase(this.repo);
  final PaymentRepo repo;

  Future<Either<Failure, Unit>> call(String id) => repo.removeCard(id);
}
