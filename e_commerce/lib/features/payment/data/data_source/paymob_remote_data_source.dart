import 'package:e_commerce/core/services/api_services.dart';

class PaymobRemoteDataSource {
  const PaymobRemoteDataSource(this.apiService);

  final ApiService apiService;

  Future<Map<String, dynamic>> createPaymentSession({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final result = await apiService.post(
      '/payments/create-session',
      data: {
        'products': products,
        'totalPrice': totalPrice,
        'shippingAddress': shippingAddress,
        'paymentMethod': 'card',
      },
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => Map<String, dynamic>.from(data as Map),
    );
  }
}
