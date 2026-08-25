import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

abstract class PaymobRepository {
  Future<Either<Failure, void>> createPayment({required String orderReference});
}
