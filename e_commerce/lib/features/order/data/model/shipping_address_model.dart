import 'package:e_commerce/features/order/domin/entity/shipping_adress_entity.dart';

class ShippingAddressModel extends ShippingAddressEntity {
  const ShippingAddressModel({
    super.street,
    super.city,
    super.country,
    super.postalCode,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      street: json['street'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'country': country,
      'postalCode': postalCode,
    };
  }
}
