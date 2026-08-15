// lib/features/product_details/data/model/product_details_model.dart

import 'package:e_commerce/features/product_details/data/model/review_model.dart';
import 'package:e_commerce/features/product_details/data/model/variant_model.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  ProductDetailsModel({
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
    super.isFavorite = false,
    super.variants,
    super.reviews,
  });

  /// Parses a single-product response where `variants` is embedded inline.
  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final variantsRaw = json['variants'];
    final variants = variantsRaw is List
        ? variantsRaw
              .whereType<Map<String, dynamic>>()
              .map((v) => VariantModel.fromJson(v))
              .toList()
        : <VariantModel>[];

    return ProductDetailsModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      images: _parseImages(json['image']),
      avgRating: _toDouble(json['avg_rating']),
      ratingsQuantity: _toInt(json['ratingsQuantity']),
      stock: _toInt(json['stock']),
      soldCount: _toInt(json['soldCount']),
      categoryId: _parseCategoryId(json['category']),
      description: json['description']?.toString(),
      reviews: _parseReviews(json['reviews']),
      variants: variants,
    );
  }

  /// Parses the response from:
  ///
  /// GET /api/product/:productId/variant
  ///
  /// variants: [{ size, price, color, stock, product: {...} }]
  factory ProductDetailsModel.fromVariantsJson({
    required Map<String, dynamic> product,
    required List<dynamic> variantsJson,
  }) {
    final variantMaps = variantsJson.whereType<Map<String, dynamic>>().toList();
    final variants = variantMaps.map((v) => VariantModel.fromJson(v)).toList();
    final firstVariant = variantMaps.isNotEmpty ? variantMaps.first : null;

    return ProductDetailsModel(
      id: product['_id']?.toString() ?? product['id']?.toString() ?? '',
      name: product['name']?.toString() ?? '',
      price: _toDouble(firstVariant?['price'] ?? product['price']),
      images: _parseImages(product['image']),
      avgRating: _toDouble(product['avg_rating']),
      ratingsQuantity: _toInt(product['ratingsQuantity']),
      stock: _toInt(firstVariant?['stock'] ?? product['stock']),
      soldCount: _toInt(firstVariant?['soldCount'] ?? product['soldCount']),
      categoryId: _parseCategoryId(product['category']),
      description: product['description']?.toString(),
      reviews: _parseReviews(product['reviews']),
      variants: variants,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static List<String> _parseImages(dynamic value) {
    if (value is! List) return [];
    return value.where((i) => i != null).map((i) => i.toString()).toList();
  }

  static List<ReviewModel> _parseReviews(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map<String, dynamic>>()
        .map((r) => ReviewModel.fromJson(r))
        .toList();
  }

  static String _parseCategoryId(dynamic category) {
    if (category is String) return category;
    if (category is Map<String, dynamic>) {
      return category['_id']?.toString() ?? category['id']?.toString() ?? '';
    }
    return '';
  }
}
