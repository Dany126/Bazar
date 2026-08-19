import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';

class PickedLocationModel extends PickedLocationEntity {
  const PickedLocationModel({
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.country,
    required super.postalCode,
    required super.formattedAddress,
  });

  factory PickedLocationModel.fromNominatimJson(
    Map<String, dynamic> json, {
    required double latitude,
    required double longitude,
  }) {
    final addr = (json['address'] as Map<String, dynamic>?) ?? {};
    return PickedLocationModel(
      latitude: latitude,
      longitude: longitude,
      city:
          (addr['city'] ??
                  addr['town'] ??
                  addr['village'] ??
                  addr['suburb'] ??
                  '')
              as String,
      country: (addr['country'] ?? '') as String,
      postalCode: (addr['postcode'] ?? '') as String,
      formattedAddress:
          (json['display_name'] as String?) ?? '$latitude, $longitude',
    );
  }

  factory PickedLocationModel.fromPhotonJson(
    Map<String, dynamic> json, {
    required double latitude,
    required double longitude,
  }) {
    final properties = (json['properties'] as Map<String, dynamic>?) ?? {};
    final displayName = [
      properties['name'],
      properties['street'],
      properties['city'] ?? properties['district'],
      properties['country'],
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

    return PickedLocationModel(
      latitude: latitude,
      longitude: longitude,
      city: (properties['city'] ?? properties['district'] ?? '') as String,
      country: (properties['country'] ?? '') as String,
      postalCode: (properties['postcode'] ?? '') as String,
      formattedAddress: displayName.isEmpty
          ? '$latitude, $longitude'
          : displayName,
    );
  }
}
