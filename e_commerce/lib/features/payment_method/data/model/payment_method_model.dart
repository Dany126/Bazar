// lib/features/payment_method/data/model/payment_method_model.dart

import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.cardholderName,
    required super.last4,
    required super.brand,
    super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] ?? json['id'] ?? '',
      cardholderName: json['cardholderName'] ?? '',
      last4: json['last4'] ?? '',
      brand: json['brand'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}
