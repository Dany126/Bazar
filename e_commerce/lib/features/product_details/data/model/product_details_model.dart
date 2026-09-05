import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
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

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final variantsRaw = json['variants'];

    final variants = variantsRaw is List
        ? variantsRaw
            .whereType<Map<String, dynamic>>()
            .map((v) => VariantModel.fromJson(v))
            .toList()
        : <VariantModel>[];

    final productId =
        json['_id']?.toString() ?? json['id']?.toString() ?? '';

    return ProductDetailsModel(
      id: productId,
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      images: _parseImages(json['image']),

      // IMPORTANT:
      // Never allow NaN, infinity, negative rating,
      // or rating greater than 5 to reach the UI.
      avgRating: _toRating(json['avg_rating']),

      ratingsQuantity: _toInt(json['ratingsQuantity']),
      stock: _toInt(json['stock']),
      soldCount: _toInt(json['soldCount']),
      categoryId: _parseCategoryId(json['category']),
      description: json['description']?.toString(),
      reviews: _parseReviews(json['reviews']),
      variants: variants,
      isFavorite: _getFavoriteState(
        productId,
        json['isFavorite'],
        json['isFavourite'],
        json['isInWishlist'],
      ),
    );
  }

  factory ProductDetailsModel.fromVariantsJson({
    required Map<String, dynamic> product,
    required List<dynamic> variantsJson,
  }) {
    final variantMaps =
        variantsJson.whereType<Map<String, dynamic>>().toList();

    final variants =
        variantMaps.map((v) => VariantModel.fromJson(v)).toList();

    final firstVariant =
        variantMaps.isNotEmpty ? variantMaps.first : null;

    final productId =
        product['_id']?.toString() ??
        product['id']?.toString() ??
        '';

    return ProductDetailsModel(
      id: productId,
      name: product['name']?.toString() ?? '',
      price: _toDouble(
        firstVariant?['price'] ?? product['price'],
      ),
      images: _parseImages(product['image']),

      // IMPORTANT:
      // Same protection here because this factory can also
      // create ProductDetailsModel objects.
      avgRating: _toRating(product['avg_rating']),

      ratingsQuantity: _toInt(
        product['ratingsQuantity'],
      ),
      stock: _toInt(
        firstVariant?['stock'] ?? product['stock'],
      ),
      soldCount: _toInt(
        firstVariant?['soldCount'] ?? product['soldCount'],
      ),
      categoryId: _parseCategoryId(
        product['category'],
      ),
      description: product['description']?.toString(),
      reviews: _parseReviews(product['reviews']),
      variants: variants,
      isFavorite: _getFavoriteState(
        productId,
        product['isFavorite'],
        product['isFavourite'],
        product['isInWishlist'],
      ),
    );
  }

  static bool _getFavoriteState(
    String productId,
    dynamic isFavorite,
    dynamic isFavourite,
    dynamic isInWishlist,
  ) {
    final sharedState =
        GetProductsCubit.favoriteProductIds.value;

    if (sharedState.containsKey(productId)) {
      return sharedState[productId] == true;
    }

    if (isFavorite == true) {
      return true;
    }

    if (isFavourite == true) {
      return true;
    }

    if (isInWishlist == true) {
      return true;
    }

    return false;
  }

  /// Converts a normal number/string to double.
  ///
  /// This method protects the application from:
  /// - null
  /// - invalid strings
  /// - NaN
  /// - infinity
  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    double result;

    if (value is num) {
      result = value.toDouble();
    } else {
      result = double.tryParse(
            value.toString().trim(),
          ) ??
          0.0;
    }

    if (!result.isFinite) {
      return 0.0;
    }

    return result;
  }

  /// Converts avg_rating to a valid product rating.
  ///
  /// Rating must always be between 0 and 5.
  static double _toRating(dynamic value) {
    final rating = _toDouble(value);

    if (!rating.isFinite) {
      return 0.0;
    }

    if (rating <= 0) {
      return 0.0;
    }

    if (rating >= 5) {
      return 5.0;
    }

    return rating;
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

    return int.tryParse(
          value.toString().trim(),
        ) ??
        0;
  }

  static List<String> _parseImages(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .where((image) => image != null)
        .map((image) => image.toString().trim())
        .where((image) => image.isNotEmpty)
        .toList();
  }

  static List<ReviewModel> _parseReviews(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (review) => ReviewModel.fromJson(review),
        )
        .toList();
  }

  static String _parseCategoryId(dynamic category) {
    if (category is String) {
      return category;
    }

    if (category is Map<String, dynamic>) {
      return category['_id']?.toString() ??
          category['id']?.toString() ??
          '';
    }

    return '';
  }
}