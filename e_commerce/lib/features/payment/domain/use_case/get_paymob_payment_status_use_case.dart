import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class GetPaymobPaymentStatusUseCase {
  const GetPaymobPaymentStatusUseCase(this.repository);

  final PaymobRepository repository;

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String paymentSessionId,
  }) {
    return repository.getPaymentSessionStatus(
      paymentSessionId: paymentSessionId,
    );
  }
}
