import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';

import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class PaymobRepositoryImpl implements PaymobRepository {
  const PaymobRepositoryImpl(this.remoteDataSource);

  final PaymobRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, void>> createPayment({
    required String orderReference,
  }) async {
    try {
      final data = await remoteDataSource.createPayment(
        orderId: orderReference,
      );

      // ignore: void_checks
      return Right(data);
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
