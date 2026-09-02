import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

abstract class AdminCategoryRemoteDataSource {
  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required MultipartFile image,
  });

  Future<Either<Failure, Unit>> deleteCategory({required String categoryId});
}

class AdminCategoryRemoteDataSourceImpl
    implements AdminCategoryRemoteDataSource {
  final ApiService apiService;

  AdminCategoryRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required MultipartFile image,
  }) async {
    final formData = FormData.fromMap({'name': name, 'image': image});

    final response = await apiService.post(kGetAllGategories, data: formData);

    return response.fold((failure) => Left(failure), (data) {
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(message: 'Invalid server response'));
      }

      final categoryJson = data['category'];

      if (categoryJson is! Map<String, dynamic>) {
        return Left(
          ServerFailure(message: 'Category was not returned by the server'),
        );
      }

      try {
        return Right(CategoryModel.fromJson(categoryJson));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory({
    required String categoryId,
  }) async {
    final response = await apiService.delete('$kGetAllGategories/$categoryId');

    return response.fold((failure) => Left(failure), (_) => Right(unit));
  }
}
