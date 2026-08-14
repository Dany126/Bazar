import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String thumbnailUrl;
  final double price;
  final double rating;
  final int stock;
  final int soldCount;
  final int ratingsQuantity;
  final CategoryEntity category;

  bool isFavorite;

  ProductEntity({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    required this.rating,
    required this.stock,
    required this.soldCount,
    required this.ratingsQuantity,
    required this.category,
    this.isFavorite = false,
  });
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['_id'],
      name: json['name'],
      thumbnailUrl: json['thumbnailUrl'],
      price: json['price'],
      rating: json['rating'],
      stock: json['stock'],
      soldCount: json['soldCount'],
      ratingsQuantity: json['ratingsQuantity'],
      category: CategoryEntity(
        id: json['category']['_id'],
        name: json['category']['name'],
        imageUrl: json['category']['imageUrl'],
      ),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnailUrl,
    price,
    rating,
    stock,
    soldCount,
    ratingsQuantity,
    category,
    isFavorite,
  ];
}
