import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

// ignore: must_be_immutable
class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.images,
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
      images: _getImages(json),
      price: _getDouble(json['price']),
      rating: _getRating(json['avg_rating'] ?? json['rating']),
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

  static List<String> _getImages(Map<String, dynamic> json) {
    final dynamic value =
        json['images'] ?? json['image'] ?? json['thumbnailUrl'];

    if (value is List) {
      final List<String> result = <String>[];

      for (final dynamic item in value) {
        if (item == null) {
          continue;
        }

        final String image = item.toString().trim();

        if (image.isNotEmpty) {
          result.add(image);
        }
      }

      return result;
    }

    if (value is String) {
      final String image = value.trim();

      if (image.isNotEmpty) {
        return <String>[image];
      }
    }

    return <String>[];
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
    final double rating = _getDouble(value);

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
      return CategoryModel.fromJson(Map<String, dynamic>.from(category));
    }

    return const CategoryModel(id: '', name: '', imageUrl: '');
  }
}
