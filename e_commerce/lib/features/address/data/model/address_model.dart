// lib/features/address/data/model/address_model.dart
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.street,
    required super.city,
    required super.country,
    required super.postalCode,
    super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? json['id'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}
