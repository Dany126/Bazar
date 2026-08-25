import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment/domain/entity/paymob_payment_entity.dart';

abstract class PaymobRepository {
  Future<Either<Failure, PaymobPaymentEntity>> createPayment({
    required int amountCents,
    required String currency,
    required String orderReference,
    required Map<String, dynamic> billingData,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
  });
}
