// lib/features/product_details/domin/entity/product_details_entity.dart

import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';
import 'package:e_commerce/features/product_details/domain/entity/variant_entity.dart';

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
  final List<VariantEntity> variants;
  final List<ReviewEntity> reviews;
  bool isFavorite;

  ProductDetailsEntity({
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
    this.variants = const [],
    this.reviews = const [],
    this.isFavorite = false,
  });

  List<String> get colors =>
      variants.map((v) => v.color).where((c) => c.isNotEmpty).toSet().toList();

  List<String> get sizes =>
      variants.map((v) => v.size).where((s) => s.isNotEmpty).toSet().toList();

  /// Resolves a user's size+color pick to a concrete variant, for addToCart.
  VariantEntity? findVariant({required String size, required String color}) {
    for (final v in variants) {
      if (v.size == size && v.color == color) return v;
    }
    return null;
  }
}
