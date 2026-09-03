import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import '../../data/models/admin_transaction_model.dart';
import '../repositories/admin_transaction_repository.dart';

class GetAdminTransaction {
  final AdminTransactionRepository repository;

  GetAdminTransaction(this.repository);

  Future<Either<Failure, AdminTransactionModel>> call({
    required String transactionId,
  }) {
    return repository.getTransaction(transactionId: transactionId);
  }
}
