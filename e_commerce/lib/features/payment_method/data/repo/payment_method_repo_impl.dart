import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/data/data_source/payment_local_data_source_impl.dart';

import '../../domain/entity/saved_card_entity.dart';

import '../../domain/repo/payment_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  PaymentRepoImpl(this.localDataSource);
  final PaymentLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards() async {
    try {
      final cards = await localDataSource.getSavedCards();
      return Right(cards);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedCardEntity>> addCard({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  }) async {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 12) {
      return const Left(ServerFailure(message: 'Enter a valid card number'));
    }
    if (ccv.trim().length < 3) {
      return const Left(ServerFailure(message: 'Enter a valid CCV'));
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry.trim())) {
      return const Left(ServerFailure(message: 'Exp must be in MM/YY format'));
    }
    if (cardholderName.trim().isEmpty) {
      return const Left(ServerFailure(message: 'Enter the cardholder name'));
    }

    try {
      final card = await localDataSource.addCard(
        cardNumber: cardNumber,
        ccv: ccv,
        expiry: expiry,
        cardholderName: cardholderName,
      );
      return Right(card);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCard(String id) async {
    try {
      await localDataSource.removeCard(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: (e.toString())));
    }
  }
}
