import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String thumbnailUrl;
  final double price;
  final double? discountPrice;
  final double rating;
  final int soldCount;
  bool isFavorite;

  ProductEntity({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    this.discountPrice,
    this.isFavorite = false,
    required this.rating,
    required this.soldCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnailUrl,
    price,
    discountPrice,
    isFavorite,
    rating,
    soldCount,
  ];
}
