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
    return remoteDataSource.getAllCategories();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.getAllProducts(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts({
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.getFavoriteProducts(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, Set<String>>> getFavoriteProductIds() async {
    return remoteDataSource.getFavoriteProductIds();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.getBestSellingProducts(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getNewestProducts({
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.getNewestProducts(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.getProductsByCategory(
      category: category,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> search({
    required String query,
    required int page,
    required int limit,
  }) async {
    return remoteDataSource.search(query: query, page: page, limit: limit);
  }

  @override
  Future<Either<Failure, Unit>> ChangeToIsFavourite({
    required String productId,
    required bool isFavourite,
  }) async {
    return remoteDataSource.changeToIsFavourite(
      productId: productId,
      isFavourite: isFavourite,
    );
  }
}
