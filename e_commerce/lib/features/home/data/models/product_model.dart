import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

// ignore: must_be_immutable
class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.thumbnailUrl,
    required super.price,
    super.discountPrice,
    required super.rating,
    required super.soldCount,
    super.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      soldCount: json['sold_count'] as int? ?? 0,
    );
  }
}
