// add_payment_method_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_method_repo.dart';

class AddPaymentMethodUseCase {
  final PaymentMethodRepository repository;
  AddPaymentMethodUseCase(this.repository);

  Future<Either<Failure, PaymentMethodEntity>> call({
    required String brand,
    required String last4,
    bool isDefault = false,
  }) {
    return repository.addPaymentMethod(
      brand: brand,
      last4: last4,
      isDefault: isDefault,
    );
  }
}
