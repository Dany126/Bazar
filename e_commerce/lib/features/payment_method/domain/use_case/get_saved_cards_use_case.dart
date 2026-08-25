import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

import '../entity/saved_card_entity.dart';

import '../repo/payment_repo.dart';

class GetSavedCardsUseCase {
  GetSavedCardsUseCase(this.repo);
  final PaymentRepo repo;

  Future<Either<Failure, List<SavedCardEntity>>> call() => repo.getSavedCards();
}
