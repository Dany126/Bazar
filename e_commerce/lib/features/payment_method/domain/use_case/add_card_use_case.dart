import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

import '../entity/saved_card_entity.dart';

import '../repo/payment_repo.dart';

class AddCardUseCase {
  AddCardUseCase(this.repo);
  final PaymentRepo repo;

  Future<Either<Failure, SavedCardEntity>> call({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  }) {
    return repo.addCard(
      cardNumber: cardNumber,
      ccv: ccv,
      expiry: expiry,
      cardholderName: cardholderName,
    );
  }
}
