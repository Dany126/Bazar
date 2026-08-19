import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

// ignore: must_be_immutable
class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.thumbnailUrl,
    required super.price,
    required super.rating,
    required super.stock,
    required super.soldCount,
    required super.ratingsQuantity,
    required super.category,
    super.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      thumbnailUrl: _getImage(json['image']),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] as int? ?? 0,
      soldCount: json['soldCount'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      ratingsQuantity: json['ratingsQuantity'] as int? ?? 0,
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : const CategoryModel(id: '', name: '', imageUrl: ''),
    );
  }

  static String _getImage(dynamic image) {
    if (image is List && image.isNotEmpty) {
      return image.first.toString();
    }
    return '';
  }
}
