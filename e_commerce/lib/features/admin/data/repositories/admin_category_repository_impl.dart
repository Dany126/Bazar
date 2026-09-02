import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

import '../datasources/admin_category_remote_data_source.dart';
import '../../domain/repositories/admin_category_repository.dart';

class AdminCategoryRepositoryImpl implements AdminCategoryRepository {
  final AdminCategoryRemoteDataSource remoteDataSource;

  AdminCategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required MultipartFile image,
  }) {
    return remoteDataSource.createCategory(name: name, image: image);
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory({required String categoryId}) {
    return remoteDataSource.deleteCategory(categoryId: categoryId);
  }
}
