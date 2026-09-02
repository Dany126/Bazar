import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

abstract class AdminCategoryRepository {
  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required MultipartFile image,
  });

  Future<Either<Failure, Unit>> deleteCategory({required String categoryId});
}
