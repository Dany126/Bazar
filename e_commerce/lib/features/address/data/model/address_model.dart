import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    super.id,
    required super.addressType,
    super.buildingName,
    super.apartmentNumber,
    super.houseName,
    super.houseNumber,
    super.officeName,
    super.officeNumber,
    super.floor,
    required super.street,
    required super.phone,
    super.additionalDirections,
    super.addressLabel,
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.country,
    required super.postalCode,
    super.isDefault,
  });

  /// Builds straight from the ReactiveForm's `.value` map plus whatever
  /// the map picker resolved. `formValue` is `_form.value` from
  /// AddAddressViewBody.
  factory AddressModel.fromForm({
    required Map<String, dynamic> formValue,
    required PickedLocationEntity picked,
  }) {
    return AddressModel(
      addressType: formValue['addressType'] as String,
      buildingName: formValue['buildingName'] as String?,
      apartmentNumber: formValue['apartmentNumber'] as String?,
      houseName: formValue['houseName'] as String?,
      houseNumber: formValue['houseNumber'] as String?,
      officeName: formValue['officeName'] as String?,
      officeNumber: formValue['officeNumber'] as String?,
      floor: formValue['floor'] as String?,
      street: formValue['street'] as String,
      phone: formValue['phone'] as String,
      additionalDirections: formValue['additionalDirections'] as String?,
      addressLabel: formValue['addressLabel'] as String?,
      latitude: picked.latitude,
      longitude: picked.longitude,
      city: picked.city,
      country: picked.country,
      postalCode: picked.postalCode,
    );
  }

  factory AddressModel.fromEntity(AddressEntity e) => AddressModel(
    id: e.id,
    addressType: e.addressType,
    buildingName: e.buildingName,
    apartmentNumber: e.apartmentNumber,
    houseName: e.houseName,
    houseNumber: e.houseNumber,
    officeName: e.officeName,
    officeNumber: e.officeNumber,
    floor: e.floor,
    street: e.street,
    phone: e.phone,
    additionalDirections: e.additionalDirections,
    addressLabel: e.addressLabel,
    latitude: e.latitude,
    longitude: e.longitude,
    city: e.city,
    country: e.country,
    postalCode: e.postalCode,
    isDefault: e.isDefault,
  );

  // Adjust keys to match your friend's actual JSON shape.
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      addressType: json['addressType'] as String? ?? 'Apartment',
      buildingName: json['buildingName'] as String?,
      apartmentNumber: json['apartmentNumber'] as String?,
      houseName: json['houseName'] as String?,
      houseNumber: json['houseNumber'] as String?,
      officeName: json['officeName'] as String?,
      officeNumber: json['officeNumber'] as String?,
      floor: json['floor'] as String?,
      street: json['street'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      additionalDirections: json['additionalDirections'] as String?,
      addressLabel: json['addressLabel'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// Only includes fields relevant to the chosen addressType.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'addressType': addressType,
      'street': street,
      'phone': phone,
      'additionalDirections': additionalDirections,
      'addressLabel': addressLabel,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'postalCode': postalCode,
    };

    switch (addressType) {
      case 'Apartment':
        map['buildingName'] = buildingName;
        map['apartmentNumber'] = apartmentNumber;
        map['floor'] = floor;
        break;
      case 'House':
        map['houseName'] = houseName;
        map['houseNumber'] = houseNumber;
        break;
      case 'Office':
        map['officeName'] = officeName;
        map['officeNumber'] = officeNumber;
        map['floor'] = floor;
        break;
    }

    map.removeWhere((key, value) => value == null || value == '');
    return map;
  }
}
