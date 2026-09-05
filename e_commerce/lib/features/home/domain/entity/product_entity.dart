import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final List<String> images;
  final double price;
  final double rating;
  final int stock;
  final int soldCount;
  final int ratingsQuantity;
  final CategoryEntity category;

  bool isFavorite;

  ProductEntity({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    required this.rating,
    required this.stock,
    required this.soldCount,
    required this.ratingsQuantity,
    required this.category,
    this.isFavorite = false,
  });

  /// Keeps existing UI code working.
  ///
  /// The first image is used as the product thumbnail.
  String get thumbnailUrl {
    if (images.isEmpty) {
      return '';
    }

    return images.first;
  }

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      images: _getImages(json),
      price: _getDouble(json['price']),
      rating: _getDouble(json['rating']),
      stock: _getInt(json['stock']),
      soldCount: _getInt(json['soldCount']),
      ratingsQuantity: _getInt(json['ratingsQuantity']),
      category: _getCategory(json['category']),
      isFavorite:
          json['isFavorite'] == true ||
          json['isFavourite'] == true ||
          json['isInWishlist'] == true,
    );
  }

  static List<String> _getImages(Map<String, dynamic> json) {
    final dynamic value =
        json['images'] ?? json['image'] ?? json['thumbnailUrl'];

    if (value is List) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String) {
      final String image = value.trim();

      if (image.isNotEmpty) {
        return [image];
      }
    }

    return <String>[];
  }

  static double _getDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }

    return 0.0;
  }

  static int _getInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
  }

  static CategoryEntity _getCategory(dynamic category) {
    if (category is Map) {
      return CategoryEntity(
        id: category['_id']?.toString() ?? '',
        name: category['name']?.toString() ?? '',
        imageUrl: category['imageUrl']?.toString() ?? '',
      );
    }

    return const CategoryEntity(id: '', name: '', imageUrl: '');
  }

  @override
  List<Object?> get props => [
    id,
    name,
    images,
    price,
    rating,
    stock,
    soldCount,
    ratingsQuantity,
    category,
    isFavorite,
  ];
}
