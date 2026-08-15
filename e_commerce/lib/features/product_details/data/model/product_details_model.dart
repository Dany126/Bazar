// lib/features/product_details/data/model/product_details_model.dart

import 'package:e_commerce/features/product_details/data/model/review_model.dart';
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
    super.colors,
    super.sizes,
    super.reviews,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
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

      colors: _parseStringList(json['colors']),

      sizes: _parseStringList(json['sizes']),

      reviews: _parseReviews(json['reviews']),
    );
  }

  /// Parses the response from:
  ///
  /// GET /api/product/:productId/variant
  ///
  /// Example:
  ///
  /// variants: [
  ///   {
  ///     size: M,
  ///     price: 20,
  ///     color: Red,
  ///     stock: 25,
  ///     product: {...}
  ///   }
  /// ]
  factory ProductDetailsModel.fromVariantsJson({
    required Map<String, dynamic> product,
    required List<dynamic> variants,
  }) {
    final variantMaps = variants.whereType<Map<String, dynamic>>().toList();

    final firstVariant = variantMaps.isNotEmpty ? variantMaps.first : null;

    // Get all available colors
    final colors = variantMaps
        .map((variant) => variant['color'])
        .where((color) => color != null)
        .map((color) => color.toString())
        .toSet()
        .toList();

    // Get all available sizes
    final sizes = variantMaps
        .map((variant) => variant['size'])
        .where((size) => size != null)
        .map((size) => size.toString())
        .toSet()
        .toList();

    return ProductDetailsModel(
      id: product['_id']?.toString() ?? product['id']?.toString() ?? '',

      name: product['name']?.toString() ?? '',

      // Price comes from the variant
      price: _toDouble(firstVariant?['price'] ?? product['price']),

      images: _parseImages(product['image']),

      avgRating: _toDouble(product['avg_rating']),

      ratingsQuantity: _toInt(product['ratingsQuantity']),

      // Stock comes from the selected/first variant
      stock: _toInt(firstVariant?['stock'] ?? product['stock']),

      soldCount: _toInt(firstVariant?['soldCount'] ?? product['soldCount']),

      categoryId: _parseCategoryId(product['category']),

      description: product['description']?.toString(),

      colors: colors,

      sizes: sizes,

      reviews: _parseReviews(product['reviews']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static List<String> _parseImages(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .where((image) => image != null)
        .map((image) => image.toString())
        .toList();
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }

  static List<ReviewModel> _parseReviews(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map((review) => ReviewModel.fromJson(review))
        .toList();
  }

  static String _parseCategoryId(dynamic category) {
    if (category is String) {
      return category;
    }

    if (category is Map<String, dynamic>) {
      return category['_id']?.toString() ?? category['id']?.toString() ?? '';
    }

    return '';
  }
}
