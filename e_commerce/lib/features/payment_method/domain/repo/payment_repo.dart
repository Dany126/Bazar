import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/entity/saved_card_entity.dart';

abstract class PaymentRepo {
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards();

  Future<Either<Failure, SavedCardEntity>> addCard({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  });

  Future<Either<Failure, Unit>> removeCard(String id);
}
