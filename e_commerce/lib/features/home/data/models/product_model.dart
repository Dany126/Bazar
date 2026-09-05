import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

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
      price: _getDouble(json['price']),
      rating: _getRating(json['avg_rating']),
      stock: _getInt(json['stock']),
      soldCount: _getInt(json['soldCount']),
      isFavorite:
          json['isFavorite'] == true ||
          json['isFavourite'] == true ||
          json['isInWishlist'] == true,
      ratingsQuantity: _getInt(json['ratingsQuantity']),
      category: _getCategory(json['category']),
    );
  }

  static String _getImage(dynamic image) {
    if (image is List) {
      for (final item in image) {
        if (item == null) continue;

        final value = item.toString().trim();

        if (value.isNotEmpty) {
          return value;
        }
      }

      return '';
    }

    if (image is String) {
      return image.trim();
    }

    return '';
  }

  static double _getDouble(dynamic value) {
    double result;

    if (value is num) {
      result = value.toDouble();
    } else if (value is String) {
      result = double.tryParse(value.trim()) ?? 0.0;
    } else {
      return 0.0;
    }

    if (result.isNaN || result.isInfinite) {
      return 0.0;
    }

    return result;
  }

  static double _getRating(dynamic value) {
    final rating = _getDouble(value);

    if (rating.isNaN || rating.isInfinite) {
      return 0.0;
    }

    if (rating < 0) {
      return 0.0;
    }

    if (rating > 5) {
      return 5.0;
    }

    return rating;
  }

  static int _getInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      if (value.isNaN || value.isInfinite) {
        return 0;
      }

      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
  }

  static CategoryModel _getCategory(dynamic category) {
    if (category is Map) {
      return CategoryModel.fromJson(
        Map<String, dynamic>.from(category),
      );
    }

    return const CategoryModel(
      id: '',
      name: '',
      imageUrl: '',
    );
  }
}