import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class CreatePaymobPaymentUseCase {
  const CreatePaymobPaymentUseCase(this.repository);

  final PaymobRepository repository;

  Future<Either<Failure, Map<String, dynamic>>> call({
    required List<Map<String, dynamic>> products,

    required Map<String, dynamic> shippingAddress,
  }) {
    return repository.createPaymentSession(
      products: products,

      shippingAddress: shippingAddress,
    );
  }
}

