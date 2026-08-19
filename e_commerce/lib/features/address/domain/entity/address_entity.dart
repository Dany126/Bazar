import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? id;
  final String addressType;
  final String? buildingName;
  final String? apartmentNumber;
  final String? houseName;
  final String? houseNumber;
  final String? officeName;
  final String? officeNumber;
  final String? floor;
  final String street;
  final String phone;
  final String? additionalDirections;
  final String? addressLabel;
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String postalCode;
  final bool isDefault;

  const AddressEntity({
    this.id,
    required this.addressType,
    this.buildingName,
    this.apartmentNumber,
    this.houseName,
    this.houseNumber,
    this.officeName,
    this.officeNumber,
    this.floor,
    required this.street,
    required this.phone,
    this.additionalDirections,
    this.addressLabel,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.postalCode,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
    id,
    addressType,
    buildingName,
    apartmentNumber,
    houseName,
    houseNumber,
    officeName,
    officeNumber,
    floor,
    street,
    phone,
    additionalDirections,
    addressLabel,
    latitude,
    longitude,
    city,
    country,
    postalCode,
    isDefault,
  ];
}
