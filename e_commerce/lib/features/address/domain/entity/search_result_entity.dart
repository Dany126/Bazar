import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final String displayName;
  final double latitude;
  final double longitude;

  const SearchResultEntity({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [displayName, latitude, longitude];
}
