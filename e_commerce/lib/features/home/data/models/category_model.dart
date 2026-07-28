import 'package:e_commerce/features/home/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? " " as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] ?? "" as String,
    );
  }
}
