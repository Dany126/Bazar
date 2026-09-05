import 'package:e_commerce/core/services/api_services.dart';

class PaymobRemoteDataSource {
  const PaymobRemoteDataSource(this.apiService);

  final ApiService apiService;

  /// Creates a temporary payment session.
  ///
  /// IMPORTANT:
  ///
  /// This does NOT create an Order.
  ///
  /// The backend creates the real Order only after
  /// Paymob confirms successful payment.
  Future<Map<String, dynamic>> createPaymentSession({
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final result = await apiService.post(
      '/payments/create-session',

      data: {
        /*
         * Products selected by the customer.
         */
        'products': products,

        /*
         * Shipping information.
         */
        'shippingAddress': shippingAddress,

        /*
         * We intentionally do NOT send totalPrice.
         *
         * WHY:
         *
         * The backend calculates the real total
         * using database prices.
         */
      },
    );

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },

      (data) {
        return Map<String, dynamic>.from(data as Map);
      },
    );
  }

  /// Gets the current status of a payment session.
  Future<Map<String, dynamic>> getPaymentSessionStatus({
    required String paymentSessionId,
  }) async {
    final result = await apiService.get(
      '/payments/sessions/'
      '$paymentSessionId/status',
    );

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },

      (data) {
        return Map<String, dynamic>.from(data as Map);
      },
    );
  }
}
