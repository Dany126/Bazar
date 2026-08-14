// lib/features/product_details/data/model/product_details_model.dart
import 'package:e_commerce/features/product_details/data/model/review_model.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    required super.price,
    required super.images,
    required super.avgRating,
    required super.ratingsQuantity,
    required super.stock,
    required super.soldCount,
    required super.categoryId,
    super.description,
    super.colors,
    super.sizes,
    super.reviews,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: (json['image'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      ratingsQuantity: json['ratingsQuantity'] ?? 0,
      stock: json['stock'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      categoryId: json['category'] is String
          ? json['category']
          : json['category']?['_id'] ?? '',
      description: json['description'],
      colors: (json['colors'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
