// lib/features/payment_method/domin/use_case/add_payment_method_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_method_repo.dart';

class AddPaymentMethodUseCase {
  final PaymentMethodRepository repository;
  AddPaymentMethodUseCase(this.repository);

  Future<Either<Failure, PaymentMethodEntity>> call({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) {
    return repository.addPaymentMethod(
      cardholderName: cardholderName,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );
  }
}
