import 'package:e_commerce/core/services/api_services.dart';

class PaymobRemoteDataSource {
  const PaymobRemoteDataSource(this.apiService);

  final ApiService apiService;

  Future<Map<String, dynamic>> createPayment({
    required int amountCents,
    required String currency,
    required String orderReference,
    required Map<String, dynamic> billingData,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final result = await apiService.post(
      '/payment/paymob',
      data: {
        'amountCents': amountCents,
        'currency': currency,
        'orderReference': orderReference,
        'billingData': billingData,
        'products': products,
        'shippingAddress': shippingAddress,
      },
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => Map<String, dynamic>.from(data as Map),
    );
  }
}
