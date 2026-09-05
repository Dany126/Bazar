import 'package:e_commerce/features/home/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: _getImage(json['image']),
    );
  }

  static String _getImage(dynamic image) {
    if (image == null) {
      return '';
    }

    if (image is String) {
      return image.trim();
    }

    return image.toString().trim();
  }
}
