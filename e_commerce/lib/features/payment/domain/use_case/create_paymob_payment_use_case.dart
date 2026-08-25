import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class CreatePaymobPaymentUseCase {
  const CreatePaymobPaymentUseCase(this.repository);

  final PaymobRepository repository;

  Future<Either<Failure, void>> call({required String orderReference}) {
    return repository.createPayment(orderReference: orderReference);
  }
}
