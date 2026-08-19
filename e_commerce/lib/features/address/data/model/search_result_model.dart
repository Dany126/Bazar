import '../../domain/entity/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.displayName,
    required super.latitude,
    required super.longitude,
  });

  factory SearchResultModel.fromNominatimJson(Map<String, dynamic> json) {
    return SearchResultModel(
      displayName: json['display_name'] as String? ?? '',
      latitude: double.parse(json['lat'] as String),
      longitude: double.parse(json['lon'] as String),
    );
  }

  factory SearchResultModel.fromPhotonJson(Map<String, dynamic> json) {
    final properties = (json['properties'] as Map<String, dynamic>?) ?? {};
    final geometry = (json['geometry'] as Map<String, dynamic>?) ?? {};
    final coordinates = (geometry['coordinates'] as List<dynamic>?) ?? [];

    return SearchResultModel(
      displayName: _displayName(properties),
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
    );
  }

  static String _displayName(Map<String, dynamic> properties) {
    return [
      properties['name'],
      properties['street'],
      properties['city'] ?? properties['district'],
      properties['country'],
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
  }
}
