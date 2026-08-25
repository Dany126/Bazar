class PaymobPaymentEntity {
  const PaymobPaymentEntity({
    required this.paymentId,
    required this.checkoutUrl,
  });

  final String paymentId;
  final String checkoutUrl;
}
