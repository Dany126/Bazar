import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import '../../data/model/admin_transaction_model.dart';
import '../repositories/admin_transaction_repository.dart';

class GetAdminTransactions {
  final AdminTransactionRepository repository;

  GetAdminTransactions(this.repository);

  Future<Either<Failure, AdminTransactionsResponse>> call({
    String search = '',
    String status = 'all',
    String paymentMethod = 'all',
    int page = 1,
    int limit = 20,
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getTransactions(
      search: search,
      status: status,
      paymentMethod: paymentMethod,
      page: page,
      limit: limit,
      from: from,
      to: to,
    );
  }
}
