// lib/features/address/domin/entity/address_entity.dart
class AddressEntity {
  final String id;
  final String street;
  final String city;
  final String country;
  final String postalCode;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.street,
    required this.city,
    required this.country,
    required this.postalCode,
    this.isDefault = false,
  });
}
