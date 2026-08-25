import 'package:e_commerce/core/services/api_services.dart';

class PaymobRemoteDataSource {
  const PaymobRemoteDataSource(this.apiService);

  final ApiService apiService;

  Future<Map<String, dynamic>> createPayment({required String orderId}) async {
    final result = await apiService.post('/payments/orders/:orderId/pay');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => Map<String, dynamic>.from(data as Map),
    );
  }
}
