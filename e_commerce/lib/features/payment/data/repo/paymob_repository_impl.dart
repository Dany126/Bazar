import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';
import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class PaymobRepositoryImpl implements PaymobRepository {
  const PaymobRepositoryImpl(this.remoteDataSource);

  final PaymobRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPaymentSession({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      final data = await remoteDataSource.createPaymentSession(
        products: products,
        totalPrice: totalPrice,
        shippingAddress: shippingAddress,
      );

      return Right(data);
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
