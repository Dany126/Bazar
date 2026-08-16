import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.brand,
    required super.last4,
    required super.isDefault, 
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      last4: json['last4']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }
}
