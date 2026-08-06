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
      id: json['_id']?.toString() ?? '',

      name: json['name']?.toString() ?? '',

      thumbnailUrl: _getImage(json['image']),

      price: (json['price'] ?? 0).toDouble(),

      discountPrice: (json['discount_price'] as num?)?.toDouble(),

      rating: (json['avg_rating'] ?? 0).toDouble(),

      soldCount: json['soldCount'] ?? 0,
    );
  }

  static String _getImage(dynamic image) {
    if (image is List && image.isNotEmpty) {
      return image.first.toString();
    }

    return '';
  }
}
