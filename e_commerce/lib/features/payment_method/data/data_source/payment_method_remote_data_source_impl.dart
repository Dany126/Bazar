import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/payment_method/data/model/payment_method_model.dart';
import 'package:e_commerce/features/payment_method/domain/data_source/payment_method_remote_data_source.dart';

class PaymentMethodRemoteDataSourceImpl
    implements PaymentMethodRemoteDataSource {
  final ApiService apiService;

  PaymentMethodRemoteDataSourceImpl(this.apiService);

  List<PaymentMethodModel> _parseList(dynamic response) {
    final data = response is Map && response.containsKey('paymentMethods')
        ? response['paymentMethods']
        : response;
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => PaymentMethodModel.fromJson(e))
        .toList();
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods() async {
    final result = await apiService.get('$kBaseUrl/payment-method');
    return result.fold((failure) => Left(failure), (response) {
      try {
        return Right(_parseList(response));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, PaymentMethodModel>> addPaymentMethod({
    required String brand,
    required String last4,
    bool isDefault = false,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/payment-method',
      data: {'brand': brand, 'last4': last4, 'isDefault': isDefault},
    );
    return result.fold((failure) => Left(failure), (response) {
      try {
        final data = response is Map && response.containsKey('paymentMethod')
            ? response['paymentMethod'] as Map<String, dynamic>
            : response as Map<String, dynamic>;
        return Right(PaymentMethodModel.fromJson(data));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod({
    required String paymentMethodId,
  }) async {
    final result = await apiService.delete(
      '$kBaseUrl/payment-method/$paymentMethodId',
    );
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
