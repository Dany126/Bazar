import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

import '../repositories/admin_category_repository.dart';

class CreateAdminCategory {
  final AdminCategoryRepository repository;

  CreateAdminCategory(this.repository);

  Future<Either<Failure, CategoryModel>> call({
    required String name,
    required MultipartFile image,
  }) {
    return repository.createCategory(name: name, image: image);
  }
}
