import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';
import 'package:e_commerce/features/payment/domain/entity/paymob_payment_entity.dart';
import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class PaymobRepositoryImpl implements PaymobRepository {
  const PaymobRepositoryImpl(this.remoteDataSource);

  final PaymobRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PaymobPaymentEntity>> createPayment({
    required int amountCents,
    required String currency,
    required String orderReference,
    required Map<String, dynamic> billingData,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      final data = await remoteDataSource.createPayment(
        amountCents: amountCents,
        currency: currency,
        orderReference: orderReference,
        billingData: billingData,
        products: products,
        shippingAddress: shippingAddress,
      );

      final paymentId = data['paymentId']?.toString();
      final checkoutUrl = data['checkoutUrl']?.toString();
      if (paymentId == null || checkoutUrl == null) {
        return const Left(
          ServerFailure(message: 'Invalid Paymob payment response'),
        );
      }

      return Right(
        PaymobPaymentEntity(paymentId: paymentId, checkoutUrl: checkoutUrl),
      );
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
