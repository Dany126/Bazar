import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class AdminCategoriesRepository {
  // Categories
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();

  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required XFile image,
  });

  Future<Either<Failure, CategoryModel>> updateCategory({
    required String id,
    required String name,
    XFile? image,
  });

  Future<Either<Failure, void>> deleteCategory({required String id});

  // Products by category
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String categoryId,
  });
}
