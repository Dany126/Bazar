import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/home/data/datasources/home_remote_data_source.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class HomeRepositoryImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    final result = await remoteDataSource.getAllCategories();
    return result.fold(
      (failure) => Left(failure),
      (categories) => Right(categories),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    final result = await remoteDataSource.getAllProducts(
      page: page,
      limit: limit,
    );
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    final result = await remoteDataSource.getBestSellingProducts(
      page: page,
      limit: limit,
    );
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getNewestProducts({
    required int page,
    required int limit,
  }) async {
    final result = await remoteDataSource.getNewestProducts(
      page: page,
      limit: limit,
    );
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    final result = await remoteDataSource.getProductsByCategory(
      category: category,
      page: page,
      limit: limit,
    );
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products),
    );
  }
}
