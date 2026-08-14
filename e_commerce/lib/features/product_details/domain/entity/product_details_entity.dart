// lib/features/product_details/domin/entity/product_details_entity.dart

import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';

class ProductDetailsEntity {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final double avgRating;
  final int ratingsQuantity;
  final int stock;
  final int soldCount;
  final String categoryId;
  final String? description;
  final List<String> colors; // hex strings, e.g. "#FFA500"
  final List<String> sizes; // e.g. "S", "M", "L", "XL"
  final List<ReviewEntity> reviews;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.avgRating,
    required this.ratingsQuantity,
    required this.stock,
    required this.soldCount,
    required this.categoryId,
    this.description,
    this.colors = const [],
    this.sizes = const [],
    this.reviews = const [],
  });
}
