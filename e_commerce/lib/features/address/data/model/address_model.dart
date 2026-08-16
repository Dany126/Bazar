import 'package:e_commerce/features/address/domain/entity/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.street,
    required super.city,
    required super.country,
    required super.postalCode,
    required super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }
}
