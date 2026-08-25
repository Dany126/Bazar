import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment/domain/entity/paymob_payment_entity.dart';
import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class CreatePaymobPaymentUseCase {
  const CreatePaymobPaymentUseCase(this.repository);

  final PaymobRepository repository;

  Future<Either<Failure, PaymobPaymentEntity>> call({
    required int amountCents,
    required String currency,
    required String orderReference,
    required Map<String, dynamic> billingData,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
  }) {
    return repository.createPayment(
      amountCents: amountCents,
      currency: currency,
      orderReference: orderReference,
      billingData: billingData,
      products: products,
      shippingAddress: shippingAddress,
    );
  }
}
