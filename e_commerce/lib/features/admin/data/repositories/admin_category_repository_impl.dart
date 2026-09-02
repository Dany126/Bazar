import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_category_remote_data_source.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoriesRepositoryImpl implements AdminCategoriesRepository {
  final AdminCategoriesRemoteDataSource remoteDataSource;

  const AdminCategoriesRepositoryImpl({required this.remoteDataSource});

  // ============================================================
  // GET ALL CATEGORIES
  // ============================================================

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    try {
      final result = await remoteDataSource.getAllCategories();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // GET PRODUCTS BY CATEGORY
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String categoryId,
  }) async {
    try {
      final result = await remoteDataSource.getProductsByCategory(
        categoryId: categoryId,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // CREATE
  // ============================================================

  @override
  Future<Either<Failure, CategoryModel>> createCategory({
    required String name,
    required XFile image,
  }) async {
    try {
      final result = await remoteDataSource.createCategory(
        name: name,
        image: image,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  @override
  Future<Either<Failure, CategoryModel>> updateCategory({
    required String id,
    required String name,
    XFile? image,
  }) async {
    try {
      final result = await remoteDataSource.updateCategory(
        id: id,
        name: name,
        image: image,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  @override
  Future<Either<Failure, void>> deleteCategory({required String id}) async {
    try {
      await remoteDataSource.deleteCategory(id: id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
