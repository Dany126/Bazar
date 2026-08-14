// lib/features/payment_method/domin/entity/payment_method_entity.dart
class PaymentMethodEntity {
  final String id;
  final String cardholderName;
  final String last4;
  final String brand; // visa, mastercard, etc.
  final bool isDefault;

  const PaymentMethodEntity({
    required this.id,
    required this.cardholderName,
    required this.last4,
    required this.brand,
    this.isDefault = false,
  });
}
