import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';

class PickedLocationModel extends PickedLocationEntity {
  const PickedLocationModel({
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.street,
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
      street: _firstString(addr, ['road', 'pedestrian', 'footway', 'street']),
      city:
          (addr['city'] ??
                  addr['town'] ??
                  addr['village'] ??
                  addr['suburb'] ??
                  addr['municipality'] ??
                  addr['state'] ??
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
    final city = _firstString(properties, [
      'city',
      'town',
      'village',
      'municipality',
      'locality',
      'district',
      'suburb',
      'state',
      'name',
    ]);
    final street = _firstString(properties, [
      'street',
      'road',
      'pedestrian',
      'name',
    ]);
    final country = _firstString(properties, ['country']);
    final postalCode = _firstString(properties, [
      'postcode',
      'postalcode',
      'postalCode',
    ]);
    final displayName = [
      properties['name'],
      properties['street'],
      city,
      country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

    return PickedLocationModel(
      latitude: latitude,
      longitude: longitude,
      street: street,
      city: city,
      country: country,
      postalCode: postalCode,
      formattedAddress: displayName.isEmpty
          ? '$latitude, $longitude'
          : displayName,
    );
  }

  static String _firstString(
    Map<String, dynamic> properties,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = properties[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}
