import 'package:dio/dio.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class AdminCategoriesRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();

  Future<CategoryModel> createCategory({
    required String name,
    required XFile image,
  });

  Future<CategoryModel> updateCategory({
    required String id,
    required String name,
    XFile? image,
  });

  Future<void> deleteCategory({
    required String id,
  });

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
  });
}

class AdminCategoriesRemoteDataSourceImpl
    implements AdminCategoriesRemoteDataSource {
  final Dio dio;

  const AdminCategoriesRemoteDataSourceImpl({
    required this.dio,
  });

  // ============================================================
  // GET ALL CATEGORIES
  // ============================================================

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await dio.get(
      '$kBaseUrl/category',
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final categories = data['categories'];

      if (categories is List) {
        return categories
            .whereType<Map>()
            .map(
              (item) => CategoryModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      final responseData = data['data'];

      if (responseData is List) {
        return responseData
            .whereType<Map>()
            .map(
              (item) => CategoryModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }
    }

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => CategoryModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    throw Exception('Invalid categories response');
  }

  // ============================================================
  // GET PRODUCTS BY CATEGORY
  // ============================================================

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
  }) async {
    final response = await dio.get(
      '$kBaseUrl/category/$categoryId/product',
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final products = data['products'];

      if (products is List) {
        return products
            .whereType<Map>()
            .map(
              (item) => ProductModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      final responseData = data['data'];

      if (responseData is List) {
        return responseData
            .whereType<Map>()
            .map(
              (item) => ProductModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }
    }

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => ProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    throw Exception('Invalid products response');
  }

  // ============================================================
  // CREATE CATEGORY
  // ============================================================

  @override
  Future<CategoryModel> createCategory({
    required String name,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('Selected category image is empty');
    }

    final multipartImage = MultipartFile.fromBytes(
      bytes,
      filename: image.name,
    );

    final formData = FormData();

    formData.fields.add(
      MapEntry('name', name),
    );

    formData.files.add(
      MapEntry('image', multipartImage),
    );

    final response = await dio.post(
      '$kBaseUrl/category',
      data: formData,
    );

    return _parseCategoryResponse(response.data);
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  @override
  Future<CategoryModel> updateCategory({
    required String id,
    required String name,
    XFile? image,
  }) async {
    final formData = FormData();

    formData.fields.add(
      MapEntry('name', name),
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      if (bytes.isEmpty) {
        throw Exception('Selected category image is empty');
      }

      final multipartImage = MultipartFile.fromBytes(
        bytes,
        filename: image.name,
      );

      formData.files.add(
        MapEntry('image', multipartImage),
      );
    }

    final response = await dio.patch(
      '$kBaseUrl/category/$id',
      data: formData,
    );

    return _parseCategoryResponse(response.data);
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  @override
  Future<void> deleteCategory({
    required String id,
  }) async {
    await dio.delete(
      '$kBaseUrl/category/$id',
    );
  }

  // ============================================================
  // PARSE CATEGORY RESPONSE
  // ============================================================

  CategoryModel _parseCategoryResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      final category = data['category'];

      if (category is Map) {
        return CategoryModel.fromJson(
          Map<String, dynamic>.from(category),
        );
      }

      final responseData = data['data'];

      if (responseData is Map) {
        return CategoryModel.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      }

      return CategoryModel.fromJson(data);
    }

    throw Exception('Invalid category response');
  }
}