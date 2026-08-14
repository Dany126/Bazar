// lib/features/payment_method/domin/repo/payment_method_repo.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();

  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });

  Future<Either<Failure, void>> deletePaymentMethod({
    required String paymentMethodId,
  });
}
